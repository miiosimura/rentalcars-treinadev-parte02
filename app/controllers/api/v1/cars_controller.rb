require "open-uri"
class Api::V1::CarsController < Api::V1::ApiController

  def index
    @cars = Car.all
    if @cars.any?
      render json: @cars
    else
      render status: :not_found, json: @cars
    end
  end

  def show
    @car = Car.find(params[:id])
    render json: @car
  end

  def create
    @car = Car.create!(params.permit(%i[car_model_id car_km color license_plate 
                                       status subsidiary_id]))
    # @car.photo.attach(params[:photo])
    photo_url = params.permit(:photo)["photo"]
    @car.photo.attach(
        io: open(photo_url),
        filename: photo_url.split('/')[-1]
      )
    puts url_for(@car.photo)
    render json: @car, status: :created
  end

  def update
    @car = Car.find(params[:id])
    @car.update!(params.permit(%i[car_model_id car_km color license_plate 
                                  status subsidiary_id]))
    render json: @car, status: :ok
  end
  
  def destroy
    @car = Car.find(params[:id])
    if @car.delete
      render json: 'Carro apagado com sucesso!', status: :ok
    end
  end
end