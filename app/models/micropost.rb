class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  def picture_size
    if picture.size > 7.megabytes
      errors.add(:picture, "Size should be less than 7 mb.")
    end
  end

end
