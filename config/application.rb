require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MTAstatus
  class Application < Rails::Application
    config.after_initialize do
      write_to_cache
    end
  end
end
