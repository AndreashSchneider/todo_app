class CreateVwVokabelns < ActiveRecord::Migration
  def self.up
    create_table :vw_vokabelns do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :vw_vokabelns
  end
end
