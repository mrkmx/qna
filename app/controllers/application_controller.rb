class ApplicationController < ActionController::Base
  before_action :fetch_shared_params

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to request.path, alert: exception.message }
      format.json { head :forbidden }
      format.js { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  private
  
  def fetch_shared_params
    payload = {
      params: params.permit(:id),
      user_id: current_user&.id
    }

    gon.push(payload)
  end
end
