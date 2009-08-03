class TweetPong::Game
  attr_reader :players, :state, :states

  def initialize player1, player2
    raise ArgumentError, 'Two players required.' unless player1.is_a? TweetPong::Player and player2.is_a? TweetPong::Player
    raise ArgumentError, 'Players must be different.' if player1.username == player2.username or player1 == player2
    @states = [
      [:race_ready,  "Players matched, warns about race start."],
      [:race_started, "Race started. First player to send a packet starts the set."],
      [:set_starting, "Set starting with ARG player, when both are ready."],
      [:game_running, "Game running."]
    ]
    @players = [player1,player2]
    @state = states.first[0] and @state_index = 0
  end

  def next_state
    @state_index += 1
    @state = @states[@state_index][0]
  end

  def jump_state target
    @states.each_with_index do |obj, i|
      if obj[0] == target
        @state_index = i
        @state = @states[i][0]
        return true
      end
    end
    raise ArgumentError, 'Invalid state specified'
  end
end

