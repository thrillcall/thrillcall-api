require 'spec_helper'
require 'thrillcall-api'
require 'ap'
require 'faker'

# Set to one of :development, :staging, :production
TEST_ENV  = :development

TEST_KEY  = "202c83b947d87687" if TEST_ENV == :development
TEST_KEY  = "xxxxxxxxxxxxxxxx" if TEST_ENV == :staging
TEST_KEY  = "xxxxxxxxxxxxxxxx" if TEST_ENV == :production

HOST      = "http://localhost:3000/api/"                    if TEST_ENV == :development
HOST      = "https://secure-zion.thrillcall.com:443/api/"   if TEST_ENV == :staging        # SSL!
HOST      = "https://api.thrillcall.com:443/api/"           if TEST_ENV == :production     # SSL!

LIMIT             = 14
TINY_LIMIT        = 3

POSTAL_CODE       = "94108"

# You need to create this user on your localhost
PERSON_LOGIN      = "test@example.com"
PERSON_PASSWORD   = "testtest"

PERSON_CREATE_FIRSTNAME = Faker::Name.first_name
PERSON_CREATE_EMAIL = Faker::Internet.email
PERSON_CREATE_PASSWORD = Faker::Lorem.words(2).join('')
PERSON_CREATE_POSTALCODE = POSTAL_CODE

FLUSH_CACHE       = true # false

describe "ThrillcallAPI" do

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

  it "should initialize properly with faraday" do
    tc = nil
    lambda { tc = ThrillcallAPI.new(TEST_KEY, :base_url => HOST) }.should_not raise_error
    puts tc.inspect
    tc.conn.class.should == Faraday::Connection
  end

  context "an authenticated user" do

    before :all do
      @tc = ThrillcallAPI.new(TEST_KEY, :base_url => HOST)

      day_buffer            = 0
      range                 = 365

      @min_date             = (Time.now - 60*60*24*(range+day_buffer)).to_date.to_s
      @max_date             = (Time.now - 60*60*24*day_buffer).to_date.to_s

      event_finder          = {
        :must_have_tickets    => true,
        :postalcode           => POSTAL_CODE,
        :radius               => 10,
        #:min_date             => @min_date,
        #:max_date             => @max_date,
        :limit                => TINY_LIMIT
      }

      events                = @tc.events(event_finder)
      events.length

      puts events.inspect

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

      puts "Event:    #{@event_id}"
      puts "Artist:   #{@artist_id} #{@artist_norm_name}"
      puts "Venue:    #{@venue_id} #{@venue_norm_name}"
      puts "Ticket:   #{@ticket_id}"
      puts "Metro:    #{@metro_area_id}"
      puts "Genre:    #{@genre_id}"
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
    it "should be able to build a nested request from a preexisting intermediate request" do
      pending "FIXME"
      artist_request  = @tc.artist(@artist_id)
      artist_request  = artist_request.events(:limit => TINY_LIMIT)
      event_id        = artist_request.first["id"]
      event_request   = @tc.event(event_id)
      event_request   = event_request.artists
      event_request.first["id"].should == @artist_id
    end

    it "should fetch data when responding to an array or a hash method" do
      a = @tc.artists(:limit => LIMIT)
      r = a.pop
      r["id"].should_not be_nil

      e = @tc.artist(r["id"])
      (e.has_key? "genre_tags").should be_true
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
        pending "FIXME"
        e = @tc.venue(32065).events
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

    context "accesing the person endpoint" do
      it "should get an existing person" do
        p = @tc.person.signin.post(:login => PERSON_LOGIN, :password => PERSON_PASSWORD)
        p["login"].should == PERSON_LOGIN
      end
      
      it "should create a person" do
        p = @tc.person.signup.post(:first_name => PERSON_CREATE_FIRSTNAME,
                                   :email => PERSON_CREATE_EMAIL,
                                   :password => PERSON_CREATE_PASSWORD,
                                   :postalcode => PERSON_CREATE_POSTALCODE,
                                   :test => true)
        p["login"].should == PERSON_CREATE_EMAIL
      end
    end

  end

end
