class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.string :venueId, :null => false # 施設ID（追記：マイセロのIDが入るよう仕様変更）
      t.string :shopId,  :null => false # 店舗ID（追記：マイセロのIDが入るよう仕様変更）
      t.string :name
      t.text   :value
      t.timestamps null: false
    end
  end
end
