require 'spec_helper'
require 'thrillcall-api'
require 'ap'

TEST_KEY  = "374a89fd4629d57c"
LOCALHOST = "http://localhost:9292/api/"

ARTIST_ID       = 22210
ARTIST_EVENT_ID = 589331
# this event will stop working if min_date is specified after august 2011
EVENT_ID        = 753419
EVENT_TICKET_ID = 455663
EVENT_ARTIST_ID = 2192
LIMIT           = 14

describe "ThrillcallAPI" do
  
  it "should initialize properly with faraday" do
    tc = nil
    lambda { tc = ThrillcallAPI.new(TEST_KEY, LOCALHOST) }.should_not raise_error
    puts tc.inspect
    tc.conn.class.should == Faraday::Connection
  end
  
  context "as an authenticated user" do
    
    before :each do
      @tc = ThrillcallAPI.new(TEST_KEY, LOCALHOST)
    end
    
    context "event" do
      it "should get a list of events" do
        e = @tc.events(:limit => LIMIT)
        e.length.should == LIMIT
      end
      
      it "should get a specific event" do
        e = @tc.event(EVENT_ID)
      end
      
      it "should get tickets for a specific event" do
        e = @tc.event(EVENT_ID).tickets
        e.first["product"]["id"].should == EVENT_TICKET_ID
      end
      
      it "should get artists for a specific event" do
        e = @tc.event(EVENT_ID).artists
        e.first["artist"]["id"].should == EVENT_ARTIST_ID
      end
      
      it "should verify the behavior of themust_have_tickets param"
      it "should verify the behavior of the min_date param"
      it "should verify the behavior of the max_date param"
      it "should verify the behavior of the offset param"
      it "should verify the behavior of the postalcode param"
      it "should verify the behavior of the radius param"
      it "should verify the behavior of the supress param"
      it "should verify the behavior of the confirmed_events_only param"
      it "should verify the behavior of the ticket_type param"
      it "should verify the behavior of the sort_by param"
      it "should verify the behavior of the partner param"
      
    end
    
    context "artist" do
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
        a.first["event"]["id"].should == ARTIST_EVENT_ID
      end
    end
    
    it "should be able to make multiple requests after initialization" do
      a = @tc.artist(ARTIST_ID)
      b = @tc.events(:limit => LIMIT)
      a["id"].should == ARTIST_ID
      b.length.should == LIMIT
    end
  end
  
end
