class AddSceneIdToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :scene_id, :integer

  end
end
