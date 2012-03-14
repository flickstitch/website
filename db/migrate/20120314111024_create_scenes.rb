class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.string :name
      t.text :desc
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
