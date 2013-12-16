class Project < ActiveRecord::Base
  
  has_many :tickets, dependent: :destroy_all

  validates :name, presence: true

end
