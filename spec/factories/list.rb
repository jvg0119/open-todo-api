FactoryGirl.define do 
	factory :list do 
		name "My todo list"
		permission "private_list"
		association :user
	end

end

 