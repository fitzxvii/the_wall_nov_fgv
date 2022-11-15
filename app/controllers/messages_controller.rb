class MessagesController < ApplicationController
    before_action :is_user_logged_in?

    def index
        @all_messages = Message.get_messages[:result]
    end

    def create_message
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            require_params = params.permit!.require(:message)

            if require_params.present?
                create_message = Message.create_message({:user_id => session[:user_id], :message => params[:message]})

                if create_message[:status]
                    response_data[:status] = true
                    response_data[:result] = render_to_string :partial => "messages/partials/new_message_partial", :locals => create_message[:result]
                else
                    response_data[:error] = create_message[:error]
                end
            end
        rescue Exception => ex
            response_data[:error] = ex
        end

        render :json => response_data
    end

    def delete_message
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            require_params = params.permit!.require(:message_id)

            response_data = Message.delete_message({:user_id => session[:user_id], :message_id => params[:message_id]}) if require_params.present?
        rescue Exception => ex
            response_data[:error] = ex
        end

        render :json => response_data
    end
end
