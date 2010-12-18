module CrowdFlower
  class Judgment < Base
    attr_reader :job
    
    def initialize(job)
      super job.connection
      @job = job
      connect
    end
    
    def resource_uri
      "/jobs/#{@job.id}/judgments"
    end
    
    #Pull every judgment
    def all(page = 1, limit = 100, latest = true)#full = true
      connection.get(resource_uri, {:query => {:limit => limit, :page => page, :latest => latest}})
    end
    
    def get(id)
      connection.get("/#{id}")
    end
  end
end