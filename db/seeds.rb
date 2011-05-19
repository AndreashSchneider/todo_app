# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#  json-Beispiel hat nicht funktioniert.
# json = ActiveSupport::JSON.decode(File.read('db/seeds/aufgaben.json'))
#   json.each do |a|
#     Aufgabe.create!(a['aufgabe'])
#   end
#   json = ActiveSupport::JSON.decode(File.read('db/seeds/aufgaben.json'))  
#   json.each do |a|
#     Aufgabe.create!(a['Aufgabe'])
#   end

                                                                                         
   ActiveSupport::Inflector.inflections do |inflect|
     inflect.irregular 'aufgabe', 'aufgaben'
     inflect.irregular 'karte', 'kartei'
   end                                     

  class Aufgabe < ActiveRecord::Base
  end 

 @aktuelles= YAML.load_file("db/seeds/akt_aufgaben")                         
   @aktuelles.each do |task|   
     Aufgabe.find(task[:id]).destroy if Aufgabe.exists?(task[:id])
     aufgabe = Aufgabe.new         
     task.attribute_names.each do |attr| 
      eval "aufgabe.#{attr}=task.#{attr}"
     end      
     aufgabe.save  
     p "Aufgabe mit id=#{aufgabe.id} geschrieben"       
   end
