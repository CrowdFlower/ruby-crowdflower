module CrowdFlower
  @@key = nil
  @@domain = nil
  
  module Defaults
    def self.included(base)
      base.send :include, HTTParty
      base.send :headers, "accept" => "application/json"
      base.send :format, :json
    end
  end
  
  def self.connect!(key, development = false)
    @@domain = development ? "http://api.localhost:4000/v1" : "https://api.crowdflower.com/v1"
    @@key = key
  end
  
  def self.with_domain(path)
    raise "Please establish a connection using 'CrowdFlower.connect!'" unless @@domain
    @@domain + path
  end
  
  def self.key
    raise "Please establish a connection using 'CrowdFlower.connect!'" unless @@key
    {:key => @@key}
  end
end
