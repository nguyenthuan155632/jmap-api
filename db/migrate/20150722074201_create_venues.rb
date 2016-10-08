class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string  :areaId,     :null => false # この施設のあるエリア
      t.string  :venueId,    :null => false # この施設のID（非自動採番,追記：マイセロのIDが入る形に仕様変更）
      t.string  :country                    # 国
      t.text    :business                   # 業種
      t.text    :lat                        # 緯度
      t.text    :lon                        # 経度
      t.string  :zipCode                    # 郵便番号
      t.text    :imageUrl                   # 画像URL
      
      t.timestamps null: false
    end
  end
end
