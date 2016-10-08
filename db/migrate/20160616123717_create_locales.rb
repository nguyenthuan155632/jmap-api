class CreateLocales < ActiveRecord::Migration
  def change
    create_table :locales do |t|
      t.string :lang, limit: 10, null: false
      t.string :description

      t.timestamps null: false
    end

    add_index :locales, :lang, :unique => true
  end
end
