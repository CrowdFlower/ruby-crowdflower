module HTTParty
  class Request
    def handle_response(response)
      case response
        when Net::HTTPRedirection
          options[:limit] -= 1
        
          self.path = response['location']
          @redirect = true
          @message = parse_response(response.body.to_s) rescue nil
          perform
        else
          parsed_response = parse_response(response.body.to_s)
          Response.new(parsed_response, response.body.to_s, response.code, @message || response.message, response.to_hash)
        end
    end
    
    def uri
      # Don't use relative path on redirect
      new_uri = path.relative? && !@redirect ? URI.parse("#{options[:base_uri]}#{path}") : path
      
      # avoid double query string on redirects [#12]
      unless @redirect
        new_uri.query = query_string(new_uri)
      end
      
      new_uri
    end
  end
end
