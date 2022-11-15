class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def is_user_logged_in?
        redirect_to "/" if !session[:user_id].present?
    end
end
