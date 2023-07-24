require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StorageNote
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.time_zone = 'Tokyo'
    config.autoload_paths += %W[#{config.root}/app/errors]
    config.i18n.default_locale = :ja
    config.firebase = config_for(:firebase)
  end
end
