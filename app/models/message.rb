class Message < ApplicationRecord
    include :: QueryHelper

    def self.get_messages
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            all_messages = query_select_all([
                "SELECT messages.id AS message_id, message_owners.id AS message_owner_id, CONCAT(message_owners.first_name, ' ', message_owners.last_name) AS message_owner_name, message, messages.created_at AS message_created_at,
                    CASE
                        WHEN comments.id IS NOT NULL THEN
                            JSON_ARRAYAGG(JSON_OBJECT('comment_id', comments.id, 'comment', comments.comment, 'comment_owner_id', comment_owners.id, 'comment_owner_name', CONCAT(comment_owners.first_name, ' ',comment_owners.last_name), 'comment_created_at', comments.created_at))
                        ELSE NULL
                    END AS comments_json
                FROM messages
                INNER JOIN users AS message_owners ON message_owners.id = messages.user_id
                LEFT JOIN comments ON comments.message_id = messages.id
                LEFT JOIN users AS comment_owners ON comment_owners.id = comments.user_id
                GROUP BY messages.id
                ORDER BY messages.created_at DESC;"
            ])

            if all_messages.present?
                response_data[:status] = true
                response_data[:result] = all_messages
            else
                response_data[:error] = "No messages yet."
            end
        rescue Exception => ex
            response_data[:error] = ex
        end

        return response_data
    end

    def self.create_message(params)
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            new_message_id = query_insert([
                    "INSERT INTO messages (user_id, message, created_at, updated_at)
                    VALUES (?, ?, NOW(), NOW());", params[:user_id], params[:message]
            ])

            if new_message_id > 0
                response_data[:status] = true
                response_data[:result] = {:id => new_message_id, :message => params[:message]}
            else
                response_data[:error] = "Insert new message failed."
            end
        rescue Exception => ex
            response_data[:error] = ex
        end

        return response_data
    end

    def self.delete_message(params)
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            delete_message = query_delete([
                "DELETE FROM messages WHERE id = ? AND user_id = ?;", params[:message_id], params[:user_id]
            ])

            if delete_message > 0
                response_data[:status] = true
                response_data[:result] = params[:message_id]
            else
                response_data[:error] = "No message deleted."
            end
        rescue Exception => ex
            response_data[:error] = ex
        end

        return response_data
    end
end
