class TweetPong::Stage::Ball < TweetPong::Stage::Object

  def initialize
    @fixed = false
    @centered_register = true
    super
  end

  def bounce axis
    raise TypeError, "Axis should be :x or :y" unless [:x, :y].include? axis
    if axis == :x
      @x_speed *= -1
    else
      @y_speed *= -1
    end
  end

end
=begin
controlSpeed = 10
if (ball.y > ricochet.y && (ball.x > ricochet.x  && ball.x < (ricochet.x + ricochet.width))) {

				ball.y = ricochet.y;
				//speedy *= bounce;
				var half = ricochet.width / 2;
				var colisionx =   (ricochet.x + ricochet.width / 2) - ball.x;
				speedx = - Math.round((colisionx * controlSpeed / half));


				speedy = speedx.toString().indexOf("-") != -1 ? controlSpeed + speedx : controlSpeed - speedx;
				speedy *= bounce;

				if(speedy == 0){
					speedy = controlSpeed;
				}

			}
=end

