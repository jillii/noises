class AddColumnToMixes < ActiveRecord::Migration
  def change
  	add_column :mixes, :mix_id, :integer
  end
end
