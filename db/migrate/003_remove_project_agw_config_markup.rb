class RemoveProjectAgwConfigMarkup < ActiveRecord::Migration
  def self.up
    remove_column :project_agw_configs, :markup_language
  end

  def self.down
    add_column :project_agw_configs, :markup_language, :string
  end
end
