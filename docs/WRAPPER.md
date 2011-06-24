# Thrillcall API
This document describes the Thrillcall API v2, and usage for the provided Ruby API wrapper gem.

# Ruby API Wrapper
### Usage:

``` ruby
    #---------------------------------------------------------------#
    # First, require the gem:
    #---------------------------------------------------------------#
    require 'rubygems'
    require 'thrillcall-api'
    
    #---------------------------------------------------------------#
    # Instantiate with your Thrillcall API key:
    #---------------------------------------------------------------#
    MY_API_KEY = "1234567890abcdef"
    tc = ThrillcallAPI.new(MY_API_KEY)
    
    #---------------------------------------------------------------#
    # Access any endpoint directly from the instance
    #---------------------------------------------------------------#
    # This is like calling GET "/events"
    tc.events
    # => [ {"id" => ... }, {...}, ...]
    
    #---------------------------------------------------------------#
    # Provide IDs as arguments
    #---------------------------------------------------------------#
    # GET "/event/1"
    tc.event(1)
    # => {"id" => 1, ...}
    
    #---------------------------------------------------------------#
    # Provide parameters as arguments
    #---------------------------------------------------------------#
    # GET "/events?limit=5"
    events = tc.events(:limit => 5)
    # => [ {"id" => ... }, {...}, ...]
    events.length
    # => 5
    
    #---------------------------------------------------------------#
    # Chain methods together for nested routes
    #---------------------------------------------------------------#
    # GET "/search/venues/warfield?postalcode=94101&radius=20"
    venues = tc.search.venues("warfield", :postalcode => "94101", :radius => 20)
    # => [{"name" => "The Warfield", ...}]
```

### Advanced Usage:

Provide additional instantiation options:

``` ruby
    
    #---------------------------------------------------------------#
    # The default endpoint is "http://thrillcall.com/api/".
    # The default API version is 2.
    # By default, Faraday access logging is turned off.
    # Override if necessary:
    #---------------------------------------------------------------#
    tc = ThrillcallAPI.new(
      MY_API_KEY,
      :base_url => "http://thrillcall.com/custom/",
      :version  => 3,
      :logger   => true
    )
    
```

Internally, the wrapper returns a ThrillcallAPI::Result class for any call.  Data for the request is fetched only when used.  This allows you to build requests piecemeal before executing them.

``` ruby
    
    #---------------------------------------------------------------#
    # Build a partial request, add on to it later
    #---------------------------------------------------------------#
    request = tc.artist(22210) # Lady Gaga
    
    # GET "/artist/22210/events?limit=2"
    artist_events = request.events(:limit => 2)
    
    artist_events.length
    # => 2
    
```

This gem is a convenience wrapper around the excellent Faraday project.  If more complicated use cases are necessary, consider using Faraday directly.

``` ruby
    
    require 'faraday'
    require 'json'
    
    MY_API_KEY  = "1234567890abcdef"
    BASE_URL    = "http://thrillcall.com/api/v2/"
    HEADERS     = { :accept => 'application/json' }
    
    connection  = Faraday.new( :url => BASE_URL, :headers => HEADERS ) do |builder|
      builder.adapter Faraday.default_adapter
      builder.response :logger
      builder.response :raise_error
    end
    
    request = connection.get do |req|
      req.url "artist/22210", { :api_key => MY_API_KEY }
    end
    
    artist = JSON.parse(request.body)
    
    artist["name"]
    # => "Lady Gaga"
    
```