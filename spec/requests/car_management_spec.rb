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
      expect(response.body).to eq('Registro não encontrado')
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

  context 'create' do
    it 'create new car' do
      car_model = create(:car_model)
      subsidiary = create(:subsidiary)
      car_count = Car.count
      
      post api_v1_cars_path, params: {car_model_id: car_model.id, car_km: 5000, license_plate: 'ABC1234', 
                                      color: 'Azul', status: 'available', subsidiary_id: subsidiary.id,
                                      photo: 'https://http.cat/404.jpg'}

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:created)
      expect(json[:car_model_id]).to eq(car_model.id)
      expect(json[:car_km]).to eq(5000)
      expect(json[:license_plate]).to eq('ABC1234')
      expect(json[:color]).to eq('Azul')
      expect(json[:status]).to eq('available')
      expect(json[:subsidiary_id]).to eq(subsidiary.id)
      expect(json[:photo]).to match(/wip/)
      # http://www.example.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a83fa1b764a68f1ddf631b7c75df21620ddaaca3/404.jpg  
      expect(Car.count).to eq(car_count + 1)
    end

    it 'didnt filled all fields' do
      post api_v1_cars_path, params: {}

      expect(response).to have_http_status(:precondition_failed)
      expect(response.body).to include('A validação falhou:')
      expect(response.body).to include('Modelo é obrigatório')
      expect(response.body).to include('Filial é obrigatório(a)')
      expect(response.body).to include('Quilometragem não pode ficar em branco')
      expect(response.body).to include('Cor não pode ficar em branco')
      expect(response.body).to include('Placa não pode ficar em branco')
    end

    it 'didnt filled any field' do
      car_model = create(:car_model)

      post api_v1_cars_path, params: {car_model_id: car_model.id, car_km: 5000, license_plate: 'ABC1234'}

      expect(response).to have_http_status(:precondition_failed)
      expect(response.body).to include('A validação falhou:')
      expect(response.body).to include('Filial é obrigatório(a)')
      expect(response.body).to include('Cor não pode ficar em branco')
      expect(response.body).not_to include('Modelo é obrigatório')
      expect(response.body).not_to include('Quilometragem não pode ficar em branco')
      expect(response.body).not_to include('Placa não pode ficar em branco')
    end
  end

  context 'update' do
    it 'update car' do
      car = create(:car)
      car_model = create(:car_model, name: 'Hatch')
      subsidiary = create(:subsidiary, name: 'Moratinho Motors')
      car_count = Car.count

      put api_v1_car_path(car.id), params: {car_model_id: car_model.id, car_km: 5000, license_plate: 'ABC1234', 
                                            color: 'Azul', status: 'unavailable', subsidiary_id: subsidiary.id}
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:car_model_id]).to eq(car_model.id)
      expect(json[:car_km]).to eq(5000)
      expect(json[:license_plate]).to eq('ABC1234')
      expect(json[:color]).to eq('Azul')
      expect(json[:status]).to eq('unavailable')
      expect(json[:subsidiary_id]).to eq(subsidiary.id)
      expect(Car.count).to eq(car_count)
    end

    it 'and filled only one field' do
      car = create(:car)

      put api_v1_car_path(car.id), params: { car_km: 99999 }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:car_km]).to eq(99999)
    end

    it 'and tried to fill in with empty fields' do
      car = create(:car)
      car_count = Car.count

      put api_v1_car_path(car.id), params: {car_model_id: '', car_km: '', license_plate: '', 
                                            color: '', status: '', subsidiary_id: ''}

      expect(response).to have_http_status(:precondition_failed)
      expect(response.body).to include('A validação falhou:')
      expect(response.body).to include('Filial é obrigatório(a)')
      expect(response.body).to include('Cor não pode ficar em branco')
      expect(response.body).to include('Modelo é obrigatório')
      expect(response.body).to include('Quilometragem não pode ficar em branco')
      expect(response.body).to include('Placa não pode ficar em branco')
      expect(Car.count).to eq(car_count)
    end

    it 'doesnt have a car' do
      put api_v1_car_path(id: 999)

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'delete' do
    it 'should delete a car' do
      @car = create(:car)
      car_count = Car.count

      delete api_v1_car_path(@car.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('Carro apagado com sucesso!')
      expect(Car.find_by(id: @car.id)).to eq(nil)
      expect(Car.count).to eq(car_count - 1)
    end

    it 'should delete a car and database is down' do
      allow_any_instance_of(Car).to receive(:delete).and_raise(ActiveRecord::ActiveRecordError)
      @car = create(:car)
      car_count = Car.count

      delete api_v1_car_path(@car.id)

      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to eq('Erro no banco')
      expect(Car.find(@car.id)).to eq(@car)
      expect(Car.count).to eq(car_count)
    end

    it 'tried to delete an inexistent car' do
      delete api_v1_car_path(999)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq('Registro não encontrado')
    end
  end
end