# Thrillcall API
This document describes the Thrillcall API v3, and usage for the provided Ruby API wrapper gem.

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
    
    #---------------------------------------------------------------#
    # POST and PUT are explicit methods
    #---------------------------------------------------------------#
    artist = tc.artist.post(:name => "Bleeding Chest Wounds")
    # => {"id" => 3, "name" => "Bleeding Chest Wounds", ...}
    
    artist = tc.artist(3).put(:name => "Grizzle and The Plenty")
    # => {"id" => 3, "name" => "Grizzle and The Plenty", ...}
    
```

### Advanced Usage:

Provide additional instantiation options:

``` ruby
    
    #---------------------------------------------------------------#
    # The default SSL endpoint is "https://api.thrillcall.com/api/".
    # The default API version is 3.
    # By default, Faraday access logging is turned off.
    # If a connection attempt fails, we will retry 5 times with a
    # timeout of 10 seconds.  We retry a boilerplate list of
    # exceptions, such as Faraday::Error::ClientError.
    # Override these if necessary:
    #---------------------------------------------------------------#
    tc = ThrillcallAPI.new(
      MY_API_KEY,
      :base_url         => "https://api.thrillcall.com/custom/",
      :version          => 3,
      :logger           => true,
      :retry_exceptions => [Timeout::Error],
      :retry_tries      => 5,
      :timeout          => 10
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
    BASE_URL    = "https://api.thrillcall.com/api/v3/"
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
