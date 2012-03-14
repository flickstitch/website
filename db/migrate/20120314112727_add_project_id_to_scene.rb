class AddProjectIdToScene < ActiveRecord::Migration
  def change
    add_column :scenes, :project_id, :integer

  end
end
