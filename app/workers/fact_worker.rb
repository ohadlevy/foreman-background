class FactWorker < BaseWorker
  delegate :logger, :to => Rails
  sidekiq_options :queue => :facts, :retry => false, :backtrace => true

  def perform(type, name, facts, certname)
    begin
      type = type.constantize
    rescue NameError => e
      logger.error "facts were not imported - #{e.message}"
      logger.error e.backtrace.join("\n")
    end

    facts = facts.with_indifferent_access

    User.as :admin do
      type.importHostAndFacts name, facts, certname
    end
  end
end
