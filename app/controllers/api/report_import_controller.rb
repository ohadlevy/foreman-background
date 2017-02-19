class ReportImportController < ActionController::Metal
  include Foreman::Controller::SmartProxyAuth
  add_smart_proxy_filters :create, features: proc {
    ConfigReportImporter.authorized_smart_proxy_features
  }

  def create
    ConfigurationImportReportJob.perform_later(
      request.raw_post,
      detected_proxy.try(:id)
    )
  end
end
