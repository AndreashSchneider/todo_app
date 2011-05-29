class AddUserIdToAufgaben < ActiveRecord::Migration
  def self.up
    add_column :aufgaben, :user_id, :integer
  end

  def self.down
    remove_column :aufgaben, :user_id
  end
end
