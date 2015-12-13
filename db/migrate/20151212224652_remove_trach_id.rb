class RemoveTrachId < ActiveRecord::Migration
  def change
  	remove_column :mixes, :track_id
  end
end
