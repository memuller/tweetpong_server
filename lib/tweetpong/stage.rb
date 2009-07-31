class TweetPong::Stage
  attr_reader :objects, :balls, :walls, :triggers, :bonus

  def initialize
    @objects = [] and @balls = [] and @walls = [] and @triggers = [] and @plataforms = [] and @bonus = []
  end

  def associate *items
    [*items].each do |target|
      if [TweetPong::Stage::Object, TweetPong::Stage::Trigger].include? target.class or target.class.superclass == TweetPong::Stage::Object
        klass_name = target.class.to_s.split('::').last
        klass_name.chop! if klass_name.end_with? 's'
        @objects << target
        instance_eval("@#{(klass_name.end_with?('s') ? klass_name.chop! : klass_name).downcase}s") << target unless klass_name == 'Object'
      else
        raise TypeError, 'Associatable objects must be a mixin of Stage::Object or a Stage::Trigger.'
      end
    end
  end

  def tick
    @objects.each do |object|
      if object.movable?
        object.tick
      end
    end
  end

  def check_triggers
    @triggers.each do |trigger|
      trigger.evaluate
    end
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

