module HTTParty
  class Request
    def handle_response(response)
      case response
        when Net::HTTPRedirection
          options[:limit] -= 1
        
          self.http_method = Net::HTTP::Get
          self.path = response['location']
          
          #Remove post data
          options[:body] = ""
          options[:headers].delete('content-type')
          @message = parse_response(response.body.to_s) rescue nil
          perform
        else
          parsed_response = parse_response(response.body.to_s)
          Response.new(parsed_response, response.body.to_s, response.code, @message || response.message, response.to_hash)
        end
    rescue
      puts response.body.to_s
    end
  end
end
