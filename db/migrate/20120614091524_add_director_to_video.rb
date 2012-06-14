class AddDirectorToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :director, :string
    add_column :videos, :actors, :text
  end
end
