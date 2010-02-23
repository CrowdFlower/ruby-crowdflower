module CrowdFlower
  class Job
    include Defaults
    attr_reader :id
    
    def initialize(job_id)
      @id = job_id
      Job.connect
    end

    def resource_uri
      Job.resource_uri
    end

    def self.resource_uri
      "/jobs"
    end

    def self.all
      connect
      get(resource_uri)
    end
    
    def self.upload(file, content_type, job_id = nil)
      connect
      job_uri = job_id ? "/#{job_id}" : ""
      res = post("#{resource_uri}/#{job_uri}/upload", 
        :body => File.read(file), 
        :headers => custom_content_type(content_type))
      if res["error"]
        raise CrowdFlower::APIError.new(res["error"])
      end
      Job.new(res["id"])
    end

    # Creates a new empty Job in CrowdFlower.
    def self.create
      connect
      res = post("#{resource_uri}/upload", :query => {:job => {:without_data => "true" } } )
      if res["error"]
        raise CrowdFlower::APIError.new(res["error"])
      end
      Job.new(res["id"])
    end
 
    def get(id = nil)
      Job.get("#{resource_uri}/#{@id || id}")
    end

    # Returns an accessor for all the Units associated with this job.
    # This enables you to do things like:
    #
    # * job.units.all
    # * job.units.get [id]
    # * job.units.create [data]
    def units
      Unit.new(self)
    end
    
    # Copies a job and optionally gold or all units.
    # Parameters
    #  opts: Hash
    #    gold: when set to true copies gold units
    #    all_units: when set to true copies all units
    def copy(opts = {})
      res = Job.get("#{resource_uri}/#{@id}/copy", {:query => opts})
      if res["error"]
        raise CrowdFlower::APIError.new(res["error"])
      end
      Job.new(res["id"])
    end
    
    def status
      Job.get("#{resource_uri}/#{@id}/ping")
    end
    
    def upload(file, content_type)
      Job.upload(file, content_type, @id)
    end
    
    def legend
      Job.get("#{resource_uri}/#{@id}/legend")
    end
    
    def download_csv(full = true, filename = nil)
      filename ||= "#{full ? "f" : "a"}#{@id}.csv"
      res = Job.get("#{resource_uri}/#{@id}.csv", {:format => :csv, :query => {:full => full}})
      puts "Status... #{res.code.inspect}"
      if res.code == 202
        puts "CSV Generating... Trying again in 10 seconds."
        Kernel.sleep 10
        download_csv(full, filename)
      else
        puts "CSV written to: #{File.expand_path(filename)}"
        File.open(filename, "w") {|f| f.puts res.body }
      end
    end
    
    def pause
      Job.get("#{resource_uri}/#{@id}/pause")
    end
    
    def resume
      Job.get("#{resource_uri}/#{@id}/resume")
    end
    
    def cancel
      Job.get("#{resource_uri}/#{@id}/cancel")
    end

    def update(data)
      res = Job.put("#{resource_uri}/#{@id}.json", {:query => { :job => data }, :headers => { "Content-Length" => "0" } } )
      if res["error"]
        raise CrowdFlower::APIError.new(res["error"])
      end
    end

    private
    def self.custom_content_type(content_type)
      #To preserve the accept header we are forced to merge the defaults back in...
      Job.default_options[:headers].merge({"content-type" => content_type})
    end
  end
end
