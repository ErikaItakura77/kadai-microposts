class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts #自分の投稿
  
  has_many :favorites, dependent: :destroy
  has_many :fav_microposts, through: :favorites, source: :micropost
  has_many :reverses_of_favorite, class_name: 'Favorite', foreign_key: 'micropost_id'

  def like(other_micropost)
    unless self == other_micropost
      self.favorites.find_or_create_by(micropost_id: other_micropost.id)
    end
  end

  def unlike(other_micropost)
    favorite= self.favorites.find_by(micropost_id: other_micropost.id)
    favorite.destroy if favorite
  end

  def fav_microposts?(other_micropost)
    self.fav_microposts.include?(other_micropost)
  end
  
end

