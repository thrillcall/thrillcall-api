# Adapted from
# http://stackoverflow.com/questions/1332404/how-to-detect-the-end-of-a-method-chain-in-ruby
# and
# http://blog.jayfields.com/2008/02/ruby-replace-methodmissing-with-dynamic.html

module ThrillcallAPI
  class Result
    attr_accessor :ran, :request_keys, :options, :set_methods, :http_method
    attr_reader :data

    def initialize
      reset
    end

    def reset
      if @set_methods
        unset_methods
      end
      @ran                      = false
      @data                     = {} # could be an array after fetch
      @end_of_chain_is_singular = false
      @options                  = {}
      @request_keys             = []
      @set_methods              = []
      @http_method              = :get
    end

    # Removes any dynamically defined methods
    def unset_methods
      @set_methods.each do |s|
        (class << self; self; end).class_eval do
          undef_method s
        end
      end

      @set_methods = []
    end

    # Dynamically defines any methods available to data.
    # i.e. it puts on a "#{data.class}" costume
    def reassign(data)
      unset_methods

      data.public_methods.each do |meth|
        @set_methods << meth
        (class << self; self; end).class_eval do
          define_method meth do |*args, &block|
            data.send meth, *args, &block
          end
        end
      end
    end

    # Append the name of the method and any args to the current
    # request being built
    def append(key, *args)

      # If this is called but we've already fetched data, reset
      if @ran
        reset
      end

      @request_keys << key

      if args
        if args.is_a? Array
          args = args.flatten
        end
        args.each do |arg|
          if arg
            a = arg
            if a.is_a? Hash
              # Merge this hash on top of the existing options
              @options.merge!(a)
            else
              # This is an ID or search term, add it directly to the
              # list of keys
              @request_keys << a.to_s
            end
          end
        end
      end
    end

    def run(method, *args, &block)
      # Fetch data if necessary.  This will also "put on the
      # data.class costume" and allow the method to respond to a
      # subsequent send()
      if !@ran
        fetch_data
      end

      # Send the requested method out to the newly defined method
      self.send(method, *args, &block)
    end

    def fetch_data
      url = URI.escape(@request_keys.join("/"))

      @data = ThrillcallAPI.send(@http_method, url, @options)

      # Now we define the instance methods present in the data object
      # so that we can use this object *as if* we are using the data
      # object directly and we don't encounter method_missing
      reassign(@data)

      @ran = true
    end

    def post(args = {}, method = :post)
      if @ran
        raise ArgumentError, "This request has already been made!"
      else
        @http_method = method
        @options.merge!(args)
        fetch_data
      end
      @data
    end

    def put(args = {})
      post(args, :put)
    end

    def method_missing(method, *args, &block)

      if @ran
        # NoMethodError
        super
      else
        # We haven't fetched the data yet, but if this method is for
        # a hash or an array, we'd better.
        # The bad news about this technique is that we can't have any
        # endpoints that map to array or hash methods
        if {}.respond_to?(method) || [].respond_to?(method)
          r = run(method, *args, &block)
          return r
        else # Keep building the request
          append(method, *args)
          return self
        end
      end
    end

  end
end
