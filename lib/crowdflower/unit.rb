module CrowdFlower
  class Unit < Base
    attr_reader :job
    
    def initialize(job)
      super job.connection
      @job = job
      connect
    end

    def resource_uri
      "/jobs/#{@job.id}/units"
    end
    
    def all(page = 1, limit = 1000)
      connection.get(resource_uri, {:query => {:limit => limit, :page => page}})
    end
    
    def get(id)
      connection.get("#{resource_uri}/#{id}")
    end
    
    def ping
      connection.get("#{resource_uri}/ping")
    end
    
    def judgments(id)
      connection.get("#{resource_uri}/#{id}/judgments")
    end
    
    def create(data, gold = false)
      connection.post(resource_uri, {:query => {:unit => {:data => data.to_json, :golden => gold}}})
    end
    
    def copy(unit_id, job_id, data = {})
      connection.get("#{resource_uri}/#{unit_id}/copy", {:query => {:unit => {:job_id => job_id, :data => data}}})
    end
    
    def split(on, with = " ")
      connection.get("#{resource_uri}/split", {:query => {:on => on, :with => with}})
    end
    
    def cancel(unit_id)
      connection.post("#{resource_uri}/#{unit_id}/cancel.json")
    end
  end
end
