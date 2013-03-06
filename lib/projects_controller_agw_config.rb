require_dependency 'projects_controller'

module ProjectsControllerAGWConfig
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :settings, :project_agw_config
    end
  end
 
  module InstanceMethods
    def settings_with_project_agw_config
      settings_without_project_agw_config
      @project_agw_config = @project.agw_config
    end
  end
end

ProjectsController.send(:include, ProjectsControllerAGWConfig)