class Mix < ActiveRecord::Base
  # belongs_to :track
  belongs_to :user
  belongs_to :mix
  has_many :mixes
  mount_uploader :audio_file, AudioFileUploader
  # allow tagging
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  # validators
  validates :audio_file, presence: { message: "You forgot an attachment." }
end
