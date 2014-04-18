module CrowdFlower
  class Worker < Base
    attr_reader :job
    
    def initialize( job )
      super job.connection
      @job = job
      connect
    end
    
    def resource_uri
      "/jobs/#{@job.id}/workers"
    end
    
    def bonus( worker_id, amount, reason=nil )
      params = {
        :amount => amount,
        :reason => reason
      }
      connection.post( "#{resource_uri}/#{worker_id}/bonus", :body => params )
    end

    def reject( worker_id )
      connection.put( "#{resource_uri}/#{worker_id}/reject", :headers => { "Content-Length" => "0" } )
    end
    
    def ban(worker_id, reason)
      connection.put("#{resource_uri}/#{worker_id}/ban", :body => { :reason => reason }, :headers => { "Content-Length" => "0" })
    end
    
    def deban(worker_id)
      connection.put("#{resource_uri}/#{worker_id}/deban", :headers => { "Content-Length" => "0" })
    end
    
    def amt_notify( worker_id, subject, message )
      params = {
        :subject => subject,
        :message => message
      }
      connection.post( "#{resource_uri}/#{worker_id}/notify", :query => params )
    end

    def notify(worker_id, message)
      connection.post("/workers/#{worker_id}/notifications", :body => { :notification => {:message => message }})
    end

    def flag( worker_id, reason = nil )
      connection.put( "#{resource_uri}/#{worker_id}/flag", :body => { :reason => reason }, :headers => { "Content-Length" => "0" } )
    end
    
    def deflag(worker_id, reason)
      connection.put( "#{resource_uri}/#{worker_id}/deflag", :body => { :reason => reason }, :headers => { "Content-Length" => "0" })
    end
  end
end
