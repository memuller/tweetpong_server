require 'rubygems'
require 'eventmachine'
require 'tweetpong'
require 'em_protocol'
#$/ = '\0'
$games = []
$queued_players = []
$active_players = []
$connections = []
class TweetPongConnection < EventMachine::Connection
  include TweetPong::Protocol
  attr_accessor :username, :game_id, :partner_connection, :partner, :swap

  def receive_data data
    #game not started yet, queue/match players.
    if data.include?('game_id') and data.include?('username') and not defined? @game
      match_or_queue_player data
    else
      #game started. let's see its state
      if @game
        case @game.state
          when :race_ready
            @swap = 'ready'
            if @partner_connection.swap == 'ready'
              swap_clear
              @game.next_state
              send_both 'race started. NEXT: send me a packet when you finish your race. The first player to do so begins the set.'
            end
          when :race_started
            @swap = Time.now
            winner = check_race_winner
            send_both "#{winner.username} starts the set. set ready. NEXT: send me a packet when ready to begin playing."
            @game.next_state
          when :set_starting
            #both must be ready for the set to start. best create a method to check this via swap.
        end
      else
        send_error :required_info_not_send
      end
    end
  end

  #adds connection to the pool.
  def post_init
    $connections << self
    send_data 'connection ok'
  end

  #sends a message to the partner if the game is running, kills the game and both connections.
  def unbind
  end

  #send data to both peers in a game.
  def send_both data, *args
    raise TypeError unless defined? @partner_connection
    self.send_data data
    @partner_connection.send_data data
  end

  def send_error kind, *args
    send_data "error - #{kind.to_s}"
    case kind
      #player with this login name already on the queue; warn and closes.
      when :player_exists

      #ARGS info required but not sent by the client, reports the error and closes.
      when :required_info_not_send
    end
  end

  #clears both players swap space.
  def swap_clear
    @swap = nil
    @partner_connection.swap = nil
  end

  #yields true if this player is found in the player queue.
  def player_exists? username
    send_error :player_exists and return true unless $queued_players.select{|p| p.username == username}.empty?
  end

  #sets partnership information on your parner's connection.
  def set_info args={}
    %w(game partner partner_connection).each do |obj|
      instance_variable_set "@#{obj}", args[obj.to_sym] if args[obj.to_sym]
    end
  end

  #sets instance variables received in a comma-separated string.
  def set_instance_variables data, args=[]
    vars = data.split(',')
    vars.each do |block|
      var,value = block.split('=')
      var.strip! and value.strip!
      if args.include? var or args.empty?
        args.delete var
        #format conversions for some common variables and they respective types.
        if var == 'position'
          value = value.to_f
        elsif var == 'game_id'
          value = value.to_i
        end
        instance_variable_set "@#{var}", value #sets it.
      end
    end
    #if required variables were not set, report the error.
    send_error :required_info_not_send, args unless args.empty?
  end

  #matches a player and starts a game; or adds the player to the queue if no partner is found.
  def match_or_queue_player data
    set_instance_variables data, %w(game_id username)
    return false if player_exists? @username
    @player = TweetPong::Player.new @game_id, :username => @username
    partner_found = false
    $queued_players.each do |waiting|
      if @player.matches? waiting

        #starts the new game and adds info to this connection
        @game = TweetPong::Game.new *@player.match!(waiting)
        @partner = waiting
        @partner_connection = $connections.find{|c| c.username == @partner.username}

        #adds the same info to the paired connection
        @partner_connection.set_info :game => @game, :partner => @player, :partner_connection => self

        #deletes the partnered player from the queue list, adds the new game to the game list, and its players to the active ones.
        $queued_players.delete @partner
        $active_players << @player and $active_players << @partner
        $games << @game

        #found partner, no need to search further
        partner_found = true
        break
      end
    end
    if partner_found
      send_both 'partner found, game started. NEXT: send me a packet when in ready to race.'
    else
      $queued_players << @player
      send_data 'waiting partner'
    end
  end

  #checks who starts the set.
  def check_race_winner
    return @player if @partner_connection.swap.nil?
    if @partner_connection.swap < swap
      winner =  @partner
    else
      winner = @player
    end
    swap_clear
    return winner

  end

end

EventMachine::run do
  EventMachine::start_server "localhost", 8081, TweetPongConnection
  #EventMachine::add_periodic_timer(5) do

end

