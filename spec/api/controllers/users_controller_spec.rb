require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do 
	let(:my_user) { create(:user) }

	context "unauthenticated users" do 
		it "GET index returns http unauthenticated" do 
			get :index
			expect(response).to have_http_status(401)
		end
		it "GET show returns http unauthenticated" do 
			get :show, params: { id: my_user.id }
			expect(response).to have_http_status(401)
		end
		it "POST create returns unauthenticated" do 
			post :create, params: { user: my_user }
			expect(response).to have_http_status(401)
		end
		it "DELETE destroy returns unauthenticated" do 
			delete :destroy, params: { id: my_user.id }
			expect(response).to have_http_status(401)
		end 	
	end 	# unauthenticated users

	context "authenticated users" do
		before do 
			controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
		end
		describe "GET index" do  
			before { get :index }
			it "returns http success" do 
				expect(response).to have_http_status(200)
			end
			it "returns json content type" do 
				expect(response.content_type).to eq("application/json")
			end
			it "returns my_user serialized" do
				#expect(response.body).to eq([my_user].as_json) 
				expect(p assigns(:users).as_json).to eq([my_user].as_json)
			end
		end 	# GET index

		describe "GET show" do 
			before { get  :show, params: { id: my_user.id } }
			it "returns http success" do 
				expect(response).to have_http_status(:success)
			end
			it "returns json/content" do 
				expect(response.content_type).to eq("application/json")
			end
			it "returns my_user serialized" do 
				#expect(response.body).to eq(my_user.to_json)
				expect(assigns(:user).as_json).to eq(my_user.as_json)
			end
		end 	# GET show

		describe "POST create" do
			context "with valid attributes" do 
				before do  
					@my_user = build(:user)
					post :create, params: { user: { username: @my_user.username, password: @my_user.password } }
					#post :create, params: { user:  attributes_for(:user) }
				end					
				it "returns http success" do
					expect(response).to have_http_status(200) 
				end
				it "returns json/content" do
					expect(response.content_type).to eq("application/json") 
				end
				it "creates a user with the correct attributes" do 
					hashed_json = JSON.parse(response.body)
					expect(hashed_json['username']).to eq(@my_user.username)
				end
			end 	# with valid attributes
			context "with invalid attributes" do
				before do 
					@my_user = build(:user, username: "")
					post :create, params: { user: { username: @my_user.username, password: @my_user.password } }
				end 
				it "returns http error" do
					expect(response).to have_http_status(:unprocessable_entity) 

				end
				it "returns the correct json error message" do
					expect(response.body).to eq({"error": ["Username can't be blank"]}.to_json) 
				end
			end 	# with invalid attributes
		end 	#  POST create

		describe "DELETE destroy" do
			before do 
				delete :destroy, params: { id: my_user.id }
			end 
			it "returns http success" do
				expect(response).to have_http_status(200) # no_conttent
			end
			it "returns json content type" do
				expect(response.content_type).to eq("application/json")  
			end
			it "returns the correct json message" do 
				expect(response.body).to eq({message: "User destroyed", status: 200}.to_json)
			end			
		end 	# DELETE destroy
	end 	# authenticated users

end





