Thrillcall API
==============
____
Ruby API Wrapper
================
Usage:
------
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
    # GET "/events/1"
    tc.event(1)
    # => {"id" => 1, ...}
    
    #---------------------------------------------------------------#
    # Provide parameters as arguments
    #---------------------------------------------------------------#
    events = tc.events(:limit => 5)
    # => [ {"id" => ... }, {...}, ...]
    events.length
    # => 5
    
    #---------------------------------------------------------------#
    # Chain methods together for nested routes
    #---------------------------------------------------------------#
    artist = tc.search.venues("warfield", :postalcode => "94101", :radius => 20)
    # => {"name" => "The Warfield", ...}

Advanced Usage:
---------------

- Additional instantiation options:
  
  Example:
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


- Internally, the wrapper returns a ThrillcallAPI::Result class for
  any call.  Data for the request is fetched only when used.  This
  allows you to build requests piecemeal before executing them.
  
  Example:
          #---------------------------------------------------------------#
          # Build a partial request, add on to it later
          #---------------------------------------------------------------#
          request = tc.artist(22210) # Lady Gaga
          
          artist_events = request.events(:limit => 2)
          
          artist_events.length
          # => 2

- This gem is a convenience wrapper around the excellent Faraday project.
  If more complicated use cases are necessary, consider using Faraday directly.
  
  Example
        
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

____
HTTP Endpoints
=====================

Parameters
----------
These are valid parameters for any endpoint, however, they will only be used by the server where applicable.

**api_key** MUST BE SUPPLIED for every endpoint.

- **api_key** _string: (format: length == 16)_
  
  Your API key.  Required for access to any endpoint.
  
- **limit** _integer_
  _Default: 100_
  
  Maximum number of results
  
- **page** _integer_
  _Default: 0_
  
  Used in conjunction with **limit**
  Specifies the page number.  If limit is 10, then page = 2 will
  return results #20 through #29
  
- **min_date** _string (format: YYYY-MM-DD)_
  _Default: Today_
  
  Results before this date will not be returned.
  
- **max_date** _string (format: YYYY-MM-DD)_
  _Default: 1 year from Today_
  
  Results after this date will not be returned.
  
- **postalcode** _string (format: length >= 5)_
  _Default: none_
  
  Results will be within the **radius** of this postal code.

- **radius** _float_
  _Default: 100_
  
  Used in conjunction with **postalcode**
  
- **suppress** _boolean_
  _Default: false_
  
  If set to _true_ or _1_, will not return any results suppressed
  by your partner definition.
  
- **use_partner_id** _boolean_
  _Default: false_
  
  If set to _true_ or _1_, instead of using Thrillcall internal IDs,
  treat any IDs in a request as belonging to your partner definition.
  Contact us to set up a list of definitions.
  
- **ticket_type** _string (format: "primary" or "resale")_
  _Default: none_
  
  If specified, will only return tickets from Primary or Resale
  merchants.
  
- **must_have_tickets** _boolean_
  _Default: false_
  
  If set to _true_ or _1_, will only return results that have tickets
  associated with them.
  
- **confirmed_events_only** _boolean_
  _Default: false_
  
  If set to _true_ or _1_, will not return any UNCONFIRMED / RUMOR
  results.

GET /artists
------------
Params:
- **limit**
- **page**

GET /artist/:id
---------------
**:id** _integer_  Thrillcall or Partner ID

Params:
- **use_partner_id**

GET /artist/:id/events
----------------------
**:id** _integer_  Thrillcall or Partner ID

Params:
- **limit**
- **page**
- **min_date**
- **max_date**
- **postalcode**
- **radius**
- **suppress**
- **use_partner_id**
- **ticket_type**
- **must_have_tickets**
- **confirmed_events_only**

GET /search/artists/:term
-------------------------
**:term** _string_  Arbitrary search string

Params:
- **limit**
- **page**
- **suppress**

____

GET /events
------------
Params:
- **limit**
- **page**
- **min_date**
- **max_date**
- **postalcode**
- **radius**
- **suppress**
- **ticket_type**
- **must_have_tickets**
- **confirmed_events_only**

GET /event/:id
--------------
**:id** _integer_  Thrillcall ID

Params:
- None

GET /event/:id/artists
----------------------
**:id** _integer_  Thrillcall ID

Params:
- **limit**
- **page**

GET /event/:id/venue
--------------------
**:id** _integer_  Thrillcall ID

Params:
- None

GET /event/:id/tickets
----------------------
**:id** _integer_  Thrillcall ID

Params:
- **limit**
- **page**
- **ticket_type**

_____

GET /venues
------------
Params:
- **limit**
- **page**
- **postalcode**
- **radius**

GET /venue/:id
--------------
**:id** _integer_  Thrillcall or Partner ID

Params:
- **use_partner_id**

GET /venue/:id/events
----------------------
**:id** _integer_  Thrillcall or Partner ID

Params:
- **limit**
- **page**
- **min_date**
- **max_date**
- **suppress**
- **use_partner_id**
- **ticket_type**
- **must_have_tickets**
- **confirmed_events_only**

GET /search/venues/:term
------------------------
**:term** _string_  Arbitrary search string

Params:
- **limit**
- **page**
- **postalcode**
- **radius**

_____

GET /zip_codes
------------
Params:
- **limit**
- **page**

GET /zip_code/:id
-----------------
**:id** _integer_  Thrillcall ID

Params:
- None

GET /search/zip_codes/:term
--------------------------
**:term** _string_  Arbitrary search string

Params:
- **limit**
- **page**

_____

GET /tickets
------------
Params:
- **limit**
- **page**
- **min_date**
- **max_date**
- **postalcode**
- **radius**
- **ticket_type**
- **confirmed_events_only**

GET /ticket/:id
---------------
**:id** _integer_  Thrillcall ID

Params:
- None
