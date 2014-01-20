class ReportWorker < BaseWorker
  sidekiq_options :queue => :reports, :retry => false, :backtrace => true

  def perform(report)
    User.as :admin do
      Report.import(report)
    end
  end

end
