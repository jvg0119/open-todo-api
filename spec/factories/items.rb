FactoryGirl.define do 
	factory :item do 
		description "This is my item description factory"
		#completed false
		association :list 
	end

end


