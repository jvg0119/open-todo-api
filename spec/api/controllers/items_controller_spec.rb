require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
	let(:my_user) { create(:user) }
	let(:my_list) { create(:list, user: my_user) }
	let(:my_item) { create(:item, list: my_list) }
	context "unathenticated users" do 
		it "GET index returns http unathenticated" do 
			get :index, params: { list_id: my_list.id } 
			expect(response).to have_http_status(401)
		end
		it "GET show returns http unathenticated" do 
			get :show, params: { list_id: my_list.id, id: my_item.id }
			expect(response).to have_http_status(401)
		end
		it "POST create returns http unathenticated" do 
			post :create, params: { list_id: my_list.id, list:  my_list }  # check later
			expect(response).to have_http_status(401)
		end
		it "PUT update returns http unathenticated" do 
			put :update, params: { list_id: my_list.id, id: my_item.id, item: attributes_for(:item) } # check later
			expect(response).to have_http_status(401)
		end
	end 	# unathenticated users

	context "authenticated users" do
		before do 
			controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
		end
		describe "GET index" do
			before { get :index, params: { list_id: my_list.id, id: my_item.id} } 
			it "returns http success" do 
				expect(response).to have_http_status(200)
			end
			it "returns json/context type" do 
				expect(response.content_type).to eq("application/json")
			end
			it "returns my_item serialized (items)" do
				expect(assigns(:items)).to eq([my_item])
				expect(assigns(:items).as_json).to eq([my_item].as_json)
			end
		end 	# GET index
		describe "GET show" do 
			before { get :show, params: { list_id: my_list.id, id: my_item.id } }
			it "returns http success" do
				expect(response).to have_http_status(200) 
			end
			it "returns json/context type" do
				expect(response.content_type).to eq("application/json") 
			end
			it "returns my_item serialized (item)" do 
				expect(assigns(:item)).to eq(my_item)
			end
		end 	# GET show

		describe "POST create" do 
			context "with valid attriutes" do 
				before do 
					@my_item = build(:item, list: my_list)
					post :create, params: { list_id: my_list.id, item: { description: @my_item.description } }
				end
				it "returns http success" do 
					expect(response).to have_http_status 202 # accepted
				end
				it "returns json/context type" do 
					expect(response.content_type).to eq("application/json")
				end
				it "creates an item with the correct attributes" do 
					parsed_body = JSON.parse(response.body)
					#expect(response.body).to eq(my_item.to_json)
					expect(parsed_body['description']).to eq(my_item.description)
					expect(parsed_body['completed']).to eq(false)
				end
			end 	# with valid attriutes
			context "with invalid attributes" do 
				before do 
					post :create, params: { list_id: my_list.id, item: attributes_for(:item, description: "") }
				end
				it "returns http error" do 
					expect(response).to have_http_status :unprocessable_entity
				end
				it "returns the correct json message" do # optional
					expect(response.message).to eq("Unprocessable Entity")
					#expect(response.body).to eq("{\"error\":[\"Description is too short (minimum is 10 characters)\",\"Description can't be blank\"]}")
					expect(response.body).to eq({"error": ["Description is too short (minimum is 10 characters)","Description can't be blank"]}.to_json)
				end
			end 	# with invalid attriutes
		end 	# POST create 

		describe "PUT update" do
			context "with valid attributes" do
				before do
					@my_item = build(:item, description: "Updated description")
					put :update, params: { list_id: my_list.id, id: my_item.id, item: attributes_for(:item, description: @my_item.description) }
				end  
				it "returns http success" do
					expect(response).to have_http_status(200) 
				end
				it "returns json/context type" do
					expect(response.content_type).to eq("application/json") 
				end
				it "updates an item with the correct attributes" do
					parsed_body = JSON.parse(response.body)
					expect(parsed_body['description']).to eq(@my_item.description) 
				end
			end 	# with valid attriutes
			context "with invalid attributes" do 
				before do 
					put :update, params: { list_id: my_list.id, id: my_item.id, item: attributes_for(:item, description: "") }
				end  
				it "returns http error" do
					expect(response).to have_http_status(422) 
				end
				it "returns the correct json message" do 
					expect(response.message).to eq("Unprocessable Entity")
				#	expect(response.body).to eq("{\"error\":[\"Description is too short (minimum is 10 characters)\",\"Description can't be blank\"]}")
					expect(response.body).to eq({"error":["Description is too short (minimum is 10 characters)", "Description can't be blank"]}.to_json)
				end
			end 	# with invalid attriutes
		end 	# PUT update

	end 	# authenticated users


end 	# ItemsController











