require 'rails_helper'

describe 'Car Management', type: :request do
  context 'show' do
    it 'redirect to car show' do
      car = create(:car)
  
      get api_v1_car_path(car)
      json = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to have_http_status(:ok)
      expect(json[:car_model_id]).to eq(car.car_model_id)
      expect(json[:car_km]).to eq(car.car_km)
      expect(json[:license_plate]).to eq(car.license_plate)
      expect(json[:color]).to eq(car.color)
      expect(json[:status]).to eq(car.status)
      expect(json[:subsidiary_id]).to eq(car.subsidiary_id)
    end

    it 'doesnt have a car' do
      get api_v1_car_path(id: 999)

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'index' do
    it 'redirect to cars index' do
      car = create(:car, color: 'Azul', car_km: 10000)
      other_car = create(:car, color: 'Amarelo', car_km: 5000)
      another_car = create(:car, color: 'Vermelho', car_km: 2000)

      get api_v1_cars_path
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json.first[:color]).to eq(car.color)
      expect(json.first[:car_km]).to eq(car.car_km)
      expect(json.second[:color]).to eq(other_car.color)
      expect(json.second[:car_km]).to eq(other_car.car_km)
      expect(json.third[:color]).to eq(another_car.color)
      expect(json.third[:car_km]).to eq(another_car.car_km)
    end

    it 'doesnt have any car' do
      get api_v1_cars_path

      expect(response).to have_http_status(:not_found)
    end
  end
end