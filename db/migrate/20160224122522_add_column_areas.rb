class AddColumnAreas < ActiveRecord::Migration
  def change
    add_column :areas, :area_type, :string
  end
end
