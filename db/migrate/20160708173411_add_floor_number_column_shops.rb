class AddFloorNumberColumnShops < ActiveRecord::Migration
  def change
    add_column :shops, :floor_number, :string
  end
end
