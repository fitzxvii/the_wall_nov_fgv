class Comment < ApplicationRecord
    include :: QueryHelper

    def self.create_comment(params)
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            new_comment_id = query_insert([
                "INSERT INTO comments (message_id, user_id, comment, created_at, updated_at)
                VALUES (?, ?, ?, NOW(), NOW());", params[:message_id], params[:user_id], params[:comment]
            ])

            if new_comment_id > 0
                response_data[:status] = true
                response_data[:result] = {:id => new_comment_id, :comment => params[:comment]}
            else
                response_data[:error] = "Insert new comment failed."
            end
        rescue Exception => ex
            response_data[:error] = ex
        end

        return response_data
    end

    def self.delete_comment(params)
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            delete_comment = query_delete([
                "DELETE FROM comments WHERE id = ? AND user_id = ?;", params[:comment_id], params[:user_id]
            ])

            if delete_comment > 0
                response_data[:status] = true
                response_data[:result] = params[:comment_id]
            else
                response_data[:error] = "No comment deleted."
            end
        rescue Exception => ex
            response_data[:error] = ex
        end

        return response_data
    end
end
