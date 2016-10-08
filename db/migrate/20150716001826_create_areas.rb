class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :areaid     # エリアのID（非自動採番）
      t.text    :lat    # 緯度
      t.text    :lon   # 経度
      t.text    :url     # 画像URL
      t.timestamps null: false
    end
  end
end
