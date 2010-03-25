module CrowdFlower
  class Order
    include Defaults
    attr_reader :job
    
    def initialize(job)
      @job = job
      Order.connect
    end

    def resource_uri
      "/jobs/#{@job.id}/orders.json"
    end
    
    def debit(units_count = 1, channels = ["amt"])
      Order.post(resource_uri, {:query => {:debit => {:units_count => units_count}, :channels => channels}})
    end
  end
end
