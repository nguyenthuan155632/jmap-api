class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :venueId,    :null => false  # 施設ID（追記：マイセロのIDが入るよう仕様変更）
      t.string :drowingId,  :null => false  # ドローイングID
      t.string :floorId,    :null => false  # フロアID
      t.string :shopId,     :null => false  # 店舗ID（非自動採番、追記：マイセロのIDが入るよう仕様変更）

      t.timestamps null: false
    end
  end
end
