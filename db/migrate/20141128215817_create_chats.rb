class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :user_1
      t.integer :user_2
      t.string :post_id
      t.integer :complete

      t.timestamps
    end
  end
end
