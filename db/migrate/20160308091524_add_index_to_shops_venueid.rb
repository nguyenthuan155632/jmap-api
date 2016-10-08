class AddIndexToShopsVenueid < ActiveRecord::Migration
  def change
    add_index :shops, :venueId
  end
end
