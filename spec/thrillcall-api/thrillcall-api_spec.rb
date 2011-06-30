require 'spec_helper'
require 'thrillcall-api'
require 'ap'

TEST_KEY  = "202c83b947d87687"
PORT      = 3000
LOCALHOST = "http://localhost:#{PORT}/api/"

ARTIST_ID         = 6468
ARTIST_NORM_NAME  = "katyperry"
ARTIST_EVENT_ID   = 855667

# this event will stop working if min_date is specified after august 2011
EVENT_ID          = 753419
EVENT_TICKET_ID   = 456349
EVENT_ARTIST_ID   = 375669
EVENT_VENUE_ID    = 65023
EVENT_ZIP         = "24901"

VENUE_ID          = 12345
VENUE_NORM_NAME   = "recordexchange"
VENUE_ZIP         = "27603"

LAT               = 37.782664
LONG              = -122.410295

TICKET_ID         = 12345

POSTAL_CODE       = "94108"

LIMIT             = 14
TINY_LIMIT        = 3
MIN_DATE          = "2011-01-01"
MAX_DATE          = "2011-01-07"

FLUSH_CACHE       = true # false

describe "ThrillcallAPI" do
  
  before :all do
    if FLUSH_CACHE
      fork do
        exec "echo 'flush_all' | nc localhost 11211"
      end
      
      Process.wait
    end
  end
  
  it "should initialize properly with faraday" do
    tc = nil
    lambda { tc = ThrillcallAPI.new(TEST_KEY, :base_url => LOCALHOST) }.should_not raise_error
    puts tc.inspect
    tc.conn.class.should == Faraday::Connection
  end
  
  context "an authenticated user" do
    
    before :all do
      @tc = ThrillcallAPI.new(TEST_KEY, :base_url => LOCALHOST)
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
      a = @tc.artist(ARTIST_ID)
      b = @tc.events(:limit => LIMIT)
      a.length
      #ap a.result.data
      a["id"].should == ARTIST_ID
      b.length.should == LIMIT
    end
    
    # This is the only remaining limitation of the wrapper
    it "should not be able to make an additional request after using the data from an intermediate request" do
      a = @tc.artist(ARTIST_ID)
      a["id"].should == ARTIST_ID
      lambda { e = a.events }.should raise_error
    end
    
    # This behavior cannot be iterated due to the previous limitation
    it "should be able to build a nested request from a preexisting intermediate request" do
      artist_request  = @tc.artist(ARTIST_ID)
      artist_request  = artist_request.events(:limit => TINY_LIMIT)
      event_id        = artist_request.first["id"]
      event_request   = @tc.event(event_id)
      event_request   = event_request.artists
      event_request.first["id"].should == ARTIST_ID
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
      v = @tc.venue(VENUE_ID)
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
        e = @tc.event(EVENT_ID)
        e["id"].should == EVENT_ID
      end
      
      it "should get tickets for a specific event" do
        e = @tc.event(EVENT_ID).tickets
        # FIXME: "product" here should be "ticket"
        e.first["id"].should == EVENT_TICKET_ID
      end
      
      it "should get artists for a specific event" do
        e = @tc.event(EVENT_ID).artists
        e.first["id"].should == EVENT_ARTIST_ID
      end
      
      it "should get the venue for a specific event" do
        e = @tc.event(EVENT_ID).venue
        e["id"].should == EVENT_VENUE_ID
      end
      
      it "should verify the behavior of the min_date param" do
        e = @tc.events(:limit => TINY_LIMIT, :min_date => MIN_DATE)
        e.length.should == TINY_LIMIT
        e.each do |ev|
          DateTime.parse(ev["start_date"]).should >= DateTime.parse(MIN_DATE)
        end
      end
      
      it "should verify the behavior of the max_date param" do
        e = @tc.events(:limit => TINY_LIMIT, :min_date => MIN_DATE, :max_date => MAX_DATE)
        e.length.should == TINY_LIMIT
        e.each do |ev|
          DateTime.parse(ev["start_date"]).should < (DateTime.parse(MAX_DATE) + 1)
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
        e = @tc.events(:limit => TINY_LIMIT, :lat => LAT, :long => LONG, :radius => 0)
        e.each do |ev|
          (@tc.event(ev["id"]).venue["latitude"].to_f - LAT).should   <= 0.01
          (@tc.event(ev["id"]).venue["longitude"].to_f - LONG).should <= 0.01
        end
      end
      
      it "should verify the behavior of the postalcode param" do
        pending "Need to be able to access the ZipCodes table externally from Rails"
        e = @tc.events(:limit => TINY_LIMIT, :postalcode => POSTAL_CODE)
        e.length.should <= TINY_LIMIT
        e.each do |ev|
          ev["venue_id"].should_not be_nil
          v = @tc.venue(ev["venue_id"])
          
          z_id = v["zip_code_id"]
          z_id.should_not be_nil
          z = @tc.zip_code(z_id)
          z["zip"].should_not be_nil
          z["zip"].to_s.should == POSTAL_CODE
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
        a = @tc.artist(ARTIST_ID)
        a["id"].should == ARTIST_ID
      end
      
      it "should get a list of events for a specific artist" do
        a = @tc.artist(ARTIST_ID).events
        a.first["id"].should == ARTIST_EVENT_ID
      end
    end
    
    context "accessing the venue endpoint" do
      it "should get a list of venues" do 
        v = @tc.venues(:limit => LIMIT)
        v.length.should == LIMIT
      end
      
      it "should get a specific venue" do
        v = @tc.venue(VENUE_ID)
        v["id"].should == VENUE_ID
      end
      
      it "should directly return a postalcode" do
        v = @tc.venue(VENUE_ID)
        v["postalcode"].should == VENUE_ZIP
      end
      
      it "should return a list of events for a specific venue" do
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
        p = @tc.ticket(TICKET_ID)
        p["id"].should == TICKET_ID
      end
    end
    
    context "searching for an object with a term" do
      it "should find the right artists" do
        a = @tc.search.artists(ARTIST_NORM_NAME)
        found = false
        a.each do |artist|
          if artist["id"] == ARTIST_ID
            found = true
            break
          end
        end
        found.should be_true
      end
      
      it "should find the right venues" do
        v = @tc.search.venues(VENUE_NORM_NAME)
        found = false
        v.each do |venue|
          if venue["id"] == VENUE_ID
            found = true
            break
          end
        end
        found.should be_true
      end
      
    end
    
  end
  
end
