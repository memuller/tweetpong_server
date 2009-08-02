require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TweetPong::Player do
  before :all do
    @user = TweetPong::Player.new(121212)
  end

  it "should have an game ID" do
    lambda{TweetPong::Player.new}.should raise_error
    @user.game_id.should be_a_kind_of Integer
  end

  it "should have a logged_at timestamp" do
    @user.logged_at.should be_a_kind_of Time
  end

  it "should receive a login name" do
    @user.username.should be nil
    @user.username = 'test'
    @user.username.should be == 'test'
  end

  it "should identify challenger and challenged" do
    @user.challenger?.should be true
    @user.challenged?.should be false
  end

  describe "its score control methods" do
    before(:each){@user = TweetPong::Player.new(121212)}
    it "should have scores for points, sets and games" do
      @user.score.should be == 0
      @user.score(:sets).should be == 0
      @user.score(:games).should be == 0
    end

    it "should score points" do
      old_points = @user.score
      @user.score!
      @user.score.should be == old_points + 1
    end

    it "should score a set after 5 points" do
      old_sets = @user.score :sets
      (5-@user.score).times{ @user.score! }
      @user.score(:sets).should be == old_sets + 1
    end

    it "should score a game after 3 sets" do
      old_game = @user.score :games
      (15-@user.score).times{@user.score!}
      @user.score(:games).should be == old_game + 1
    end
  end

  describe "has methods to match players together" do

    before :all do
      %w(a b c).each_with_index { |prefix,i| instance_eval("@user_#{prefix} = TweetPong::Player.new(i == 0 ? 1 : 2)") }
    end

    it "should test if users match" do
      @user_a.matches?(@user_b).should be false
      @user_b.matches?(@user_c).should be true
    end

    it "should not match with itself" do
      @user_a.matches?(@user_a).should be false
    end

    it "should match the users, returning them in order (challenger/challenged)" do
      result = @user_b.match!(@user_c)
      result.should be == [@user_b, @user_c]
      @user_b.challenger?.should be true
      @user_c.challenger?.should be false
    end
  end
end

