module CrowdFlower
  class Judgment
    include Defaults
    attr_reader :job
    
    def initialize(job)
      @job = job
      Judgment.base_uri CrowdFlower.with_domain("/jobs/#{@job.id}/judgments")
      Judgment.default_params CrowdFlower.key
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