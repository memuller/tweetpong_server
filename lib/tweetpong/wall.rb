class TweetPong::Stage::Wall < TweetPong::Stage::Object
  def initialize
    @fixed = true
    super
  end
end

