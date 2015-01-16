class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :word
      t.integer :retailer_id

      t.timestamps
    end
  end
end
