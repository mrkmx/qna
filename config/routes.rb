Rails.application.routes.draw do
  devise_for :users
  
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true do
      patch :best, on: :member
    end
  end

  resources :files, only: :destroy

  resources :rewards, only: :index

end
