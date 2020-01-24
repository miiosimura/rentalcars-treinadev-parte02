class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :database_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :filled_required_fields

  private

  def record_not_found
    render status: :not_found, json: 'Registro não encontrado'
  end

  def filled_required_fields(expection)
    render status: :precondition_failed, json: expection
  end

  def database_error
    render status: :internal_server_error, json: 'Erro no banco'
  end
end