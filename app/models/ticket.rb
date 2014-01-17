class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  mount_uploader :asset, AssetUploader

  validates :title, presence: true
  validates :description, presence: true, 
                          length: { minimum: 10 }
end
