class ProjectAGWConfig < ActiveRecord::Base
  unloadable
  belongs_to :project
end
