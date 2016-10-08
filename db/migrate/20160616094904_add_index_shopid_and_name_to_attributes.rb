class AddIndexShopidAndNameToAttributes < ActiveRecord::Migration
  def change
    add_index :attributes, [:shopId, :name]
  end
end
