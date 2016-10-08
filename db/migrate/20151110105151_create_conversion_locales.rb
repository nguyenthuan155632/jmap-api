class CreateConversionLocales < ActiveRecord::Migration
  def change
    create_table :conversion_locales do |t|
      t.string :locale, :null => false        # 言語コード
      t.string :lang, :null => false          # 変換言語コード
      t.string :description                   # ロケール名
      t.timestamps null: false
    end
  end
end
