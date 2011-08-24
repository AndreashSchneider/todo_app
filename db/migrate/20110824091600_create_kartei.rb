class CreateKartei < ActiveRecord::Migration
  def self.up
    create_table :kartei do |t|
      t.date :anl_dat
      t.date :aend_dat
      t.text :question
      t.text :answer
      t.string :sparte
      t.integer :folder
      t.integer :kapitel
      t.string :not_known_today

      t.timestamps
    end
  end

  def self.down
    drop_table :kartei
  end
end
