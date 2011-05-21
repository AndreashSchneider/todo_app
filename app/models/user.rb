class User < ActiveRecord::Base
  attr_accessible :name, :email

  email_regex =/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates (:name, :presence => true,
                    :lenght => {:maximum => 50})
  validates (:email, :presence => true,
                     :formati => {with => email_regex})
 

end
