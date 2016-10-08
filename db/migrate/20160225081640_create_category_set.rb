class CreateCategorySet < ActiveRecord::Migration
  def change
    create_table :category_set do |t|
      t.string :catset_id                       # catset_id
      t.string :category_id,    :null => false  # category_id
      t.string :shopId,         :null => false  # shopId

      t.timestamps null: false
    end
  end
end
