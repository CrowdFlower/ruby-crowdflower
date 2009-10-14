module CrowdFlower
  class Order
    include Defaults
    attr_reader :job
    
    def initialize(job)
      @job = job
      Order.connect
    end

    def resource_uri
      "/jobs/#{@job.id}/orders"
    end
    
    def debit(percentage = 100, channels = ["amt"])
      Order.post(resource_uri, {:body => {:percentage => percentage, :channels => channels}})
    end
  end
end
