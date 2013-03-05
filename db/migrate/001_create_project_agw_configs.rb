class CreateProjectAgwConfigs < ActiveRecord::Migration
  def change
    create_table :project_agw_configs do |t|
      t.references :project
      t.string :wikis_subdir
      t.string :markup_language
    end
  end
end
