module CrowdFlower
  class Order
    include Defaults
    
    def initialize(job)
      @job = job
      Order.base_uri "https://api.crowdflower.com/v1/jobs/#{@job.job_id}/orders"
      Order.default_params(CrowdFlower.conn.default_params)
    end
    
    def debit(percentage = 100)
      Order.post("", {:query => {:percentage => percentage}})
    end
  end
end