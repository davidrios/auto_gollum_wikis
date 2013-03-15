require_dependency 'project'

module ProjectModelAGWConfig
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end
 
  module InstanceMethods
    def agw_config
      raise "Need project id." unless self.id
      return ProjectAGWConfig.first(:conditions => ["project_id = ?", self.id]) ||
             ProjectAGWConfig.new(:project_id => self.id,
                                  :markup_language => "markdown",
                                  :wikis_subdir => "docs",
                                  :auto_toc => false)
    end
  end
end

Project.send(:include, ProjectModelAGWConfig)