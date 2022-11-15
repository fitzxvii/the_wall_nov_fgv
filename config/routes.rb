Rails.application.routes.draw do
    # Users Controller
    root "users#login_register"

    post "/register" => "users#register"
    post "/login"    => "users#login"

    get "/logout"    => "users#logout"

    # Messages Controller
    get "/main" => "messages#index"
    post "/messages/create" => "messages#create_message"
    post "/messages/delete" => "messages#delete_message"

    # Comments Controller
    post "/comments/create" => "comments#create_comment"
    post "/comments/delete" => "comments#delete_comment"
end
