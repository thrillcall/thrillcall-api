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
    # The default SSL endpoint is "https://api.thrillcall.com/api/".
    # The default API version is 2.
    # By default, Faraday access logging is turned off.
    # Override if necessary:
    #---------------------------------------------------------------#
    tc = ThrillcallAPI.new(
      MY_API_KEY,
      :base_url => "https://api.thrillcall.com/custom/",
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
    BASE_URL    = "https://api.thrillcall.com/api/v2/"
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


# HTTPS Endpoints

### SSL/TLS Endpoints Required:
All API access must use the secure HTTPS endpoint : https://api.thrillcall.com:443
Access over an insecure HTTP (port 80) endpoint is now deprecated and will be disabled.

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
    

- <a name="time_zone" />**time\_zone** _string (format: TZ Database string, eg "America/Los\_Angeles")_
    
    _Default: UTC_
    _For Metro Area endpoints, the default is instead the Metro Area's time zone and cannot be overridden._
    
    **[min\_date](#min_date)** and **[max\_date](#max_date)** will be calculated based on this time zone.
    
- <a name="min_date" />**min\_date** _string (format: "YYYY-MM-DD")_
    
    _Default: Today_
    
    Results before this date will not be returned.
    
- <a name="max_date" />**max\_date** _string (format: "YYYY-MM-DD")_
    
    _Default: 1 year from Today_
    
    Results after this date will not be returned.
    
- <a name="lat" />**lat** _float_
    
    _Default: none_
    
    If latitude (**[lat](#lat)**) and longitude (**[long](#long)**) if both are specified, results will be within **[radius](#radius)** of this location.
    
    For Person queries, this specifies the latitude of the person's location.
    
- <a name="long" />**long** _float_
    
    _Default: none_
    
    If latitude (**[lat](#lat)**) and longitude (**[long](#long)**) if both are specified, results will be within **[radius](#radius)** of this location.
    
    For Person queries, this specifies the longitude of the person's location.
    
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

- <a name="primary_genre_id" />**primary\_genre\_id** _integer_
    
    _Default: none_
    
    If set, will filter Artist results to only those with the specified **[primary\_genre\_id](#primary_genre_id)**

- <a name="email" />**email** _string_
    
    The email address associated with a user, required for registration.

- <a name="password" />**password** _string (format: 40 >= length >= 5)_
    
    The user's password.  Must be supplied along with **[email](#email)** unless using **[provider](#provider)** / **[uid](#uid)** / **[token](#token)** auth.

- <a name="provider" />**provider** _string_
    
    The name of the authentication provider (e.g. "facebook").  Must be supplied along with **[uid](#uid)** and **[token](#token)** unless using **[email](#email)**/**[password](#password)** auth.

- <a name="uid" />**uid** _string_
    
    The user's ID with **[provider](#provider)**.  Must be supplied along with **[provider](#provider)** and **[token](#token)** unless using **[email](#email)**/**[password](#password)** auth.

- <a name="token" />**token** _string_
    
    The user's authentication token with **[provider](#provider)**.  Must be supplied along with **[provider](#provider)** and **[uid](#uid)** unless using **[email](#email)**/**[password](#password)** auth.

- <a name="first_name" />**first\_name** _string (format: 50 >= length >= 2)_
    
    Required to register a user.

- <a name="last_name" />**last\_name** _string (format: 50 >= length >= 2)_
    
    Optional for registering a user.

- <a name="gender" />**gender** _string (format: length == 1)_
    
    Optional for registering a user.

- <a name="location_name" />**location\_name** _string (format: "City, ST or City, State", length > 0))_
    
    The name of the user's location when auto-registering.  Either this or **[lat](#lat)** / **[long](#long)** must be provided.

- <a name="referral_code" />**referral\_code** _string_
    
    The referral code to be used during registration.  Both the owner of the code as well as the new user will receive a point on their referral counts.


## Artists
Fields:

- **created\_at**             _string_    ISO 8601 representation the time this object was created
- **genre\_tags**             _string_    Semicolon separated list of Genre names
- **id**                      _integer_   Thrillcall ID
- **name**                    _string_    Artist / Band Name
- **primary\_genre\_id**      _integer_   The Thrillcall ID for this artist's primary Genre
- **upcoming\_events\_count** _integer_   Number of upcoming events associated with this object
- **updated\_at**             _string_    ISO 8601 representation of last time this object was updated
- **photos**                  _hash_      A hash of image urls of the primary photo available for this object in different styles
- **url**                     _string_    URL for this object on Thrillcall


### GET /artists
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[primary\_genre\_id](#primary_genre_id)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v2/artists?limit=14&api_key=1234567890abcdef
    
    [
      {
        "created_at": "2008-04-29T10:19:45Z",
        "genre_tags": "O",
        "id": 1,
        "name": "Hyler Jones Proteges",
        "primary_genre_id": 61,
        "upcoming_events_count": 0,
        "updated_at": "2010-03-26T16:49:20Z",
        "photos":
            {
              "thumbnail": "http://i.tc-core.com/artist/_default/default-thumbnail.jpg",
              "medium": "http://i.tc-core.com/artist/_default/default-medium.jpg",
              "large": "http://i.tc-core.com/artist/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/artist/_default/default-mobile.jpg"
            },
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
    // Example: GET /api/v2/artist/4802?api_key=1234567890abcdef
    
    {
      "created_at": "2008-04-28T18:56:09Z",
      "genre_tags": "Rock",
      "id": 4802,
      "name": "The Sea and Cake",
      "primary_genre_id": 27,
      "upcoming_events_count": 8,
      "updated_at": "2011-09-20T19:12:57Z",
      "photos":
            {
              "thumbnail": "http://i.tc-core.com/artist/_default/default-thumbnail.jpg",
              "medium": "http://i.tc-core.com/artist/_default/default-medium.jpg",
              "large": "http://i.tc-core.com/artist/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/artist/_default/default-mobile.jpg"
            },
      "url": "http://thrillcall.com/artist/The_Sea_and_Cake"
    }
```

### GET /artist/:id/events
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[time\_zone](#time_zone)**
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
    // Example: GET /api/v2/artist/4802/events?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2011-06-23T23:10:31Z",
        "end_date": null,
        "festival": false,
        "id": 862618,
        "latitude": 30.2729,
        "longitude": -97.7405,
        "name": "The Sea and Cake @ The Mohawk",
        "num_cancelled_bookings": 0,
        "num_confirmed_bookings": 1,
        "num_disabled_bookings": 0,
        "num_unconfirmed_bookings": 0,
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2011-12-09T05:59:00Z",
        "unconfirmed_location": 0,
        "updated_at": "2011-09-28T04:01:56Z",
        "venue_id": 10116,
        "photos":
            {
              "thumbnail": "http://i.tc-core.com/event/_default/default-thumbnail.jpg",
              "large": "http://i.tc-core.com/event/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/event/_default/default-mobile.jpg"
            },
        "url": "http://thrillcall.com/event/862618"
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
    // Example: GET /api/v2/search/artists/The%20Sea%20and%20Cake?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2008-04-28T18:56:09Z",
        "genre_tags": "Rock",
        "id": 4802,
        "name": "The Sea and Cake",
        "primary_genre_id": 27,
        "upcoming_events_count": 8,
        "updated_at": "2011-09-20T19:12:57Z",
        "photos":
            {
              "thumbnail": "http://i.tc-core.com/artist/_default/default-thumbnail.jpg",
              "medium": "http://i.tc-core.com/artist/_default/default-medium.jpg",
              "large": "http://i.tc-core.com/artist/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/artist/_default/default-mobile.jpg"
            },
        "url": "http://thrillcall.com/artist/The_Sea_and_Cake"
      },
      {
        ...
      },
      ...
    ]
```

## Events
Fields:

- **created\_at**                 _string_  ISO 8601 representation the time this object was created
- **end\_date**                   _string_  ISO 8601 representation of the end of the Event
- **festival**                    _boolean_ Is this event a festival?
- **id**                          _integer_ Thrillcall ID
- **latitude**                    _float_   Approximate latitude for the Event
- **longitude**                   _float_   Approximate longitude for the Event
- **name**                        _string_  Name of the Event
- **num\_confirmed\_bookings**    _integer_ The number of confirmed Artist bookings for this event.  Only Artists with a confirmed booking are returned when requesting artists for an event.
- **num\_unconfirmed\_bookings**  _integer_ The number of unconfirmed Artist bookings for this event
- **num\_disabled\_bookings**     _integer_ The number of disabled Artist bookings for this event
- **num\_cancelled\_bookings**    _integer_ The number of cancelled Artist bookings for this event
- **on\_sale\_date**              _string_  ISO 8601 representation of the date when tickets go on sale
- **rumor**                       _boolean_ Are the details for this event based on a rumor?
- **start\_date**                 _string_  YYYY-MM-DD or, if time of day is known, ISO 8601 representation of the start of the Event
- **unconfirmed\_location**       _integer_ If 1, the location if this event is unconfirmed
- **updated\_at**                 _string_  ISO 8601 representation of last time this object was updated
- **venue\_id**                   _integer_ Thrillcall Venue ID
- **photos**                      _hash_    A hash of image urls of the primary photo available for this object in different styles
- **url**                         _string_  URL for this object on Thrillcall


### GET /events
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[time\_zone](#time_zone)**
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
    // Example: GET /api/v2/events?must_have_tickets=true&postalcode=94108&radius=10&limit=3&api_key=1234567890abcdef
    
    [
      {
        "created_at": "2011-06-14T00:09:13Z",
        "end_date": null,
        "festival": false,
        "id": 858707,
        "latitude": 37.7951,
        "longitude": -122.421,
        "name": "The Sea and Cake @ Great American Music Hall",
        "num_cancelled_bookings": 0,
        "num_confirmed_bookings": 1,
        "num_disabled_bookings": 0,
        "num_unconfirmed_bookings": 0,
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2011-12-06T07:59:00Z",
        "unconfirmed_location": 0,
        "updated_at": "2011-09-28T04:00:41Z",
        "venue_id": 27418,
        "photos":
            {
              "thumbnail": "http://i.tc-core.com/event/_default/default-thumbnail.jpg",
              "large": "http://i.tc-core.com/event/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/event/_default/default-mobile.jpg"
            },
        "url": "http://thrillcall.com/event/858707"
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
    // Example: GET /api/v2/event/858707?api_key=1234567890abcdef
    
    {
      "created_at": "2011-06-14T00:09:13Z",
      "end_date": null,
      "festival": false,
      "id": 858707,
      "latitude": 37.7951,
      "longitude": -122.421,
      "name": "The Sea and Cake @ Great American Music Hall",
      "num_cancelled_bookings": 0,
      "num_confirmed_bookings": 1,
      "num_disabled_bookings": 0,
      "num_unconfirmed_bookings": 0,
      "on_sale_date": null,
      "rumor": false,
      "start_date": "2011-12-06T07:59:00Z",
      "unconfirmed_location": 0,
      "updated_at": "2011-09-28T04:00:41Z",
      "venue_id": 27418,
      "photos":
            {
              "thumbnail": "http://i.tc-core.com/event/_default/default-thumbnail.jpg",
              "large": "http://i.tc-core.com/event/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/event/_default/default-mobile.jpg"
            },
      "url": "http://thrillcall.com/event/858707"
    }
```

### GET /event/:id/artists
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v2/event/858707/artists?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2008-04-28T18:56:09Z",
        "genre_tags": "Rock",
        "id": 4802,
        "name": "The Sea and Cake",
        "primary_genre_id": 27,
        "upcoming_events_count": 8,
        "updated_at": "2011-09-20T19:12:57Z",
        "photos":
            {
              "thumbnail": "http://i.tc-core.com/artist/_default/default-thumbnail.jpg",
              "medium": "http://i.tc-core.com/artist/_default/default-medium.jpg",
              "large": "http://i.tc-core.com/artist/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/artist/_default/default-mobile.jpg"
            },
        "url": "http://thrillcall.com/artist/The_Sea_and_Cake"
      },
      {
        ...
      },
      ...
    ]
```

### GET /event/:id/venue
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Venue _Hash_

``` js
    // Example: GET /api/v2/event/858707/venue?api_key=1234567890abcdef
    
    {
      "address1": "859 O'Farrell St.",
      "address2": null,
      "city": "San Francisco",
      "country": "US",
      "created_at": "2008-04-21T16:52:31Z",
      "id": 27418,
      "latitude": 37.784796,
      "longitude": -122.418819,
      "name": "Great American Music Hall",
      "state": "CA",
      "upcoming_events_count": 34,
      "updated_at": "2011-01-20T21:04:37Z",
      "postalcode": "94109",
      "metro_area_id": 105,
      "photos":
          {
            "thumbnail": "http://i.tc-core.com/venue/_default/default-thumbnail.jpg",
            "medium": "http://i.tc-core.com/venue/_default/default-medium.jpg",
            "large": "http://i.tc-core.com/venue/_default/default-large.jpg",
            "mobile": "http://i.tc-core.com/venue/_default/default-mobile.jpg"
          }
      "url": "http://thrillcall.com/venue/Great_American_Music_Hall_in_San_Francisco_CA"
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
    // Example: GET /api/v2/event/858707/tickets?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2011-06-14T00:09:16Z",
        "description": null,
        "event_id": 858707,
        "id": 599794,
        "marketing_text": null,
        "max_ticket_price": 21,
        "min_ticket_price": null,
        "name": "Gen. Admission Seating Limited",
        "on_sale_end_date": null,
        "on_sale_start_date": null,
        "seat_info": null,
        "updated_at": "2011-06-14T00:09:16Z",
        "url": "http://tickets.gamh.com/evinfo.php?eventid=154723&amp;r=affi&amp;u=210785"
      },
      {
        ...
      },
      ...
    ]
```

## Genre
Fields:

- **created\_at**             _string_    ISO 8601 representation the time this object was created
- **description**             _string_    Description of the Genre
- **id**                      _integer_   Thrillcall ID
- **name**                    _string_    Name of the Genre
- **updated\_at**             _string_    ISO 8601 representation of last time this object was updated

### GET /genres
Params:

- **[limit](#limit)**
- **[page](#page)**

Returns:  _Array_ of Genres _Hash_

``` js
    // Example: GET /api/v2/genres?limit=14&api_key=1234567890abcdef
    
    [
      {
        "created_at": "2008-07-09T19:17:45Z",
        "description": "Shawn Colvin, Loudon Wainwright III etc...",
        "id": 6,
        "name": "Folk",
        "updated_at": "2010-03-25T23:51:55Z"
      },
      {
        ...
      },
      ...
    ]
```

### GET /genre/:id
**:id** _integer_  Thrillcall ID

Params:

- None

Returns: Genre _Hash_

``` js
    // Example: GET /api/v2/genre/27?api_key=1234567890abcdef
    
    {
      "created_at": "2008-07-09T19:17:45Z",
      "description": "U2, 30 Seconds To Mars etc...",
      "id": 27,
      "name": "Rock",
      "updated_at": "2010-03-25T23:52:21Z"
    }
```

### GET /genre/:id/artists
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v2/genre/27/artists?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2008-04-29T10:06:05Z",
        "genre_tags": "Folk;Other;psychedelic",
        "id": 2,
        "name": "Espers",
        "primary_genre_id": 27,
        "upcoming_events_count": 1,
        "updated_at": "2011-01-03T22:14:36Z",
        "photos":
            {
              "thumbnail": "http://i.tc-core.com/artist/_default/default-thumbnail.jpg",
              "medium": "http://i.tc-core.com/artist/_default/default-medium.jpg",
              "large": "http://i.tc-core.com/artist/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/artist/_default/default-mobile.jpg"
            },
        "url": "http://thrillcall.com/artist/Espers"
      },
      {
        ...
      },
      ...
    ]
```

## Metro Area
Fields:

- **city**                                _string_    City of the Metro Area
- **country**                             _string_    Country of the Metro Area
- **created\_at**                         _string_    ISO 8601 representation the time this object was created
- **id**                                  _integer_   Thrillcall ID
- **latitude**                            _float_     Latitude of the Metro Area
- **longitude**                           _float_     Longitude of the Metro Area
- **radius**                              _integer_   Radius of the Metro Area from the Lat/Long center
- **state**                               _string_    State of the Metro Area
- **time\_zone**                          _string_    Time zone of the Metro Area
- **updated\_at**                         _string_    ISO 8601 representation of last time this object was updated
- **url**                                 _string_    URL for this object on Thrillcall
- **offers\_availability\_status\_code**  _integer_   Offers status for the Metro Area ( no\_offers = 0, available = 1, coming\_soon = 2)

### GET /metro_areas
Params:

- **[limit](#limit)**
- **[page](#page)**

Returns:  _Array_ of Metro Areas _Hash_

``` js
    // Example: GET /api/v2/metro_areas?limit=14&api_key=1234567890abcdef
    
    [
      {
        "city": "Chicago",
        "country": "US",
        "created_at": "2011-06-24T03:23:57Z",
        "id": 104,
        "latitude": 41.8842,
        "longitude": -87.6324,
        "offers_availability_status_code": 2,
        "radius": 50,
        "state": "IL",
        "time_zone": "America/Chicago",
        "updated_at": "2011-07-05T23:11:24Z",
        "url": "http://thrillcall.com/live-music/chicago"
      },
      {
        ...
      },
      ...
    ]
```

### GET /metro_area/:id
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Metro Area _Hash_

``` js
    // Example: GET /api/v2/metro_area/105?api_key=1234567890abcdef
    
    {
      "city": "San Francisco",
      "country": "US",
      "created_at": "2011-06-24T03:23:57Z",
      "id": 105,
      "latitude": 37.7771,
      "longitude": -122.42,
      "offers_availability_status_code": 1,
      "radius": 50,
      "state": "CA",
      "time_zone": "America/Chicago",
      "updated_at": "2011-07-05T23:11:24Z",
      "url": "http://thrillcall.com/live-music/san-francisco"
    }
```

### GET /metro_area/:id/events
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min\_date](#min_date)**
- **[max\_date](#max_date)**
- **[radius](#radius)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**

Note:  Time Zone is set as the time zone of the Metro Area and cannot be overridden.

Returns:  _Array_ of Metro Areas _Hash_

``` js
    // Example: GET /api/v2/metro_area/105/events?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2011-04-24T02:12:09Z",
        "end_date": null,
        "festival": false,
        "id": 831330,
        "latitude": 37.7794,
        "longitude": -122.418,
        "name": "Philadelphia Orchestra @ Davies Symphony Hall",
        "num_cancelled_bookings": 0,
        "num_confirmed_bookings": 1,
        "num_disabled_bookings": 0,
        "num_unconfirmed_bookings": 0,
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2012-06-11T06:59:00Z",
        "unconfirmed_location": 0,
        "updated_at": "2011-09-28T03:51:22Z",
        "venue_id": 51886,
        "photos":
            {
              "thumbnail": "http://i.tc-core.com/event/_default/default-thumbnail.jpg",
              "large": "http://i.tc-core.com/event/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/event/_default/default-mobile.jpg"
            },
        "url": "http://thrillcall.com/event/831330"
      },
      {
        ...
      },
      ...
    ]
```

## Person
**Note:** Your API key requires the api\_auth permission to access the endpoints associated with this object.

Fields:

- **created\_at**             _string_    ISO 8601 representation the time this object was created
- **first\_name**             _string_    First name of the Person
- **gender**                  _string_    Gender of the Person
- **id**                      _integer_   Thrillcall ID
- **last\_name**              _string_    Last name of the Person
- **login**                   _string_    Login (Email Address) of the Person
- **updated\_at**             _string_    ISO 8601 representation of last time this object was updated
- **referral\_code**          _string_    Referral code of the Person
- **referral\_code\_count**   _integer_   Number of Referral code used for the Person
- **postalcode**              _string_    Postalcode of the Person
- **photos**                  _hash_      A hash of image urls of the primary photo available for this object in different styles

### GET /person/:id
Params:

- None.

Returns: Person _Hash_

``` js
    // Example: GET /api/v2/person/49
    
    {
      "created_at": "2000-11-09T19:09:23Z",
      "first_name": "John",
      "gender": null,
      "id": 49,
      "last_name": "Doe",
      "login": "john@example.com",
      "updated_at": "2011-11-09T19:09:23Z",
      "referral_code": "fhskjfhk3j43h43hjkh",
      "referral_code_count": 0,
      "photos":
          {
            "small_thumb": "http://i.tc-core.com/person/_default/default-small_thumb.jpg",
            "thumbnail": "http://i.tc-core.com/person/_default/default-thumbnail.jpg",
            "medium": "http://i.tc-core.com/person/_default/default-medium.jpg"
          },
      "postalcode": "94104"
    }
```

### POST /person/signin
Params:

- **[email](#email)**
- **[password](#password)**
- **[provider](#provider)**
- **[uid](#uid)**
- **[token](#token)**
- **[first\_name](#first_name)**
- **[last\_name](#last_name)**
- **[location\_name](#location_name)**
- **[lat](#lat)**
- **[long](#long)**
- **[referral\_code](#referral_code)**

Use either **[email](#email)** / **[password](#password)** or **[provider](#provider)** / **[uid](#uid)** / **[token](#token)**.

May perform registration ("signup") automatically if using **[provider](#provider)** / **[uid](#uid)** / **[token](#token)** when no match is found and name, location, and **[referral_code](#referral_code)** are also provided.

Returns: Person _Hash_

``` js
    // Example: POST /api/v2/person/signin
    
    {
      "created_at": "2000-11-09T19:09:23Z",
      "first_name": "John",
      "gender": null,
      "id": 49,
      "last_name": "Doe",
      "login": "john@example.com",
      "updated_at": "2011-11-09T19:09:23Z",
      "referral_code": "fhskjfhk3j43h43hjkh",
      "referral_code_count": 0,
      "photos":
          {
            "small_thumb": "http://i.tc-core.com/person/_default/default-small_thumb.jpg",
            "thumbnail": "http://i.tc-core.com/person/_default/default-thumbnail.jpg",
            "medium": "http://i.tc-core.com/person/_default/default-medium.jpg"
          },
      "postalcode": "94104"
    }
```

### POST /person/signup
Params:

- **[first\_name](#first_name)**
- **[last\_name](#last_name)**
- **[gender](#gender)**
- **[email](#email)**
- **[password](#password)**
- **[postalcode](#postalcode)**
- **[referral\_code](#referral_code)**

Returns: Person _Hash_

``` js
    // Example: POST /api/v2/person/signup
    
    {
        "created_at": "2000-11-09T19:09:23Z",
        "first_name": "John",
        "gender": null,
        "id": 49,
        "last_name": "Doe",
        "login": "john@example.com",
        "updated_at": "2011-11-09T19:09:23Z",
        "referral_code": "fhskjfhk3j43h43hjkh",
        "referral_code_count": 0,
        "photos":
          {
            "small_thumb": "http://i.tc-core.com/person/_default/default-small_thumb.jpg",
            "thumbnail": "http://i.tc-core.com/person/_default/default-thumbnail.jpg",
            "medium": "http://i.tc-core.com/person/_default/default-medium.jpg"
          },
        "postalcode": "94104"
     }
```


## Venues
Fields:

- **address1**                _string_    First address field for the Venue
- **address2**                _string_    Second address field for the Venue
- **city**                    _string_    City the Venue is in
- **country**                 _string_    Country the Venue is in
- **created\_at**             _string_    ISO 8601 representation the time this object was created
- **id**                      _integer_   Thrillcall ID
- **latitude**                _float_     Approximate Latitude for the Venue
- **long\_description**       _text_      Description of the Venue
- **longitude**               _float_     Approximate Longitude for the Venue
- **name**                    _string_    Name of the Venue
- **metro\_area\_id**         _integer_   Thrillcall ID of the Metro Area this Venue is in, if any
- **state**                   _string_    State the Venue is in
- **upcoming\_events\_count** _integer_   Number of upcoming events associated with this object
- **updated\_at**             _string_    ISO 8601 representation of last time this object was updated
- **postalcode**              _string_    Postal code for the Venue
- **phone\_number**           _string_    Phone number for the Venue (including country code)
- **photos**                  _hash_      A hash of image urls of the primary photo available for this object in different styles
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
        "created_at": "2000-11-09T19:09:23Z",
        "id": 1,
        "latitude": null,
        "long_description": "Description of the venue",
        "longitude": null,
        "name": "Fbolko",
        "state": "MX",
        "upcoming_events_count": 0,
        "updated_at": "2010-03-28T17:24:20Z",
        "postalcode": null,
        "photos":
          {
            "thumbnail": "http://i.tc-core.com/venue/_default/default-thumbnail.jpg",
            "medium": "http://i.tc-core.com/venue/_default/default-medium.jpg",
            "large": "http://i.tc-core.com/venue/_default/default-large.jpg",
            "mobile": "http://i.tc-core.com/venue/_default/default-mobile.jpg"
          }
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
    // Example: GET /api/v2/venue/27418?api_key=1234567890abcdef
    
    {
      "address1": "859 O'Farrell St.",
      "address2": null,
      "city": "San Francisco",
      "country": "US",
      "created_at": "2008-04-21T16:52:31Z",
      "id": 27418,
      "latitude": 37.784796,
      "long_description": "Description of the venue",
      "longitude": -122.418819,
      "name": "Great American Music Hall",
      "state": "CA",
      "upcoming_events_count": 34,
      "updated_at": "2011-01-20T21:04:37Z",
      "postalcode": "94109",
      "metro_area_id": 105,
      "photos":
          {
            "thumbnail": "http://i.tc-core.com/venue/_default/default-thumbnail.jpg",
            "medium": "http://i.tc-core.com/venue/_default/default-medium.jpg",
            "large": "http://i.tc-core.com/venue/_default/default-large.jpg",
            "mobile": "http://i.tc-core.com/venue/_default/default-mobile.jpg"
          }
      "url": "http://thrillcall.com/venue/Great_American_Music_Hall_in_San_Francisco_CA"
    }
```

### GET /venue/:id/events
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[time\_zone](#time_zone)**
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
        "created_at": "2000-11-09T19:09:23Z",
        "end_date": null,
        "festival": false,
        "id": 824614,
        "latitude": 37.8016,
        "long_description": "Description of the venue",
        "longitude": -80.4462,
        "name": "Colt Ford @ West Virginia State Fair",
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2011-08-21T03:59:00Z",
        "unconfirmed_location": 0,
        "updated_at": "2011-06-24T05:10:05Z",
        "venue_id": 32065,
        "photos":
            {
              "thumbnail": "http://i.tc-core.com/event/_default/default-thumbnail.jpg",
              "large": "http://i.tc-core.com/event/_default/default-large.jpg",
              "mobile": "http://i.tc-core.com/event/_default/default-mobile.jpg"
            },
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
    // Example: GET /api/v2/search/venues/Great%20American%20Music%20Hall?api_key=1234567890abcdef
    
    [
      {
        "address1": "859 O'Farrell St.",
        "address2": null,
        "city": "San Francisco",
        "country": "US",
        "created_at": "2008-04-21T16:52:31Z",
        "id": 27418,
        "latitude": 37.784796,
        "long_description": "Description of the venue",
        "longitude": -122.418819,
        "name": "Great American Music Hall",
        "state": "CA",
        "upcoming_events_count": 34,
        "updated_at": "2011-01-20T21:04:37Z",
        "postalcode": "94109",
        "metro_area_id": 105,
        "photos":
          {
            "thumbnail": "http://i.tc-core.com/venue/_default/default-thumbnail.jpg",
            "medium": "http://i.tc-core.com/venue/_default/default-medium.jpg",
            "large": "http://i.tc-core.com/venue/_default/default-large.jpg",
            "mobile": "http://i.tc-core.com/venue/_default/default-mobile.jpg"
          }
        "url": "http://thrillcall.com/venue/Great_American_Music_Hall_in_San_Francisco_CA"
      },
      {
        ...
      },
      ...
    ]
```

## Tickets
Fields:

- **created\_at**            _string_   ISO 8601 representation the time this object was created
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
- **[time\_zone](#time_zone)**
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
        "created_at": "2008-12-06T00:19:59Z",
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
    // Example: GET /api/v2/ticket/599794?api_key=1234567890abcdef
    
    {
      "created_at": "2011-06-14T00:09:16Z",
      "description": null,
      "event_id": 858707,
      "id": 599794,
      "marketing_text": null,
      "max_ticket_price": 21,
      "min_ticket_price": null,
      "name": "Gen. Admission Seating Limited",
      "on_sale_end_date": null,
      "on_sale_start_date": null,
      "seat_info": null,
      "updated_at": "2011-06-14T00:09:16Z",
      "url": "http://tickets.gamh.com/evinfo.php?eventid=154723&amp;r=affi&amp;u=210785"
    }
```
