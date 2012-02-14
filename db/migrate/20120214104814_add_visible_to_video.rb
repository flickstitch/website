class AddVisibleToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :visible, :boolean, :default => true

  end
end
