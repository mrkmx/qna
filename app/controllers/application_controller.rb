class ApplicationController < ActionController::Base
  before_action :fetch_shared_params

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
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
