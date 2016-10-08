class AddIndexVenueidAndNameToAttributes < ActiveRecord::Migration
  def change
    add_index :attributes, [:venueId, :name]
  end
end
