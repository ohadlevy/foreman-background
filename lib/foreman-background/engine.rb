require 'sidekiq'

module ForemanBackground
  class Engine < ::Rails::Engine
    config.autoload_paths += Dir["#{config.root}/app/workers"]
    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]

    if (s = SETTINGS[:sidekiq])
      s[:namespace] = 'foreman'
      Sidekiq.configure_server { |config| config.redis = s }
      Sidekiq.configure_client { |config| config.redis = s }
    end

    # Include extensions to models in this config.to_prepare block
    config.to_prepare do
      # Extend the report model
      ::Api::V2::ReportsController.send :include, ForemanBackground::API::ReportsControllerExtensions
    end
    Rails.logger.info 'Sidekiq and Redis enabled, make sure that you have the sidekiq process running'
  end
end
