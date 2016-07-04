class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.references :mix, index: true
      t.integer :state

      t.timestamps
    end
  end
end
