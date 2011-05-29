class AddUserIdToProjekte < ActiveRecord::Migration
  def self.up
    add_column :projekte, :user_id, :integer
  end

  def self.down
    remove_column :projekte, :user_id
  end
end
