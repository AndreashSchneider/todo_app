class Aufgabe < ActiveRecord::Base
   def self.search(suchbedingung)  
     if suchbedingung     
        suchen = suchbedingung
        suchen
     else  
       scoped  
     end  
   end  
end
