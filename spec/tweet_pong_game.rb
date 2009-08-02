require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TweetPong::Game do
  before :each do
    @player1 = TweetPong::Player.new(2111, :username => 'test1')
    @player2 = TweetPong::Player.new(2111, :username => 'test2')
    @game = TweetPong::Game.new(@player1,@player2)
  end

  it "should be created with a fixed number of two players" do
    lambda{TweetPong::Game.new}.should raise_error
    lambda{TweetPong::Game.new(@player1)}.should raise_error
    lambda{TweetPong::Game.new(1,2)}.should raise_error
  end

  it "players should be different connections" do
    @player1.username = 'test' and @player2.username = 'test'
    lambda{TweetPong::Game.new(@player1,@player2)}.should raise_error
  end

end

