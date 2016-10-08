class AddIndexToCategoryMasterCategoryId < ActiveRecord::Migration
  def change
    add_index :category_master, :category_id
  end
end
