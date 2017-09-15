require 'faraday'
require 'json'
require "#{File.expand_path("../thrillcall-api/exceptions", __FILE__)}"
require "#{File.expand_path("../thrillcall-api/result", __FILE__)}"
require "#{File.expand_path("../thrillcall-api/version", __FILE__)}"
require 'net/http'
require 'open-uri'
require 'retriable'
require 'retriable/core_ext/kernel'

module ThrillcallAPI

  RETRY_EXCEPTIONS = {
    Errno::ECONNREFUSED           => nil,
    Errno::ECONNRESET             => nil,
    Errno::EHOSTUNREACH           => nil,
    Errno::EHOSTDOWN              => nil,
    Errno::EINVAL                 => nil,
    Net::HTTPBadResponse          => nil,
    Net::HTTPRequestTimeOut       => nil,
    Net::HTTPServerError          => nil,   # 5xx
    Net::HTTPInternalServerError  => nil,   # 500
    Net::HTTPNotImplemented       => nil,   # 501
    Net::HTTPBadGateway           => nil,   # 502
    Net::HTTPServiceUnavailable   => nil,   # 503
    Net::HTTPGatewayTimeOut       => nil,   # 504
    Net::HTTPVersionNotSupported  => nil,   # 505
    OpenURI::HTTPError            => /5[0-9][0-9]|400/,
    Timeout::Error                => nil,
    EOFError                      => nil,
    SocketError                   => nil
  }

  class << self
    attr_accessor :cur_api_key, :base, :result, :conn

    # Set up the Faraday connection based on configuration
    def new(cur_api_key, options = {})
      default_options = {
        :base_url   => "https://api.thrillcall.com/api/",
        :version    => 3,
        :logger     => false,
        :timeout    => 20
      }

      opts = default_options.merge(options)

      @retry_exceptions = opts[:retry_exceptions] || RETRY_EXCEPTIONS
      @retry_tries      = opts[:retry_tries]      || 5
      @retry_timeout    = opts[:timeout]          || 10

      @cur_api_key  = cur_api_key
      base_url      = opts[:base_url]
      version       = opts[:version]
      logger        = opts[:logger]

      faraday_opts  = {
        :timeout      => opts[:timeout],
        :open_timeout => opts[:timeout]
      }

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
      @conn   = Faraday.new( :url => @base, :headers => @headers, :options => faraday_opts ) do |builder|
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

    def on_retry_exception
      Proc.new do |exception, tries|
        msg = "ThrillcallAPI : #{exception.class}: '#{exception.message}' - #{tries} attempts."
        @conn.send(:warn, msg)
      end
    end

    def get(endpoint, params)
      r = nil
      retriable :on => @retry_exceptions, :tries => @retry_tries, :timeout => @retry_timeout, :on_retry => on_retry_exception do
        r = @conn.get do |req|
          req.url endpoint, params.merge(:api_key => @cur_api_key)
        end
      end
      return JSON.parse(r.body)
    end

    def post(endpoint, params, method = :post)
      r = nil
      block = lambda do |req|
        req.url endpoint, params.merge(:api_key => @cur_api_key)
      end
      retriable :on => @retry_exceptions, :tries => @retry_tries, :timeout => @retry_timeout, :on_retry => on_retry_exception do
        r = @conn.send(method, &block)
      end
      JSON.parse(r.body)
    end

    def put(endpoint, params)
      post(endpoint, params, :put)
    end

    def method_missing(method, *args, &block)
      r = Result.new
      r.send(method, args, block)
      return r
    end
  end
end
