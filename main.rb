require 'dxopal'
include DXOpal

require_remote './lib/util/sprite_ex.rb'
require_remote './lib/megaman.rb'
require_remote './lib/map_tile.rb'
require_remote './lib/map.rb'

Window.load_resources do
  Window.fps = 60
  Window.width = 512
  Window.height = 448
  Window.bgcolor = C_WHITE

  megaman = Megaman.new
  map = Map.create

  Window.loop do
    Sprite.update([megaman])
    Sprite.check(megaman, map.tiles)
    map.offset = megaman.update_offset
    Sprite.update(map.tiles)
    Sprite.draw(map.tiles)
    Sprite.draw([megaman])
  end
end
