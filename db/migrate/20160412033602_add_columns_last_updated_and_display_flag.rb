class AddColumnsLastUpdatedAndDisplayFlag < ActiveRecord::Migration
  def change
    add_column :venues, :display_flag, :integer, :null => false, :default => 1
    add_column :venues, :last_updated, :datetime
  end
end
