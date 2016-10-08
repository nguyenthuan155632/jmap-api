class AddIndexAreaidToVenues < ActiveRecord::Migration
  def change
    add_index :venues, :areaId
  end
end
