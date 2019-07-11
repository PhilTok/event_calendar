class Event < ApplicationRecord
  belongs_to :user
  validates :datetime, presence: true
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 25 }
  validates :content, length: { maximum: 140 }
  default_scope -> { order(:datetime) } 
end
