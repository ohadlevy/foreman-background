class HostCreator < BaseWorker

  def perform(attributes = {}, user)
    host = nil
    User.as user do
     host = Host::Managed.create!(attributes)
    end
  rescue Foreman::Exception, ActiveRecord::Rollback => e
    # if there was an exception, we want to able to updates the tasks output
    tasks = {:errors => host.errors, :exception => e.to_s}
    logger.debug { "writing cache #{attributes[:uuid]} as : #{tasks.inspect}"}
    Rails.cache.write(attributes[:uuid], tasks.to_json)
    #raise e
  end

end