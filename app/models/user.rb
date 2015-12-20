class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tracks
  has_many :mixes

  # validators
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  # search function
  def self.search(query)
    where(['lower(name) like ?', "%#{query.downcase}%"])
  end
end
