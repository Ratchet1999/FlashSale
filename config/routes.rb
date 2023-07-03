Rails.application.routes.draw do
  root "store#homepage"
  devise_for :users, controllers: { :sessions => "user/sessions" }

  namespace :admin do
    resources :deals do
      patch 'check_publishablity', to: 'deals#check_publishablity', on: :member
    end
  end
end
