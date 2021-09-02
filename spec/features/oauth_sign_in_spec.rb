require 'rails_helper'

feature 'The user can sign in from provider', %q{
  In order to sign in to the resource
  As an unauthenticated user
  I would like to be able to use my social network account
} do

  describe 'Sign in with Github' do
    background do
      mock_auth_hash(provider: :github, email: 'github@github.com')

      visit new_user_session_path
    end

    scenario 'when the guest tries to sign in' do
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    context 'when the user already has authorization with GitHub' do
      given(:user) { create(:user, email: 'github@github.com') }
      given(:authorization) { create(:authorization, user: user) }

      scenario 'and tries to sign in' do
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end

    scenario 'when there is an authentication error occurs' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials".'
    end

  end
end
