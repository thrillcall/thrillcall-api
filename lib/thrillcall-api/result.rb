# Adapted from http://stackoverflow.com/questions/1332404/how-to-detect-the-end-of-a-method-chain-in-ruby

module ThrillcallAPI
  class Result
    attr_reader :data
    
    def initialize
      reset
    end
    
    def reset
      @ran      = false
      @data     = [] # could be a hash after fetch
      @keys     = []
      @end_of_chain_is_singular = false
      @options  = {}
    end
    
    def append(key, args)
      
      if @ran
        reset
      end
      
      @keys << key
      
      @end_of_chain_is_singular = false
      
      if args
        args.each do |arg|
          if arg.is_a? Hash
            @options.merge!(arg)
          else
            @end_of_chain_is_singular = true
            @keys << arg.to_s
          end
        end
      end
    end
    
    def run(method, args, block)
      if !@ran
        fetch_data
      end
      
      @data.send(method, *args, &block)
    end
    
    def fetch_data
      #puts "Only runs once!"
      
      url = @keys.join("/")
      
      @data = ThrillcallAPI.get url, @options
      
      if @end_of_chain_is_singular && (@data.is_a? Hash)
        @data = @data.values.first
      end
      
      #puts "Data is: #{@data}"
      @ran = true
    end
    
    def method_missing(method, args = nil, block = nil)
      # puts "Data: #{@data}"
      # by checking result.data, this works for both array and hash
      # bad news is that we can't have any endpoints that map to array or hash methods
      if @data.respond_to?(method)
        r = run(method, args, block)
        return r
      else
        append(method, args)
        return self
      end
    end
  end
end