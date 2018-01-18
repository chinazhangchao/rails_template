require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module APPLICATION_NAME
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = (ENV['TIME_ZONE'] || 'Beijing')
    config.active_record.default_timezone = :local
    config.i18n.default_locale = (ENV['LOCALE'] || 'zh-CN').to_sym

    config.web_console.whitelisted_ips = '10.0.0.0/16' if Rails.env.development?

    config.autoload_paths << Rails.root.join('lib')
  end
end
