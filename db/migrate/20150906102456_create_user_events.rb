class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|

      t.references :user
      t.references :event
      t.string :summary
      t.timestamps 
    end
    add_index :user_events ,["user_id","event_id"]
  end
  def down
  	drop_table :user_events
  end
end