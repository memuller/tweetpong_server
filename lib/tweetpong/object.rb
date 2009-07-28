module TweetPong::Stage::Object
  attr_accessor :x, :y

  def movable?
    not @fixed
  end

  def moving?
    @xspeed > 0 or @yspeed > 0
  end


end

