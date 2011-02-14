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
    def all(page = 1, limit = 100, latest = true)
      opts = CrowdFlower.version == 2 ? {:unseen => latest} : {:latest => latest}
      get(resource_uri, {:query => {:limit => limit, :page => page}.merge(opts)})
    end
    
    def get(id)
      get("#{resource_uri}/#{id}")
    end
    
    # Reject an individual Judgment.
    # 
    # *Admin-only && MTurk-only*
    # 
    # @param [String,Integer] id The CrowdFlower id for the judgment to reject.
    def reject( id )
      put( "#{resource_uri}/#{id}/reject", :headers => { "Content-Length" => 0 } )
    end
    
    protected
    
    def put( *args )
      connection.put *args
    end
    
    def get( *args )
      connection.get *args
    end
  end
end
