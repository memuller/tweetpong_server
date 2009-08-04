class TweetPong::Stage::Object
  attr_reader :x, :y, :x_speed, :y_speed, :fixed, :decay_factor, :gravity, :width, :height
  attr_accessor :centered_register
  %w(x y x_speed y_speed gravity decay_factor width height).each do |var|
    class_eval("def #{var}= value; @#{var} = value.to_f; end")
  end

  def initialize args={}
    @fixed = true unless defined? @fixed
    @centered_register = false unless defined? @centered_register
    @x = @y = @x_speed = @y_speed = 0.to_f
    @width = @height = 1.0 unless defined? @width or defined? @height
    @decay_factor ||= 5.to_f
    @gravity ||= 0.to_f
    args.keys.each do |key|
      instance_variable_set "@#{key.to_s}", args[key]
    end
  end

  def from_center axis = :w
    if axis == :w
      @centered_register ? @width/2 : @width
    else
      @centered_register ? @height/2 : @height
    end
  end

  def round?
    @centered_register and @width == @height
  end

  def movable?
    not @fixed
  end

  def moving?
    @x_speed > 0 or @y_speed > 0
  end

  def tick
    @y_speed += @gravity
    @x += @x_speed/@decay_factor
    @y += @y_speed/@decay_factor
  end

end

