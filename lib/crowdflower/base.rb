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
  
  # a convenience method for backward compatibility
  def self.connect!(key, development = false, version = 1)
    Base.connect!(key, development, version)
  end
  
  # an object that stores connection details; does actual http talking
  class Connection
    include HTTParty
    headers "accept" => "application/json"
    format :json
    
    attr_reader :key, :domain, :version
    
    def initialize(key, development, version)
      @version = version
      @domain = development ? "http://api.localhost.com:4000/v#{version}" : "https://api.crowdflower.com/v#{version}"
      @key = key
      begin # pass yaml file
        key = YAML.load_file(key)
        @key = key[:key] || key["key"]
      rescue # pass key
        @key = key
      end
    end
    
    # get, post, put and delete methods
    def method_missing(method_id, *args)
      if [:get, :post, :put, :delete].include?(method_id)
        path, options = *args
        options ||= {}
        options[:query] = (default_params.merge(options[:query] || {}))
        options[:headers] = (self.class.default_options[:headers].merge(options[:headers] || {}))
        
        self.class.send(method_id, url(path), options)
      else
        super
      end
    end
    
    private
    def url(path)
      "#{@domain}/#{path}"
    end
    
    def default_params
      {'key' => @key}
    end
  end
  
  
  # Base class for Crowdflower api entities.
  # Now instead of one global configuration, each instance could maintain its own connection.
  # If no connection is available for an instance it will look for default class-level or global
  # connection settings, see Base#connection method.
  # You can set class-specific connection with Base.connect! call
  # for example:
  #     Job.connect!(api_key, development, version).
  # It is possible to use several api keys simultaneously either by providing each entity instance
  # with a specific Connection object or by creating entity subclasses that have their own default connections
  # for example:
  #     CrowdFlower.connect!(default_api_key, development, version)
  #     (JobSubclass = Class.new(Job)).connect!(custom_api_key, development, version)
  #     job1 = Job.create('created with default api key')      
  #     job2 = JobSubclass.create('created with custom api key')
  class Base

    def initialize(new_connection = nil)
      @connection = new_connection
    end
    
    def connection
      @connection or self.class.connection
    end
    
    def self.connection
      default_connection or (self != Base and superclass.connection)
    end
    
    class << self
      attr_accessor :default_connection
    end
    
    def self.connect!(key, development = false, version = 1)
      self.default_connection = Connection.new(key, development, version)
    end
    
    def self.method_missing(method_id, *args)
      if [:get, :post, :put, :delete].include?(method_id)
        connection.send(method_id, *args)
      else
        super
      end
    end
    
    def connect
      unless connection
        raise UsageError, "Please establish a connection using 'CrowdFlower.connect!'"
      end
    end

    def self.connect
      unless connection
        raise UsageError, "Please establish a connection using 'CrowdFlower.connect!'"
      end
    end
    
  end
  
end
