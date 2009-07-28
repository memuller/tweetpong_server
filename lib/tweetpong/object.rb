class TweetPong::Stage::Object
  attr_reader :x, :y, :x_speed, :y_speed, :fixed, :decay_factor, :gravity
  
  %w(x y x_speed y_speed gravity decay_factor).each do |var|
    class_eval("def #{var}= value; @#{var} = value.to_f; end")
  end
  
  def initialize
    @fixed = true
    @x = @y = @x_speed = @y_speed = 0.to_f
    @decay_factor = 5.to_f and @gravity = 0.to_f
  end
  
  def movable?
    not @fixed    
  end

  def moving?
    @x_speed > 0 or @y_speed > 0
  end
  
  def tick!
    @y_speed += @gravity 
    @x += @x_speed/@decay_factor
    @y += @y_speed/@decay_factor
  end
  
  def dump
    klass = self.class
    klass = klass.split('::').last if klass.include? '::'
    
  end

end

