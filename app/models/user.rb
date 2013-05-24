class User < ActiveRecord::Base

  authenticates_with_sorcery!

  validates :email, :presence => true, :uniqueness => true
  validates :password, {:confirmation => true, :presence => true, :if => :password}

end
