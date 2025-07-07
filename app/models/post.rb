class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :body, presence: true, length: { minimum: 20 }
  
  scope :recent, -> { order(created_at: :desc) }
  
  def liked_by?(user)
    return false unless user
    likes.exists?(user: user, liked: true)
  end
  
  def likes_count
    likes.where(liked: true).count
  end
end
