require 'spec'
require 'rubygems'
require 'redgreen'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tweetpong'

Spec::Runner.configure do |config|

end
module TweetPong::Game::SpecHelpers
  def create_game kind = :valid
    case kind
      when :valid
        @player1 = TweetPong::Player.new(2111, :username => 'test1')
        @player2 = TweetPong::Player.new(2111, :username => 'test2')
        @game = TweetPong::Game.new(@player1,@player2)
    end
  end
end

