# require 'nucleus_queue_format/base'
# require 'nucleus_queue_format/request'
# require 'nucleus_queue_format/response'
# require 'nucleus_queue_format/exception'
# require 'validatable'
require 'faraday'
require 'json'

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
        builder.response :logger
        builder.response :raise_error
      end
      
      return self
    end
    
    def conn
      return @conn if @conn
      self.new
      return @conn
    end
    
    def get(endpoint, params)
      begin
        r = conn.get do |req|
          req.url endpoint, params.merge(:api_key => @api_key)
        end
        JSON.parse(r.body)
      rescue Exception => e
        puts "#{e}: #{e.backtrace.join("\n")}"
      end
    end
    
    def events(limit = 10, offset = 0)
      get 'events', :limit => limit.to_s, :offset => offset.to_s
    end
    
    def zip_codes(limit = 10, offset = 0)
      get 'zip_codes', :limit => limit.to_s, :offset => offset.to_s
    end
  end
end