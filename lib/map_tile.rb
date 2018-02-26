class MapTile < ScrollSprite
  def self.init(tileset, xcount, ycount)
    @@tileset = tileset.slice_tiles(xcount, ycount)
    @@tile_width = @@tileset[0].width
    @@tile_height = @@tileset[0].height
  end

  def initialize(x, y, tile_index)
    super()
    @_x = x * @@tile_width
    @_y = y * @@tile_height
    self.image = @@tileset[tile_index]

    @in_window_range_x = -self.image.width..Window.width
    @in_window_range_y = -self.image.height..Window.height
  end

  def update
    self.visible = in_window?
  end

  def in_window?
    @in_window_range_x === self.x and @in_window_range_y === self.y
  end
end
