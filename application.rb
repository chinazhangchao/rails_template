require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dataaudit
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = (ENV['TIME_ZONE'] || 'Beijing')
    config.i18n.default_locale = (ENV['LOCALE'] || 'zh-CN').to_sym

    config.web_console.whitelisted_ips = '10.0.0.0/16' if Rails.env.development?

    # config.autoload_paths << "#{Rails.root}/app/models/"
  end
end
