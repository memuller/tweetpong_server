require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TweetPong::Stage::Object do
  before :all do
    class TweetPong::Mocked < TweetPong::Stage::Object; end
    @obj = TweetPong::Mocked.new
  end

  describe "In its initial state" do
    it "should have a movable?/fixed property" do
      @obj.movable?.should be false
      @obj.fixed.should be true
    end

    it "should have an initial x and y values" do
      @obj.x.should == 0.0
      @obj.y.should == 0.0
    end

    it "should have an initial xspeed and yspeed values" do
      @obj.x_speed.should == 0.0
      @obj.y_speed.should == 0.0
    end
  end

  it "must have a tick method that moves the object by an tick" do
    @obj.x_speed = 30 and original_x = @obj.x
    @obj.tick
    @obj.x.should == original_x + 30.0/@obj.decay_factor
  end

end

