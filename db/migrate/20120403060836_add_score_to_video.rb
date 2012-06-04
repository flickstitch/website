class AddScoreToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :score, :integer, :default => 0

  end
end
