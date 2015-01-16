class CreateRetailers < ActiveRecord::Migration
  def change
    create_table :retailers do |t|

      t.timestamps
    end
  end
end
