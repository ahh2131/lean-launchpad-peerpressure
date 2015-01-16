class AddColumnToCelebrityProducts < ActiveRecord::Migration
  def change
    add_column :celebrity_products, :available, :integer, default: -1
  end
end
