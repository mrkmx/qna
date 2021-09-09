class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check
  
  def github
    sign_in_with_oauth
  end

  def facebook
    sign_in_with_oauth
  end

  private

  def sign_in_with_oauth
    req = request.env['omniauth.auth']
    provider = req.provider
    @user = User.find_for_oauth(req)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize()) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
