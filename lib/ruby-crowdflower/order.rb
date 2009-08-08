module CrowdFlower
  class Order
    include Defaults
    attr_reader :job
    
    def initialize(job)
      @job = job
      Order.base_uri CrowdFlower.with_domain("/jobs/#{@job.id}/orders")
      Order.default_params CrowdFlower.key
    end
    
    def debit(percentage = 100)
      Order.post("", {:query => {:percentage => percentage}})
    end
  end
end