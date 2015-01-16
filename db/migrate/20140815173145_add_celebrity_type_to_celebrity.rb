class AddCelebrityTypeToCelebrity < ActiveRecord::Migration
  def change
  	add_column :celebrities, :celebrity_type, :text
  end
end
