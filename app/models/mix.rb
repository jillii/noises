class Mix < ActiveRecord::Base
  # belongs_to :track
  belongs_to :user
  belongs_to :mix
  has_many :mixes
  mount_uploader :audio_file, AudioFileUploader
  validates :audio_file, file_size: { less_than: 2.gigabytes }

  # allow tagging
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  ActsAsTaggableOn.remove_unused_tags = true
  ActsAsTaggableOn.force_lowercase = true
  # validators
  validates :audio_file, presence: { message: "You forgot an attachment." }
  # search by names
	def self.search(search)
	  where("lower(name) LIKE ? ", "%#{search.downcase}%")
	end
end
