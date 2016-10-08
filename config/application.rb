require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JMAPapi
  module ApiServer
    class Application < Rails::Application
      # Settings in config/environments/* take precedence over those specified here.
      # Application configuration should go into files in config/initializers
      # -- all .rb files in that directory are automatically loaded.
  
      # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
      # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
      # config.time_zone = 'Central Time (US & Canada)'
        config.time_zone = 'Tokyo'
        config.active_record.default_timezone = :local
  
      # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
      # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
      # config.i18n.default_locale = :de
  
      # Do not swallow errors in after_commit/after_rollback callbacks.
      config.active_record.raise_in_transactional_callbacks = true
  
      # config.action_dispatch.default_headers = {
      #   'Access-Control-Allow-Origin' => '*',
      #   'Access-Control-Request-Method' => 'GET, POST'
      # }

      config.middleware.insert_before 0, "Rack::Cors", :debug => true, :logger => (-> { Rails.logger }) do
        allow do
          origins '*'

          resource '/cors',
                   :headers => :any,
                   :methods => [:post],
                   :credentials => true,
                   :max_age => 0

          resource '*',
                   :headers => :any,
                   :methods => [:get, :post, :delete, :put, :patch, :options, :head],
                   :max_age => 0
        end
      end
  
      # to auto load lib/ directory
      config.generators do |g|
        g.javascripts false
        g.stylesheets false
        g.helper true
        g.template_engine :jbuilder
        g.test_framework :rspec, view_specs: false, helper_specs: true, fixture: true
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
      end
      #config.autoload_paths += %W(#{config.root}/lib/)
    end
  end
end
