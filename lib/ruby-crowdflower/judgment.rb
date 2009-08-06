module CrowdFlower
  class Judgment
    include Defaults
    
    def initialize(job)
      @job = job
      Judgment.base_uri "https://api.crowdflower.com/v1/jobs/#{@job.job_id}/judgments"
      Judgment.default_params(CrowdFlower.conn.default_params)
    end
    
    #Pull every judgment
    def all(page = 1, limit = 1000)#full = true
      Judgment.get("", {:query => {:limit => limit, :page => page}})
    end
    
    def get(id)
      Judgment.get("/#{id}")
    end
  end
end