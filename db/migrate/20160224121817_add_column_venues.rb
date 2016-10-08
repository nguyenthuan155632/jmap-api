class AddColumnVenues < ActiveRecord::Migration
  def change
    add_column :venues, :venue_type, :string
    add_column :venues, :officialUrl, :string
  end
end
