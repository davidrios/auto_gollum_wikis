require_dependency 'projects_helper'

module ProjectAGWConfigTab # :nodoc:
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :project_settings_tabs, :agw_config
    end
  end

  module InstanceMethods
    # Adds a agw config tab to the project settings page
    def project_settings_tabs_with_agw_config
      tabs = project_settings_tabs_without_agw_config
      tabs << { :name => 'project_agw_config', :action => :project_agw_config, :partial => 'project_agw_config/edit', :label => :auto_gollum_wikis }
      tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
    end
  end
end

ProjectsHelper.send(:include, ProjectAGWConfigTab)