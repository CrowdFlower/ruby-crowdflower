module CrowdFlower
  class Base
    include HTTParty

    def initialize(key)
      Base.default_params(:key => key)
    end
  end
  
  module Defaults
    def self.included(base)
      base.send :include, HTTParty
      base.send :headers, "HTTP_ACCEPT" => "application/json"
      base.send :format, :json
    end
  end
  
  def self.connect!(key)
    @@conn = Base.new(key)
  end
  
  def self.conn
    raise "Please establish a connection using 'CrowdFlower.connect!'" unless @@conn
    @@conn.class
  end
end
