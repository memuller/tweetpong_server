class TweetPong::Stage::Wall < TweetPong::Stage::Object
  def initialize args = {}
    @fixed = true
    super args
  end
end

class TweetPong::Stage::Plataform < TweetPong::Stage::Object
  def initialize
    @fixed = false
    super
  end
end

class TweetPong::Stage::Bonus < TweetPong::Stage::Object
  def initialize
    @fixed = true
    super
  end
end

