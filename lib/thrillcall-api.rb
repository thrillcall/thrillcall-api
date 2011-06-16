require 'faraday'
#require 'faraday_middleware'
require 'json'
require "#{File.expand_path("../thrillcall-api/result", __FILE__)}"
require "#{File.expand_path("../thrillcall-api/exceptions", __FILE__)}"

module ThrillcallAPI
  class << self
    def new(api_key = "1234567890", base_url = "http://api.thrillcall.com/api/", version = 2)
      @api_key  = api_key
      
      unless base_url.match /^http:\/\//
        base_url = "http://" + base_url
      end
      
      unless base_url.match /\/$/
        base_url = base_url + "/"
      end
      
      @headers = { 
        :accept     => 'application/json',
        :user_agent => "Thrillcall API Wrapper version #{ThrillcallAPI::VERSION}"
      }
      
      @base   = "#{base_url}v#{version}/"
      @conn   = Faraday.new( :url => @base, :headers => @headers ) do |builder|
        builder.adapter Faraday.default_adapter
        #builder.response :logger
        builder.response :raise_error
      end
      
      @result = Result.new
      
      return self
    end
    
    def conn
      return @conn if @conn
      self.new
      return @conn
    end
    
    def get(endpoint, params)
      r = conn.get do |req|
        req.url endpoint, params.merge(:api_key => @api_key)
      end
      JSON.parse(r.body)
    end
    
    def method_missing(method, *args, &block)
      r = Result.new
      r.send(method, args, block)
      return r
    end
  end
end