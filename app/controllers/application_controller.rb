class ApplicationController < ActionController::Base
  before_action :fetch_shared_params

  private
  
  def fetch_shared_params
    payload = {
      params: params.permit(:id),
      user_id: current_user&.id
    }

    gon.push(payload)
  end
end
