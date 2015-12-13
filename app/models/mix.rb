class Mix < ActiveRecord::Base
  # belongs_to :track
  belongs_to :user
  belongs_to :mix
  has_many :mixes
  mount_uploader :audio_file, AudioFileUploader
  # validates :audio_file, presence: { message: "You forgot an attachment." }
  # search function
  def self.search(query)
    where("name like ?", "%#{query}%") 
  end
end
