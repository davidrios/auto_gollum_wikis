require_dependency 'project_agw_config_tag'
require_dependency 'project_model_agw_config'
require_dependency 'projects_controller_agw_config'

Redmine::Plugin.register :auto_gollum_wikis do
  name 'Auto Gollum Wikis plugin'
  author 'David Rios'
  description 'A plugin to load Gollum wikis from project git repositories.'
  version '0.0.1'
  url 'https://github.com/davidrios/redmine_auto_gollum_wikis'
  author_url 'https://github.com/davidrios'

  requires_redmine :version_or_higher => '2.2.0'

  project_module :auto_gollum_wikis do
    permission :project_agw_config, { :project_agw_config => [:index, :show, :create, :update] }
  end

  menu :project_menu, :auto_gollum_wikis, { :controller => :project_agw_config, :action => :index }, :caption => :auto_gollum_wikis, :before => :wiki, :param => :project_id
end
