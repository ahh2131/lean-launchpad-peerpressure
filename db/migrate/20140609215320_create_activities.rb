class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :fromUser
      t.string :toUser
      t.string :type
      t.string :product

      t.timestamps
    end
  end
end
