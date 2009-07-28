class TweetPong::Stage::Ball < TweetPong::Stage::Object

  def initialize
    @fixed = false
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

