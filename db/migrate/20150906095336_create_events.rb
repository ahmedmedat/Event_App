class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.column "name",:string, :limit => 100
      t.integer "date" 
      t.text "description",:default => "",:null =>false
      t.string "location",:limit =>100
      t.string "username",:limit => 50
      t.timestamps  
    end
  end
  def down
  	drop_table :events
  end
end
