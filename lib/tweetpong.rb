require 'socket'
server = TCPServer.open('10.0.1.132',6673)
@thread_pool = []
@accepted_threads = 0
loop do
  Thread.start(server.accept) do |session|
    puts "thread/session started with #{session.peeraddr}"
    @speedy = 50.0;
    @speedx = 50.0;
    @gravity = 0.0;
    @bounce = -1;
    @wallL = 0.0;
    @wallR = 320.0;
    @floor = 240.0;
    @top = 0.0;
    ball = {:x => 0.0, :y => 0.0}
    #while session.gets
      #puts $_.dump
      #session.puts "<item>#{$_.dump.strip}</item>"
    #end
    loop{
      @speedy += @gravity;
      ball[:y] += @speedy/5;
      ball[:x] += @speedx/5;

      if ball[:y] > @floor
      	ball[:y] = @floor;
      	@speedy = @speedy * @bounce;
      end

      if ball[:y] < @top 
      	ball[:y] = @top;
      	@speedy = @speedy * @bounce;
      end

      if ball[:x] > @wallR 
      	ball[:x] = @wallR;
      	@speedx = @speedx * @bounce;
      end

      if ball[:x] < @wallL 
      	ball[:x] = @wallL;
      	@speedx = @speedx * @bounce;
      end
      session.puts "<item x='#{ball[:x]}' y='#{ball[:y]}'></item>\0"
      sleep 1.0/30
    }
  end
end
