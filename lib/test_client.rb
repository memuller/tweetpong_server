require 'rubygems'
require 'socket'

def connect
  $client = TCPSocket.open 'localhost', 8081
  $client.puts "game_id = 1, username = test#{rand(200)}"
end

def put arg
  $client.puts arg
end

def recv
  puts $client.recv 512
end

#connects
connect

