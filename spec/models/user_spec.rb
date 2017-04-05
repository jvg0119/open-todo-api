require 'rails_helper'

RSpec.describe User, type: :model do 
	describe "creates a token" do 
		it "creates a token" do
			user = User.create(username: "joe", password: "password") 
			expect(user.auth_token).to_not be_nil
			#p user.auth_token
		end
	end

end

