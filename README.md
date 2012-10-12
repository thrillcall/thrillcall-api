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


# HTTPS Endpoints

### SSL/TLS Endpoints Required:
All API access must use the secure HTTPS endpoint : https://api.thrillcall.com:443
Access over an insecure HTTP (port 80) endpoint is now deprecated and will be disabled.

### Parameters
These are valid parameters for any endpoint, however, they will only be used by the server where applicable.

**api\_key** MUST BE SUPPLIED for every endpoint.

- <a name="api_key" />**api\_key** _string: (format: length == 16)_
    
    Your API key.  Required for access to any endpoint.
    
- <a name="ids" />**ids** _string_
  
    _Default: nil_
    
    Comma-separated list of ID integers, like "100,200,300".
    
    If provided to a list endpoint (e.g. /venues), will retrieve only the specific venue ids listed.
    
- <a name="limit" />**limit** _integer_
    
    _Default: 100_
    
    Sets the maximum number of results to return.  Cannot be above 200.
    
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
    
- <a name="min_updated_at" />**min\_updated\_at** _string (format: "YYYY-MM-DD")_
    
    _Default: none_
    
    Results with updated_at columns before this date will not be returned.
    
- <a name="max_date" />**max\_updated\_at** _string (format: "YYYY-MM-DD")_
  
    _Default: none_
    
    Results with updated_at columns after this date will not be returned.
    
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
    
    For GET requests:
        Results will be within the **[radius](#radius)** of this postal code.
        If latitude (**[lat](#lat)**) and longitude (**[long](#long)**) if both are specified, this will be ignored.
    
    For POST / PUT requests:
        Required for creating or updating a Person or Venue.
    
- <a name="radius" />**radius** _float_
    
    _Default: 100.0_
    
    Used in conjunction with **[postalcode](#postalcode)**
    
- <a name="ticket_type" />**ticket\_type** _string (format: "primary" or "resale")_
    
    _Default: both_
    
    If specified, will only return tickets from Primary or Resale merchants.
    
- <a name="must_have_tickets" />**must\_have\_tickets** _boolean_
    
    _Default: false_
    
    If set to _true_ or _1_, will only return results that have tickets associated with them.
    
- <a name="show_disabled_events" />**show\_disabled\_events** _boolean_
    
    _Default: false_
    
    If set to _true_ or _1_, will not filter out events which have been disabled internally.
    
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
    
    The email address associated with a Person, required for registration.

- <a name="password" />**password** _string (format: 40 >= length >= 5)_
    
    The Person's password.  Must be supplied along with **[email](#email)** unless using **[provider](#provider)** / **[uid](#uid)** / **[token](#token)** auth.

- <a name="provider" />**provider** _string_
    
    The name of the authentication provider (e.g. "facebook").  Must be supplied along with **[uid](#uid)** and **[token](#token)** unless using **[email](#email)**/**[password](#password)** auth.

- <a name="uid" />**uid** _string_
    
    The Person's ID with **[provider](#provider)**.  Must be supplied along with **[provider](#provider)** and **[token](#token)** unless using **[email](#email)**/**[password](#password)** auth.

- <a name="token" />**token** _string_
    
    The Person's authentication token with **[provider](#provider)**.  Must be supplied along with **[provider](#provider)** and **[uid](#uid)** unless using **[email](#email)**/**[password](#password)** auth.

- <a name="first_name" />**first\_name** _string (format: 50 >= length >= 2)_
    
    Required to register a Person.

- <a name="last_name" />**last\_name** _string (format: 50 >= length >= 2)_
    
    Optional for creating or updating a Person.

- <a name="gender" />**gender** _string (format: length == 1)_
    
    Optional for creating or updating a Person.

- <a name="address1" />**address1** _string_

    Optional for creating or updating a Person, required for Venues.

- <a name="address2" />**address2** _string_

    Optional parameter for Person or Venue.

- <a name="city" />**city** _string_

    Optional for creating or updating a Person, required for Venues.

- <a name="state" />**state** _string_

    Optional for creating or updating a Person, required for Venues.

- <a name="country" />**country** _string (format: "US" length == 2)_

    Country code, required for Venues.

- <a name="location_name" />**location\_name** _string (format: "City, ST or City, State", length > 0))_
    
    The name of the Person's location when auto-registering.  Either this or **[lat](#lat)** / **[long](#long)** must be provided.

- <a name="referral_code" />**referral\_code** _string_
    
    The referral code to be used during registration.  Both the owner of the code as well as the new Person will receive a referral credit point.

- <a name="name" />**name** _string_
    
    Name of the Artist or Venue.

- <a name="facebook_url" />**facebook\_url** _string (format: "http://facebook.com/ladygaga")_
    
    Facebook URL for the Artist or Venue.

- <a name="myspace_url" />**myspace\_url** _string (format: "http://myspace.com/ladygaga")_
    
    Myspace URL for the Artist.

- <a name="official_url" />**official\_url** _string (format: "http://www.ladygaga.com/")_
    
    Official URL for the Artist or Venue.

- <a name="wikipedia_url" />**wikipedia\_url** _string (format: "http://en.wikipedia.org/wiki/Lady_Gaga")_
    
    Wikipedia URL for the Artist.

- <a name="mappings" />**mappings** _string or array (format: ["myspace", "livenation"])_ 
    
    Foreign ID mappings for the specified partners, if available, will be provided along with the object data.
    Can be provided as a single param ("mappings=myspace") or as an array ("mappings[]=myspace&mappings[]=livenation").

- <a name="partner_id" />**partner\_id** _string_
    
    Name of the partner for foreign ID mappings, e.g. "myspace"

- <a name="partner_obj_id" />**partner\_obj\_id** _string or integer_
    
    Foreign ID for mappings, can be a string or integer.

- <a name="partner_display_name" />**partner\_display\_name** _string_
    
    Name of the object from the partner's perspective, optional.
    Use to specify a name other than the one supplied in the Thrillcall object.

- <a name="tc_obj_id" />**tc\_obj\_id** _integer_
    
    Thrillcall ID for foreign ID mappings.

- <a name="obj_type" />**obj\_type** _string_
    
    Object type for foreign ID mappings, e.g. "artist"

- <a name="sort" />**sort** _string_
    
    The name of the field you wish to sort by, e.g. "created\_at".
    
    When searching by radius, or from the Metro Area endpoint, you can also specify "distance," although this value is not directly exposed.
    
    Calls for Artists, Genres, Tickets, Venues, and all Search endpoints default to using the "name" field.
    Calls for Events default to the "starts\_at" field.
    Calls for Metro Areas default to the "city" field.
    Calls for Mappings default to the "partner\_id" field.

- <a name="order" />**order** _string: "ASC" or "DESC"_
    
    The direction you wish to sort the results.  Default: DESC for events, ASC otherwise


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
- **facebook\_url**           _string_    URL for this object on Facebook
- **myspace\_url**            _string_    Myspace URL for this object
- **official\_url**           _string_    Official external URL for this object
- **wikipedia\_url**          _string_    Wikipedia URL for this object


### GET /artists
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[primary\_genre\_id](#primary_genre_id)**
- **[mappings](#mappings)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v3/artists?mappings=ticketmaster&limit=14&api_key=1234567890abcdef
    
    [
      {
        "created_at": "2008-04-29T10:19:45Z",
        "genre_tags": "O",
        "id": 1,
        "name": "Hyler Jones Proteges",
        "primary_genre_id": 61,
        "popularity": 0.0,
        "upcoming_events_count": 0,
        "updated_at": "2010-03-26T16:49:20Z",
        "photos": {
          "thumbnail": "http://i1.tc-core.com/artist/_default/default-thumbnail.jpg",
          "medium": "http://i1.tc-core.com/artist/_default/default-medium.jpg",
          "large": "http://i1.tc-core.com/artist/_default/default-large.jpg",
          "mobile": "http://i1.tc-core.com/artist/_default/default-mobile.jpg"
        },
        "url": "http://thrillcall.com/artist/Hyler_Jones_Proteges"
      },
      {
        ...
      },
      ...
    ]
```

### POST /artist

Params:

- **[name](#name)**
- **[facebook\_url](#facebook_url)**
- **[myspace\_url](#myspace_url)**
- **[official\_url](#official_url)**
- **[wikipedia\_url](#wikipedia_url)**

Creates a new Artist record with the provided parameters.

Returns:  Artist _Hash_

``` js
    // Example: GET /api/v3/artist?name=Bleeding%20Chest%20Wounds&wikipedia_url=http%3A%2F%2Ftest.com&api_key=1234567890abcdef
    
    {
      "created_at": null,
      "facebook_url": null,
      "genre_tags": null,
      "myspace_url": null,
      "name": "Bleeding Chest Wounds",
      "official_url": null,
      "popularity": 0.0,
      "permalink": null,
      "primary_genre_id": null,
      "upcoming_events_count": 0,
      "updated_at": null,
      "wikipedia_url": "http://test.com",
      "photos": {
        "thumbnail": "http://i1.tc-core.com/artist/_default/default-thumbnail.jpg",
        "medium": "http://i1.tc-core.com/artist/_default/default-medium.jpg",
        "large": "http://i1.tc-core.com/artist/_default/default-large.jpg",
        "mobile": "http://i1.tc-core.com/artist/_default/default-mobile.jpg"
      }
    }
```

### GET /artist/:id
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[mappings](#mappings)**

Returns:  Artist _Hash_

``` js
    // Example: GET /api/v3/artist/12?mappings=livenation&api_key=1234567890abcdef
    {
      "created_at": "2008-05-08T18:33:35Z",
      "facebook_url": null,
      "genre_tags": "classic rock",
      "id": 12,
      "myspace_url": "http://www.myspace.com/southsidejohnnyandtheasburyjukes",
      "name": "Southside Johnny And The Asbury Jukes",
      "official_url": "http://www.southsidejohnny.com/",
      "primary_genre_id": 27,
      "popularity": 0.0,
      "upcoming_events_count": 9,
      "updated_at": "2012-06-18T07:49:24Z",
      "wikipedia_url": "http://en.wikipedia.org/wiki/Southside_Johnny_%26_The_Asbury_Jukes",
      "foreign_mappings": [
        {
          "created_at": "2009-08-13T04:41:27Z",
          "id": 11504,
          "obj_type": "artist",
          "partner_display_name": "Southside Johnny",
          "partner_id": "livenation",
          "partner_obj_id": "28610",
          "updated_at": "2012-07-18T00:19:25Z"
        },
        {
          "created_at": "2009-08-13T04:41:27Z",
          "id": 11505,
          "obj_type": "artist",
          "partner_display_name": "Southside Johnny & The Asbury Jukes",
          "partner_id": "livenation",
          "partner_obj_id": "6208",
          "updated_at": "2012-07-18T00:19:25Z"
        }
      ],
      "photos": {
        "thumbnail": "http://i1.tc-core.com/artist/12/2778/1324557379/southside-johnny-and-the-asbury-jukes-thumbnail.jpg?1324557379",
        "medium": "http://i1.tc-core.com/artist/12/2778/1324557379/southside-johnny-and-the-asbury-jukes-medium.jpg?1324557379",
        "large": "http://i1.tc-core.com/artist/12/2778/1324557379/southside-johnny-and-the-asbury-jukes-large.jpg?1324557379",
        "mobile": "http://i1.tc-core.com/artist/12/2778/1324557379/southside-johnny-and-the-asbury-jukes-mobile.jpg?1324557379"
      },
      "url": "http://localhost:3000/artist/Southside_Johnny_And_The_Asbury_Jukes"
    }
```

### PUT /artist/:id
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[name](#name)**
- **[facebook\_url](#facebook_url)**
- **[myspace\_url](#myspace_url)**
- **[official\_url](#official_url)**
- **[wikipedia\_url](#wikipedia_url)**
- **[mappings](#mappings)**

Updates the provided fields on Artist **:id**.

Returns:  Artist _Hash_

``` js
    // Example: PUT /api/v3/artist/12569?wikipedia_url=http%3A%2F%2Ftest.com&api_key=1234567890abcdef
    
    {
      "created_at": "2008-04-21T16:53:17Z",
      "facebook_url": null,
      "genre_tags": "acoustic;Country;Rock;rockabilly",
      "id": 12569,
      "myspace_url": "http://www.myspace.com/chrisisaak",
      "name": "Chris Isaak",
      "official_url": "http://www.chrisisaak.com/",
      "primary_genre_id": 27,
      "popularity": 0.0,
      "upcoming_events_count": 58,
      "updated_at": "2012-07-02T09:55:40Z",
      "wikipedia_url": "http://test.com",
      "photos": {
        "thumbnail": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-thumbnail.jpg?1324556547",
        "medium": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-medium.jpg?1324556547",
        "large": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-large.jpg?1324556547",
        "mobile": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-mobile.jpg?1324556547"
      },
      "url": "http://thrillcall.com/artist/Chris_Isaak"
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
- **[min\_updated\_at](#min_updated_at)**
- **[max\_updated\_at](#max_updated_at)**
- **[lat](#lat)**
- **[long](#long)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_disabled\_events](#show_disabled_events)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**
- **[mappings](#mappings)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Events _Hash_

``` js
    // Example: GET /api/v3/artist/378465/events?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2012-03-02T18:06:14Z",
        "festival": false,
        "id": 1047075,
        "latitude": 37.7915,
        "longitude": -122.413,
        "name": "Il Volo @ Masonic Center",
        "rumor": false,
        "starts_at": "2012-09-30T02:30:04Z",
        "starts_at_time_trusted": true,
        "unconfirmed_location": 0,
        "updated_at": "2012-03-29T01:35:57Z",
        "venue_id": 63279,
        "photos": {
          "thumbnail": "http://i1.tc-core.com/artist/378465/10658/1324561426/il-volo-thumbnail.jpg?1324561426",
          "large": "http://i1.tc-core.com/artist/378465/10658/1324561426/il-volo-large.jpg?1324561426",
          "mobile": "http://i1.tc-core.com/artist/378465/10658/1324561426/il-volo-mobile.jpg?1324561426"
        },
        "url": "http://thrillcall.com/event/1047075",
        "starts_at_local": "2012-09-29T19:30:04-07:00",
        "time_zone": "America/Los_Angeles",
        "event_status": "confirmed",
        "artists": [
          {
            "id": 378465,
            "name": "Il Volo",
            "headliner": false
          }
        ]
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
- **[mappings](#mappings)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v3/search/artists/Chris%20Isaak?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2008-04-21T16:53:17Z",
        "facebook_url": null,
        "genre_tags": "acoustic;Country;Rock;rockabilly",
        "id": 12569,
        "myspace_url": "http://www.myspace.com/chrisisaak",
        "name": "Chris Isaak",
        "official_url": "http://www.chrisisaak.com/",
        "primary_genre_id": 27,
        "popularity": 0.0,
        "upcoming_events_count": 58,
        "updated_at": "2012-07-02T09:55:40Z",
        "wikipedia_url": "http://en.wikipedia.org/wiki/Chris_Isaak",
        "photos": {
          "thumbnail": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-thumbnail.jpg?1324556547",
          "medium": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-medium.jpg?1324556547",
          "large": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-large.jpg?1324556547",
          "mobile": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-mobile.jpg?1324556547"
        },
        "url": "http://thrillcall.com/artist/Chris_Isaak"
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
- **festival**                    _boolean_ Is this event a festival?
- **id**                          _integer_ Thrillcall ID
- **latitude**                    _float_   Approximate latitude for the Event
- **longitude**                   _float_   Approximate longitude for the Event
- **name**                        _string_  Name of the Event
- **on\_sale\_date**              _string_  ISO 8601 representation of the date when tickets go on sale
- **rumor**                       _boolean_ Are the details for this event based on a rumor?
- **event\_status**               _string_  Status of the event (confirmed, unconfirmed, cancelled, or disabled)
- **starts\_at**                  _string_  ISO 8601 representation of the start of the Event in UTC time
- **starts\_at\_local**           _string_  ISO 8601 representation of the start of the Event in the local timezone
- **starts\_at\_time\_trusted**   _boolean_ Do we trust that the time of day component of **starts\_at** is valid?
- **time\_zone**                  _string_  TZ Database string representing the time zone at the location of the event
- **unconfirmed\_location**       _integer_ If 1, the location of this event is unconfirmed
- **updated\_at**                 _string_  ISO 8601 representation of last time this object was updated
- **venue\_id**                   _integer_ Thrillcall Venue ID
- **photos**                      _hash_    A hash of image urls of the primary photo available for this object in different styles
- **artists**                     _array_   An array of hashes, each representing an artist at this event.
- **id**                          _integer_ Thrillcall ID for the artist
- **name**                        _string_  Artist name
- **headliner**                   _boolean_ Is this artist a headliner on the bill?
- **url**                         _string_  URL for this object on Thrillcall


### GET /events
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[time\_zone](#time_zone)**
- **[min\_date](#min_date)**
- **[max\_date](#max_date)**
- **[min\_updated\_at](#min_updated_at)**
- **[max\_updated\_at](#max_updated_at)**
- **[lat](#lat)**
- **[long](#long)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_disabled\_events](#show_disabled_events)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Events _Hash_

``` js
    // Example: GET /api/v3/events?must_have_tickets=true&postalcode=94108&radius=10&limit=3&api_key=1234567890abcdef
    
    [
      {
        "created_at": "2012-03-02T18:06:14Z",
        "festival": false,
        "id": 1047075,
        "latitude": 37.7915,
        "longitude": -122.413,
        "name": "Il Volo @ Masonic Center",
        "rumor": false,
        "starts_at": "2012-09-30T02:30:04Z",
        "starts_at_time_trusted": true,
        "unconfirmed_location": 0,
        "updated_at": "2012-03-29T01:35:57Z",
        "venue_id": 63279,
        "photos": {
          "thumbnail": "http://i1.tc-core.com/artist/378465/10658/1324561426/il-volo-thumbnail.jpg?1324561426",
          "large": "http://i1.tc-core.com/artist/378465/10658/1324561426/il-volo-large.jpg?1324561426",
          "mobile": "http://i1.tc-core.com/artist/378465/10658/1324561426/il-volo-mobile.jpg?1324561426"
        },
        "url": "http://thrillcall.com/event/1047075",
        "starts_at_local": "2012-09-29T19:30:04-07:00",
        "time_zone": "America/Los_Angeles",
        "event_status": "confirmed",
        "artists": [
          {
            "id": 378465,
            "name": "Il Volo",
            "headliner": false
          }
        ]
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
    // Example: GET /api/v3/event/1113134/venue?api_key=1234567890abcdef
    
    {
      "address1": "1111 California Street",
      "address2": null,
      "city": "San Francisco",
      "country": "US",
      "created_at": "2009-08-25T19:25:27Z",
      "facebook_url": "http://www.facebook.com/pages/Nob-Hill-Masonic-Center/152483968103491",
      "hide_resale_tickets": false,
      "id": 63279,
      "latitude": 37.79153,
      "long_description": null,
      "longitude": -122.412757,
      "myspace_url": "http://www.myspace.com/masonicauditorium",
      "name": "Masonic Center",
      "official_url": "http://www.masonicauditorium.com/",
      "phone_number": "+1 (877) 598-8497",
      "state": "CA",
      "time_zone": "America/Los_Angeles",
      "upcoming_events_count": 10,
      "updated_at": "2012-07-03T09:41:24Z",
      "postalcode": "94108",
      "photos": {
        "thumbnail": "http://i1.tc-core.com/venue/63279/87/1326419135/masonic-center-in-san-francisco-ca-thumbnail.jpg?1326419135",
        "medium": "http://i1.tc-core.com/venue/63279/87/1326419135/masonic-center-in-san-francisco-ca-medium.jpg?1326419135",
        "large": "http://i1.tc-core.com/venue/63279/87/1326419135/masonic-center-in-san-francisco-ca-large.jpg?1326419135",
        "mobile": "http://i1.tc-core.com/venue/63279/87/1326419135/masonic-center-in-san-francisco-ca-mobile.jpg?1326419135"
      },
      "metro_area_id": 105,
      "url": "http://thrillcall.com/venue/Masonic_Center_in_San_Francisco_CA"
    }
```

### GET /event/:id/artists
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[mappings](#mappings)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v3/event/1113134/artists?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2008-04-21T16:53:17Z",
        "facebook_url": null,
        "genre_tags": "acoustic;Country;Rock;rockabilly",
        "id": 12569,
        "myspace_url": "http://www.myspace.com/chrisisaak",
        "name": "Chris Isaak",
        "official_url": "http://www.chrisisaak.com/",
        "primary_genre_id": 27,
        "popularity": 0.0,
        "upcoming_events_count": 58,
        "updated_at": "2012-07-02T09:55:40Z",
        "wikipedia_url": "http://en.wikipedia.org/wiki/Chris_Isaak",
        "photos": {
          "thumbnail": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-thumbnail.jpg?1324556547",
          "medium": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-medium.jpg?1324556547",
          "large": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-large.jpg?1324556547",
          "mobile": "http://i1.tc-core.com/artist/12569/657/1324556547/chris-isaak-mobile.jpg?1324556547"
        },
        "url": "http://thrillcall.com/artist/Chris_Isaak"
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

- **[mappings](#mappings)**

Returns:  Venue _Hash_

``` js
    // Example: GET /api/v3/event/1113134/venue?api_key=1234567890abcdef
    
    {
      "address1": "1111 California Street",
      "address2": null,
      "city": "San Francisco",
      "country": "US",
      "created_at": "2009-08-25T19:25:27Z",
      "facebook_url": "http://www.facebook.com/pages/Nob-Hill-Masonic-Center/152483968103491",
      "hide_resale_tickets": false,
      "id": 63279,
      "latitude": 37.79153,
      "long_description": null,
      "longitude": -122.412757,
      "myspace_url": "http://www.myspace.com/masonicauditorium",
      "name": "Masonic Center",
      "official_url": "http://www.masonicauditorium.com/",
      "phone_number": "+1 (877) 598-8497",
      "state": "CA",
      "time_zone": "America/Los_Angeles",
      "upcoming_events_count": 10,
      "updated_at": "2012-07-03T09:41:24Z",
      "postalcode": "94108",
      "photos": {
        "thumbnail": "http://i1.tc-core.com/venue/63279/87/1326419135/masonic-center-in-san-francisco-ca-thumbnail.jpg?1326419135",
        "medium": "http://i1.tc-core.com/venue/63279/87/1326419135/masonic-center-in-san-francisco-ca-medium.jpg?1326419135",
        "large": "http://i1.tc-core.com/venue/63279/87/1326419135/masonic-center-in-san-francisco-ca-large.jpg?1326419135",
        "mobile": "http://i1.tc-core.com/venue/63279/87/1326419135/masonic-center-in-san-francisco-ca-mobile.jpg?1326419135"
      },
      "metro_area_id": 105,
      "url": "http://thrillcall.com/venue/Masonic_Center_in_San_Francisco_CA"
    }
```

### GET /event/:id/tickets
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[ticket\_type](#ticket_type)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Tickets _Hash_

``` js
    // Example: GET /api/v3/event/1047075/tickets?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2012-03-02T18:06:14Z",
        "description": null,
        "event_id": 1047075,
        "id": 819883,
        "marketing_text": null,
        "max_ticket_price": 85,
        "min_ticket_price": 29,
        "name": "Onsale to General Public",
        "on_sale_end_date": null,
        "on_sale_start_date": null,
        "seat_info": null,
        "updated_at": "2012-03-02T18:06:14Z",
        "url": "http://ticketsus.at/thrillcall?CTY=39&DURL=http://www.ticketmaster.com/event/1C00486178A1251A?camefrom=CFC_BUYAT&brand=[=BRAND=]"
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
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Genres _Hash_

``` js
    // Example: GET /api/v3/genres?limit=14&api_key=1234567890abcdef
    
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
    // Example: GET /api/v3/genre/27?api_key=1234567890abcdef
    
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
- **[mappings](#mappings)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v3/genre/27/artists?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2008-04-29T10:06:05Z",
        "facebook_url": null,
        "genre_tags": "Folk;Other;psychedelic",
        "id": 2,
        "myspace_url": "http://www.myspace.com/espers",
        "name": "Espers",
        "official_url": "http://www.espers.org",
        "primary_genre_id": 27,
        "popularity": 0.0,
        "upcoming_events_count": 1,
        "updated_at": "2012-05-31T09:16:49Z",
        "wikipedia_url": "http://en.wikipedia.org/wiki/index.html?curid=4735724",
        "photos": {
          "thumbnail": "http://i1.tc-core.com/artist/2/15306/1328344246/espers-thumbnail.jpg?1328344246",
          "medium": "http://i1.tc-core.com/artist/2/15306/1328344246/espers-medium.jpg?1328344246",
          "large": "http://i1.tc-core.com/artist/2/15306/1328344246/espers-large.jpg?1328344246",
          "mobile": "http://i1.tc-core.com/artist/2/15306/1328344246/espers-mobile.jpg?1328344246"
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
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Metro Areas _Hash_

``` js
    // Example: GET /api/v3/metro_areas?limit=14&api_key=1234567890abcdef
    
    [
      {
        "city": "Chicago",
        "country": "US",
        "created_at": "2011-06-24T03:23:57Z",
        "id": 104,
        "latitude": 41.8842,
        "longitude": -87.6324,
        "offers_availability_status_code": 1,
        "radius": 50,
        "state": "IL",
        "time_zone": "America/Chicago",
        "updated_at": "2011-12-27T00:44:37Z",
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
    // Example: GET /api/v3/metro_area/105?api_key=1234567890abcdef
    
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
      "time_zone": "America/Los_Angeles",
      "updated_at": "2011-12-27T00:44:37Z",
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
- **[min\_updated\_at](#min_updated_at)**
- **[max\_updated\_at](#max_updated_at)**
- **[radius](#radius)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_disabled\_events](#show_disabled_events)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**
- **[mappings](#mappings)**
- **[sort](#sort)**
- **[order](#order)**

Note:  Time Zone is set as the time zone of the Metro Area and cannot be overridden.

Returns:  _Array_ of Metro Areas _Hash_

``` js
    // Example: GET /api/v3/metro_area/105/events?min_date=2011-06-20&max_date=2012-06-19&limit=3&api_key=1234567890abcdef
    
    [
      {
        "created_at": "2012-01-02T08:53:00Z",
        "festival": false,
        "id": 1011386,
        "latitude": 37.7771,
        "longitude": -122.42,
        "name": "Kontrol @ The End Up",
        "rumor": false,
        "starts_at": "2012-01-07T08:00:04Z",
        "starts_at_time_trusted": false,
        "unconfirmed_location": 0,
        "updated_at": "2012-03-29T01:19:31Z",
        "venue_id": 47273,
        "photos": {
          "thumbnail": "http://i1.tc-core.com/venue/47273/107/1326489566/the-end-up-in-san-francisco-ca-thumbnail.jpg?1326489566",
          "large": "http://i1.tc-core.com/venue/47273/107/1326489566/the-end-up-in-san-francisco-ca-large.jpg?1326489566",
          "mobile": "http://i1.tc-core.com/venue/47273/107/1326489566/the-end-up-in-san-francisco-ca-mobile.jpg?1326489566"
        },
        "url": "http://thrillcall.com/event/1011386",
        "starts_at_local": "2012-01-07T00:00:04-08:00",
        "time_zone": "America/Los_Angeles",
        "event_status": "confirmed",
        "artists": [
          {
            "id": 2295,
            "name": "Kontrol",
            "headliner": false
          }
        ]
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
- **referral\_credits**       _integer_   Number of Referral credits the Person has (including bonus points)
- **postalcode**              _string_    Postalcode of the Person
- **photos**                  _hash_      A hash of image urls of the primary photo available for this object in different styles

### GET /person/:id
Params:

- None

Returns: Person _Hash_

``` js
    // Example: GET /api/v3/person/49?api_key=1234567890abcdef
    
    {
      "address1": null,
      "address2": null,
      "city": "Santa Rosa",
      "country_code": "US",
      "created_at": "2011-10-17T18:54:31Z",
      "first_name": "John",
      "gender": "m",
      "id": 49,
      "last_name": "Doe",
      "login": "bogus@bogus.com",
      "state": "CA",
      "time_zone": "America/Los_Angeles",
      "timezone": "-7",
      "updated_at": "2012-03-28T16:07:16Z",
      "referral_code": null,
      "referral_credits": 0,
      "postalcode": "95407",
      "photos": {
        "small_thumb": "http://i1.tc-core.com/person/164761/1324568419/19154-small_thumb.jpg?1324568419",
        "thumbnail": "http://i1.tc-core.com/person/164761/1324568419/19154-thumbnail.jpg?1324568419",
        "medium": "http://i1.tc-core.com/person/164761/1324568419/19154-medium.jpg?1324568419"
      }
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
    // Example: POST /api/v3/person/signin?provider=facebook&uid=123123bogus&token=123123bogus&email=123123bogus%40bogus.com&first_name=Mister&last_name=Bogus&lat=38.5&long=-123.0&api_key=1234567890abcdef
    
    {
      "address1": null,
      "address2": null,
      "city": null,
      "country_code": null,
      "created_at": null,
      "first_name": "Mister",
      "gender": null,
      "last_name": "Bogus",
      "login": null,
      "state": null,
      "time_zone": null,
      "timezone": null,
      "updated_at": null,
      "referral_code": null,
      "referral_credits": 0,
      "postalcode": null,
      "photos": {
        "small_thumb": "http://i1.tc-core.com/person/_default/default-small_thumb.jpg",
        "thumbnail": "http://i1.tc-core.com/person/_default/default-thumbnail.jpg",
        "medium": "http://i1.tc-core.com/person/_default/default-medium.jpg"
      }
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
    // Example: POST /api/v3/person/signup?first_name=Mister&email=bogus%40bogus.com&password=bogus&postalcode=94108&api_key=1234567890abcdef
    
    {
      "address1": null,
      "address2": null,
      "city": null,
      "country_code": null,
      "created_at": null,
      "first_name": "Mister",
      "gender": null,
      "last_name": null,
      "login": null,
      "state": null,
      "time_zone": null,
      "timezone": null,
      "updated_at": null,
      "referral_code": null,
      "referral_credits": 0,
      "postalcode": null,
      "photos": {
        "small_thumb": "http://i1.tc-core.com/person/_default/default-small_thumb.jpg",
        "thumbnail": "http://i1.tc-core.com/person/_default/default-thumbnail.jpg",
        "medium": "http://i1.tc-core.com/person/_default/default-medium.jpg"
      }
    }
```

### PUT /person/:id
Params:

- **[email](#email)**
- **[first\_name](#first_name)**
- **[last\_name](#last_name)**
- **[address1](#address1)**
- **[address2](#address2)**
- **[city](#city)**
- **[state](#state)**
- **[postalcode](#postalcode)**
- **[gender](#gender)**

Returns: Person _Hash_

``` js
    // Example: PUT /api/v3/person/49?&first_name=John&api_key=1234567890abcdef
    
    {
      "address1": null,
      "address2": null,
      "city": "Santa Rosa",
      "country_code": "US",
      "created_at": "2011-10-17T18:54:31Z",
      "first_name": "John",
      "gender": "m",
      "id": 49,
      "last_name": "Doe",
      "login": "bogus@bogus.com",
      "state": "CA",
      "time_zone": "America/Los_Angeles",
      "timezone": "-7",
      "updated_at": "2012-03-28T16:07:16Z",
      "referral_code": null,
      "referral_credits": 0,
      "postalcode": "95407",
      "photos": {
        "small_thumb": "http://i1.tc-core.com/person/164761/1324568419/19154-small_thumb.jpg?1324568419",
        "thumbnail": "http://i1.tc-core.com/person/164761/1324568419/19154-thumbnail.jpg?1324568419",
        "medium": "http://i1.tc-core.com/person/164761/1324568419/19154-medium.jpg?1324568419"
      }
    }
```

### GET /people/tracking/:class
**:class** _string_  One of: "genres", "events", "artists", "people", "venues"

Params:

- **[ids](#ids)** _Required_

Returns: _Array_ of _Hash_ containing id, name, and count for each tracked **:class** ordered by count descending.

``` js
    // Example: GET /api/v3/people/tracking/artist?ids=2,4,321&api_key=1234567890abcdef
    
    [
      {
        "name": "M83",
        "count": 3,
        "id": 18927
      },
      {
        "name": "Radiohead",
        "count": 2,
        "id": 2687
      },
      ...
    ]
```


### GET /person/:id/:class
**:class** _string_  One of: "genres", "events", "artists", "people", "venues"

Params:

- None.

Returns: _Hash_ of tracked **:class** IDs mapped to **:class** names for this person.

``` js
    // Example: GET /api/v3/person/2/artists?&api_key=1234567890abcdef
    
    {
      2687: "Radiohead",
      18927: "M83",
      ...
    }
```

### GET /tracks/:id

Params:

- **[obj\_type](#obj_type)**

Returns: Person _Hash_

``` js
    // Example: GET /api/v3/person/tracks/24?&api_key=1234567890abcdef

  {
    "after_track_notification": false,
    "created_at": "2012-10-08T23:32:51Z",
    "display_index": 99999,
    "id": 1212870,
    "obj_id": 44,
    "obj_type": "venue",
    "person_id": 24,
    "platform": "ios",
    "relation_type_id": 21,
    "updated_at": "2012-10-08T23:33:32Z"
  }
```

### POST /person/:id/:action/:obj_type
Params:

- **[obj\_id](#obj_id)**
- **[obj\_type](#obj_type)**
- **[platform](#platform)**

Returns: Person _Hash_

``` js
    // Example: POST /api/v3/person/24/track/artist?obj_id=44&platform=ios&api_key=1234567890abcdef

  {
    "after_track_notification": false,
    "created_at": "2012-10-08T23:32:51Z",
    "display_index": 99999,
    "id": 1212870,
    "obj_id": 44,
    "obj_type": "venue",
    "person_id": 24,
    "platform": "ios",
    "relation_type_id": 21,
    "updated_at": "2012-10-08T23:33:32Z"
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

- **[ids](#ids)**
- **[limit](#limit)**
- **[page](#page)**
- **[lat](#lat)**
- **[long](#long)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[mappings](#mappings)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Venues _Hash_

``` js
    // Example: GET /api/v3/venues?limit=14&api_key=1234567890abcdef
    
    [
      {
        "address1": null,
        "address2": null,
        "city": "Guadalajara",
        "country": "MX",
        "created_at": "2008-05-09T09:29:23Z",
        "facebook_url": null,
        "hide_resale_tickets": false,
        "id": 1,
        "latitude": 20.666222,
        "long_description": null,
        "longitude": -103.352089,
        "myspace_url": null,
        "name": "Fbolko",
        "official_url": null,
        "phone_number": null,
        "state": null,
        "time_zone": "America/Mexico_City",
        "upcoming_events_count": 0,
        "updated_at": "2012-04-20T19:08:53Z",
        "postalcode": "0",
        "photos": {
          "thumbnail": "http://i1.tc-core.com/venue/_default/default-thumbnail.jpg",
          "medium": "http://i1.tc-core.com/venue/_default/default-medium.jpg",
          "large": "http://i1.tc-core.com/venue/_default/default-large.jpg",
          "mobile": "http://i1.tc-core.com/venue/_default/default-mobile.jpg"
        },
        "metro_area_id": null,
        "url": "http://thrillcall.com/venue/Fbolko_in_Guadalajara"
      },
      {
        ...
      },
      ...
    ]
```

### POST /venue
Params:

- **[name](#name)**
- **[address1](#address1)**
- **[address2](#address2)**
- **[city](#city)**
- **[state](#state)**
- **[postalcode](#postalcode)**
- **[country](#country)**
- **[facebook_url](#facebook_url)**
- **[official_url](#official_url)**

Returns:  Venue _Hash_

``` js
    // Example: POST /api/v3/venue?name=Test%20Venue&city=Guerneville&state=CA&country=US&address1=123%20Main%20St&postalcode=95446&api_key=1234567890abcdef
    
    {
      "address1": "123 Main St",
      "address2": null,
      "city": "Guerneville",
      "country": "US",
      "created_at": "2012-08-14T00:15:23Z",
      "facebook_url": null,
      "hide_resale_tickets": false,
      "id": 108951,
      "latitude": 38.50223159790039,
      "long_description": null,
      "longitude": -122.99627685546875,
      "myspace_url": null,
      "name": "Test Venue",
      "official_url": null,
      "phone_number": null,
      "state": "CA",
      "time_zone": "America/Los_Angeles",
      "upcoming_events_count": 0,
      "updated_at": "2012-08-14T00:15:23Z",
      "postalcode": "95446",
      "photos": {
        "thumbnail": "http://i1.tc-core.com/venue/_default/default-thumbnail.jpg",
        "medium": "http://i1.tc-core.com/venue/_default/default-medium.jpg",
        "large": "http://i1.tc-core.com/venue/_default/default-large.jpg",
        "mobile": "http://i1.tc-core.com/venue/_default/default-mobile.jpg"
      },
      "metro_area_id": null,
      "url": "http://thrillcall.com/venue/Test_Venue_in_Guerneville_CA"
    }
```

### GET /venue/:id
**:id** _integer_  Thrillcall or Partner ID

Params:

- None

Returns:  Venue _Hash_

``` js
    // Example: GET /api/v3/venue/51886?api_key=1234567890abcdef
    
    {
      "address1": "201 Van Ness Avenue",
      "address2": null,
      "city": "San Francisco",
      "country": "US",
      "created_at": "2008-04-28T17:59:32Z",
      "facebook_url": "http://www.facebook.com/sfsymphony",
      "hide_resale_tickets": false,
      "id": 51886,
      "latitude": 37.777402,
      "long_description": null,
      "longitude": -122.419815,
      "myspace_url": null,
      "name": "Davies Symphony Hall",
      "official_url": "http://www.sfsymphony.org/",
      "phone_number": "+1 (415) 864-6000",
      "state": "CA",
      "time_zone": "America/Los_Angeles",
      "upcoming_events_count": 17,
      "updated_at": "2012-07-03T09:37:30Z",
      "postalcode": "94102",
      "photos": {
        "thumbnail": "http://i1.tc-core.com/venue/51886/74/1326417154/davies-symphony-hall-in-san-francisco-ca-thumbnail.jpg?1326417154",
        "medium": "http://i1.tc-core.com/venue/51886/74/1326417154/davies-symphony-hall-in-san-francisco-ca-medium.jpg?1326417154",
        "large": "http://i1.tc-core.com/venue/51886/74/1326417154/davies-symphony-hall-in-san-francisco-ca-large.jpg?1326417154",
        "mobile": "http://i1.tc-core.com/venue/51886/74/1326417154/davies-symphony-hall-in-san-francisco-ca-mobile.jpg?1326417154"
      },
      "metro_area_id": 105,
      "url": "http://thrillcall.com/venue/Davies_Symphony_Hall_in_San_Francisco_CA"
    }
```

### PUT /venue/:id
Params:

- **[name](#name)**
- **[address1](#address1)**
- **[address2](#address2)**
- **[city](#city)**
- **[state](#state)**
- **[postalcode](#postalcode)**
- **[country](#country)**
- **[facebook_url](#facebook_url)**
- **[official_url](#official_url)**

Returns:  Venue _Hash_

``` js
    // Example: PUT /api/v3/venue/51886?address1=202%20Van%20Ness%20Avenue&api_key=1234567890abcdef
    
    {
      "address1": "202 Van Ness Avenue",
      "address2": null,
      "city": "San Francisco",
      "country": "US",
      "created_at": "2008-04-28T17:59:32Z",
      "facebook_url": "http://www.facebook.com/sfsymphony",
      "hide_resale_tickets": false,
      "id": 51886,
      "latitude": 37.777402,
      "long_description": null,
      "longitude": -122.419815,
      "myspace_url": null,
      "name": "Davies Symphony Hall",
      "official_url": "http://www.sfsymphony.org/",
      "phone_number": "+1 (415) 864-6000",
      "state": "CA",
      "time_zone": "America/Los_Angeles",
      "upcoming_events_count": 17,
      "updated_at": "2012-07-03T09:37:30Z",
      "postalcode": "94102",
      "photos": {
        "thumbnail": "http://i1.tc-core.com/venue/51886/74/1326417154/davies-symphony-hall-in-san-francisco-ca-thumbnail.jpg?1326417154",
        "medium": "http://i1.tc-core.com/venue/51886/74/1326417154/davies-symphony-hall-in-san-francisco-ca-medium.jpg?1326417154",
        "large": "http://i1.tc-core.com/venue/51886/74/1326417154/davies-symphony-hall-in-san-francisco-ca-large.jpg?1326417154",
        "mobile": "http://i1.tc-core.com/venue/51886/74/1326417154/davies-symphony-hall-in-san-francisco-ca-mobile.jpg?1326417154"
      },
      "metro_area_id": 105,
      "url": "http://thrillcall.com/venue/Davies_Symphony_Hall_in_San_Francisco_CA"
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
- **[min\_updated\_at](#min_updated_at)**
- **[max\_updated\_at](#max_updated_at)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_disabled\_events](#show_disabled_events)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Events _Hash_

``` js
    // Example: GET /api/v3/venue/63279/events?api_key=1234567890abcdef
    
    [
      {
        "created_at": "2012-03-02T18:06:14Z",
        "festival": false,
        "id": 1047075,
        "latitude": 37.7915,
        "longitude": -122.413,
        "name": "Il Volo @ Masonic Center",
        "rumor": false,
        "starts_at": "2012-09-30T02:30:04Z",
        "starts_at_time_trusted": true,
        "unconfirmed_location": 0,
        "updated_at": "2012-03-29T01:35:57Z",
        "venue_id": 63279,
        "photos": {
          "thumbnail": "http://i1.tc-core.com/artist/378465/10658/1324561426/il-volo-thumbnail.jpg?1324561426",
          "large": "http://i1.tc-core.com/artist/378465/10658/1324561426/il-volo-large.jpg?1324561426",
          "mobile": "http://i1.tc-core.com/artist/378465/10658/1324561426/il-volo-mobile.jpg?1324561426"
        },
        "url": "http://thrillcall.com/event/1047075",
        "starts_at_local": "2012-09-29T19:30:04-07:00",
        "time_zone": "America/Los_Angeles",
        "event_status": "confirmed",
        "artists": [
          {
            "id": 378465,
            "name": "Il Volo",
            "headliner": false
          }
        ]
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
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Venues _Hash_

``` js
    // Example: GET /api/v3/search/venues/Masonic%20Center?api_key=1234567890abcdef
    
    [
      {
        "address1": "525 W Riverview Ave",
        "address2": null,
        "city": "Dayton",
        "country": "US",
        "created_at": "2008-06-12T14:12:53Z",
        "facebook_url": null,
        "hide_resale_tickets": false,
        "id": 33642,
        "latitude": 39.765526,
        "long_description": null,
        "longitude": -84.203133,
        "myspace_url": null,
        "name": "Dayton Masonic Center",
        "official_url": null,
        "phone_number": null,
        "state": "OH",
        "time_zone": "America/New_York",
        "upcoming_events_count": 0,
        "updated_at": "2012-06-06T03:05:53Z",
        "postalcode": "45405",
        "photos": {
          "thumbnail": "http://i1.tc-core.com/venue/_default/default-thumbnail.jpg",
          "medium": "http://i1.tc-core.com/venue/_default/default-medium.jpg",
          "large": "http://i1.tc-core.com/venue/_default/default-large.jpg",
          "mobile": "http://i1.tc-core.com/venue/_default/default-mobile.jpg"
        },
        "metro_area_id": 134,
        "url": "http://thrillcall.com/venue/Dayton_Masonic_Center_in_Dayton_OH"
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
- **[min\_updated\_at](#min_updated_at)**
- **[max\_updated\_at](#max_updated_at)**
- **[lat](#lat)**
- **[long](#long)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[ticket\_type](#ticket_type)**
- **[show\_disabled\_events](#show_disabled_events)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**
- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Tickets _Hash_

``` js
    // Example: GET /api/v3/tickets?limit=14&api_key=1234567890abcdef
    
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
    // Example: GET /api/v3/ticket/819883?api_key=1234567890abcdef
    
    {
      "created_at": "2012-03-02T18:06:14Z",
      "description": null,
      "event_id": 1047075,
      "id": 819883,
      "marketing_text": null,
      "max_ticket_price": 85,
      "min_ticket_price": 29,
      "name": "Onsale to General Public",
      "on_sale_end_date": null,
      "on_sale_start_date": null,
      "seat_info": null,
      "updated_at": "2012-03-02T18:06:14Z",
      "url": "http://ticketsus.at/thrillcall?CTY=39&DURL=http://www.ticketmaster.com/event/1C00486178A1251A?camefrom=CFC_BUYAT&brand=[=BRAND=]"
    }
```

## Mappings
Fields:

- **created\_at**            _string_   ISO 8601 representation the time this object was created
- **id**                     _integer_  Thrillcall ID of the mapping, not the referenced object
- **obj\_type**              _integer_  Type of the referenced object, e.g. "artist"
- **partner\_display\_name** _string_   The name of the object according to the partner, if different
- **partner\_id**            _string_   The name of the partner for this foreign mapping, e.g. "myspace"
- **partner\_obj\_id**       _string_   Partner's ID for the referenced object
- **tc_obj_id**              _integer_  Thrillcall ID of the referenced object
- **updated\_at**            _string_   ISO 8601 representation of last time this object was updated

### GET /mappings

Params:

- **[sort](#sort)**
- **[order](#order)**

Returns:  _Array_ of Mappings _Hash_

``` js
  // Example: GET /mappings?api_key=1234567890abcdef
  
  [
    {
      "created_at": "2009-08-13T01:51:23Z",
      "id": 1,
      "obj_type": "artist",
      "partner_display_name": "3",
      "partner_id": "livenation",
      "partner_obj_id": "448380",
      "tc_obj_id": 17498,
      "updated_at": "2012-07-18T00:10:15Z"
    },
    {
      ...
    },
    ...
  ]
```

### GET /mapping/:id
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Mapping _Hash_

``` js
  // Example: GET /mapping/1?api_key=1234567890abcdef
  
  {
    "created_at": "2009-08-13T01:51:23Z",
    "id": 1,
    "obj_type": "artist",
    "partner_display_name": "3",
    "partner_id": "livenation",
    "partner_obj_id": "448380",
    "tc_obj_id": 17498,
    "updated_at": "2012-07-18T00:10:15Z"
  }
```


### POST /mapping

Create a new foreign ID mapping

Params:

- **[obj\_type](#obj_type)**                              _integer_  Type of the referenced object, e.g. "artist"
- **[partner\_display\_name](#partner_display_name])**    _string_   The name of the object according to the partner, if different
- **[partner\_id](#partner_id)**                          _string_   The name of the partner for this foreign mapping, e.g. "myspace"
- **[partner\_obj\_id](#partner_obj_id)**                 _string_   Partner's ID for the referenced object
- **[tc\_obj\_id](#tc_obj_id)**                           _integer_  Thrillcall ID of the referenced object

Returns:  Mapping _Hash_

``` js
  // Example: POST /mapping?obj_type=artist&partner_id=myspace&partner_obj_id=1&tc_obj_id=2000&api_key=1234567890abcdef
  
  {
    "created_at": "2009-08-13T01:51:23Z",
    "id": 39821,
    "obj_type": "artist",
    "partner_display_name": null,
    "partner_id": "myspace",
    "partner_obj_id": "1",
    "tc_obj_id": 2000,
    "updated_at": "2012-07-18T00:10:15Z"
  }
```

### PUT /mapping/:id
**:id** _integer_  Thrillcall ID

Edit an existing foreign ID mapping.

Params:

- **[obj\_type](#obj_type)**                              _integer_  Type of the referenced object, e.g. "artist"
- **[partner\_display\_name](#partner_display_name])**    _string_   The name of the object according to the partner, if different
- **[partner\_id](#partner_id)**                          _string_   The name of the partner for this foreign mapping, e.g. "myspace"
- **[partner\_obj\_id](#partner_obj_id)**                 _string_   Partner's ID for the referenced object
- **[tc\_obj\_id](#tc_obj_id)**                           _integer_  Thrillcall ID of the referenced object

Returns:  Mapping _Hash_

``` js
  // Example: PUT /mapping/1?partner_obj_id=1000&api_key=1234567890abcdef
  
  {
    "created_at": "2009-08-13T01:51:23Z",
    "id": 39821,
    "obj_type": "artist",
    "partner_display_name": null,
    "partner_id": "myspace",
    "partner_obj_id": "1000",
    "tc_obj_id": 2000,
    "updated_at": "2012-07-18T00:10:15Z"
  }
```
