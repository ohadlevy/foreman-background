class ReportWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :reports, :retry => false, :backtrace => true

  def perform(report)
    User.as :admin do
      Report.import(report)
    end
  end

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