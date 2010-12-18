module CrowdFlower
  class Job < Base
    attr_reader :id
    
    def initialize(job_id, connection = nil)
      super connection
      @id = job_id
      connect
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
    
    def self.upload(file, content_type, job = nil)
      connect
      
      job_uri = job ? "/#{job.kind_of?(Job) ? job.id : job}" : ""
      conn = job.kind_of?(Job) ? job.connection : self.connection
      res = conn.post("#{resource_uri}/#{job_uri}/upload", 
        :body => File.read(file), 
        :headers => {"content-type" => content_type})

      verify_response res
      self.new(res["id"])
    end

    # Creates a new empty Job in CrowdFlower.
    def self.create(title)
      connect
      res = post("#{resource_uri}.json", :query => {:job => {:title => title } }, :headers => { "Content-Length" => "0" } )
      verify_response res
      self.new(res["id"])
    end
 
    def get(id = nil)
      connection.get("#{resource_uri}/#{@id || id}")
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
      res = connection.get("#{resource_uri}/#{@id}/copy", {:query => opts})
      self.class.verify_response res
      self.class.new(res["id"])
    end
    
    def status
      connection.get("#{resource_uri}/#{@id}/ping")
    end
    
    def upload(file, content_type)
      self.class.upload(file, content_type, self)
    end
    
    def legend
      connection.get("#{resource_uri}/#{@id}/legend")
    end
    
    def download_csv(type = :full, filename = nil)
      filename ||= "#{type.to_s[0].chr}#{@id}.csv"
      res = connection.get("#{resource_uri}/#{@id}.csv", {:format => :csv, :query => {:type => type}})
      verify_response res
      puts "Status... #{res.code.inspect}"
      if res.code == 202
        puts "CSV Generating... Trying again in 10 seconds."
        Kernel.sleep 10
        download_csv(type, filename)
      else
        puts "CSV written to: #{File.expand_path(filename)}"
        File.open(filename, "w") {|f| f.puts res.body }
      end
    end
    
    def pause
      connection.get("#{resource_uri}/#{@id}/pause")
    end
    
    def resume
      connection.get("#{resource_uri}/#{@id}/resume")
    end
    
    def cancel
      connection.get("#{resource_uri}/#{@id}/cancel")
    end

    def update(data)
      res = connection.put("#{resource_uri}/#{@id}.json", {:body => { :job => data }, :headers => { "Content-Length" => "0" } } )
      if res["error"]
        raise CrowdFlower::APIError.new(res["error"])
      end
    end
    
    def delete
      connection.delete("#{resource_uri}/#{@id}.json")
    end
    
    def channels
      connection.get("#{resource_uri}/#{@id}/channels")
    end
    
    def enable_channels(channels)
      connection.post("#{resource_uri}/#{@id}/channels", {:body => { :channels => channels } } )
    end

    private
    
    def self.verify_response(response)
      if response["error"]
        raise CrowdFlower::APIError.new(response["error"])
      elsif response.response.kind_of? Net::HTTPUnauthorized
        raise CrowdFlower::APIError.new('message' => response.to_s)
      end
    end
  end
end
