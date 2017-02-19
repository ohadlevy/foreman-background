class ConfigurationImportReportJob < ActiveJob::Base
  queue_as :reports
  rescue_from(ErrorLoadingSite) do
    retry_job wait: 5.minutes, queue: :failed_reports
  end

  def perform(raw_report, proxy_id = nil)
    report = JSON.prase(raw_report)
    User.as :admin do
      ConfigReportImporter.import(report, proxy_id)
    end
  end
end
