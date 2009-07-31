class TweetPong::Player
  attr_accessor :username, :challenger
  attr_reader :game_id

  def initialize game_id, args={}
    raise ArgumentError, 'Game id should be an integer.' unless game_id.is_a? Integer
    @game_id = game_id
    @username = args[:username] if args[:username]
    @challenger = args[:challenger] ? args[:challenger] : true
    @scores = {:points => 0, :sets => 0, :games => 0}
  end

  def challenger?; @challenger; end
  def challenged?; not @challenger; end

  def score kind = :points
    raise ArgumentError, 'Scores are only :points, :sets and :games.' unless kind.is_a? Symbol and [:points, :sets, :games].include? kind
    @scores[kind]
  end

  def score! kind = :points
    raise ArgumentError, 'Scores are only :points, :sets and :games.' unless kind.is_a? Symbol and [:points, :sets, :games].include? kind
    @scores[kind] += 1
    case kind
      when :points
        @scores[:sets] += 1 and @scores[:points] = 0 if @scores[:points] >= 5
      when :sets
        @scores[:games] += 1 and @scores[:sets] = 0 if @scores[:sets] >= 3
    end
  end

end

