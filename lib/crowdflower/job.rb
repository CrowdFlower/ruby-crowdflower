module CrowdFlower
  class Job < Base
    attr_accessor :res
    attr_reader :id

    def initialize(job_id, connection = nil, last_response = nil)
      super connection, last_response
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
    
    def self.upload(file, content_type, job = nil, opts = {})
      connect
      
      job_uri = job ? "/#{job.kind_of?(Job) ? job.id : job}" : ""
      conn = job.kind_of?(Job) ? job.connection : self.connection
      upload_uri = "#{resource_uri}/#{job_uri}/upload".squeeze("/")
      res = conn.post(upload_uri, 
        :body => File.read(file), 
        :headers => {"content-type" => content_type},
        :query => opts)

      verify_response res
      job.kind_of?(Job) ? job : self.new(res["id"], conn, res)
    end

    # Creates a new empty Job in CrowdFlower.
    def self.create(title)
      connect
      res = self.post("#{resource_uri}.json", :query => {:job => {:title => title } }, :headers => { "Content-Length" => "0" } )
      verify_response res
      self.new(res["id"], nil, res)
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
      self.class.new(res["id"], nil, res)
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
      filename ||= "#{type.to_s[0].chr}#{@id}.zip"
      res = connection.get("#{resource_uri}/#{@id}.csv", {:format => "zip", :query => {:type => type}})
      self.class.verify_response res
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
      response = connection.put("#{resource_uri}/#{@id}.json", {:body => { :job => data }, :headers => { "Content-Length" => "0" } } )
      self.class.verify_response(response)
      response
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

    def tags
      connection.get("#{resource_uri}/#{@id}/tags") 
    end

    def update_tags(tags)
      connection.put("#{resource_uri}/#{@id}/tags", {:body => { :tags => tags } } ) 
    end

    def add_tags(tags)
      connection.post("#{resource_uri}/#{@id}/tags", {:body => { :tags => tags } } ) 
    end

    def remove_tags(tags)
      connection.delete("#{resource_uri}/#{@id}/tags", {:body => { :tags => tags } } ) 
    end
  end
end
