require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash(
        provider: :github,
        email: 'user@github.com'
      )
    end

    context 'when the user exists' do
      let(:user) { create(:user, email: 'user@github.com') }

      before do
        create(:authorization, user: user)

        get :github
      end

      it 'logins the user' do
        expect(controller.current_user).to eq(user)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when the user does not exists' do
      it 'logins created user' do
        get :github

        expect(controller.current_user.email).to eq('user@github.com')
      end

      it 'does not login user' do
        expect { get :github }.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        get :github

        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'Facebook' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash(
        provider: :facebook,
        email: 'user@facebook.com'
      )
    end

    context 'when the user exists' do
      let(:user) { create(:user, email: 'user@facebook.com') }

      before do
        create(:authorization, user: user)

        get :facebook
      end

      it 'logins the user' do
        expect(controller.current_user).to eq(user)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when the user does not exists' do
      it 'logins created user' do
        get :facebook

        expect(controller.current_user.email).to eq('user@facebook.com')
      end

      it 'does not login user' do
        expect { get :facebook }.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        get :facebook

        expect(response).to redirect_to root_path
      end
    end
  end

end 
