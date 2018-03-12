class Bullet < SpriteEx
  Image.register(:bullet, "data/bullet.png")

  def initialize(x, y, ox, oy, direction)
    super()

    @_x, @_y = x + 35, y + 29
    @ox, @oy = ox, oy
    @direction = direction
    self.image = Image[:bullet]
  end

  def update
    @_x += (@direction == :right) ? 9 : -9
    move

    self.vanish unless in_window?
  end

  def move
    self.x = @_x - @ox
    self.y = @_y - @oy
  end

  def in_window?
    (-self.image.width..Window.width) === self.x
  end
end
