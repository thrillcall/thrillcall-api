require 'faraday'
require 'json'
require "#{File.expand_path("../thrillcall-api/exceptions", __FILE__)}"
require "#{File.expand_path("../thrillcall-api/result", __FILE__)}"
require "#{File.expand_path("../thrillcall-api/version", __FILE__)}"

module ThrillcallAPI
  class << self
    attr_accessor :cur_api_key, :base, :result, :conn

    # Set up the Faraday connection based on configuration
    def new(cur_api_key, options = {})
      default_options = {
        :base_url   => "https://api.thrillcall.com/api/",
        :version    => 3,
        :logger     => false
      }

      opts = default_options.merge(options)

      @cur_api_key  = cur_api_key
      base_url      = opts[:base_url]
      version       = opts[:version]
      logger        = opts[:logger]

      # Make sure the base_url is in the form https://.../
      unless base_url.match /^(http|https):\/\//
        base_url = "https://" + base_url
      end

      unless base_url.match /\/$/
        base_url = base_url + "/"
      end

      # Set JSON accept header and custom user agent
      @headers = {
        :accept     => 'application/json',
        :user_agent => "Thrillcall API Wrapper version #{ThrillcallAPI::VERSION}"
      }

      @base   = "#{base_url}v#{version}/"
      @conn   = Faraday.new( :url => @base, :headers => @headers ) do |builder|
        builder.adapter Faraday.default_adapter
        if logger
          builder.response :logger
        end
        # This will raise an exception if an error occurs during a request
        builder.response :raise_error
      end

      @result = Result.new

      return self
    end

    def get(endpoint, params)
      r = @conn.get do |req|
        req.url endpoint, params.merge(:api_key => @cur_api_key)
      end
      JSON.parse(r.body)
    end

    def post(endpoint, params)
      r = @conn.post do |req|
        req.url endpoint, params.merge(:api_key => @cur_api_key)
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
