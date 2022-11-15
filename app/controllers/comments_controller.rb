class CommentsController < ApplicationController
    before_action :is_user_logged_in?

    def create_comment
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            require_params = params.permit!.require([:message_id, :comment])

            if require_params.present?
                create_comment = Comment.create_comment({:user_id => session[:user_id], :message_id => params[:message_id], :comment => params[:comment]})

                if create_comment[:status]
                    response_data[:status] = true
                    response_data[:result] = {
                        :message_id => params[:message_id],
                        :html => render_to_string(:partial => "comments/partials/new_comment_partial", :locals => create_comment[:result])
                    }
                else
                    response_data[:error] = create_comment[:error]
                end
            end
        rescue Exception => ex
            response_data[:error] = ex
        end

        render :json => response_data
    end

    def delete_comment
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            require_params = params.permit!.require(:comment_id)

            response_data = Comment.delete_comment({:user_id => session[:user_id], :comment_id => params[:comment_id]}) if require_params.present?
        rescue Exception => ex
            response_data[:error] = ex
        end

        render :json => response_data
    end
end
