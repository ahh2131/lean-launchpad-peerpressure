class AddSignupProcessToUser < ActiveRecord::Migration
  def change
  	add_column :users, :signup_process, :integer, :default => 0
  end
end
