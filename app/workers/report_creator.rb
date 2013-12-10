class ReportCreator < BaseWorker
  sidekiq_options :queue => :reports

  def perform(report)
    User.as :admin do
      Report.import(report)
    end
  end

end
