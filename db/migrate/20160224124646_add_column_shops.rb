class AddColumnShops < ActiveRecord::Migration
  def change
    add_column :shops, :shop_type, :string
  end
end
