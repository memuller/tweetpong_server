class TweetPong::Player
  attr_accessor :username, :challenger
  attr_reader :game_id, :logged_at

  def initialize game_id, args={}
    raise ArgumentError, 'Game id should be an integer.' unless game_id.is_a? Integer
    @game_id = game_id
    @username = args[:username] if args[:username]
    @challenger = args[:challenger] ? args[:challenger] : true
    @logged_at = Time.now
    @scores = {:points => 0, :sets => 0, :games => 0}
  end

  def challenger?; @challenger; end
  def challenged?; not @challenger; end
  def score kind = :points
    raise ArgumentError, 'Scores are only :points, :sets and :games.' unless [:points, :sets, :games].include? kind
    @scores[kind]
  end

  def score!
    @scores[:points] += 1
    @scores[:sets] += 1 and @scores[:points] = 0 if @scores[:points] >= 5
    @scores[:games] += 1 and @scores[:sets] = 0 if @scores[:sets] >= 3
  end

  def matches? partner
    raise ArgumentError, 'Must pass an instance of Player to match with.' unless partner.is_a? TweetPong::Player
    return false if self == partner or @username == partner.username
    @game_id == partner.game_id ? true : false
  end

  def match! partner
    raise ArgumentError, 'Must pass an instance of Player to match with.' unless partner.is_a? TweetPong::Player
    return false unless self.matches? partner
    a = [self,partner].sort{|a,b| a.logged_at <=> b.logged_at}
    a.first.challenger = true and a.last.challenger = false
    return a
  end

end

