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
    
    def debit(units_count = 1, channels = ["amt"])
      connection.post(resource_uri, {:query => {:debit => {:units_count => units_count}, :channels => channels}})
    end
  end
end
