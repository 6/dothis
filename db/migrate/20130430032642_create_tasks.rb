class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id, :null => false
      t.text :title, :null => false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
