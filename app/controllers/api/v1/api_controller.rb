class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :filled_required_fields

  private

  def record_not_found
    render status: :not_found, json: 'Record not found'
  end

  def filled_required_fields(expection)
    render status: :precondition_failed, json: expection
  end
end