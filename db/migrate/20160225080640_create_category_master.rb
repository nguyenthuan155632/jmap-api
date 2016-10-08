class CreateCategoryMaster < ActiveRecord::Migration
  def change
    create_table :category_master do |t|
      t.string :category_id,        :null => false  # category_id
      t.string :category_parentId                   # category_parentId
      t.string :categoryAttr1                       # categoryAttr1

      t.timestamps null: false
    end
  end
end
