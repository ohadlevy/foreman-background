module ForemanBackground::API::HostsControllerExtensions
  extend ActiveSupport::Concern
  included do
    alias_method_chain :facts, :background
  end

  def facts_with_background
    if FactWorker.redis_available? && facts_import_supports_background?
      facts = params[:facts].to_json
      FactWorker.perform_async(detect_host_type.to_s, params[:name], params[:facts], params[:certname])
      head :status => 202
    else
      logger.warn 'REDIS is not available , blocking until report processing is done.' unless FactWorker.redis_available?
      logger.warn 'Import type does not support background processing, blocking until report processing is done.' unless facts_import_supports_background?
      facts_without_background
    end
  rescue ::Foreman::Exception => e
    render :json => {'message'=>e.to_s}, :status => :unprocessable_entity
  end

  def facts_import_supports_background?
    @facts_import_supports_background ||= begin
      type     = params.fetch(:facts, {})[:_type] || 'puppet'
      importer = FactImporter.importer_for(type)
      importer.respond_to?(:support_background) && importer.support_background
    end
  end
end

def facts
  @host, state = detect_host_type.importHostAndFacts params[:name],params[:facts],params[:certname]
  process_response state
rescue ::Foreman::Exception => e
  render :json => {'message'=>e.to_s}, :status => :unprocessable_entity
end
