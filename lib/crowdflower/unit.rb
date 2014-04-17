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
      connection.post(resource_uri, {:body => {:unit => {:data => data.to_json, :golden => gold}}})
    end
    
    def copy(unit_id, job_id, data = {})
      connection.get("#{resource_uri}/#{unit_id}/copy", {:query => {:unit => {:job_id => job_id, :data => data}}})
    end
    
    def split(on, with = " ")
      connection.get("#{resource_uri}/split", {:query => {:on => on, :with => with}})
    end
    
    def update(unit_id, params)
      connection.put("#{resource_uri}/#{unit_id}", {:body => {:unit => params}})
    end
    
    def make_gold(unit_id)
      update(unit_id, :golden => "true")
    end
    
    def cancel(unit_id)
      connection.post("#{resource_uri}/#{unit_id}/cancel.json")
    end
    
    def delete(unit_id)
      connection.delete("#{resource_uri}/#{unit_id}")
    end

    def request_more_judgments(unit_id, nb_judgments = 1)
      connection.post("#{resource_uri}/#{unit_id}/request_more_judgments.json", :body => {:nb_judgments => nb_judgments})
    end
  end
end
