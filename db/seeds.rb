# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

seeds_dir  = "#{Rails.root}/db/seeds"

csv_files = Dir.entries(seeds_dir).select {|f| f =~ /\.csv$/ }
csv_files.each do |csv_file|

  model_name = File.basename(csv_file, '.csv')
  model_name = model_name.gsub(/[0-9]|_/,"")
  
  model      = model_name.classify.constantize

  path = "#{seeds_dir}/#{csv_file}"
  csv  = CSV.read(path, headers: true, converters: :numeric)
  ActiveRecord::Base.transaction do
    csv.each do |row|
      # idが重複するレコードがある場合はupdate
      if row.has_key?('id')
        record = model.where(id: row['id']).first
        if record.present?
          record.update(row.to_hash)
          next
        end
      end

      model.create(row.to_hash)
    end
  end
end
Locale.first_or_create [
  { id: 1, lang: 'ja', description: '日本語' },
  { id: 2, lang: 'en-us', description: '英語(US)' },
  { id: 3, lang: 'zh-cn', description: '中国語(簡体字)' },
  { id: 4, lang: 'zh-tw', description: '中国語(繁体字)' },
]
