Rails.application.routes.draw do
  resources :staffs do
    collection do
      get :csv
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
