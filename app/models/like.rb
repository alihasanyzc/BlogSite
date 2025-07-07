class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
  
  validates :user_id, uniqueness: { scope: :post_id }
  
  scope :liked, -> { where(liked: true) }
  scope :unliked, -> { where(liked: false) }
end
