class AddIndexAreaidToAreas < ActiveRecord::Migration
  def change
    add_index :areas, :areaid
  end
end
