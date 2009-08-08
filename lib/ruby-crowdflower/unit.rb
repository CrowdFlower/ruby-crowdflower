module CrowdFlower
  class Unit
    include Defaults
    attr_reader :job
    
    def initialize(job)
      @job = job
      Unit.base_uri CrowdFlower.with_domain("/jobs/#{@job.id}/units")
      Unit.default_params CrowdFlower.key
    end
    
    def all(page = 1, limit = 1000)
      Unit.get("", {:query => {:limit => limit, :page => page}})
    end
    
    def get(id)
      Unit.get("/#{id}")
    end
    
    def create(data, gold = nil)
      Unit.post("", {:query => {:unit => {:data => data.to_json, :golden => gold}}})
    end
    
    def copy(unit_id, job_id, data = {})
      Unit.get("/#{unit_id}/copy", {:query => {:unit => {:job_id => job_id, :data => data}}})
    end
    
    def split(on, with = " ")
      Unit.get("/split", {:query => {:on => on, :with => with}})
    end
  end
end