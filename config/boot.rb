ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# tsuno added +++
# With local env, Net::HTTP NameErrorになる。これをここでrequireしておくとエラー解消になる
require 'net/http'
# tsuno ---