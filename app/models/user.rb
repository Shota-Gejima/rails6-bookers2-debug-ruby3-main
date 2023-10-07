class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  
  has_many :favorites, dependent: :destroy
  
  has_many :book_comments, dependent: :destroy
  
  
  has_many :active_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  
  has_many :followers, through: :active_relationships, source: :followed
  
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy
  
  has_many :followeds, through: :passive_relationships, source: :follower
  
  
  has_many :entries, dependent: :destroy
  
  has_many :messages, dependent: :destroy
  
  has_many :rooms, through: :entries
  
  has_many :read_counts, dependent: :destroy
  
  
  has_one_attached :profile_image
  
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  
  validates :introduction, length: { maximum: 50 }
  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  
  def following_by?(user)
    passive_relationships.find_by(follower_id: user.id).present?
  end
  
  def self.search_for(search,word)
    if search == 'perfect'
      User.where(name: word)
    elsif search == 'forward'
      User.where('name LIKE ?', word + '%')
    elsif search == 'backward'
      User.where('name LIKE ?', '%' + word)
    else
      User.where('name LIKE ?', '%' + word + '%')
    end
  end
end
