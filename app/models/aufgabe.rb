class Aufgabe < ActiveRecord::Base
   def self.search(search, suchbedingung, datumseinschraenkung)  
     if search  
       # p "Datumseinschränkung #{datumseinschraenkung}"
       where(suchbedingung) #'aufgabe LIKE ?', "%#{search}%" 
       where(datumseinschraenkung)       
     else  
       scoped  
     end  
   end  
end
