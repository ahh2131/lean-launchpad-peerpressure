class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :user_id
      t.integer :category_id
      t.string :time_period
      t.integer :score

      t.timestamps
    end
  end
end
