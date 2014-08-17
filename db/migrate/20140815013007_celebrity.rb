class Celebrity < ActiveRecord::Migration
  def change
  	create_table :celebrities do |t|
  	  t.string :name
  	end
  end
end
