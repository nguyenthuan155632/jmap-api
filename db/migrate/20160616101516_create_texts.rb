class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :type, limit: 10, null: false
      t.string :entity_id, limit: 20, null: false
      t.string :name, limit: 20, null: false
      t.string :lang, limit: 10, null: false
      t.text :value, null: false

      t.timestamps null: false
    end

    add_index :texts, [:type, :entity_id, :name, :lang], :unique => true
  end
end
