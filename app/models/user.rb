class User < ActiveRecord::Base

  has_secure_password
  
  has_many :permissions
  
  validates :email, presence: true
  
  def self.reset_request_count!
    where( "request_count > 0" ).update_all( "request_count = 0" )
  end

  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end

end
