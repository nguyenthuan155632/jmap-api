class AddIndexVenueidToVenues < ActiveRecord::Migration
  def change
    add_index :venues, :venueId
  end
end
