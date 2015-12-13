class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :audio_file
      t.string :name
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
