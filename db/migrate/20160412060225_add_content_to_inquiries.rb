class AddContentToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :content, :text
  end
end
