# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :projects do
  resources  :project_agw_config
end