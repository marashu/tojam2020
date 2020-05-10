Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'games#new'

  resource :games do
    member do
      get :join
      post :confirm_join
    end
  end

  resource :player do
    member do
      post :update
    end
  end
end
