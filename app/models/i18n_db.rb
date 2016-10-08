class I18nDb < ActiveRecord::Base
  self.abstract_class = true
  database = YAML::load(IO.read('config/database_i18n.yml'))
  establish_connection(database[Rails.env])
end