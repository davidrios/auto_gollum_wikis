# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :projects do
  get 'project_agw_config', :to => 'project_agw_config#index'
  match 'project_agw_config', :to => 'project_agw_config#update', :via => [:post, :put]
end