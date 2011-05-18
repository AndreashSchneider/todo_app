class Aufgabe < ActiveRecord::Base
   def self.search(search, suchbedingung)  
     if search  
       where(suchbedingung)  #'aufgabe LIKE ?', "%#{search}%"
     else  
       scoped  
     end  
   end  
end
