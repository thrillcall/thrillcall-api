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
    
- <a name="postalcode" />**postalcode** _string (format: length >= 5)_
    
    _Default: none_
    
    Results will be within the **[radius](#radius)** of this postal code.
    
- <a name="radius" />**radius** _float_
    
    _Default: 100.0_
    
    Used in conjunction with **[postalcode](#postalcode)**
    
- <a name="suppress" />**suppress** _boolean_
    
    _Default: false_
    
    If set to _true_ or _1_, will not return any results suppressed by your partner definition.
    
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
    // Example: GET /api/v2/artist/22210?api_key=1234567890abcdef
    
    {
      "genre_tags": "Pop",
      "id": 22210,
      "name": "Lady GaGa",
      "upcoming_events_count": 41,
      "updated_at": "2011-01-13T02:02:25Z",
      "url": "http://thrillcall.com/artist/Lady_GaGa"
    }
```

### GET /artist/:id/events
**:id** _integer_  Thrillcall or Partner ID

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min\_date](#min_date)**
- **[max\_date](#max_date)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[suppress](#suppress)**
- **[use\_partner\_id](#use_partner_id)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**

Returns:  _Array_ of Events _Hash_

``` js
    // Example: GET /api/v2/artist/22210/events?api_key=1234567890abcdef
    
    [
      {
        "end_date": null,
        "festival": false,
        "id": 589331,
        "latitude": null,
        "longitude": null,
        "name": "Lady GaGa @ Pepsi Center",
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2011-07-28T00:00:00Z",
        "unconfirmed_location": 0,
        "updated_at": "2011-01-13T02:02:59Z",
        "utc_time": "2011-07-29T05:59:00Z",
        "venue_id": 45479,
        "url": "http://thrillcall.com/event/589331"
      }
    ]
```

### GET /search/artists/:term
**:term** _string_  Arbitrary search string

Params:

- **[limit](#limit)**
- **[page](#page)**
- **[suppress](#suppress)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v2/search/artists/ladygaga?api_key=1234567890abcdef
    
    [
      {
        "genre_tags": "Pop",
        "id": 22210,
        "name": "Lady GaGa",
        "upcoming_events_count": 41,
        "updated_at": "2011-01-13T02:02:25Z",
        "url": "http://thrillcall.com/artist/Lady_GaGa"
      }
    ]
```

## Events
Fields:

- **end_date**                _string_  ISO 8601 representation of the end of the Event
- **festival**                _boolean_ Is this event a festival?
- **id**                      _integer_ Thrillcall ID
- **latitude**                _float_   Approximate latitude for the Event
- **longitude**               _float_   Approximate longitude for the Event
- **name**                    _string_  Name of the Event
- **on\_sale\_date**          _string_  ISO 8601 representation of the date when tickets go on sale
- **rumor**                   _boolean_ Are the details for this event based on a rumor?
- **start\_date**             _string_  ISO 8601 representation of the start of the Event
- **unconfirmed\_location**   _integer_ If 1, the location if this event is unconfirmed
- **updated\_at**             _string_  ISO 8601 representation of last time this object was updated
- **utc\_time**               _string_  ISO 8601 representation of the start of the Event with local offset
- **venue\_id**               _integer_ Thrillcall Venue ID
- **url**                     _string_  URL for this object on Thrillcall


### GET /events
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min\_date](#min_date)**
- **[max\_date](#max_date)**
- **[postalcode](#postalcode)**
- **[radius](#radius)**
- **[suppress](#suppress)**
- **[ticket\_type](#ticket_type)**
- **[must\_have\_tickets](#must_have_tickets)**
- **[show\_unconfirmed\_events](#show_unconfirmed_events)**
- **[show\_rumor\_events](#show_rumor_events)**

Returns:  _Array_ of Events _Hash_

``` js
    // Example: GET /api/v2/events?limit=3&min_date=2011-01-01&api_key=1234567890abcdef
    
    [
      {
        "end_date": null,
        "festival": false,
        "id": 598282,
        "latitude": null,
        "longitude": null,
        "name": "<span class='cancelledBooking'>[Cancelled]Christina Aguilera, Leona Lewis</span> @ Susquehanna Bank Center (Formerly Tweeter Center)",
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2012-04-24T00:00:00Z",
        "unconfirmed_location": 0,
        "updated_at": "2010-08-20T00:28:43Z",
        "utc_time": "2012-04-25T03:59:00Z",
        "venue_id": 11833,
        "url": "http://thrillcall.com/event/598282"
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
    // Example: GET /api/v2/event/753419?api_key=1234567890abcdef
    
    {
      "end_date": null,
      "festival": false,
      "id": 753419,
      "latitude": null,
      "longitude": null,
      "name": "Alice Cooper @ West Virginia State Fair",
      "on_sale_date": null,
      "rumor": false,
      "start_date": "2011-08-19T07:00:00Z",
      "unconfirmed_location": 0,
      "updated_at": "2011-05-23T21:03:55Z",
      "utc_time": "2011-08-19T11:00:00Z",
      "venue_id": 32065,
      "url": "http://thrillcall.com/event/753419"
    }
```

### GET /event/:id/artists
**:id** _integer_  Thrillcall ID

Params:

- **[limit](#limit)**
- **[page](#page)**

Returns:  _Array_ of Artists _Hash_

``` js
    // Example: GET /api/v2/event/589331/artists?api_key=1234567890abcdef
    
    [
      {
        "genre_tags": "Pop",
        "id": 22210,
        "name": "Lady GaGa",
        "upcoming_events_count": 41,
        "updated_at": "2011-01-13T02:02:25Z",
        "url": "http://thrillcall.com/artist/Lady_GaGa"
      }
    ]
```

### GET /event/:id/venue
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Venue _Hash_

``` js
    // Example: GET /api/v2/event/753419/venue?api_key=1234567890abcdef
    
    {
      "address1": "State Fairgrounds",
      "address2": null,
      "city": "Lewisburg",
      "country": "US",
      "id": 32065,
      "latitude": 37.801788,
      "longitude": -80.44563,
      "name": "West Virginia State Fair",
      "state": "WV",
      "upcoming_events_count": 0,
      "updated_at": "2010-03-28T19:31:40Z",
      "postalcode": "24901",
      "url": "http://thrillcall.com/venue/West_Virginia_State_Fair_in_Lewisburg_WV"
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
    // Example: GET /api/v2/event/595357/tickets?api_key=1234567890abcdef
    
    [
      {
        "description": null,
        "event_id": 595357,
        "id": 286794,
        "marketing_text": null,
        "max_ticket_price": null,
        "min_ticket_price": null,
        "name": "Onsale to General Public",
        "on_sale_end_date": null,
        "on_sale_end_time": null,
        "on_sale_start_date": null,
        "on_sale_start_time": null,
        "seat_info": "[]",
        "updated_at": "2010-07-13T22:27:43Z",
        "url": "http://ticketsus.at/thrillcall?CTY=39&DURL=http://www.ticketmaster.com/event/00004488CCC19DAD?camefrom=CFC_BUYAT&brand=[=BRAND=]"
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
      "latitude": null,
      "longitude": null,
      "name": "Record Exchange",
      "state": "NC",
      "upcoming_events_count": 0,
      "updated_at": "2010-03-28T18:23:27Z",
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
- **[suppress](#suppress)**
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
        "id": 753419,
        "latitude": null,
        "longitude": null,
        "name": "Alice Cooper @ West Virginia State Fair",
        "on_sale_date": null,
        "rumor": false,
        "start_date": "2011-08-19T07:00:00Z",
        "unconfirmed_location": 0,
        "updated_at": "2011-05-23T21:03:55Z",
        "utc_time": "2011-08-19T11:00:00Z",
        "venue_id": 32065,
        "url": "http://thrillcall.com/event/753419"
      },
      {
        ...
      },
      ...
    ]
```

### GET /search/venues/:term
**:term** _string_  Arbitrary search string

Params:

- **[limit](#limit)**
- **[page](#page)**
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
        "latitude": null,
        "longitude": null,
        "name": "Zia Record Exchange",
        "state": "AZ",
        "upcoming_events_count": 0,
        "updated_at": "2010-03-28T18:17:58Z",
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
- **on\_sale\_end\_date**    _string_   ISO 8601 date when the ticket goes off sale
- **on\_sale\_end\_time**    _string_   ISO 8601 time of day when the ticket goes off sale
- **on\_sale\_start\_date**  _string_   ISO 8601 date when the ticket goes on sale
- **on\_sale\_start\_time**  _string_   ISO 8601 time of day when the ticket goes on sale
- **seat\_info**             _string_   Additional info about the seat
- **updated\_at**            _string_   ISO 8601 representation of last time this object was updated
- **url**                    _string_   URL for this object on Thrillcall

### GET /tickets
Params:

- **[limit](#limit)**
- **[page](#page)**
- **[min\_date](#min_date)**
- **[max\_date](#max_date)**
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
        "on_sale_end_time": null,
        "on_sale_start_date": null,
        "on_sale_start_time": null,
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
      "on_sale_end_time": null,
      "on_sale_start_date": null,
      "on_sale_start_time": null,
      "seat_info": null,
      "updated_at": "2009-02-05T19:51:27Z",
      "url": "http://www.ticketcity.com/concert-tickets/world-music-tickets/celtic-woman-tickets/celtic-woman-tickets-nokia-live-april-18-8-00pm.html"
    }
```