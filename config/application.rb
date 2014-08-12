require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module MTAstatus
  class Application < Rails::Application
    config.after_initialize do
      update_cache
      system('bundle exec whenever --update-crontab')
      trap("SIGINT") do
      	puts "*"*500
      end
    end
  end
end
