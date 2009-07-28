require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TweetPong::Stage::Ball do
  before :all do
    @ball = TweetPong::Stage::Ball.new
  end

  it "should be an stage object mixin" do
    @ball.class.superclass.should be TweetPong::Stage::Object
  end

  it "should not be fixed" do
    @ball.movable?.should be true
  end

  describe "its cute bouncing properties" do
    before :each do
      @ball.x = 0 and @ball.x_speed = 50
    end

    it "accepts an axis as a symbol" do
      lambda{ @ball.bounce(:x) }.should_not raise_error
      lambda{ @ball.bounce('a') }.should raise_error TypeError
    end

    it "should have its speed direction changed when bounced" do
      @ball.bounce :x
      @ball.x_speed.should be < 0
    end

    it "should move bouncingly" do
      5.times{@ball.tick}
      @ball.x.should == 50.0
      @ball.x_speed = 50 and @ball.bounce :x
      5.times{@ball.tick}
      @ball.x.should == 0.0
    end
  end

end

