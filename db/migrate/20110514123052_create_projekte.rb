class CreateProjekte < ActiveRecord::Migration
  def self.up
    create_table :projekte do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :projekte
  end
end
