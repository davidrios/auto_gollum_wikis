class AutoTocProjectAgwConfigs < ActiveRecord::Migration
  def self.up
    add_column :project_agw_configs, :auto_toc, :boolean, :default => false
  end

  def self.down
    remove_column :project_agw_configs, :auto_toc
  end
end
