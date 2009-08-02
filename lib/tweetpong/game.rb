class TweetPong::Game
  attr_reader :players

  def initialize player1, player2
    raise ArgumentError, 'Two players required.' unless player1.is_a? TweetPong::Player and player2.is_a? TweetPong::Player
    raise ArgumentError, 'Players must be different.' if player1.username == player2.username or player1 == player2
    @players = [player1,player2]

  end
end

