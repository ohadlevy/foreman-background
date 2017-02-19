module ForemanBackground
  class Engine < ::Rails::Engine
    # config.autoload_paths += Dir["#{config.root}/app/jobs"]
    config.active_job.queue_adapter = :sidekiq
  end
end
