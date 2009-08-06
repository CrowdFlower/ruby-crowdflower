module CrowdFlower
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
    
    def upload(file, content_type)
      Job.upload(file, content_type, @job_id)
    end
    
    def self.upload(file, content_type, job_id = nil)
      job_id = "/#{job_id}" unless job_id.nil?
      Job.post("#{job_id}/upload", 
        :body => File.read(file), 
        :headers => custom_content_type(content_type))
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
    
    private
    
    def self.custom_content_type(content_type)
      #To preserve the accept header we are forced to merge the defaults back in...
      Job.default_options[:headers].merge({:content_type => content_type})
    end
  end
end