module CrowdFlower
  class Unit
    include Defaults
    attr_reader :job
    
    def initialize(job)
      @job = job
      Unit.connect
    end

    def resource_uri
      "/jobs/#{@job.id}/units"
    end
    
    def all(page = 1, limit = 1000)
      Unit.get(resource_uri, {:query => {:limit => limit, :page => page}})
    end
    
    def get(id)
      Unit.get("#{resource_uri}/#{id}")
    end
    
    def ping
      Unit.get("#{resource_uri}/ping")
    end
    
    def judgments(id)
      Unit.get("#{resource_uri}/#{id}/judgments")
    end
    
    def create(data, gold = false)
      Unit.post(resource_uri, {:query => {:unit => {:data => data.to_json, :golden => gold}}})
    end
    
    def copy(unit_id, job_id, data = {})
      Unit.get("#{resource_uri}/#{unit_id}/copy", {:query => {:unit => {:job_id => job_id, :data => data}}})
    end
    
    def split(on, with = " ")
      Unit.get("#{resource_uri}/split", {:query => {:on => on, :with => with}})
    end
    
    def cancel(unit_id)
      Unit.post("#{resource_uri}/#{unit_id}/cancel.json")
    end
  end
end
