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
      params = { :amount => amount }
      params.merge!( :reason => reason ) if reason
      connection.put( "#{resource_uri}/#{worker_id}/bonus", params )
    end
    
    def approve( worker_id )
      connection.put( "#{resource_uri}/#{worker_id}/approve" )
    end
    
    def reject( worker_id )
      connection.put( "#{resource_uri}/#{worker_id}/reject" )
    end
    
    def ban( worker_id )
      connection.put( "#{resource_uri}/#{worker_id}/ban" )
    end
    
    def deban( worker_id )
      connection.put( "#{resource_uri}/#{worker_id}/deban" )
    end
    
    def notify( worker_id, subject, message )
      params = {
        :subject => subject,
        :message => message
      }
      connection.put( "#{resource_uri}/#{worker_id}/notify", params )
    end
    
    def flag( worker_id, reason )
      params = reason ? { :reason => reason } : nil
      connection.put( "#{resource_uri}/#{worker_id}/flag", params )
    end
    
    def deflag( worker_id )
      connection.put( "#{resource_uri}/#{worker_id}/deflag" )
    end
  end
end
