class BaseWorker
  include Sidekiq::Worker

  def self.redis_available?
    redis_available = true
    Sidekiq.redis do |connection|
      begin
        connection.info
      rescue Redis::CannotConnectError
        redis_available = false
      end
    end
    redis_available
  end

end
