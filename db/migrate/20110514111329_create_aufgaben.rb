class CreateAufgaben < ActiveRecord::Migration
  def self.up
    create_table :aufgaben do |t|
      t.date :erfasst
      t.string :projekt
      t.text :aufgabe
      t.text :erklaerung
      t.text :information
      t.string :zustaendig
      t.string :status
      t.date :erledigt_am
      t.integer :zeit
      t.string :heute_bearbeiten_kz
      t.string :nur_heute_interessant
      t.string :mantis_nummer
      t.string :privat
      t.integer :aufgabe_id
      t.date :termin
      t.date :aend_dat
      t.integer :reihenfolge
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :aufgaben
  end
end
