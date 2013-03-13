class ProjectAGWConfig < ActiveRecord::Base
  unloadable
  belongs_to :project

  validates_inclusion_of :markup_language, :in => Gollum::Page::FORMAT_NAMES.keys.map { |i| i.to_s }
end
