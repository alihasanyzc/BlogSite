class Profile < ApplicationRecord
  belongs_to :user
  
  has_one_attached :avatar
  
  validates :bio, length: { maximum: 500 }
  validate :avatar_validation
  
  private
  
  def avatar_validation
    return unless avatar.attached?
    
    unless avatar.blob.content_type.start_with?('image/')
      errors.add(:avatar, 'must be an image')
    end
    
    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, 'is too large (maximum 5MB)')
    end
  end
end
