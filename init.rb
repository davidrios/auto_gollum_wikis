require_dependency 'project_agw_config_tag'
require_dependency 'project_model_agw_config'
require_dependency 'projects_controller_agw_config'
require_dependency 'gollum_markup_patch'
require_dependency 'gollum_wiki'

Redmine::Plugin.register :auto_gollum_wikis do
  name 'Auto Gollum Wikis plugin'
  author 'David Rios'
  description 'A plugin to load Gollum wikis from project git repositories.'
  version '0.0.1'
  url 'https://github.com/davidrios/redmine_auto_gollum_wikis'
  author_url 'https://github.com/davidrios'

  requires_redmine :version_or_higher => '2.2.0'

  settings :default => { :highlight_style => 'default' },
           :partial => 'settings/form'

  project_module :auto_gollum_wikis do
    permission :project_agw_config, { :project_agw_config => [:index, :show, :update] }
    permission :project_agw_view, { :project_agw => [:index, :show, :search, :pages] }
    permission :project_agw_history, { :project_agw => [:history] }
  end

  menu :project_menu, :auto_gollum_wikis, { :controller => :project_agw, :action => :index }, :caption => :label_auto_gollum_wikis, :before => :wiki, :param => :project_id
end
