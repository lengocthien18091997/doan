Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  Rails.application.routes.draw do
    root "main#index"

    get "/login",  to: "sessions#new"
    post "/login",  to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    get "/dashboard", to: "main#dashboard", as: "dashboard"

    get "/register", to: "user#new"
    post "/register", to: "user#create"
    get "/user_update", to: "user#get"
    post "/user_update", to: "user#update"
    get "/user_registration_form", to: "user#registration_form", as: "user_registration_form"
    get "/user_contract/:id", to: "user#contract_form", as: "user_contract"
    post "/user_confirm_contract/:id", to: "user#confirm_contract", as: "user_confirm_contract"
    post "/user_lock/:id", to: "user#lock", as: "user_lock"
    post "/user_unlock/:id", to: "user#unlock", as: "user_unlock"
    get "/user_detail/:id", to: "user#detail", as: "user_detail"
    get "/user_export", to: "main#export_users", as: "user_export"
    get "/user_import", to: "main#new_user_import", as: "user_import"
    post "/user_import", to: "main#import_users", as: "user_import_create"

    get "/request/list", to: "request#list", as: "request_list"
    post "/request_accep/:id", to: "request#accep", as: "request_accep"
    post "/request_denial/:id", to: "request#denial", as: "request_denial"

    get "/request/:id", to: "request#new", as: "request"
    post "/request/:id", to: "request#create", as: "request_save"

    get "/timetable", to: "timetable#list"
    post "/timetable_done/:id", to: "timetable#done", as: "timetable_done"

    get "/support", to: "support#list"
    post "/support", to: "support#create"

    post "/support/processing/:id", to: "support#processing", as: "support_processing"
    post "/support/closed/:id", to: "support#closed", as: "support_closed"

    get "/tuition", to: "tuition#index"
    get "/tuition_pay/:id", to: "tuition#pay", as: "tuition_pay"
    post "/tuition_deposit/:id", to: "tuition#deposit", as: "tuition_deposit"
    post "/tuition_complete/:id", to: "tuition#complete", as: "tuition_complete"
    get "/tuition_invoice/:id", to: "tuition#invoice", as: "tuition_invoice"

    get "/review", to: "review#list", as: "review_list"
    post "/review", to: "review#create", as: "review_create"
  end

end
