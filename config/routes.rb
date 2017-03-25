Rails.application.routes.draw do
  
  get 'index' => 'welcome#index'
  get 'about' => 'welcome#about'
	root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
