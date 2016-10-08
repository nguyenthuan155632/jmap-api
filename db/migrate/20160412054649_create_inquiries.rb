class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.string :emailaddress
      t.datetime :inquiry_date

      t.timestamps null: false
    end
  end
end
