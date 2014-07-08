class AddColumnToActivity < ActiveRecord::Migration
  def change
  	add_column :activities, :list_id, :integer
  end
end
