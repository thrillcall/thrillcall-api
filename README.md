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

# HTTP Endpoints

### Parameters
These are valid parameters for any endpoint, however, they will only be used by the server where applicable.

**api\_key** MUST BE SUPPLIED for every endpoint.

- <a name="api_key" />**api\_key** _string: (format: length == 16)_
    
    Your API key.  Required for access to any endpoint.
    
- <a name="limit" />**limit** _integer_
    
    _Default: 100_
    
    Sets the maximum number of results to return.  Cannot be above 100.
    
- <a name="page" />**page** _integer_
    
    _Default: 0_
    
    Used in conjunction with **[limit](#limit)**.
    
    Specifies the page number.  If limit is 10, then page = 2 will return results #20 through #29
    
- <a name="min_date" />**min\_date** _string (format: "YYYY-MM-DD")_
    
    _Default: Today_
    
    Results before this date will not be returned.
    
- <a name="max_date" />**max\_date** _string (format: "YYYY-MM-DD")_
    
    _Default: 1 year from Today_
    
    Results after this date will not be returned.
    
- <a name="lat" />**lat** _float_
    
    _Default: none_
    
    If latitude (**[lat](#lat)**) and longitude (**[long](#long)**) if both are specified, results will be within **[radius](#radius)** of this location.
    
- <a name="long" />**long** _float_
    
    _Default: none_
    
    If latitude (**[lat](#lat)**) and longitude (**[long](#long)**) if both are specified, results will be within **[radius](#radius)** of this location.
    
- <a name="postalcode" />**postalcode** _string (format: length >= 5)_
    
    _Default: none_
    
    Results will be within the **[radius](#radius)** of this postal code.
    If latitude (**[lat](#lat)**) and longitude (**[long](#long)**) if both are specified, this will be ignored.
    
- <a name="radius" />**radius** _float_
    
    _Default: 100.0_
    
    Used in conjunction with **[postalcode](#postalcode)**
    
- <a name="use_partner_id" />**use\_partner\_id** _boolean_
    
    _Default: false_
    
    If set to _true_ or _1_, instead of using Thrillcall internal IDs, treat any IDs in a request as belonging to your partner definition.
    
    Contact us to set up a list of definitions.
    
- <a name="ticket_type" />**ticket\_type** _string (format: "primary" or "resale")_
    
    _Default: both_
    
    If specified, will only return tickets from Primary or Resale merchants.
    
- <a name="must_have_tickets" />**must\_have\_tickets** _boolean_
    
    _Default: false_
    
    If set to _true_ or _1_, will only return results that have tickets associated with them.
    
- <a name="show_unconfirmed_events" />**show\_unconfirmed\_events** _boolean_
    
    _Default: false_
    
    If set to _true_ or _1_, will not filter out events with unconfirmed locations.
    
- <a name="show_rumor_events" />**show\_rumor\_events** _boolean_
    
    _Default: false_
    
    If set to _true_ or _1_, will not filter out events marked as rumored.

## Artists
Fields:

- **genre\_tags**             _string_    Semicolon separated list of Genre names
- **id**                      _integer_   Thrillcall ID
- **name**                    _string_    Artist / Band Name
- **upcoming\_events\_count** _integer_   Number of upcoming events associated with this object
- **updated\_at**             _string_    ISO 8601 representation of last time this object was updated
- **url**                     _string_    URL for this object on Thrillcall


### GET /artists
Params:

- **[limit](#limit)**
- **[page](#page)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v2/artists?limit=14&api_key=1234567890abcdef
    
    [
      {
        "genre_tags": "O",
        "id": 1,
        "name": "Hyler Jones Proteges",
        "upcoming_events_count": 0,
        "updated_at": "2010-03-26T16:49:20Z",
        "url": "http://thrillcall.com/artist/Hyler_Jones_Proteges"
      },
      {
        ...
      },
      ...
    ]
```

### GET /artist/:id
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[use\_partner\_id](#use_partner_id)**

Returns:  Artist _Hash_

``` js
    // Example: GET /api/v2/artist/6468?api_key=1234567890abcdef
    
    {
      "genre_tags": "Rock",
      "id": 6468,
      "name": "Katy Perry",
      "upcoming_events_count": 68,
      "updated_at": "2011-06-24T23:59:52Z",
      "url": "http://thrillcall.com/artist/Katy_Perry"
    }
```

### GET /artist/:id/events
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min\_date](#min_date)**
- **[max\_date](#max_date)**
- **[lat](#lat)**
- **[long](#long)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[use\_partner\_id](#use_partner_id)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**

Returns:  _Array_ of Events _Hash_

``` js
    // Example: GET /api/v2/artist/6468/events?api_key=1234567890abcdef
    
    [
      {
        "end_date": null,
        "festival": false,
        "id": 855667,
        "latitude": 34.0398,
        "longitude": -118.266,
        "name": "Katy Perry @ Staples Center",
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2011-11-22",
        "unconfirmed_location": 0,
        "updated_at": "2011-06-24T04:04:47Z",
        "venue_id": 39782,
        "url": "http://thrillcall.com/event/855667"
      },
      {
        ...
      },
      ...
    ]
```

### GET /search/artists/:term
**:term** _string_  Arbitrary search string on the **name** field.  (alphanumerics only, underscore matches underscore, use '+' for space)

Params:

- **[limit](#limit)**
- **[page](#page)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v2/search/artists/katyperry?api_key=1234567890abcdef
    
    [
      {
        "genre_tags": "Rock",
        "id": 6468,
        "name": "Katy Perry",
        "upcoming_events_count": 68,
        "updated_at": "2011-06-24T23:59:52Z",
        "url": "http://thrillcall.com/artist/Katy_Perry"
      }
    ]
```

## Events
Fields:

- **end\_date**               _string_  ISO 8601 representation of the end of the Event
- **festival**                _boolean_ Is this event a festival?
- **id**                      _integer_ Thrillcall ID
- **latitude**                _float_   Approximate latitude for the Event
- **longitude**               _float_   Approximate longitude for the Event
- **name**                    _string_  Name of the Event
- **on\_sale\_date**          _string_  ISO 8601 representation of the date when tickets go on sale
- **rumor**                   _boolean_ Are the details for this event based on a rumor?
- **start\_date**             _string_  YYYY-MM-DD or, if time of day is known, ISO 8601 representation of the start of the Event
- **unconfirmed\_location**   _integer_ If 1, the location if this event is unconfirmed
- **updated\_at**             _string_  ISO 8601 representation of last time this object was updated
- **venue\_id**               _integer_ Thrillcall Venue ID
- **url**                     _string_  URL for this object on Thrillcall


### GET /events
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min\_date](#min_date)**
- **[max\_date](#max_date)**
- **[lat](#lat)**
- **[long](#long)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**

Returns:  _Array_ of Events _Hash_

``` js
    // Example: GET /api/v2/events?limit=3&lat=37.782664&long=-122.410295&radius=0&api_key=1234567890abcdef
    
    [
      {
        "bearing": "129",
        "distance": "0.10208889540143654",
        "end_date": null,
        "festival": false,
        "id": 862237,
        "latitude": 37.7816,
        "longitude": -122.409,
        "name": "Keith Murray @ Club SIX",
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2011-07-17T06:59:00Z",
        "unconfirmed_location": 0,
        "updated_at": "2011-06-24T03:46:52Z",
        "venue_id": 39476,
        "url": "http://thrillcall.com/event/862237"
      },
      {
        ...
      },
      ...
    ]
```

### GET /event/:id
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Event _Hash_

``` js
    // Example: GET /api/v2/event/753419/artists?api_key=1234567890abcdef
    
    [
      {
        "genre_tags": null,
        "id": 375669,
        "name": "The Magnetic Fields",
        "upcoming_events_count": 0,
        "updated_at": "2011-06-20T12:52:54Z",
        "url": "http://thrillcall.com/artist/The_Magnetic_Fields"
      }
    ]
```

### GET /event/:id/artists
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v2/event/855667/artists?api_key=1234567890abcdef
    
    [
      {
        "genre_tags": "Rock",
        "id": 6468,
        "name": "Katy Perry",
        "upcoming_events_count": 68,
        "updated_at": "2011-06-24T23:59:52Z",
        "url": "http://thrillcall.com/artist/Katy_Perry"
      }
    ]
```

### GET /event/:id/venue
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Venue _Hash_

``` js
    // Example: GET /api/v2/event/831330/venue?api_key=1234567890abcdef
    
    {
      "address1": "201 Van Ness Avenue",
      "address2": null,
      "city": "San Francisco",
      "country": "US",
      "id": 51886,
      "latitude": 37.777292,
      "longitude": -122.419779,
      "name": "Davies Symphony Hall",
      "state": "CA",
      "upcoming_events_count": 85,
      "updated_at": "2011-02-20T02:15:48Z",
      "postalcode": "94102",
      "url": "http://thrillcall.com/venue/Davies_Symphony_Hall_in_San_Francisco_CA"
    }
```

### GET /event/:id/tickets
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[ticket\_type](#ticket_type)**

Returns:  _Array_ of Tickets _Hash_

``` js
    // Example: GET /api/v2/event/753419/tickets?api_key=1234567890abcdef
    
    [
      {
        "description": null,
        "event_id": 753419,
        "id": 456349,
        "marketing_text": null,
        "max_ticket_price": null,
        "min_ticket_price": null,
        "name": "Resale",
        "on_sale_end_date": null,
        "on_sale_start_date": null,
        "seat_info": null,
        "updated_at": "2011-01-19T22:28:24Z",
        "url": "/event/ticketnetwork_tickets/753419"
      }
    ]
```

## Venues
Fields:

- **address1**                _string_    First address field for the Venue
- **address2**                _string_    Second address field for the Venue
- **city**                    _string_    City the Venue is in
- **country**                 _string_    Country the Venue is in
- **id**                      _integer_   Thrillcall ID
- **latitude**                _float_     Approximate Latitude for the Venue
- **longitude**               _float_     Approximate Longitude for the Venue
- **name**                    _string_    Name of the Venue
- **state**                   _string_    State the Venue is in
- **upcoming\_events\_count** _integer_   Number of upcoming events associated with this object
- **updated\_at**             _string_    ISO 8601 representation of last time this object was updated
- **postalcode**              _string_    Postal code for the Venue
- **url**                     _string_    URL for this object on Thrillcall


### GET /venues
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[lat](#lat)**
- **[long](#long)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**

Returns:  _Array_ of Venues _Hash_

``` js
    // Example: GET /api/v2/venues?limit=14&api_key=1234567890abcdef
    
    [
      {
        "address1": null,
        "address2": null,
        "city": "Guadalajara",
        "country": "MX",
        "id": 1,
        "latitude": null,
        "longitude": null,
        "name": "Fbolko",
        "state": "MX",
        "upcoming_events_count": 0,
        "updated_at": "2010-03-28T17:24:20Z",
        "postalcode": null,
        "url": "http://thrillcall.com/venue/Fbolko_in_Guadalajara_MX"
      },
      {
        ...
      },
      ...
    ]
```


### GET /venue/:id
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[use\_partner\_id](#use_partner_id)**

Returns:  Venue _Hash_

``` js
    // Example: GET /api/v2/venue/12345?api_key=1234567890abcdef
    
    {
      "address1": null,
      "address2": null,
      "city": "Raleigh",
      "country": "US",
      "id": 12345,
      "latitude": 35.716105,
      "longitude": -78.65734,
      "name": "Record Exchange",
      "state": "NC",
      "upcoming_events_count": 0,
      "updated_at": "2011-06-24T03:46:01Z",
      "postalcode": "27603",
      "url": "http://thrillcall.com/venue/Record_Exchange_in_Raleigh_NC"
    }
```

### GET /venue/:id/events
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min\_date](#min_date)**
- **[max\_date](#max_date)**
- **[use\_partner\_id](#use_partner_id)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**

Returns:  _Array_ of Events _Hash_

``` js
    // Example: GET /api/v2/venue/32065/events?api_key=1234567890abcdef
    
    [
      {
        "end_date": null,
        "festival": false,
        "id": 824614,
        "latitude": 37.8016,
        "longitude": -80.4462,
        "name": "Colt Ford @ West Virginia State Fair",
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2011-08-21T03:59:00Z",
        "unconfirmed_location": 0,
        "updated_at": "2011-06-24T05:10:05Z",
        "venue_id": 32065,
        "url": "http://thrillcall.com/event/824614"
      },
      {
        ...
      },
      ...
    ]
```

### GET /search/venues/:term
**:term** _string_  Arbitrary search string on the **name** field.  (alphanumerics only, underscore matches underscore, use '+' for space)

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[lat](#lat)**
- **[long](#long)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**

Returns:  _Array_ of Venues _Hash_

``` js
    // Example: GET /api/v2/search/venues/recordexchange?api_key=1234567890abcdef
    
    [
      {
        "address1": null,
        "address2": null,
        "city": "Chandler",
        "country": "US",
        "id": 10843,
        "latitude": 33.237229,
        "longitude": -111.8004,
        "name": "Zia Record Exchange",
        "state": "AZ",
        "upcoming_events_count": 0,
        "updated_at": "2011-06-24T03:45:46Z",
        "postalcode": "85249",
        "url": "http://thrillcall.com/venue/Zia_Record_Exchange_in_Chandler_AZ"
      },
      {
        ...
      },
      ...
    ]
```

## Tickets
Fields:

- **description**            _string_   Long form description of the ticket
- **event\_id**              _integer_  Thrillcall Event ID
- **id**                     _integer_  Thrillcall ID
- **marketing\_text**        _string_   Long form description of the ticket
- **max\_ticket\_price**     _float_    Maximum price for this ticket
- **min\_ticket\_price**     _float_    Minimum price for this ticket
- **name**                   _string_   Name of this ticket
- **on\_sale\_end\_date**    _string_   YYYY-MM-DD date when the ticket goes off sale
- **on\_sale\_start\_date**  _string_   YYYY-MM-DD date when the ticket goes on sale
- **seat\_info**             _string_   Additional info about the seat
- **updated\_at**            _string_   ISO 8601 representation of last time this object was updated
- **url**                    _string_   URL for this object on Thrillcall

### GET /tickets
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min\_date](#min_date)**
- **[max\_date](#max_date)**
- **[lat](#lat)**
- **[long](#long)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[ticket\_type](#ticket_type)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**

Returns:  _Array_ of Tickets _Hash_

``` js
    // Example: GET /api/v2/tickets?limit=14&api_key=1234567890abcdef
    
    [
      {
        "description": null,
        "event_id": 455646,
        "id": 1,
        "marketing_text": null,
        "max_ticket_price": null,
        "min_ticket_price": null,
        "name": "General Onsale",
        "on_sale_end_date": null,
        "on_sale_start_date": null,
        "seat_info": null,
        "updated_at": "2009-09-22T22:58:37Z",
        "url": "http://www.livenation.com/edp/eventId/335800/?c=api-000157"
      },
      {
        ...
      },
      ...
    ]
```

### GET /ticket/:id
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Ticket _Hash_

``` js
    // Example: GET /api/v2/ticket/12345?api_key=1234567890abcdef
    
    {
      "description": null,
      "event_id": 465757,
      "id": 12345,
      "marketing_text": null,
      "max_ticket_price": null,
      "min_ticket_price": null,
      "name": "Resale",
      "on_sale_end_date": null,
      "on_sale_start_date": null,
      "seat_info": null,
      "updated_at": "2009-02-05T19:51:27Z",
      "url": "http://www.ticketcity.com/concert-tickets/world-music-tickets/celtic-woman-tickets/celtic-woman-tickets-nokia-live-april-18-8-00pm.html"
    }
```