class TweetPong::Stage
  attr_reader :objects, :balls, :walls, :triggers, :bonus
  attr_accessor :width, :height

  def initialize width = 320, height = 240
    raise ArgumentError, 'Must provide width and height as integers' unless width.is_a? Integer and height.is_a? Integer
    %w(objects balls walls triggers plataforms bonus).each { |obj| instance_eval("@#{obj} = []") }
    @width = width and @height = height
  end

  def associate *items
    [*items].each do |target|
      if [TweetPong::Stage::Object, TweetPong::Stage::Trigger].include? target.class or target.class.superclass == TweetPong::Stage::Object
        klass_name = target.class.to_s.split('::').last
        klass_name.chop! if klass_name.end_with? 's'
        @objects << target unless klass_name == 'Trigger'
        instance_eval("@#{(klass_name.end_with?('s') ? klass_name.chop! : klass_name).downcase}s") << target unless klass_name == 'Object'
      else
        raise TypeError, 'Associatable objects must be a mixin of Stage::Object or a Stage::Trigger.'
      end
    end
  end

  #moves all movable objects by and tick.
  def tick
    @objects.each do |object|
      if object.movable?
        object.tick
      end
    end
  end

  #evaluate all trigger conditions.
  def check_triggers
    @triggers.each do |trigger|
      trigger.evaluate
    end
  end

  #places game scenario - walls and plataforms.
  def place_scenario
    associate TweetPong::Stage::Wall.new(:x => 0, :y => 0, :width => width, :height => 0)
    associate TweetPong::Stage::Wall.new(:x => width, :y => 0, :width => 0, :height => height)
    associate TweetPong::Stage::Wall.new(:x => 0, :y => height, :width => width, :height => 0)
    associate TweetPong::Stage::Wall.new(:x => 0, :y => 0, :width => 0, :height => height)

  end

end

class TweetPong::Stage::Trigger
  attr_accessor :condition
  attr_reader :ran, :evaluated

  def initialize condition, &block
    raise ArgumentError, 'Needs a boolean condition' unless [true,false].include? condition
    raise ArgumentError, 'Needs an action, as a proc to run' unless block and block.is_a? Proc
    @ran = 0
    @evaluated = 0
    @condition = condition and @block = block
  end

  def evaluate
    @evaluated += 1
    if condition
      @block.call and @ran += 1
    else
      return nil
    end
  end

end

