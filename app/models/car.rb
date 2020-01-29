class Car < ApplicationRecord
  enum status: { available: 0, unavailable: 10, pending_inspection: 20 }
  belongs_to :car_model
  belongs_to :subsidiary
  has_one :category, through: :car_model
  has_one_attached :photo
  validates :car_km, presence: true
  validates :color, presence: true
  validates :license_plate, presence: true
  validates :license_plate, uniqueness: true
end
