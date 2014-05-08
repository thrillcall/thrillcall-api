# HTTPS Endpoints

### Contents
- **[Parameters](#content_parameters)**
- **[Artists](#content_artists)**
  - **[GET /artists](#content_artists_get_artists)**
  - **[POST /artist](#content_artists_post_artist)**
  - **[GET /artist/:id](#content_artists_get_artist_id)**
  - **[PUT /artist/:id](#content_artists_put_artist_id)**
  - **[GET /artist/:id/events](#content_artists_get_artist_id_events)**
  - **[GET /search/artists/:term](#content_artists_get_search_artists_term)**
- **[Events](#content_events)**
  - **[GET /events](#content_events_get_events)**
  - **[GET /event/:id](#content_events_get_event_id)**
  - **[GET /event/:id/artists](#content_events_get_event_id_artists)**
  - **[GET /event/:id/venue](#content_events_get_event_id_venue)**
  - **[GET /event/:id/tickets](#content_events_get_event_id_tickets)**
- **[Genre](#content_genre)**
  - **[GET /genres](#content_genre_get_genres)**
  - **[GET /genre/:id](#content_genre_get_genre_id)**
  - **[GET /genre/:id/artists](#content_genre_get_genre_id_artists)**
- **[Metro Area](#content_metro_area)**
  - **[GET /metro_areas](#content_metro_area_get_metro_areas)**
  - **[GET /metro_area/:id](#content_metro_area_get_metro_area_id)**
  - **[GET /metro_area/:id/events](#content_metro_area_get_metro_area_id_events)**
- **[Person](#content_person)**
  - **[GET /person/:id](#content_person_get_person_id)**
  - **[POST /person/signin](#content_person_post_person_signin)**
  - **[POST /person/signup](#content_person_post_person_signup)**
  - **[PUT /person/:id](#content_person_put_person_id)**
  - **[GET /people/tracking/:class](#content_person_get_people_tracking_class)**
  - **[GET /person/:id/:class](#content_person_get_person_id_class)**
  - **[POST /person/:id/:action/:class](#content_person_post_person_id_action_class)**
  - **[POST /person/:id/track\_artists\_by\_name](#content_person_post_person_id_track_artists_by_name)**
  - **[GET /person/:id/recommended_events](#content_person_get_person_id_recommended_events)**
  - **[GET /person/:id/discover_events](#content_person_get_person_id_discover_events)**
  - **[GET /person/:id/friends_events](#content_person_get_person_id_friends_events)**
  - **[GET /person/:id/recommended_artists](#content_person_get_person_id_recommended_artists)**
- **[Credential](#content_credential)**
  - **[POST /credential](#content_credential_post_credential)**
  - **[PUT /credential/:id](#content_credential_put_id_credential)**
- **[Venues](#content_venues)**
  - **[GET /venues](#content_venues_get_venues)**
  - **[POST /venue](#content_venues_post_venue)**
  - **[GET /venue/:id](#content_venues_get_venue_id)**
  - **[PUT /venue/:id](#content_venues_put_venue_id)**
  - **[GET /venue/:id/events](#content_venues_get_venue_id_events)**
  - **[GET /search/venues/:term](#content_venues_get_search_venues_term)**
- **[Tickets](#content_tickets)**
  - **[GET /tickets](#content_tickets_get_tickets)**
  - **[GET /ticket/:id](#content_tickets_get_ticket_id)**
- **[Mappings](#content_mappings)**
  - **[GET /mappings](#content_mappings_get_mappings)**
  - **[GET /mapping/:id](#content_mappings_get_mapping_id)**
  - **[POST /mapping](#content_mappings_post_mapping)**
  - **[PUT /mapping/:id](#content_mappings_put_mapping_id)**

### SSL/TLS Endpoints Required:
All API access must use the secure HTTPS endpoint : https://api.thrillcall.com:443
Access over an insecure HTTP (port 80) endpoint is now deprecated and will be disabled.

<a name="content_parameters" />
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

    _Default: 200_

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

    Used in conjunction with **[lat](#lat)**/**[long](#long)** or **[postalcode](#postalcode)**

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

- <a name="featured_events_only" />**featured\_events\_only** _boolean_

    _Default: false_

    If set to _true_ , will only return featured events.

- <a name="primary_genre_id" />**primary\_genre\_id** _integer_

    _Default: none_

    If set, will filter Artist results to only those with the specified **[primary\_genre\_id](#primary_genre_id)**

- <a name="email" />**email** _string_

    The email address associated with a Person, required for registration.

- <a name="password" />**password** _string (format: 40 >= length >= 5)_

    The Person's password.

    When creating a Person, this must be supplied along with **[email](#email)** unless using **[provider](#provider)** / **[uid](#uid)** / **[token](#token)** auth.

    When updating a Person, this will change the Person's password.  It must be supplied along with **[old\_password](#old_password)**.

- <a name="old_password" />**old\_password** _string (format: 40 >= length >= 5)_

    The Person's current password, supplied along with **[password](#password)** to update a Person's password.

- <a name="provider" />**provider** _string_

    The name of the authentication provider (e.g. "facebook").

    For registration, this must be supplied along with **[uid](#uid)** and **[token](#token)** unless using **[email](#email)**/**[password](#password)** auth.

- <a name="uid" />**uid** _string_

    The Person's ID with **[provider](#provider)**.

    For registration, this must be supplied along with **[provider](#provider)** and **[token](#token)** unless using **[email](#email)**/**[password](#password)** auth.

- <a name="token" />**token** _string_

    The Person's authentication token with **[provider](#provider)**.

    For registration, this must be supplied along with **[provider](#provider)** and **[uid](#uid)** unless using **[email](#email)**/**[password](#password)** auth.

    For additional credentials, this field is optional.

- <a name="old_token" />**old\_token** _string_

    The Credential's current token, must match record to perform Credential updates.

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

- <a name="country_code" />**country_code** _string (format: "US" length == 2)_

    Country code, required for Venues.

- <a name="location_name" />**location\_name** _string (format: "City, ST or City, State", length > 0))_

    The name of the Person's location when auto-registering.  Either this or **[lat](#lat)** / **[long](#long)** must be provided.

- <a name="platform" />**platform** _string_

    _Default: web_

    Platform of origin for tracking an object.  Valid platforms: "ios", "web", "android"

- <a name="referral_code" />**referral\_code** _string_

    The referral code to be used during registration.  Both the owner of the code as well as the new Person will receive a referral credit point.

- <a name="preferred_radius" />**preferred\_radius** _float_

    _Default: 100.0_

    Person's search radius preference, used as a default for Person endpoints such as **[GET /person/:id/recommended_events](#content_person_get_person_id_recommended_events)**.

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

- <a name="artist_names" />**artist\_names** _string_

    A list of comma separated artist names.

- <a name="mappings" />**mappings** _string or array (format: ["myspace", "livenation"])_

    Foreign ID mappings for the specified partners, if available, will be provided along with the object data.
    Can be provided as a single param ("mappings=myspace") or as an array ("mappings[]=myspace&mappings[]=livenation").

- <a name="person_id" />**person\_id** _string_

    Thrillcall ID for the Person object.

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

    The direction you wish to sort the results.  Default: DESC

- <a name="polling_for" />**polling\_for** _string_

    Comma-separated list of services to poll.  Use this to decrease response time if recommendations from only one or two services need to be refreshed.

    e.g. _"spotify,lastfm"_

    If specified, will only return recommended artists from these services.  Popular artists will be omitted.

    If not specified, will return recommended artists from all available services, as well as popular artists.

<a name="content_artists" />
## Artists
Fields:

- **created\_at**             _string_    ISO 8601 representation the time this object was created
- **genre\_tags**             _string_    Semicolon separated list of Genre names
- **id**                      _integer_   Thrillcall ID
- **name**                    _string_    Artist / Band Name
- **primary\_genre\_id**      _integer_   The Thrillcall ID for this artist's primary Genre
- **upcoming\_events\_count** _integer_   Number of upcoming events associated with this object
- **updated\_at**             _string_    ISO 8601 representation of last time this object was updated
- **popularity**              _float_     A number from 0.0 to 1.0 indicating relative popularity of the Artist, 1.0 being most popular
- **photos**                  _hash_      A hash of image urls of the primary photo available for this object in different styles
- **url**                     _string_    URL for this object on Thrillcall
- **facebook\_url**           _string_    URL for this object on Facebook
- **myspace\_url**            _string_    Myspace URL for this object
- **official\_url**           _string_    Official external URL for this object
- **wikipedia\_url**          _string_    Wikipedia URL for this object


<a name="content_artists_get_artists" />
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

<a name="content_artists_post_artist" />
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

<a name="content_artists_get_artist_id" />
### GET /artist/:id
**:id** _integer_  Thrillcall or **[Mapping](#content_mappings)**

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

<a name="content_artists_put_artist_id" />
### PUT /artist/:id
**:id** _integer_  Thrillcall or **[Mapping](#content_mappings)**

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

<a name="content_artists_get_artist_id_events" />
### GET /artist/:id/events
**:id** _integer_  Thrillcall or **[Mapping](#content_mappings)**

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
- **[featured\_events\_only](#featured_events_only)**
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
        "name_modified": false,
        "featured_event": false,
        "venue": {
          "address1": "1111 California Street",
          "address2": null,
          "city": "San Francisco",
          "country_code": "US",
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
        },
        "artists": [
          {
            "id": 378465,
            "name": "Il Volo",
            "headliner": false
          }
        ],
        "offer_details": {}
      },
      {
        ...
      },
      ...
    ]
```


<a name="content_artists_get_search_artists_term" />
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

<a name="content_events" />
## Events
Fields:

- **created\_at**                         _string_  ISO 8601 representation the time this object was created
- **festival**                            _boolean_ Is this event a festival?
- **id**                                  _integer_ Thrillcall ID
- **latitude**                            _float_   Approximate latitude for the Event
- **longitude**                           _float_   Approximate longitude for the Event
- **name**                                _string_  Name of the Event
- **on\_sale\_date**                      _string_  ISO 8601 representation of the date when tickets go on sale
- **rumor**                               _boolean_ Are the details for this event based on a rumor?
- **event\_status**                       _string_  Status of the event (confirmed, unconfirmed, cancelled, or disabled)
- **starts\_at**                          _string_  ISO 8601 representation of the start of the Event in UTC time
- **starts\_at\_local**                   _string_  ISO 8601 representation of the start of the Event in the local timezone
- **starts\_at\_time\_trusted**           _boolean_ Do we trust that the time of day component of **starts\_at** is valid?
- **time\_zone**                          _string_  TZ Database string representing the time zone at the location of the event
- **unconfirmed\_location**               _integer_ If 1, the location of this event is unconfirmed
- **updated\_at**                         _string_  ISO 8601 representation of last time this object was updated
- **name_modified**                       _boolean_ Has the event name been modified?
- **featured_event**                      _boolean_ Is this a featured event?
- **venue\_id**                           _integer_ Thrillcall Venue ID
- **photos**                              _hash_    A hash of image urls of the primary photo available for this object in different styles
- **artists**                             _array_   An array of hashes, each representing an artist at this event, containing:
  - **id**                                  _integer_ Thrillcall ID for the Event
  - **name**                                _string_  Artist name
  - **headliner**                           _boolean_ Is this artist a headliner on the bill?
  - **photos**                              _hash_    A hash of image urls of the primary photo available for this object in different styles
- **url**                                 _string_  URL for this object on Thrillcall
- **offer_details**                       _hash_    A hash of of attributes consisting of offer details about an offer attached to an event, if present
  - **id**                                  _integer_ Offer ID
  - **title**                               _string_  Offer title
  - **offer\_starts\_at**                   _string_  ISO 8601 representation of the start of the Offer in UTC time
  - **offer\_starts\_at\_local**            _string_  ISO 8601 representation of the start of the Offer in local timezone
  - **offer\_end\_at**                      _string_  ISO 8601 representation of the end of the Offer in UTC time
  - **offer\_starts\_at\_local**            _string_  ISO 8601 representation of the end of the Offer in local timezone
  - **offer\_sale\_starts\_at**             _string_  ISO 8601 representation of the start of the Offer sale in UTC time
  - **offer\_sale\_starts\_at\_local**      _string_  ISO 8601 representation of the start of the Offer sale in local timezone
  - **short_description**                   _string_  Short description of the offer
  - **offer_type**                          _string_  Type of the offer ( contest, standard )
  - **price_cents**                         _integer_ Price of the offer in cents
  - **photos**                              _hash_    A hash of offer photos (currently only returns 'mobile' style photos)


<a name="content_events_get_events" />
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
- **[featured\_events\_only](#featured_events_only)**
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
        "name_modified": false,
        "featured_event": true,
        "venue": {
          "address1": "1111 California Street",
          "address2": null,
          "city": "San Francisco",
          "country_code": "US",
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
        },
        "artists": [
          {
            "id": 378465,
            "name": "Il Volo",
            "headliner": false
          }
        ],
        "offer_details": {
          "id": 123,
          "title": "Example Offer",
          "offer_starts_at": "2013-05-01T09:00:00-07:00",
          "offer_starts_at_local": "2013-05-01T09:00:00-07:00",
          "offer_ends_at": "2013-05-02T17:00:00-07:00",
          "offer_ends_at_local": "2013-05-02T17:00:00-07:00",
          "offer_sale_starts_at": "2013-05-01T09:00:00-07:00",
          "offer_sale_starts_at_local": "2013-05-01T09:00:00-07:00",
          "short_description": "Win tickets for the show!",
          "offer_type": "contest",
          "price_cents": 0
        }
      },
      {
        ...
      },
      ...
    ]
```

<a name="content_events_get_event_id" />
### GET /event/:id
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Event _Hash_

``` js
    // Example: GET /api/v3/event/1047075?api_key=1234567890abcdef
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
      "name_modified": false,
      "featured_event": true,
      "artists": [
        {
          "id": 378465,
          "name": "Il Volo",
          "headliner": false
        }
      ],
      "offer_details": {
        "id": 123,
        "title": "Example Offer",
        "offer_starts_at": "2013-05-01T09:00:00-07:00",
        "offer_starts_at_local": "2013-05-01T09:00:00-07:00",
        "offer_ends_at": "2013-05-02T17:00:00-07:00",
        "offer_ends_at_local": "2013-05-02T17:00:00-07:00",
        "offer_sale_starts_at": "2013-05-01T09:00:00-07:00",
        "offer_sale_starts_at_local": "2013-05-01T09:00:00-07:00",
        "short_description": "Get tickets for tonight!",
        "offer_type": "standard",
        "price_cents": 2000
      }
    }
```

<a name="content_events_get_event_id_artists" />
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

<a name="content_events_get_event_id_venue" />
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
      "country_code": "US",
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

<a name="content_events_get_event_id_tickets" />
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
        "currency": "USD",
        "description": null,
        "event_id": 1047075,
        "id": 819883,
        "marketing_text": null,
        "max_ticket_price": "85.00",
        "min_ticket_price": "29.00",
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

<a name="content_genre" />
## Genre
Fields:

- **created\_at**             _string_    ISO 8601 representation the time this object was created
- **description**             _string_    Description of the Genre
- **id**                      _integer_   Thrillcall ID
- **name**                    _string_    Name of the Genre
- **updated\_at**             _string_    ISO 8601 representation of last time this object was updated

<a name="content_genre_get_genres" />
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

<a name="content_genre_get_genre_id" />
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

<a name="content_genre_get_genre_id_artists" />
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

<a name="content_metro_area" />
## Metro Area
Fields:

- **city**                                _string_    City of the Metro Area
- **country\_code**                       _string_    Country of the Metro Area
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

<a name="content_metro_area_get_metro_areas" />
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
        "country_code": "US",
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

<a name="content_metro_area_get_metro_area_id" />
### GET /metro_area/:id
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Metro Area _Hash_

``` js
    // Example: GET /api/v3/metro_area/105?api_key=1234567890abcdef

    {
      "city": "San Francisco",
      "country_code": "US",
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

<a name="content_metro_area_get_metro_area_id_events" />
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
- **[featured\_events\_only](#featured_events_only)**
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
        "name_modified": false,
        "featured_event": false,
        "venue": {
          "address2":null,"city":"San Francisco",
          "country_code":"US",
          "created_at":"2008-04-28T18:13:50Z",
          "facebook_url":"http://www.facebook.com/theendup",
          "hide_resale_tickets":false,
          "id":47273,
          "latitude":37.777243,
          "long_description":null,
          "longitude":-122.403919,
          "myspace_url":null,
          "name":"The End Up",
          "official_url":"http://www.theendup.com",
          "phone_number":"+1 (415) 896-1075",
          "state":"CA",
          "time_zone":"America/Los_Angeles",
          "upcoming_events_count":5,
          "updated_at":"2012-08-19T11:29:19Z",
          "postalcode":"94708",
          "photos":{"thumbnail":"http://i1.tc-core.com/venue/47273/107/1326489566/the-end-up-in-san-francisco-ca-thumbnail.jpg?1326489566",
          "medium":"http://i1.tc-core.com/venue/47273/107/1326489566/the-end-up-in-san-francisco-ca-medium.jpg?1326489566",
          "large":"http://i1.tc-core.com/venue/47273/107/1326489566/the-end-up-in-san-francisco-ca-large.jpg?1326489566",
          "mobile":"http://i.development.tc-core.com/noel/venue/47273/107/1326489566/the-end-up-in-san-francisco-ca-mobile.jpg?1326489566"},
          "metro_area_id":105,
          "url":"http://localhost:3000/venue/The_End_Up_in_San_Francisco_CA"
        },
        "artists": [
          {
            "id": 2295,
            "name": "Kontrol",
            "headliner": false
          }
        ],
        "offer_details": {}
      },
      {
        ...
      },
      ...
    ]
```

<a name="content_person" />
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
- **preferred\_radius**       _float_     Preference for radius in miles from the Person to search for events for that Person

<a name="content_person_get_person_id" />
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
      "credentials": [
        {
          "id": 18434,
          "provider": "facebook",
          "uid": "abc123",
          "token_present": true
        }
      ]
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
      },
      "preferred_radius": 100.0
    }
```

<a name="content_person_post_person_signin" />
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
      "credentials": [
        {
          "id": 18434,
          "provider": "facebook",
          "uid": "abc123",
          "token_present": true
        }
      ]
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
      },
      "preferred_radius": 100.0
    }
```

<a name="content_person_post_person_signup" />
### POST /person/signup
Params:

- **[first\_name](#first_name)**
- **[last\_name](#last_name)**
- **[gender](#gender)**
- **[email](#email)**
- **[password](#password)**
- **[postalcode](#postalcode)**
- **[referral\_code](#referral_code)**
- **[preferred\_radius](#preferred_radius)**

Returns: Person _Hash_

``` js
    // Example: POST /api/v3/person/signup?first_name=Mister&email=bogus%40bogus.com&password=bogus&postalcode=94108&api_key=1234567890abcdef

    {
      "address1": null,
      "address2": null,
      "city": null,
      "country_code": null,
      "created_at": null,
      "credentials": [
        {
          "id": 18434,
          "provider": "facebook",
          "uid": "abc123",
          "token_present": true
        }
      ]
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
      },
      "preferred_radius": 100.0
    }
```

<a name="content_person_put_person_id" />
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
- **[password](#password)**
- **[old\_password](#old_password)**
- **[preferred\_radius](#preferred_radius)**

Returns: Person _Hash_

``` js
    // Example: PUT /api/v3/person/49&first_name=John&api_key=1234567890abcdef

    {
      "address1": null,
      "address2": null,
      "city": "Santa Rosa",
      "country_code": "US",
      "created_at": "2011-10-17T18:54:31Z",
      "credentials": [
        {
          "id": 18434,
          "provider": "facebook",
          "uid": "abc123",
          "token_present": true
        }
      ]
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
      },
      "preferred_radius": 100.0
    }
```

<a name="content_person_get_people_tracking_class" />
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


<a name="content_person_get_person_id_class" />
### GET /person/:id/:class
**:class** _string_  One of: "genres", "events", "artists", "people", "venues"

Params:

- None.

Returns: _Hash_ of tracked **:class** IDs mapped to **:class** names for this person.

``` js
    // Example: GET /api/v3/person/2/artists&api_key=1234567890abcdef

    {
      "2687": "Radiohead",
      "18927": "M83",
      ...
    }
```

<a name="content_person_post_person_id_action_class" />
### POST /person/:id/:action/:class
**:action** _string_  One of: "track", "untrack"
**:class** _string_   One of: "genres", "events", "artists", "people", "venues"

Params:

- **[ids](#ids)** _Required_
- **[platform](#platform)**

Returns: Hash of **:class** tracked IDs mapped for this person after performing **:action**.

``` js
    // Example: POST /api/v3/person/24/track/artists?ids=44,45&platform=ios&api_key=1234567890abcdef

    {
      "44": "Paco Osuna",
      "45": "Wanamaker"
    }
```

<a name="content_person_post_person_id_track_artists_by_name" />
### POST /person/:id/track\_artists\_by\_name

Params:

- **[artist\_names](#artist_names)** _Required_
- **[platform](#platform)**

Returns: _Array_ of hash with tracked artist IDs mapped to artist names for this person.

``` js
    // Example: POST /api/v3/person/24/track_artists_by_name?artist_names=Radiohead,M83&platform=ios&api_key=1234567890abcdef

    [
      {
        "2687": "Radiohead"
      },
      {
        "18927": "M83",
      }
    ]
```

<a name="content_person_get_person_id_recommended_events" />
### GET /person/:id/recommended_events
**:id** _integer_  Thrillcall ID

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
- **[featured\_events\_only](#featured_events_only)**
- **[sort](#sort)**
- **[order](#order)**

Note:  By default, this will search for events within the Person's **[preferred\_radius](#preferred_radius)** of the Person's geolocation.  You may override these defaults with **[lat](#lat)**/**[long](#long)** or **[postalcode](#postalcode)** and **[radius](#radius)**.

Returns:  _Array_ of Events _Hash_ where at least one of the person's tracked artists is performing in an event

``` js
    // Example: GET /api/v3/person/24/recommended_events?api_key=1234567890abcdef

    [
      {
        "id": 1291050,
        "name": "T.I., Lil Wayne, 2 Chainz @ Sleep Train Pavilion At Concord",
        "venue_id": 323,
        "created_at": "2013-03-25T20:42:16Z",
        "updated_at": "2013-06-12T22:20:41Z",
        "festival": false,
        "rumor": false,
        "unconfirmed_location": 0,
        "latitude": 37.9604,
        "longitude": -121.94,
        "starts_at": "2013-08-31T02:30:00Z",
        "starts_at_time_trusted": true,
        "skip_event_conflict_validation": false,
        "distance": 30.608671818601927,
        "bearing": "68.0",
        "photos": {
          "thumbnail": "http://i1.tc-core.com/artist/34156/491/1324556348/lil-wayne-thumbnail.jpg?1324556348",
          "large": "http://i1.tc-core.com/artist/34156/491/1324556348/lil-wayne-large.jpg?1324556348",
          "mobile": "http://i1.tc-core.com/artist/34156/491/1324556348/lil-wayne-mobile.jpg?1324556348"
        },
        "url": "http://thrillcall.com/event/1291050",
        "starts_at_local": "2013-08-30T19:30:00-07:00",
        "time_zone": "America/Los_Angeles",
        "event_status": "confirmed",
        "name_modified": false,
        "featured_event": false,
        "venue": {
          "id": 323,
          "name": "Sleep Train Pavilion At Concord",
          "address1": "2000 Kirker Pass Road",
          "address2": null,
          "city": "Concord",
          "state": "CA",
          "official_url": null,
          "created_at": "2008-04-21T16:52:53Z",
          "updated_at": "2013-06-24T09:00:13Z",
          "latitude": 37.960354,
          "longitude": -121.939659,
          "country_code": "US",
          "myspace_url": null,
          "upcoming_events_count": 4,
          "facebook_url": "http://www.facebook.com/pages/Sleep-Train-Pavilion/116238125066831",
          "long_description": null,
          "phone_number": "+1 (925) 676-8742",
          "time_zone": "America/Los_Angeles",
          "hide_resale_tickets": false,
          "postalcode": "94521",
          "photos": {
            "thumbnail": "http://i1.tc-core.com/venue/323/1473/1336436387/sleep-train-pavilion-at-concord-in-concord-ca-thumbnail.jpg?1336436387",
            "medium": "http://i1.tc-core.com/venue/323/1473/1336436387/sleep-train-pavilion-at-concord-in-concord-ca-medium.jpg?1336436387",
            "large": "http://i1.tc-core.com/venue/323/1473/1336436387/sleep-train-pavilion-at-concord-in-concord-ca-large.jpg?1336436387",
            "mobile": "http://i1.tc-core.com/venue/323/1473/1336436387/sleep-train-pavilion-at-concord-in-concord-ca-mobile.jpg?1336436387"
          },
          "metro_area_id": 105,
          "url": "http://thrillcall.com/venue/Sleep_Train_Pavilion_At_Concord_in_Concord_CA"
        },
        "artists": [
          {
            "id": 34156,
            "name": "Lil Wayne",
            "headliner": true
          },
          {
            "id": 28490,
            "name": "T.I.",
            "headliner": false
          },
          {
            "id": 387608,
            "name": "2 Chainz",
            "headliner": false
          }
        ],
        "offer_details": {}
      },
      {
        ...
      },
      ...
    ]
```

<a name="content_person_get_person_id_discover_events" />
### GET /person/:id/discover_events
**:id** _integer_  Thrillcall ID

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
- **[featured\_events\_only](#featured_events_only)**
- **[sort](#sort)**
- **[order](#order)**

Note:  By default, this will search for events within the Person's **[preferred\_radius](#preferred_radius)** of the Person's geolocation.  You may override these defaults with **[lat](#lat)**/**[long](#long)** or **[postalcode](#postalcode)** and **[radius](#radius)**.

Returns:  _Array_ of Events _Hash_ where a similar artist to one of the person's tracked artists is performing in an event

``` js
    // Example: GET /api/v3/person/24/discover_events?api_key=1234567890abcdef

    [
      {
        "id": 1308413,
        "name": "My Morning Jacket, Wilco, Bob Dylan, Ryan Bingham @ Shoreline Amphitheatre at Mountain View",
        "venue_id": 29474,
        "created_at": "2013-04-22T20:54:34Z",
        "updated_at": "2013-05-11T03:22:49Z",
        "festival": false,
        "rumor": false,
        "unconfirmed_location": 0,
        "latitude": 37.4234,
        "longitude": -122.078,
        "starts_at": "2013-08-05T00:30:00Z",
        "starts_at_time_trusted": true,
        "skip_event_conflict_validation": false,
        "distance": 30.458803738929397,
        "bearing": "133.0",
        "photos": {
          "thumbnail": "http://i1.tc-core.com/artist/28246/513/1324556491/bob-dylan-thumbnail.jpg?1324556491",
          "large": "http://i1.tc-core.com/artist/28246/513/1324556491/bob-dylan-large.jpg?1324556491",
          "mobile": "http://i1.tc-core.com/artist/28246/513/1324556491/bob-dylan-mobile.jpg?1324556491"
        },
        "url": "http://thrillcall.com/event/1308413",
        "starts_at_local": "2013-08-04T17:30:00-07:00",
        "time_zone": "America/Los_Angeles",
        "event_status": "confirmed",
        "name_modified": false,
        "featured_event": false,
        "venue": {
          "id": 29474,
          "name": "Shoreline Amphitheatre at Mountain View",
          "address1": "One Amphitheatre Parkway",
          "address2": null,
          "city": "Mountain View",
          "state": "CA",
          "official_url": "http://www.livenation.com/Shoreline-Amphitheatre-tickets-Mountain-View/venue/229414",
          "created_at": "2008-04-21T16:52:54Z",
          "updated_at": "2013-08-04T04:48:04Z",
          "latitude": 37.4234,
          "longitude": -122.078124,
          "country_code": "US",
          "myspace_url": null,
          "upcoming_events_count": 25,
          "facebook_url": "http://www.facebook.com/ShorelineAmphitheatre?sk=info",
          "long_description": null,
          "phone_number": "+1 (650) 967-3000",
          "time_zone": "America/Los_Angeles",
          "hide_resale_tickets": false,
          "postalcode": "94043",
          "photos": {
            "thumbnail": "http://i1.tc-core.com/venue/29474/263/1327616683/shoreline-amphitheatre-at-mountain-view-in-mountain-view-ca-thumbnail.jpg?1327616683",
            "medium": "http://i1.tc-core.com/venue/29474/263/1327616683/shoreline-amphitheatre-at-mountain-view-in-mountain-view-ca-medium.jpg?1327616683",
            "large": "http://i1.tc-core.com/venue/29474/263/1327616683/shoreline-amphitheatre-at-mountain-view-in-mountain-view-ca-large.jpg?1327616683",
            "mobile": "http://i1.tc-core.com/venue/29474/263/1327616683/shoreline-amphitheatre-at-mountain-view-in-mountain-view-ca-mobile.jpg?1327616683"
          },
          "metro_area_id": 141,
          "url": "http://thrillcall.com/venue/Shoreline_Amphitheatre_at_Mountain_View_in_Mountain_View_CA"
        },
        "artists": [
          {
          "id": 28246,
          "name": "Bob Dylan",
          "headliner": true
          },
          {
          "id": 16250,
          "name": "Wilco",
          "headliner": false
          },
          {
          "id": 9271,
          "name": "My Morning Jacket",
          "headliner": false
          },
          {
          "id": 53718,
          "name": "Ryan Bingham",
          "headliner": false
          }
        ],
        "offer_details": {}
      },
      {
        ...
      },
      ...
    ]
```

<a name="content_person_get_person_id_friends_events" />
### GET /person/:id/friends_events
**:id** _integer_  Thrillcall ID

Params:

- None.

Returns: _Array_ of _Hashes_ containing Person _Hash_ keyed on "friend" and _Array_ of Event IDs keyed on "events"

All people in the result set are friends (tracked Person objects) of the Person.

Event IDs are future active events tracked by that friend.

``` js
    // Example: GET /api/v3/person/2/friends_events&api_key=1234567890abcdef

    [
      {
        "friend": {
          "address1": null,
          "address2": null,
          "city": "Santa Rosa",
          "country_code": "US",
          "created_at": "2011-10-17T18:54:31Z",
          "credentials": [
            {
              "id": 18434,
              "provider": "facebook",
              "uid": "abc123",
              "token_present": true
            }
          ]
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
          },
          "preferred_radius": 100.0
        },
        "events": [
          1308413,
          ...
        ],
        ...
      }
    ]
```
<a name="content_person_get_person_id_recommended_artists" />
### GET /person/:id/recommended_artists
**:id** _integer_  Thrillcall ID

Params:
- **[polling_for](#polling_for)**

Returns: _Hash_
The hash will contain the following keys.

- **recommendations**: For each service and popular artists, an _Array_ of recommended artist _Hashes_.  If there is any error with the connection, an error message _string_ to present to the user will be here instead of the array.
- **connected**: For each service, _boolean_ whether or not the user is connected
- **autotrack**: For each service, _boolean_ whether or not the user is automatically tracking recommended artists

In the recommendations hash, each artist is represented by a hash of the following key-value pairs:

- **id**: Thrillcall ID
- **title**: Name of the Artist
- **tracking**: Boolean value indicating whether or not the user is tracking the Artist
- **artist\_normalized\_name**
- **artist\_upcoming\_shows**: The number of upcoming shows for this Artist
- **url**: Artist photo URL

``` js
    // Example: GET /api/v3/person/2/recommended_artists?api_key=1234567890abcdef

    {
      "recommendations": {
        "popular": [
          {
            "id": 17053,
            "title": "Justin Timberlake",
            "tracking": false,
            "artist_normalized_name": "justintimberlake",
            "artist_upcoming_shows": 70,
            "url": "http://i.development.tc-core.com/artist/17053/1048/1324556871/justin-timberlake-medium.jpg?1324556871"
          },
          {
            ...
          },
          ...
        ],
        "facebook": [
          ...
        ],
        "pandora": "Failure: No Pandora user found named 'bogususername'.",
        ...
      },
      "connected": {
        "facebook": true,
        "pandora": false,
        ...
      },
      "autotrack": {
        "facebook": false,
        ...
      }
    }
```

<a name="content_credential" />
## Credentials
Fields:

N/A.  Always returns Person objects.  Credentials are nested inside Person objects.

<a name="content_credential_post_credential" />
### POST /credential

Params:

- **[person_id](#person_id)**
- **[provider](#provider)**
- **[uid](#uid)**
- **[token](#token)**

Returns: Person _Hash_

Credentials are stored tokens allowing us to authenticate on behalf of a Person.
These are typically OAuth tokens, but can take any form.  The token itself is
not required and may be left blank, the other parameters are required.

``` js
    // Example: POST /api/v3/credential
    // person_id=49&provider=spotify&uid=4321&token=abc123&api_key=1234567890abcdef

    {
      "address1": null,
      "address2": null,
      "city": "Santa Rosa",
      "country_code": "US",
      "created_at": "2011-10-17T18:54:31Z",
      "credentials": [
        {
          "id": 18435,
          "provider": "spotify",
          "uid": "4321",
          "token_present": true
        }
      ]
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
      },
      "preferred_radius": 100.0
    }
```

<a name="content_credential_put_credential_id" />
### PUT /credential/:id
**:id** _integer_  Thrillcall ID

Params:

- **[uid](#uid)**
- **[token](#token)**
- **[old_token](#old_token)**
- **[old_password](#old_password)**

Returns: Person _Hash_

This endpoint allows you to change the UID or token of an existing credential.
You must supply either the user's current password, or the existing token on the
credential.

``` js
    // Example: PUT /api/v3/credential/18435
    // old_token=abc123&token=&api_key=1234567890abcdef

    {
      "address1": null,
      "address2": null,
      "city": "Santa Rosa",
      "country_code": "US",
      "created_at": "2011-10-17T18:54:31Z",
      "credentials": [
        {
          "id": 18435,
          "provider": "spotify",
          "uid": "4321",
          "token_present": false
        }
      ]
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
      },
      "preferred_radius": 100.0
    }
```

<a name="content_venues" />
## Venues
Fields:

- **address1**                _string_    First address field for the Venue
- **address2**                _string_    Second address field for the Venue
- **city**                    _string_    City the Venue is in
- **country\_code**           _string_    Country the Venue is in
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


<a name="content_venues_get_venues" />
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
        "country_code": "MX",
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

<a name="content_venues_post_venue" />
### POST /venue
Params:

- **[name](#name)**
- **[address1](#address1)**
- **[address2](#address2)**
- **[city](#city)**
- **[state](#state)**
- **[postalcode](#postalcode)**
- **[country_code](#country_code)**
- **[facebook_url](#facebook_url)**
- **[official_url](#official_url)**

Returns:  Venue _Hash_

``` js
    // Example: POST /api/v3/venue?name=Test%20Venue&city=Guerneville&state=CA&country_code=US&address1=123%20Main%20St&postalcode=95446&api_key=1234567890abcdef

    {
      "address1": "123 Main St",
      "address2": null,
      "city": "Guerneville",
      "country_code": "US",
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

<a name="content_venues_get_venue_id" />
### GET /venue/:id
**:id** _integer_  Thrillcall or **[Mapping](#content_mappings)**

Params:

- None

Returns:  Venue _Hash_

``` js
    // Example: GET /api/v3/venue/51886?api_key=1234567890abcdef

    {
      "address1": "201 Van Ness Avenue",
      "address2": null,
      "city": "San Francisco",
      "country_code": "US",
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

<a name="content_venues_put_venue_id" />
### PUT /venue/:id
Params:

- **[name](#name)**
- **[address1](#address1)**
- **[address2](#address2)**
- **[city](#city)**
- **[state](#state)**
- **[postalcode](#postalcode)**
- **[country_code](#country_code)**
- **[facebook_url](#facebook_url)**
- **[official_url](#official_url)**

Returns:  Venue _Hash_

``` js
    // Example: PUT /api/v3/venue/51886?address1=202%20Van%20Ness%20Avenue&api_key=1234567890abcdef

    {
      "address1": "202 Van Ness Avenue",
      "address2": null,
      "city": "San Francisco",
      "country_code": "US",
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

<a name="content_venues_get_venue_id_events" />
### GET /venue/:id/events
**:id** _integer_  Thrillcall or **[Mapping](#content_mappings)**

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
- **[featured\_events\_only](#featured_events_only)**
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
        "name_modified": false,
        "featured_event": false,
        "venue": {
          "address1": "1111 California Street",
          "address2": null,
          "city": "San Francisco",
          "country_code": "US",
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
        },
        "artists": [
          {
            "id": 378465,
            "name": "Il Volo",
            "headliner": false
          }
        ],
        "offer_details": {}
      },
      {
        ...
      },
      ...
    ]
```

<a name="content_venues_get_search_venues_term" />
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
        "country_code": "US",
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

<a name="content_tickets" />
## Tickets
Fields:

- **created\_at**                    _string_   ISO 8601 representation the time this object was created
- **currency**                       _string_   Currency of the price
- **description**                    _string_   Long form description of the ticket
- **event\_id**                      _integer_  Thrillcall Event ID
- **id**                             _integer_  Thrillcall ID
- **marketing\_text**                _string_   Long form description of the ticket
- **max\_ticket\_price**             _string_   Maximum price for this ticket
- **min\_ticket\_price**             _string_   Minimum price for this ticket
- **name**                           _string_   Name of this ticket
- **on\_sale\_end\_date**            _string_   YYYY-MM-DD date when the ticket goes off sale
- **on\_sale\_start\_date**          _string_   YYYY-MM-DD date when the ticket goes on sale
- **seat\_info**                     _string_   Additional info about the seat
- **updated\_at**                    _string_   ISO 8601 representation of last time this object was updated
- **url**                            _string_   URL for this object on Thrillcall

<a name="content_tickets_get_tickets" />
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
        "currency": "USD",
        "description": null,
        "event_id": 455646,
        "id": 1,
        "marketing_text": null,
        "max_ticket_price": "0.00",
        "min_ticket_price": "0.00",
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

<a name="content_tickets_get_ticket_id" />
### GET /ticket/:id
**:id** _integer_  Thrillcall ID

Params:

- None

Returns:  Ticket _Hash_

``` js
    // Example: GET /api/v3/ticket/819883?api_key=1234567890abcdef

    {
      "created_at": "2012-03-02T18:06:14Z",
      "currency": "USD",
      "description": null,
      "event_id": 1047075,
      "id": 819883,
      "marketing_text": null,
      "max_ticket_price": "85.00",
      "min_ticket_price": "29.00",
      "name": "Onsale to General Public",
      "on_sale_end_date": null,
      "on_sale_start_date": null,
      "seat_info": null,
      "updated_at": "2012-03-02T18:06:14Z",
      "url": "http://ticketsus.at/thrillcall?CTY=39&DURL=http://www.ticketmaster.com/event/1C00486178A1251A?camefrom=CFC_BUYAT&brand=[=BRAND=]"
    }
```

<a name="content_mappings" />
## Mappings
Mappings provide a translation between a Thrillcall ID and an ID from another source (partner).

They are used in place of IDs in the following format:

``` js
  partner_name:obj_type:partner_id
```

For example:

``` js
  GET /artist/myspace:artist:alicia_keys
```

Fields:

- **created\_at**            _string_   ISO 8601 representation the time this object was created
- **id**                     _integer_  Thrillcall ID of the mapping, not the referenced object
- **obj\_type**              _integer_  Type of the referenced object, e.g. "artist"
- **partner\_display\_name** _string_   The name of the object according to the partner, if different
- **partner\_id**            _string_   The name of the partner for this foreign mapping, e.g. "myspace"
- **partner\_obj\_id**       _string_   Partner's ID for the referenced object
- **tc_obj_id**              _integer_  Thrillcall ID of the referenced object
- **updated\_at**            _string_   ISO 8601 representation of last time this object was updated

<a name="content_mappings_get_mappings" />
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

<a name="content_mappings_get_mapping_id" />
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


<a name="content_mappings_post_mapping" />
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

<a name="content_mappings_put_mapping_id" />
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
