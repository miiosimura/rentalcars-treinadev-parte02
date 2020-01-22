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
    if Car.where(id: params[:id]).present?
      @car = Car.find(params[:id])
      render json: @car
    else
      render status: :not_found, json: ''
    end
  end
end