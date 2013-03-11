# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :projects do
  match 'project_agw_config', :to => 'project_agw_config#update', :via => [:post, :put]
  
  match 'agw', :to => 'project_agw#index'
  match 'agw/:repo_id', :to => 'project_agw#index'
  match 'agw/:repo_id/:rev/page/*page', :to => 'project_agw#show'
  match 'agw/:repo_id/:rev/page', :to => 'project_agw#index'
  match 'agw/:repo_id/page/*page', :to => 'project_agw#show'
end