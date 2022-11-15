Rails.application.routes.draw do
    # Users Controller
    root "users#login_register"

    post "/register" => "users#register"
    post "/login"    => "users#login"

    get "/logout"    => "users#logout"
end
