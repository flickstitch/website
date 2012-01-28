class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string

    User.all.each do |u|
      u.username = u.email.split('@')[0]
      u.save!
    end
  end
end
