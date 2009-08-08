module CrowdFlower
  class Job
    include Defaults
    attr_reader :id
    
    def initialize(job_id)
      @id = job_id
      Job.base_uri CrowdFlower.with_domain("/jobs")
      Job.default_params CrowdFlower.key
    end
    
    def self.all
      Job.get("/")
    end
    
    def get(id = nil)
      Job.get("/#{@id || id}")
    end
    
    #Copies a job and optionally gold or all units.
    #Parameters
    #  opts: Hash
    #    gold: when set to true copies gold units
    #    all_units: when set to true copies all units
    def copy(opts = {})
      Job.get("/#{@id}/copy", {:query => opts})
    end
    
    def status
      Job.get("/#{@id}/ping")
    end
    
    def upload(file, content_type)
      Job.upload(file, content_type, @id)
    end
    
    def legend
      Job.get("/#{@id}/legend")
    end
    
    def self.upload(file, content_type, job_id = nil)
      job_id = "/#{job_id}" unless job_id.nil?
      Job.post("#{job_id}/upload", 
        :body => File.read(file), 
        :headers => custom_content_type(content_type))
    end
    
    def download_csv(full = true, filename = nil)
      filename ||= "#{full ? "f" : "a"}#{@id}.csv"
      res = Job.get("/#{@id}.csv", {:format => :csv, :query => {:full => full}})
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
      Job.get("/#{@id}/pause")
    end
    
    def resume
      Job.get("/#{@id}/resume")
    end
    
    def cancel
      Job.get("/#{@id}/cancel")
    end
    
    private
    
    def self.custom_content_type(content_type)
      #To preserve the accept header we are forced to merge the defaults back in...
      Job.default_options[:headers].merge({"content-type" => content_type})
    end
  end
end