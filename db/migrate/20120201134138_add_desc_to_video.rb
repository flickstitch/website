class AddDescToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :desc, :text

  end
end
