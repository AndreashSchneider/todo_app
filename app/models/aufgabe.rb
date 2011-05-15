class Aufgabe < ActiveRecord::Base
   def self.search(search)  
     if search  
       where('aufgabe LIKE ?', "%#{search}%")  
     else  
       scoped  
     end  
   end  
end
