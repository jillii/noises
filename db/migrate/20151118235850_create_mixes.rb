class CreateMixes < ActiveRecord::Migration
  def change
    create_table :mixes do |t|
      t.references :track, index: true
      t.references :user, index: true
      t.string :audio_file
      t.string :name

      t.timestamps
    end
  end
end
