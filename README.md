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
events = tc.events(:limit => 5)
# => [ {"id" => ... }, {...}, ...]
events.length
# => 5

#---------------------------------------------------------------#
# Chain methods together for nested routes
#---------------------------------------------------------------#
artist = tc.search.venues("warfield", :postalcode => "94101", :radius => 20)
# => {"name" => "The Warfield", ...}
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

# HTTP Endpoints

### Parameters
These are valid parameters for any endpoint, however, they will only be used by the server where applicable.

**api_key** MUST BE SUPPLIED for every endpoint.

- <a name="api_key" />**api_key** _string: (format: length == 16)_
    
    Your API key.  Required for access to any endpoint.
    
- <a name="limit" />**limit** _integer_
    _Default: 100_
    
    Maximum number of results
    
- <a name="page" />**page** _integer_
    _Default: 0_
    
    Used in conjunction with **limit**
    Specifies the page number.  If limit is 10, then page = 2 will
    return results #20 through #29
    
- <a name="min_date" />**min_date** _string (format: YYYY-MM-DD)_
    _Default: Today_
    
    Results before this date will not be returned.
    
- <a name="max_date" />**max_date** _string (format: YYYY-MM-DD)_
    _Default: 1 year from Today_
    
    Results after this date will not be returned.
    
- <a name="postalcode" />**postalcode** _string (format: length >= 5)_
    _Default: none_
    
    Results will be within the **radius** of this postal code.
    
- <a name="radius" />**radius** _float_
    _Default: 100_
    
    Used in conjunction with **postalcode**
    
- <a name="suppress" />**suppress** _boolean_
    _Default: false_
    
    If set to _true_ or _1_, will not return any results suppressed by your partner definition.
    
- <a name="use_partner_id" />**use_partner_id** _boolean_
    _Default: false_
    
    If set to _true_ or _1_, instead of using Thrillcall internal IDs, treat any IDs in a request as belonging to your partner definition.
    Contact us to set up a list of definitions.
    
- <a name="ticket_type" />**ticket_type** _string (format: "primary" or "resale")_
    _Default: none_
    
    If specified, will only return tickets from Primary or Resale merchants.
    
- <a name="must_have_tickets" />**must_have_tickets** _boolean_
    _Default: false_
    
    If set to _true_ or _1_, will only return results that have tickets associated with them.
    
- <a name="confirmed_events_only" />**confirmed_events_only** _boolean_
    _Default: false_
    
    If set to _true_ or _1_, will not return any UNCONFIRMED / RUMOR results.

## Artists
### GET /artists
Params:

- **[limit](#limit)**
- **[page](#page)**

### GET /artist/:id
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[use_partner_id](#use_partner_id)**

### GET /artist/:id/events
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min_date](#min_date)**
- **[max_date](#max_date)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[suppress](#suppress)**
- **[use_partner_id](#use_partner_id)**
- **[ticket_type](#ticket_type)**
- **[must_have_tickets](#must_have_tickets)**
- **[confirmed_events_only](#confirmed_events_only)**

### GET /search/artists/:term
**:term** _string_  Arbitrary search string

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[suppress](#suppress)**

## Events
### GET /events
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min_date](#min_date)**
- **[max_date](#max_date)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[suppress](#suppress)**
- **[ticket_type](#ticket_type)**
- **[must_have_tickets](#must_have_tickets)**
- **[confirmed_events_only](#confirmed_events_only)**

### GET /event/:id
**:id** _integer_  Thrillcall ID

Params:

- None

### GET /event/:id/artists
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**

### GET /event/:id/venue
**:id** _integer_  Thrillcall ID

Params:

- None

### GET /event/:id/tickets
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[ticket_type](#ticket_type)**

## Venues
### GET /venues
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**

### GET /venue/:id
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[use_partner_id](#use_partner_id)**

### GET /venue/:id/events
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min_date](#min_date)**
- **[max_date](#max_date)**
- **[suppress](#suppress)**
- **[use_partner_id](#use_partner_id)**
- **[ticket_type](#ticket_type)**
- **[must_have_tickets](#must_have_tickets)**
- **[confirmed_events_only](#confirmed_events_only)**

### GET /search/venues/:term
**:term** _string_  Arbitrary search string

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**

## Zip Codes
### GET /zip_codes
Params:

- **[limit](#limit)**
- **[page](#page)**

### GET /zip_code/:id
**:id** _integer_  Thrillcall ID

Params:

- None

### GET /search/zip_codes/:term
**:term** _string_  Arbitrary search string

Params:

- **[limit](#limit)**
- **[page](#page)**

## Tickets
### GET /tickets
Params:

- **[limit](#limit)]**
- **[page](#page)**
- **[min_date](#min_date)**
- **[max_date](#max_date)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[ticket_type](#ticket_type)**
- **[confirmed_events_only](#confirmed_events_only)**

### GET /ticket/:id
**:id** _integer_  Thrillcall ID

Params:

- None
