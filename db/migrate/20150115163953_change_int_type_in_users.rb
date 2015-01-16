class ChangeIntTypeInUsers < ActiveRecord::Migration
  def change
    change_column :users, :latitude, :float, :precision => 12, :scale => 9
    change_column :users, :longitude, :float, :precision => 12, :scale => 9
  end
end
