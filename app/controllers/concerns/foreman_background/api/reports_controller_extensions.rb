module ForemanBackground::API::ReportsControllerExtensions
  extend ActiveSupport::Concern
  included do
    alias_method_chain :create, :background
  end

  def create_with_background
    if BaseWorker.redis_available?
      ReportCreator.perform_async(params[:report])
      head :status => 202
    else
      logger.warn 'REDIS is not available, blocking until report processing is done.'
      create_without_background
    end
  rescue ::Foreman::Exception => e
    render :json => {'message'=>e.to_s}, :status => :unprocessable_entity
  end
end