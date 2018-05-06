class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.datetime :post_date
      t.integer :telegram_message_id

      t.timestamps
    end
  end
end
