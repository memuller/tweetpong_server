class TweetPong::Stage

  attr_reader :objects, :balls, :walls

  def initialize
    @objects = @balls = @walls = []

  end

  def associate *items
    [*items].each do |target|
      if target.instance_of? TweetPong::Stage::Object or target.class.superclass == TweetPong::Stage::Object
        klass_name = target.class.to_s.split('::').last
        @objects << target
        instance_eval("@#{klass_name.downcase + 's'}") << target unless klass_name == 'Object'
      else
        raise TypeError, 'Associatable objects must be a mixin of TweetPong::Stage::Object'
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

end

