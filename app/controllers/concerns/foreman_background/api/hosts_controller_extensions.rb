module ForemanBackground::API::HostsControllerExtensions
  extend ActiveSupport::Concern
  included do
    alias_method_chain :create, :background
  end

  def create_with_background
    if BaseWorker.redis_available?
      uuid       = Foreman.uuid
      attributes = params[:host].merge(:progress_report_id => uuid)
      attributes[:managed] = true if (attributes && attributes[:managed].nil?)

      @host = Host::Managed.new(attributes)
      if @host.valid?
        HostCreator.perform_async(attributes, User.current.name.to_sym)
        render :status => 202, :json => { :href => {:tasks => { :id => uuid }}}
      else
        process_resource_error
      end
    else
      logger.warn 'REDIS is not available, blocking until report processing is done.'
      create_without_background
    end
  rescue ::Foreman::Exception => e
    render :json => { 'message' => e.to_s }, :status => :unprocessable_entity
  end
end