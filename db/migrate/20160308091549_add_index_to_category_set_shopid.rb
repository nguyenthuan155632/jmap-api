class AddIndexToCategorySetShopid < ActiveRecord::Migration
  def change
    add_index :category_set, :shopId
  end
end
