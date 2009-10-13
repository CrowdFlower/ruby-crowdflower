module CrowdFlower
  @@key = nil
  @@domain = nil
  
  module Defaults
    def self.included(base)
      base.send :include, HTTParty
      base.send :headers, "accept" => "application/json"
      base.send :format, :json
      base.extend ClassMethods
    end

    module ClassMethods
      def connect
        raise "Please establish a connection using 'CrowdFlower.connect!'" unless CrowdFlower.key
        self.base_uri CrowdFlower.domain + self.resource_uri
        self.default_params :key => CrowdFlower.key
      end
    end
  end
  
  def self.connect!(key, development = false)
    @@domain = development ? "http://api.localhost:4000/v1" : "https://api.crowdflower.com/v1"
    @@key = key
  end

  def self.key
    @@key
  end

  def self.domain
    @@domain
  end
end
