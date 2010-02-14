module CrowdFlower
  @@key = nil
  @@domain = nil

  class UsageError < StandardError ; end

  class APIError < StandardError
    attr_reader :details

    def initialize(hash)
      @details = hash
      super @details["message"]
    end
  end
  
  module Defaults
    def self.included(base)
      base.send :include, HTTParty
      base.send :headers, "accept" => "application/json"
      base.send :format, :json
      base.extend ClassMethods
    end

    module ClassMethods
      def connect
        unless CrowdFlower.key
          raise UsageError, "Please establish a connection using 'CrowdFlower.connect!'"
        end
        self.base_uri CrowdFlower.domain
        self.default_params :key => CrowdFlower.key
      end
    end
  end
  
  def self.connect!(key, development = false)
    @@domain = development ? "http://api.tsujigiri.local:4000/v1" : "https://api.crowdflower.com/v1"
    begin # pass yaml file
      key = YAML.load_file(key)
      @@key = key[:key] || key["key"]
    rescue # pass key
      @@key = key
    end
  end

  def self.key
    @@key
  end

  def self.domain
    @@domain
  end
end
