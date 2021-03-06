# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :projects do
  match 'project_agw_config', :to => 'project_agw_config#update', :via => [:post, :put]

  match 'agw', :to => 'project_agw#index'
  match 'agw/:repo_id', :to => 'project_agw#index'
  match 'agw/:repo_id/:rev/page', :to => 'project_agw#index'
  match 'agw/:repo_id/:rev/page/*page', :to => 'project_agw#show'
  match 'agw/:repo_id/:rev/history/*page', :to => 'project_agw#history'
  match 'agw/:repo_id/:rev/search', :to => 'project_agw#search'
  match 'agw/:repo_id/:rev/pages', :to => 'project_agw#pages'
  match 'agw/:repo_id/:rev/pages/*path', :to => 'project_agw#pages'
end