module CrowdFlower
  @@key = nil
  @@domain = nil
  @@request_hook = Proc.new do |*, &block|
    block.call
  end

  def self.request_hook=(hook)
    @@request_hook = hook
  end

  def self.request_hook
    @@request_hook
  end

  class UsageError < StandardError ; end

  class APIWarning < StandardError ; end

  class APIError < StandardError
    attr_reader :details

    def initialize(hash)
      @details = hash
      
      super(hash.inspect)
    end
  end
  
  # a convenience method for backward compatibility
  def self.connect!(key, domain_base = "https://api.crowdflower.com", version = 1)
    Base.connect!(key, domain_base, version)
  end

  def self.connect_domain!(key, domain_base, version = 1)
    Base.connect_domain!(key, domain_base, version)
  end

  def self.connect_config!(opts)
    Base.connect_config!(opts)
  end
  
  # an object that stores connection details; does actual http talking
  class Connection
    include HTTParty
    headers "accept" => "application/json"
    format :json
    
    attr_reader :key, :domain, :version, :domain_base, :ssl_port, :public_port
    
    def initialize(key, domain_base, version, ssl_port = 443, public_port = 80)
      @domain_base = domain_base
      @version = version
      @domain = "#{@domain_base}/v#{version}"
      @key = key
      @ssl_port = ssl_port
      @public_port = public_port
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

        CrowdFlower.request_hook.call(method_id, path, options) do
          self.class.send(method_id, url(path), options)
        end
      else
        super
      end
    end

    # Returns the base crowdflower domain from the api url's domain.
    #
    # @api public
    # @return [String] the base crowdflower domain
    # @example
    #   CrowdFlower::Connection.new("asdf", "https://api.crowdflower.com").crowdflower_base #=> "crowdflower.com"
    def crowdflower_base
      uri = URI.parse(domain_base)
      "#{uri.host.gsub("api.", "")}"
    end

    # Returns the url to reach crowdflower regularly through a browser
    #
    # @api public
    # @return [String] the url to reach crowdflower in a browser
    # @example
    #   CrowdFlower::Connection.new("asdf", "https://api.crowdflower.com").public_url #=> "crowdflower.com:80"
    def public_url
      "#{crowdflower_base}:#{public_port}"
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
    attr_accessor :last_response

    def initialize(new_connection = nil, last_res = nil)
      @connection = new_connection
      @last_response = last_res
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

    def self.connect!(key, domain_base = "https://api.crowdflower.com", version = 1)
      connect_domain!(key, domain_base, version)
    end
    
    def self.connect_domain!(key, domain_base, version = 1)
      self.default_connection = Connection.new(key, domain_base, version)
    end

    def self.connect_config!(opts)
      extract_option = lambda do |arr|
        arr.map { |k| opts[k] || opts[k.to_s] }.compact.first
      end
      key         = extract_option.call([:key, :api_key])
      domain_base = extract_option.call([:domain_base, :domain])
      version     = extract_option.call([:version])     || 1
      ssl_port    = extract_option.call([:ssl_port])    || 443
      public_port = extract_option.call([:public_port]) || 80
      self.default_connection = Connection.new(key, domain_base, version, ssl_port, public_port)
    end

    def self.get(*args); connection.get(*args); end
    def self.post(*args); connection.post(*args); end
    def self.put(*args); connection.put(*args); end
    def self.delete(*args); connection.delete(*args); end
    
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

    def self.verify_response(response)
      if response.respond_to?(:[])
        if error = (response["errors"] || response["error"])
          raise CrowdFlower::APIError.new(error)
        elsif warning = response["warning"]
          raise CrowdFlower::APIWarning.new(warning)
        end
      elsif response.response.kind_of? Net::HTTPUnauthorized
        raise CrowdFlower::APIError.new('message' => response.to_s)
      elsif (500...600).include?(response.code)
        raise CrowdFlower::APIError.new('message' => response.to_s)
      end
    end
    
  end
  
end


