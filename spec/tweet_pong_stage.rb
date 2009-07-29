require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TweetPong::Stage do

  before :each do
    @stage = TweetPong::Stage.new
  end

  it "should accept any number of valid objects" do
    lambda{ @stage.associate(TweetPong::Stage::Ball.new, TweetPong::Stage::Object.new) }.should_not raise_error
    lambda{ @stage.associate(0) }.should raise_error TypeError
  end

  describe "when receiving an object, it should register it with a property that is an array of these objects" do

    it 'should have no balls' do
      @stage.balls.should be_empty
    end

    it 'should associate with a ball' do
      ball = TweetPong::Stage::Ball.new and @stage.associate ball
      @stage.balls.first.should be ball
      @stage.objects.first.should be ball
    end

    it 'should associate with a wall' do
      wall = TweetPong::Stage::Wall.new and @stage.associate wall
      @stage.walls.first.should be wall
      @stage.objects.include?(wall).should be true
    end

    it 'should associate with a bonus item' do
      bonus = TweetPong::Stage::Bonus.new and @stage.associate bonus
      @stage.bonus.first.should be bonus
      @stage.objects.include?(bonus).should be true
    end

    it 'should associate with a trigger' do
      trigger = TweetPong::Stage::Trigger.new(true){2+2}
      @stage.associate trigger
      @stage.triggers.first.should be trigger
    end
  end

  it "should have a check method that evaluates all triggers" do
    @stage.associate TweetPong::Stage::Trigger.new(true){2+2}, TweetPong::Stage::Trigger.new(false){2+2}
    @stage.check_triggers
    @stage.triggers.first.ran.should == 1
    @stage.trigger.last.ran.should == 0
    [@stage.triggers.last.evaluated, @stage.triggers.last.evaluated].select{|n| n == 1}.should == 1
  end


  it "should have a tick method that ticks all objects" do
    x_array = []
    @stage.objects.each{|obj| x_array << obj.x and obj.x_speed = 50 }
    5.times{ @stage.tick }
    @stage.objects.each_with_index{|obj,i| obj.x.should ==  x_array[i] + 50}
  end


end

