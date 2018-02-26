class ScrollSprite < Sprite
  attr_accessor :offset

  def initialize
    @offset = {x: 0, y: 0}
    super
  end

  def draw
    self.x = @_x - @offset[:x]
    self.y = @_y - @offset[:y]
    super
  end
end
