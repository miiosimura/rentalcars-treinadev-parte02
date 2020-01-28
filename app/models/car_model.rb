class CarModel < ApplicationRecord
  has_one_attached :photo
  belongs_to :manufacture
  belongs_to :fuel_type
  belongs_to :category
  has_many :cars
  validates :name, presence: true
  validates :year, presence: true
  validates :car_options, presence: true

  def fipe_price
    response = HTTParty.get('/api/1/carros/veiculo/21/4828/2014-1.json')
  end
end
