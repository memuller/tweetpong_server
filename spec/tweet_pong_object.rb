require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TweetPong::Stage::Object do
  before :all do
    class TweetPong::Mocked < TweetPong::Stage::Object; end
  end
  before :each do
    @obj = TweetPong::Mocked.new
  end

  describe "In its initial state" do
    it "should have a movable?/fixed property" do
      @obj.movable?.should be false
      @obj.fixed.should be true
    end

    it "should have x and y values" do
      @obj.x.should == 0.0
      @obj.y.should == 0.0
    end

    it "should have xspeed and yspeed values" do
      @obj.x_speed.should == 0.0
      @obj.y_speed.should == 0.0
    end

    it "should have width and height values" do
      @obj.height.should == 1.0
      @obj.width.should == 1.0
    end
  end

  it "should have a round property" do
    @obj.round?.should be false
    @obj.centered_register = true and @obj.width = @obj.height = 50
    @obj.round?.should be true
  end

  it "should have a method that gives distance from center in an axis" do
    lambda{ @obj.from_center(:a)}.should raise_error TypeError
    @obj.from_center(:w).should == @obj.width
    @obj.from_center(:h).should == @obj.height
    @obj.centered_register = true
    @obj.from_center(:w).should == @obj.width/2
    @obj.from_center(:h).should == @obj.height/2
  end

  it "must have a tick method that moves the object by an tick" do
    @obj.x_speed = 30 and original_x = @obj.x
    @obj.tick
    @obj.x.should == original_x + 30.0/@obj.decay_factor
  end

end

