class BaseWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  class << self
    def redis_available?
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

end
