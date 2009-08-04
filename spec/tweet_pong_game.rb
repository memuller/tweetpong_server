require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
include TweetPong::Game::SpecHelpers
describe TweetPong::Game, 'initializing stage:' do
  before(:each){create_game :valid}

  it "should be created with a fixed number of two players, fails otherwise" do
    lambda{TweetPong::Game.new}.should raise_error
    lambda{TweetPong::Game.new(@player1)}.should raise_error
    lambda{TweetPong::Game.new(1,2)}.should raise_error
  end

  it "fails if players are not from different connections" do
    @player1.username = 'test' and @player2.username = 'test'
    lambda{TweetPong::Game.new(@player1,@player2)}.should raise_error
  end

  it "state should be race_ready" do
    @game.state.should be == :race_ready
  end
end

describe TweetPong::Game, 'state machine:' do
  include TweetPong::Game::SpecHelpers

  context 'the states in general' do
    before(:each){ create_game :valid }

    it "should be ordered in an array" do
      @game.states.should be_a_kind_of Array
    end

    it "should have descriptions" do
      @game.states.each do |state|
        state[1].should be_a_kind_of String
      end
    end

    it "should have conditions to achieve the state"

  end

  context 'state-changing behavior' do
    before(:each){ create_game :valid }

    it "should jump to an specific state" do
      @game.jump_state @game.states.last[0]
      @game.state.should be == @game.states.last[0]
    end

    it "should jump to the next state" do
      old_state = @game.state
      @game.next_state
      state_okay = false
      @game.states.each_with_index do |state, i|
        if state[0] == old_state
          state_okay = true if @game.states[i+1][0] == @game.state
        end
      end
      state_okay.should be true
    end

    it "should remain in the current state if conditions are not met"

  end
end

describe TweetPong::Game, 'in-game behavior' do

  context "before set begins:" do
    before(:all){ create_game :valid}
    it "begins only if given the player that starts with the ball"
    it "begins only if the state is :set_starting"
    it "places the ball on the beggining player's side"
    it "sets ricocheting triggers"
    it "sets triggers to score points for both players"
    it "sets bonus-placement triggers"
  end

  context "during the game" do

  end


end

