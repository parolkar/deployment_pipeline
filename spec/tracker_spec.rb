require "spec_helper"

describe Tracker do

  it "should act like abstract base class to help developers implement more trackers" do

    class FooTracker < Tracker
      def initialize()
        @tracker_ids = ['tracker_id']
        @api_key = 'api_key'
        super(@tracker_ids,@api_key)
      end
    end

    foo_tracker  =  FooTracker.new()
    expect {foo_tracker.story_obj("1234")}.to raise_error(RuntimeError, /Must implement #story_obj in FooTracker/)
  end

end


describe PivotalTracker do
  PIVOTAL_TRACKER_PROJECT_IDS = ['test_traker_id']
  PIVOTAL_TRACKER_TOKEN = "api_key"
  describe "#story_obj"  do
    it "should fetch story information using pivotal api" do
      mock(Net::HTTP).start(anything,anything)  {|response|
        stub(response).body {
          "<story>
            <name>Story Name</name>
            <story_type>feature</story_type>
            <requested_by>Tom</requested_by>
            <url>/path</url>
            <current_state>finished</current_state>
           </story>
          "
        }
        response
      }
      pivotal_tracker  =  PivotalTracker.new()
      story = pivotal_tracker.story_obj('1234')

      story[:name].should == "Story Name"
    end
  end
end


