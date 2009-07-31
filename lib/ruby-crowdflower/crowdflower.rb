module CrowdFlower
  def self.connect!(key)
    @@conn = Base.new(key)
  end
  
  def self.conn
    raise "Please establish a connection using 'CrowdFlower.connect!'" unless @@conn
    @@conn.class
  end
  
  class Base
    include HTTParty

    def initialize(key)
      Base.default_params(:key => key)
    end
  end
  
  module Defaults
    def self.included(base)
      base.send :include, HTTParty
      base.send :headers, "HTTP_ACCEPT" => "application/json"
      base.send :format, :json
    end
  end
  
  class Job
    include Defaults
    attr_reader :job_id
    
    def initialize(job_id)
      @job_id = job_id
      Job.base_uri "https://api.crowdflower.com/v1/jobs"
      Job.default_params(CrowdFlower.conn.default_params)
    end
    
    def self.all
      Job.get("/")
    end
    
    def get(id = nil)
      Job.get("/#{@job_id || id}")
    end
    
    #Copies a job and optionally gold or all units.
    #Parameters
    #  opts: Hash
    #    gold: when set to true copies gold units
    #    all_units: when set to true copies all units
    def copy(opts = {})
      Job.get("/#{@job_id}/copy", {:query => opts})
    end
    
    def status
      Job.get("/#{@job_id}/ping")
    end
    
    def download_csv(full = true, filename = nil)
      filename ||= "#{full ? "f" : "a"}#{@job_id}.csv"
      res = Job.get("/#{@job_id}.csv", {:format => :csv, :query => {:full => full}})
      puts "Status... #{res.code.inspect}"
      if res.code == 202
        puts "CSV Generating... Trying again in 10 seconds."
        Kernel.sleep 10
        download_csv
      else
        puts "CSV written to: #{File.expand_path(filename)}"
        File.open(filename, "w") {|f| f.puts res.body }
      end
    end
    
    def pause
      Job.get("/#{@job_id}/pause")
    end
    
    def resume
      Job.get("/#{@job_id}/resume")
    end
    
    def cancel
      Job.get("/#{@job_id}/cancel")
    end
  end
  
  class Unit
    include Defaults
    
    def initialize(job)
      @job = job
      Unit.base_uri "https://api.crowdflower.com/v1/jobs/#{@job.job_id}/units"
      Unit.default_params(CrowdFlower.conn.default_params)
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
  
  class Judgment
    include Defaults
    
    def initialize(job)
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
