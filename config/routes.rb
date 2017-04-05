Rails.application.routes.draw do

	namespace :api, defaults: { format: :json } do
		resources :users do 
			resources :lists, only: [:create, :destroy, :update, :index, :show]
		end
		resources :lists, only: [] do 
			resources :items, only: [:create, :update, :index, :show]
		end

	end

  get 'index' => 'welcome#index'
  get 'about' => 'welcome#about'
	root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
