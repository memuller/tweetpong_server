require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TweetPong::Stage::Trigger do
  before :each do
    @trigger = TweetPong::Stage::Trigger.new true do
      @i+=1
    end
    @i=0
  end

  it "should have condition and action upon creation" do
    lambda{ TweetPong::Stage::Trigger.new}.should raise_error
    lambda{ TweetPong::Stage::Trigger.new true}.should raise_error
    lambda{ TweetPong::Stage::Trigger.new{2+2}}.should raise_error
  end

  it "should have zeroed run counters" do
    @trigger.ran.should == 0
    @trigger.evaluated.should == 0
  end

  it "condition should evaluate to true or false only" do
    [true, false].include?(@trigger.condition).should be true
  end

  it "should have a call method that calls the action if the condition is met" do
    @trigger.evaluate
    @i.should == 1
  end

  it "shouldn't call action and should return nill if the condition isn't true" do
    @trigger.condition = false
    @trigger.evaluate.should be nil
    @i.should == 0
  end

  it "called counter should increase with each call" do
    old_n = @trigger.evaluated
    @trigger.evaluate
    @trigger.evaluated.should == old_n + 1
  end

  it "ran counter should increase with each run" do
    old_n = @trigger.ran
    @trigger.evaluate
    @trigger.ran.should == old_n + 1
    @trigger.condition = false and @trigger.evaluate
    @trigger.ran.should == old_n + 1
  end

end

