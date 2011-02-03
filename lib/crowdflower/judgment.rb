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
      opts = CrowdFlower.version == 2 ? {:unseen => latest} : {:latest => latest}
      connection.get(resource_uri, {:query => {:limit => limit, :page => page}.merge(opts)})
    end
    
    def get(id)
      connection.get("#{resource_uri}/#{id}")
    end
  end
end
