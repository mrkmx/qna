require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper
  
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  root to: "questions#index"

  get :search, to: 'searches#index'

  concern :votable do
    member { post :vote }
    member { post :revote }
  end

  concern :commented do
    post :comment, on: :member
  end

  resources :questions, concerns: [:votable, :commented] do
    resources :answers, shallow: true, concerns: [:votable, :commented] do
      patch :best, on: :member
    end
  end

  resources :subscriptions, only: %i[create destroy]

  resources :files, only: :destroy

  resources :rewards, only: :index

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, shallow: true, except: %i[new] do
        resources :answers, except: %i[new]
      end
    end
  end

end
