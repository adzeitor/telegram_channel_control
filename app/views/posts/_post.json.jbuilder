json.extract! post, :id, :title, :description, :post_date, :telegram_message_id, :created_at, :updated_at
json.url post_url(post, format: :json)
