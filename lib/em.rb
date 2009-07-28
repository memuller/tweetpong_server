require 'rubygems'
require 'eventmachine'

$/ = '\0'
$games = []

module TweetPongConnection
  def post_init
    puts "new connection started with #{self.class} and #{self.id}"
  end

  def unbind
    puts "disconnected."
  end

  def receive_data data
    send_data "#{data}"
  end


end

EventMachine::run do
  EventMachine::start_server "localhost", 8081, TweetPongConnection
  EventMachine::add_periodic_timer(5) do
    puts $games * ', '
  end
end

