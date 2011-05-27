require 'spec_helper'
require 'thrillcall-api'

TEST_KEY  = "374a89fd4629d57c"
LOCALHOST = "http://localhost:9292/api/"

describe "ThrillcallAPI" do
  
  it "should initialize properly with faraday" do
    tc = nil
    lambda { tc = ThrillcallAPI.new(TEST_KEY, LOCALHOST) }.should_not raise_error
    puts tc.inspect
    tc.conn.class.should == Faraday::Connection
  end
  
  it "should get a list of events" do
    tc = ThrillcallAPI.new(TEST_KEY, LOCALHOST)
    e = tc.events(14)
    e.length.should == 14
  end
  
end
