require 'rubygems'
require 'yaml'
# YAML::ENGINE.yamler = 'psych' 
require 'active_support'
require 'active_record'
require 'time'


# in Base.rb @attributes||initialize eingebaut und es geht fast.
# mit Ruby 1.8.7 sind sogar die Umlaute okay ;-)
# wenn die letzte Zeile entfernt wird, dann funktioniert es ohne Fehler !! 
# also 1. Programm Mails_holen.sh starten -> Mails_holen.rb holt die Dateien
# 2. das einladen in die Datenbank schlägt fehl weil die Datei wg. der letzten 
# Zeile nicht geladen werden kann.
# woher kommt diese Zeile ??

                                                           
ActiveRecord::Base::establish_connection(                  
  :adapter=>"sqlite3",                                                                    
  :host=>"localhost",                                                                         
  :database=>"db/development.sqlite3")                                                              
                                                                                      
                                                                                         
ActiveSupport::Inflector.inflections do |inflect|
# Inflector.inflections do |inflect|
   inflect.irregular 'aufgabe', 'aufgaben'
   inflect.irregular 'karte', 'kartei'
 end                                     

  class Aufgabe < ActiveRecord::Base
  end 
  
  class Karte < ActiveRecord::Base
  end 
  
  def in_datei_schreiben (datei,liste)   # schreibt die übergebene Datensäte in angegebene Date
    File.open(datei,'w+') do |f|  
      f.puts liste.to_yaml
     end   
  end
  
  def akt_kartei_in_file   
    @kartei= Karte.find_by_sql("select * from kartei where                                       
     ( strftime('%d.%m.%Y',aend_dat) = strftime('%d.%m.%Y', date('now','localtime','-1461 days'))
     or strftime('%d.%m.%Y',anl_dat) =strftime('%d.%m.%Y', date('now','localtime','-1461 days')))") 
     in_datei_schreiben 'akt_kartei',@kartei 
   # @kartei.each do |karte|
   # 	Karte.find(karte[:id]).destroy if Karte.exists?(karte[:id])     
   # end
  end
  
  def akt_kartei_in_db
    @aktuelles= YAML.load_file("akt_kartei") 
    @aktuelles.each do |karte| 
      Karte.find(karte[:id]).destroy if Karte.exists?(karte[:id])	
      kartei =Karte.new
      kartei.id							= karte.id             
      kartei.anl_dat        = karte.anl_dat        
      kartei.aend_dat       = karte.aend_dat       
      kartei.question       = karte.question       
      kartei.answer         = karte.answer         
      kartei.sparte         = karte.sparte         
      kartei.folder         = karte.folder         
      kartei.kapitel        = karte.kapitel        
      kartei.not_known_today = karte.not_known_today 
      kartei.save
      p "Kartei mit id=#{kartei.id} geschrieben"
    end
  end

  def aktuelle_aufgabe_in_file
    @aufgaben= Aufgabe.find_by_sql(" select * from aufgaben where
    ( strftime('%d.%m.%Y',aend_dat) = strftime('%d.%m.%Y', date('now'))
      or strftime('%d.%m.%Y',erfasst) = strftime('%d.%m.%Y', date('now')))") 
     in_datei_schreiben 'akt_aufgaben',@aufgaben
  end 

  def aktuelle_aufgabe_in_db    #  Aufgaben laden und neu in der Datenbank speichern
      @aktuelles= YAML.load_file("/home/andreas/ror/todo_app/akt_aufgaben")                         
       @aktuelles.each do |task|   
         Aufgabe.find(task[:id]).destroy if Aufgabe.exists?(task[:id])
         aufgabe = Aufgabe.new         
         task.attribute_names.each do |attr| 
          eval "aufgabe.#{attr}=task.#{attr}"
         end      
         aufgabe.save  
         p "Aufgabe mit id=#{aufgabe.id} geschrieben"       
       end
   end
#  aktuelle_aufgabe_in_file
 aktuelle_aufgabe_in_db
# akt_kartei_in_file
 akt_kartei_in_db
