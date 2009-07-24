class TweetPong::Ball
  attr_accessor :x, :y
  @speedy = 80
  @speedx = 25
  @gravity = 0
  @bounce = -1
  @wallL = 0
  @wallR = 320
  @floor = 240
  @top = 0
  @x, @y = 0

loop do
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
  
  puts "#{ball[:x]} #{ball[:y]}"
  
  sleep 1.0/25
end
