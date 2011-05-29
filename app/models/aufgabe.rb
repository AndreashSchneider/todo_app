class Aufgabe < ActiveRecord::Base
   has_many :projekte
   belongs_to :user
   def self.search(suchbedingung)  
     if suchbedingung     
        suchen = suchbedingung
        suchen
     else  
       scoped  
     end  
   end  
end
