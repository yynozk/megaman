class SpriteEx < Sprite
  attr_accessor :offset

  def initialize
    super
    @offset = {x: 0, y: 0}
  end

  # def left
  #   self.x + self.collision[0]
  # end

  # def right
  #   self.x + self.collision[2]
  # end

  # def top
  #   self.y + self.collision[1]
  # end

  # def bottom
  #   self.y + self.collision[3]
  # end

  def left
    @_x + self.collision[0]
  end

  def right
    @_x + self.collision[2]
  end

  def top
    @_y + self.collision[1]
  end

  def bottom
    @_y + self.collision[3]
  end

end
