# Adapted from
# http://stackoverflow.com/questions/1332404/how-to-detect-the-end-of-a-method-chain-in-ruby
# and
# http://blog.jayfields.com/2008/02/ruby-replace-methodmissing-with-dynamic.html

module ThrillcallAPI
  class Result
    attr_accessor :ran, :end_of_chain_is_singular, :keys, :options, :set_methods
    attr_reader :data
    
    def initialize
      reset
    end
    
    def reset
      if @set_methods
        unset_methods
      end
      @ran                      = false
      @data                     = [] # could be a hash after fetch
      @end_of_chain_is_singular = false
      @options                  = {}
      @keys                     = []
      @set_methods              = []
    end
    
    def unset_methods
      @set_methods.each do |s|
        (class << self; self; end).class_eval do
          undef_method s
        end
      end
      
      @set_methods = []
    end
    
    def reassign(data)
      unset_methods
      
      data.public_methods(false).each do |meth|
        @set_methods << meth
        (class << self; self; end).class_eval do
          define_method meth do |*args, &block|
            data.send meth, *args, &block
          end
        end
      end
    end
    
    def append(key, *args)
      
      if @ran
        reset
      end
      
      @keys << key
      
      if args
        if args.is_a? Array
          args = args.flatten
        #else
        #  args = [args]
        end
        args.each do |arg|
          if arg
            a = arg
            #if a.is_a? Array
            #  a = arg.first
            #else
            #  a = arg
            #end
            if a.is_a? Hash
              @options.merge!(a)
            else
              @end_of_chain_is_singular = true
              @keys << a.to_s
            end
          end
        end
      end
    end
    
    def run(method, *args, &block)
      if !@ran
        fetch_data
      end
      
      self.send(method, *args, &block)
    end
    
    def fetch_data
      url = @keys.join("/")
      
      @data = ThrillcallAPI.get url, @options
      
      #if @end_of_chain_is_singular && (@data.is_a? Hash)
      #  @data = @data.values.first
      #end
      
      # Now we define the instance methods present in the data object so
      # that we can use this object *as if* we are using the data object directly
      # and we don't encounter method_missing
      reassign(@data)
      
      @ran = true
    end
    
    def method_missing(method, *args, &block)
      # by checking result.data, this works for both array and hash
      # bad news is that we can't have any endpoints that map to array or hash methods
      if @data.respond_to?(method)
        r = run(method, *args, &block)
        return r
      else
        if @ran
          # Here be dragons, too much magic
          # I tried to enable this so that it would create a new Result object from the original's keys and options, resetting
          # the ran and end_of_chain_singular flags and data.  Then it would run append() on the new copy.
          # The problem is that you can't reassign self (self = something), so this doesn't work.  Open to suggestions.
          super
          #raise ThrillcallAPI::Error.new(:type => "Request Failed", :message => "Cannot chain request methods after using an intermediate step.  Create new requests directly from an instance of ThrillcallAPI.")
        else
          append(method, *args)
          return self
        end
      end
    end
    
  end
end