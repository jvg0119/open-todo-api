Rails.application.routes.draw do
  
	# namespace :api, defaults: { format: :json } do
	# 	resources :users
		
	# end

  get 'index' => 'welcome#index'
  get 'about' => 'welcome#about'
	root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
