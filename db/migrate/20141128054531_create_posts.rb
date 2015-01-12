class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :description
      t.decimal :price
      t.integer :user_id
      t.integer :sold

      t.timestamps
    end
  end
end
