require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TweetPong::Player do
  before :all do
    @user = TweetPong::User.new(121212)
  end
  it "should have an game ID" do
    lambda{TweetPong::User.new}.should raise_error
    @user.game_id.should be_a_instance_of Integer
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
      %w(a b c).each_with_index { |prefix,i| eval("user_#{prefix} = TweetPong::User.new(i == 0 ? 1 : 2)") }
    end

    it "should test if users match" do
      user_a.match(user_b).should_be false
      user_b.match(user_c).should_be true
    end

    it "should not match with itself" do
      user_a.match(user_a).should_be false
    end

    it "should match the users, returning them in order (challenger/challenged)" do
      result = user_b.match!(user_c)
      result.should be == [user_b, user_c]
      user_b.challenger?.should be true
      user_c.challenger?.should be false
      user_b.challenger = false and user_b.challenger = true
      user_b.match!(user_c).should be == [user_c, user_b]
    end
  end
end

