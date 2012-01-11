require 'spec_helper'
require 'thrillcall-api'
require 'ap'
require 'faker'

# Set to one of :development, :staging, :production
TEST_ENV                  = :development

# For the environment specified in TEST_ENV, you must have set a few system environment variables.
# For example, if your TEST_ENV is :development, you need:
# TC_DEVELOPMENT_API_KEY        : your API key
# TC_DEVELOPMENT_EMAIL          : the email address (login) for the test account if testing the Person endpoint
# TC_DEVELOPMENT_PASSWORD       : the password for the test account if testing the Person endpoint
# TC_DEVELOPMENT_KNOWN_UID      : a facebook user ID that is known in the database
# TC_DEVELOPMENT_KNOWN_TOKEN    : a facebook oauth token matching the above ID which is in the database
# TC_DEVELOPMENT_KNOWN_EMAIL    : an email address matching the above ID which is in the database
# TC_DEVELOPMENT_UNKNOWN_UID    : a facebook user ID that is not known in the database
# TC_DEVELOPMENT_UNKNOWN_TOKEN  : a facebook oauth token matching the above ID which is not in the database
# TC_DEVELOPMENT_UNKNOWN_EMAIL  : an email address matching the above ID which is not in the database

# Place something like this in your bash_login script:
# export TC_DEVELOPMENT_API_KEY="1234567890abcdef"
# export TC_DEVELOPMENT_EMAIL="some_account@thrillcall.com"
# export TC_DEVELOPMENT_PASSWORD="some_password"
# export TC_DEVELOPMENT_KNOWN_UID="12345679"
# export TC_DEVELOPMENT_KNOWN_TOKEN="AAC93tkWRL4BAFzv8mYYZCEqbZCwvZBJGQ6rbCwwZCXhlcDMj4lI3lJRJzhd7FQPb9bK3J9155eVI0jIACZCoympMm1SYoEJajaRULY"
# export TC_DEVELOPMENT_UNKNOWN_UID="123123bogus"
# export TC_DEVELOPMENT_UNKNOWN_TOKEN="123123bogus"

# You should not have to edit anything below this line.
#####################################################################

env_prefix = TEST_ENV.to_s.upcase

TEST_KEY                  = ENV["TC_#{env_prefix}_API_KEY"]
PERSON_EMAIL              = ENV["TC_#{env_prefix}_EMAIL"]
PERSON_PASSWORD           = ENV["TC_#{env_prefix}_PASSWORD"]

PERSON_KNOWN_UID          = ENV["TC_#{env_prefix}_KNOWN_UID"]
PERSON_KNOWN_TOKEN        = ENV["TC_#{env_prefix}_KNOWN_TOKEN"]
PERSON_KNOWN_EMAIL        = ENV["TC_#{env_prefix}_KNOWN_EMAIL"]
PERSON_UNKNOWN_UID        = ENV["TC_#{env_prefix}_UNKNOWN_UID"]
PERSON_UNKNOWN_TOKEN      = ENV["TC_#{env_prefix}_UNKNOWN_TOKEN"]
PERSON_UNKNOWN_EMAIL      = ENV["TC_#{env_prefix}_UNKNOWN_EMAIL"]

HOST                      = "http://localhost:3000/api/"                    if TEST_ENV == :development
HOST                      = "https://secure-zion.thrillcall.com:443/api/"   if TEST_ENV == :staging        # SSL!
HOST                      = "https://api.thrillcall.com:443/api/"           if TEST_ENV == :production     # SSL!

LIMIT                     = 14
TINY_LIMIT                = 3

POSTAL_CODE               = "94108"

PERSON_PROVIDER           = :facebook
PERSON_CREATE_FIRSTNAME   = Faker::Name.first_name
PERSON_CREATE_LASTNAME    = Faker::Name.last_name
PERSON_CREATE_EMAIL       = Faker::Internet.email
PERSON_CREATE_PASSWORD    = Faker::Lorem.words(2).join('')
PERSON_CREATE_LOCATION    = "San Francisco, CA"
PERSON_CREATE_LAT         = 38.5
PERSON_CREATE_LONG        = -123.0
PERSON_CREATE_POSTALCODE  = POSTAL_CODE

FLUSH_CACHE               = true # false

describe "ThrillcallAPI" do

  def setup_key
    @tc = ThrillcallAPI.new(TEST_KEY, :base_url => HOST)
    
    @tc_permissions = @tc.api_key.permissions
    @tc_permissions.length
    @tc_permissions = @tc_permissions.data
    
    # api_auth permission allows you to access the Person endpoints.
    # api_read permission allows you to access all other endpoints.
  end

  def has_permission?(p=:api_read)
    (@tc_permissions.include? p.to_s)
  end

  def mark_pending_if_no_permission(p = :api_read)
    unless has_permission? p
      pending "TEST_KEY permissions #{@tc_permissions} do not include #{p}"
    end
  end

  def mark_pending_if_nil_value(h)
    h.each do |k, v|
      if v.nil?
        pending "Required parameter #{k} is nil!"
      end
    end
  end

  def setup_read
    if has_permission? :api_read
      day_buffer            = 0
      range                 = 365

      @min_date             = (Time.now - 60*60*24*(range+day_buffer)).to_date.to_s
      @max_date             = (Time.now - 60*60*24*day_buffer).to_date.to_s

      event_finder          = {
        :must_have_tickets    => true,
        :postalcode           => POSTAL_CODE,
        :radius               => 10,
        :limit                => TINY_LIMIT
      }

      events                = @tc.events(event_finder)
      events.length

      @event                = events.first
      @event_id             = @event["id"]

      @ticket               = @tc.event(@event_id).tickets.first
      @artist               = @tc.event(@event_id).artists.first
      @venue                = @tc.event(@event_id).venue

      @artist_id            = @artist["id"]
      @artist_norm_name     = @artist["name"]

      @venue_id             = @venue["id"]
      @venue_norm_name      = @venue["name"]
      @venue_zip            = @venue["postalcode"]

      @event_zip            = @venue_zip

      @ticket_id            = @ticket["id"]

      @lat                  = @venue["latitude"]
      @long                 = @venue["longitude"]

      @genre_id             = @artist["primary_genre_id"]
      @metro_area_id        = @venue["metro_area_id"]

      puts "Using Thrillcall objects:"
      puts "Event:    #{@event_id}"
      puts "Artist:   #{@artist_id} #{@artist_norm_name}"
      puts "Venue:    #{@venue_id} #{@venue_norm_name}"
      puts "Ticket:   #{@ticket_id}"
      puts "Metro:    #{@metro_area_id}"
      puts "Genre:    #{@genre_id}"
    end
  end

  # Flush memcache results
  before :all do
    if TEST_ENV == :development
      if FLUSH_CACHE
        fork do
          exec "echo 'flush_all' | nc localhost 11211"
        end

        Process.wait
      end
    end
  end

  it "the test suite should be able to retrieve the environment variables correctly" do
    TEST_KEY.should_not be_nil
  end

  it "should initialize properly with faraday" do
    tc = nil
    lambda { tc = ThrillcallAPI.new(TEST_KEY, :base_url => HOST) }.should_not raise_error
    puts tc.inspect
    tc.conn.class.should == Faraday::Connection
  end

  it "should be able to retrieve the permissions for the api key" do
    tc = ThrillcallAPI.new(TEST_KEY, :base_url => HOST)
    tc_permissions = tc.api_key.permissions
    tc_permissions.length
    tc_permissions = tc_permissions.data
    tc_permissions.class.should == Array
  end

  it "should return a 401 error if using an invalid API key" do
    tc = ThrillcallAPI.new("bogus key", :base_url => HOST)

    tc_permissions = tc.api_key.permissions
    lambda {
      tc_permissions.length
    }.should raise_error
  end

  context "an authenticated user with get permission" do

    before :all do
      setup_key
      setup_read
    end

    before :each do
      mark_pending_if_no_permission(:api_read)
    end

    it "should be able to handle a method with a block used on fresh data" do
      e = @tc.events(:limit => LIMIT)
      c = 0
      e.each do |ev|
        c += 1
      end
      c.should == e.length
    end

    it "should be able to make multiple requests after initialization" do
      a = @tc.artist(@artist_id)
      b = @tc.events(:limit => LIMIT)
      a["id"].should == @artist_id
      b.length.should == LIMIT
    end

    # This is the only remaining limitation of the wrapper
    it "should not be able to make an additional request after using the data from an intermediate request" do
      a = @tc.artist(@artist_id)
      a["id"].should == @artist_id
      lambda { e = a.events }.should raise_error
    end

    # This behavior cannot be iterated due to the previous limitation
    it "should be able to build a nested request from a preexisting intermediate unfetched request" do
      venue_intermediate_request = @tc.event(@event_id)
      v = venue_intermediate_request.venue
      v["id"].should == @venue_id
    end

    it "should fetch data when responding to an array or a hash method" do
      a = @tc.artists(:limit => LIMIT)
      r = a.pop
      r["id"].should_not be_nil

      e = @tc.artist(r["id"])
      (e.has_key? "genre_tags").should be_true
    end

    it "should respond to methods from Enumerable" do
      a = @tc.artists(:limit => LIMIT)
      c = 0
      a.each do |artist|
        artist["id"].should_not be_nil
        c += 1
      end
      c.should == LIMIT
    end

    it "should raise NoMethodError when given a method the data doesn't respond to after fetched" do
      a = @tc.artists(:limit => LIMIT)
      a.length.should == LIMIT
      lambda { a.bazooka }.should raise_error NoMethodError
    end

    it "should not return filtered attributes" do
      v = @tc.venue(@venue_id)
      v["alt_city"].should be_nil
    end

    context "accessing the event endpoint" do
      it "should get a list of events" do
        # This call sets up the Result object and returns an instance of ThrillcallAPI
        e = @tc.events(:limit => LIMIT)

        # This call executes fetch_data because @data responds_to .length
        e.length.should == LIMIT

        # Now e behaves as a hash
      end

      it "should get a specific event" do
        e = @tc.event(@event_id)
        e["id"].should == @event_id
      end

      it "should get tickets for a specific event" do
        e = @tc.event(@event_id).tickets
        # FIXME: "product" here should be "ticket"
        e.first["id"].should == @ticket_id
      end

      it "should get artists for a specific event" do
        e = @tc.event(@event_id).artists
        e.first["id"].should == @artist_id
      end

      it "should get the venue for a specific event" do
        e = @tc.event(@event_id).venue
        e["id"].should == @venue_id
      end

      it "should verify the behavior of the min_date param" do
        e = @tc.events(:limit => TINY_LIMIT, :min_date => @min_date)
        e.length.should == TINY_LIMIT
        e.each do |ev|
          DateTime.parse(ev["start_date"]).should >= DateTime.parse(@min_date)
        end
      end

      it "should verify the behavior of the max_date param" do
        e = @tc.events(:limit => TINY_LIMIT, :min_date => @min_date, :max_date => @max_date)
        e.length.should == TINY_LIMIT
        e.each do |ev|
          DateTime.parse(ev["start_date"]).should < (DateTime.parse(@max_date) + 1)
        end
      end

      it "should verify the behavior of the time_zone param" do
        tz      = "Asia/Tokyo"
        offset  = 9/24.0
        e = @tc.events(:limit => TINY_LIMIT, :min_date => @min_date, :max_date => @max_date, :time_zone => tz)
        e.length.should == TINY_LIMIT
        e.each do |ev|
          
          d = DateTime.parse(ev["start_date"]).new_offset(offset)
          
          d.should >= DateTime.parse(@min_date).new_offset(offset)
          d.should < (DateTime.parse(@max_date).new_offset(offset) + 1)
        end
      end

      it "should verify the behavior of the page param" do
        offset = 1
        e = @tc.events(:limit => TINY_LIMIT * 2)
        o = @tc.events(:limit => TINY_LIMIT, :page => 1)
        e.length.should == TINY_LIMIT * 2
        o.length.should == TINY_LIMIT
        (e - o).length.should == TINY_LIMIT
      end

      it "should verify the behavior of the confirmed_events_only param" do
        e = @tc.events(:limit => LIMIT, :confirmed_events_only => true)
        e.each do |ev|
          ev["unconfirmed_location"].should == 0
        end
      end

      it "should verify the behavior of the must_have_tickets param" do
        e = @tc.events(:limit => TINY_LIMIT, :must_have_tickets => true)
        e.length.should == TINY_LIMIT
        e.each do |ev|
          t = @tc.event(ev["id"]).tickets
          t.length.should_not == 0
        end
      end

      it "should verify the behavior of the lat long params" do
        e = @tc.events(:limit => TINY_LIMIT, :lat => @lat, :long => @long, :radius => 0)
        e.each do |ev|
          (@tc.event(ev["id"]).venue["latitude"].to_f - @lat).should   <= 1.0
          (@tc.event(ev["id"]).venue["longitude"].to_f - @long).should <= 1.0
        end
      end

      it "should verify the behavior of the postalcode param" do
        pending "Need to be able to access the ZipCodes table externally from Rails"
        e = @tc.events(:limit => TINY_LIMIT, :postalcode => POSTAL_CODE)
        e.length.should <= TINY_LIMIT
        e.each do |ev|
          ev["venue_id"].should_not be_nil
          v = @tc.venue(ev["venue_id"])

          v["postalcode"].should == POSTAL_CODE
        end
      end

      it "should verify the behavior of the radius param" do
        pending
      end

      #############
      # Can't verify the behavior below without more access to data on the Rails side
      it "should verify the behavior of the ticket_type param" do
        pending "Need to be able to access the Merchants table externally from Rails"
        e = @tc.events(:limit => TINY_LIMIT, :must_have_tickets => true)
        e.length.should == TINY_LIMIT
        e.each do |ev|
          t = @tc.event(ev["id"]).tickets(:ticket_type => "primary")
          t.each do |ticket|
            ticket
          end
          t.length.should be_empty
        end
      end
      #################

    end

    context "accessing the artist endpoint" do
      it "should get a list of artists" do
        a = @tc.artists(:limit => LIMIT)
        a.length.should == LIMIT
      end

      it "should get a specific artist" do
        a = @tc.artist(@artist_id)
        a["id"].should == @artist_id
      end

      it "should get a list of events for a specific artist" do
        a = @tc.artist(@artist_id).events
        found = false
        a.each do |event|
          found = found || (event["id"] == @event_id)
          break if found
        end
        found.should be_true
      end
    end

    context "accessing the venue endpoint" do
      it "should get a list of venues" do
        v = @tc.venues(:limit => LIMIT)
        v.length.should == LIMIT
      end

      it "should get a specific venue" do
        v = @tc.venue(@venue_id)
        v["id"].should == @venue_id
      end

      it "should directly return a postalcode" do
        v = @tc.venue(@venue_id)
        v["postalcode"].should == @venue_zip
      end

      it "should return a list of events for a specific venue" do
        e = @tc.venue(@venue_id).events
        e.length.should > 0
      end

    end

    context "accessing the ticket endpoint" do
      it "should get a list of tickets" do
        p = @tc.tickets(:limit => LIMIT)
        p.length.should == LIMIT
      end

      it "should get a specific ticket" do
        p = @tc.ticket(@ticket_id)
        p["id"].should == @ticket_id
      end
    end

    context "searching for an object with a term" do
      it "should find the right artists" do
        a = @tc.search.artists(@artist_norm_name)
        found = false
        a.each do |artist|
          if artist["id"] == @artist_id
            found = true
            break
          end
        end
        found.should be_true
      end

      it "should find the right venues" do
        v = @tc.search.venues(@venue_norm_name)
        found = false
        v.each do |venue|
          if venue["id"] == @venue_id
            found = true
            break
          end
        end
        found.should be_true
      end

    end

    context "accessing the metro area endpoint" do
      it "should get a specific metro area" do
        m = @tc.metro_area(@metro_area_id)
        m["id"].should == @metro_area_id
      end

      it "should get a list of metro areas" do
        m = @tc.metro_areas(:limit => LIMIT)
        m.length.should == LIMIT
      end

      it "should get a list of events for a specific metro" do
        e = @tc.metro_area(@metro_area_id).events
        cur_venue_id = e.first["venue_id"]

        @tc.venue(cur_venue_id)["metro_area_id"].should == @metro_area_id
      end
    end

    context "accesing the genre endpoint" do
      it "should get a specific genre" do
        g = @tc.genre(@genre_id)
        g["id"].should == @genre_id
      end

      it "should get a list of genres" do
        g = @tc.genres(:limit => LIMIT)
        g.length.should == LIMIT
      end

      it "should get a list of artists for a specific genre" do
        g = @tc.genre(@genre_id).artists
        g.first["primary_genre_id"].should == @genre_id
      end
    end

  end

  context "an authenticated user with api_auth permission" do
    before :all do
      setup_key
    end

    before :each do
      mark_pending_if_no_permission(:api_auth)
    end

    context "accesing the person endpoint" do
      it "should be able to login a person using login/password credentials" do
        # Don't forget to change the credentials in your environment variables
        params = {
          :email    => PERSON_EMAIL,
          :password => PERSON_PASSWORD
        }
        mark_pending_if_nil_value(params)
        p = @tc.person.signin.post(params)
        (p["email"] || p["login"]).should == PERSON_EMAIL
      end

      it "should be able to login a person using provider/uid/token credentials" do
        params = {
          :provider => PERSON_PROVIDER,
          :uid      => PERSON_KNOWN_UID,
          :token    => PERSON_KNOWN_TOKEN
        }
        mark_pending_if_nil_value(params)
        p = @tc.person.signin.post(params)
        (p["email"] || p["login"]).should == PERSON_KNOWN_EMAIL
      end

      it "should be able to create a person using the registration endpoint" do
        params = {
          :first_name   => PERSON_CREATE_FIRSTNAME,
          :email        => PERSON_CREATE_EMAIL,
          :password     => PERSON_CREATE_PASSWORD,
          :postalcode   => PERSON_CREATE_POSTALCODE,
          :test         => true
        }
        mark_pending_if_nil_value(params)
        p = @tc.person.signup.post(params)
        p["first_name"].should == PERSON_CREATE_FIRSTNAME
      end

      it "should return a proper error message on failed login" do
        params = {
          :email    => PERSON_EMAIL,
          :password => rand(1000000)
        }
        lambda {
          p = @tc.person.signin.post(params)
        }.should raise_error
      end

      context "autoregistration for unknown provider/uid" do
        it "should be able to create a person using location name" do
          params = {
            :provider       => PERSON_PROVIDER,
            :uid            => PERSON_UNKNOWN_UID,
            :token          => PERSON_UNKNOWN_TOKEN,
            :email          => PERSON_UNKNOWN_EMAIL,
            :first_name     => PERSON_CREATE_FIRSTNAME,
            :last_name      => PERSON_CREATE_LASTNAME,
            :location_name  => PERSON_CREATE_LOCATION,
            :test           => true
          }

          mark_pending_if_nil_value(params)

          p = @tc.person.signin.post(params)

          p["first_name"].should == PERSON_CREATE_FIRSTNAME
        end
        
        it "should be able to create a person using (lat, long) for location" do
          params = {
            :provider       => PERSON_PROVIDER,
            :uid            => PERSON_UNKNOWN_UID,
            :token          => PERSON_UNKNOWN_TOKEN,
            :email          => PERSON_UNKNOWN_EMAIL,
            :first_name     => PERSON_CREATE_FIRSTNAME,
            :last_name      => PERSON_CREATE_LASTNAME,
            :lat            => PERSON_CREATE_LAT,
            :long           => PERSON_CREATE_LONG,
            :test           => true
          }

          mark_pending_if_nil_value(params)

          p = @tc.person.signin.post(params)

          p["first_name"].should == PERSON_CREATE_FIRSTNAME
        end
      end
    end
  end

end
