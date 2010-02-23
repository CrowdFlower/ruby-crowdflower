module CrowdFlower
  class Judgment
    include Defaults
    attr_reader :job
    
    def initialize(job)
      @job = job
      Judgment.connect
    end
    
    def resource_uri
      "/jobs/#{@job.id}/judgments"
    end
    
    #Pull every judgment
    def all(page = 1, limit = 100, latest = true)#full = true
      Judgment.get(resource_uri, {:query => {:limit => limit, :page => page, :latest => latest}})
    end
    
    def get(id)
      Judgment.get("/#{id}")
    end
  end
end