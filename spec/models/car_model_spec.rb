require 'rails_helper'

describe CarModel, type: :model do
  context '#fipe_price' do
    it 'should return a price' do
      car_model = create(:car_model)

      double_response = double("response", body: { "preco": "R$ 10.000,00" })
      allow(HTTParty).to receive(:get).and_return(double_response)
      result = car_model.fipe_price

      expect(result.body[:preco]).to eq('R$ 10.000,00')
    end
  end
end