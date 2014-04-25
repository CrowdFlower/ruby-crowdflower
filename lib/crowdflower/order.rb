module CrowdFlower
  class Order < Base
    attr_reader :job
    
    def initialize(job)
      super job.connection
      @job = job
      connect
    end

    def resource_uri
      "/jobs/#{@job.id}/orders.json"
    end
    
    # defaults to on_demand; pass in diff channel name to launch job with that channel
    # use job.enable_channels("channel_name") if you to keep on_demand and add another channel
    def debit(units_count = 1, channels = ["on_demand"])
      connection.post(resource_uri, {:body => {:debit => {:units_count => units_count}, :channels => channels}})
    end
  end
end