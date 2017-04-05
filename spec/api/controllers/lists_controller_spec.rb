require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do
	let(:my_user) { create(:user) }
	let(:my_list) { create(:list, user: my_user) }
	
	context "unauthenticated users" do
		it "GET index returns http unauthenticated" do
			get :index, params: { user_id: my_user.id }
			expect(response).to have_http_status 401
		end
		it "GET show returns http unauthenticated" do 
			get :show, params: { user_id: my_user.id, id: my_list.id }
			expect(response).to have_http_status 401
		end
		it "POST create returns unauthenticated" do 	
			post :create, params: { user_id: my_user.id }
			expect(response).to have_http_status 401
		end
		it "PUT update returns unauthenticated" do 
			put :update, params: { user_id: my_user.id, id: my_user.id }
			expect(response).to have_http_status 401
		end
		it "DELETE destroy returns unauthenticated" do 
			delete :destroy, params: { user_id: my_user.id, id: my_user.id }
			expect(response).to have_http_status 401
		end
	end 	# unauthenticated users

	context "authenticated users" do
		before do 
			controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
		end
		describe "GET index" do 
			before { get :index, params: { user_id: my_user.id, id: my_list.id } }
			it "returns http success" do 	
				expect(response).to have_http_status(200)
			end
			it "returns json/context type" do
				expect(response.content_type).to eq("application/json") 
			end
			it "returns my_list serialized" do
				expect(assigns(:lists).as_json).to eq([my_list].as_json)
			end
		end 	# GET index

		describe "GET show" do 
			before { get :show, params: { user_id: my_user.id, id: my_list.id } }
			it "returns http success" do 
				expect(response).to have_http_status(200)
			end
			it "returns json/context type" do 
				expect(response.content_type).to eq("application/json")
			end
			it "returns my_list serialized" do 
				expect(assigns(:list).as_json).to eq(my_list.as_json)
			end
		end 	# GET show

		describe "POST create" do 
			context "with valid attributes" do 
				before do
					@my_list = build(:list) 
					post :create, params: { user_id: my_user.id, list: { name: @my_list.name } }
				end
				it "returns http success" do
					expect(response).to have_http_status :success 
				end
				it "returns json/context type" do
					expect(response.content_type).to eq("application/json") 
				end
				it "returns my_list serialized" do 
					hashed_json = JSON.parse(response.body)
					expect(hashed_json['name']).to eq(@my_list.name)
					expect(hashed_json['permission']).to eq(@my_list.permission)	
				end
			end 	# with valid attributes
			context "with invalid attributes" do
			before do
				@my_list = build(:list, name: "") 
				post :create, params: { user_id: my_user.id, list: @my_list.name }
			end  
				it "returns http error" do
					expect(response).to have_http_status(400)
				end
				it "returns the correct json error message" do 
					expect(response.message).to eq("Bad Request")
					#expect(response.body).to eq("{\"error\":\"The request could not be understood by the server due to malformed syntax. The client SHOULD NOT repeat the request without modifications.\",\"status\":400}")
					expect(response.body).to eq({"error": "The request could not be understood by the server due to malformed syntax. The client SHOULD NOT repeat the request without modifications.", "status": 400}.to_json)
				end
			end 	# with invalid attributes
		end 	# POST create

		describe "PUT update" do
			context "with valid attributes" do 
				before do
					@my_list = build(:list, name: "my new todo list**", user: my_user) 
					#put :update, params: { user_id: my_user.id, id: my_list.id, list: { name: @my_list.name } } # OK
					put :update, params: { user_id: my_user.id, id: my_list.id, list: attributes_for(:list, name: @my_list.name) }
				end 
				it "returns http success" do 
					#byebug
				#	p attributes_for(:list)
					expect(response).to have_http_status 200
				end
				it "returns json/context type" do
					expect(response.content_type).to eq("application/json") 			
				end
				it "returns my_user serialized" do 
					hashed_json = JSON.parse(response.body)
					expect(hashed_json['name']).to eq(@my_list.name)
				end
			end 	# with valid attributes
			context "with invalid attributes" do 
				before do 
					@my_list_invalid = build(:list, name: "", user: my_user)
					put :update, params: { user_id: my_user.id, id: my_list.id, list: { name: @my_list_invalid.name } }
					#put :update, params: { user_id: my_user.id, id: my_list.id, list: { name: @my_list_invalid.name } }
				end
				it "returns http error" do
					expect(response).to have_http_status(422)
				end
				it "returns the correct json error message" do 
					expect(response.body).to eq({"error": ["Name can't be blank"]}.to_json)
				end
			end 	# with invalid attributes
		end 	# PUT update

		describe "DELETE destroy" do 
			before do 
				delete :destroy, params: { user_id: my_user.id, id: my_list.id }
			end
			it "returns http success" do 
				expect(response).to have_http_status :success
			end
			it "returns json/context type" do 
				expect(response.content_type).to eq("application/json") # does not work if status: :no_content
			end
			it "returns the correct json message" do 
				expect(response.body).to eq({message: "List destroyed", status: 200}.to_json)
			end
			# it "retuns no content" do 
			# 	expect(response.body).to eq("{}".as_json) # OK if status: :no_content
			# end
		end 	# DELETE destroy

	end 	# authenticated users

end 	# RSpec












