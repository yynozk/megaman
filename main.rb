require 'dxopal'
include DXOpal

require_remote './lib/scroll_sprite.rb'
require_remote './lib/megaman.rb'
require_remote './lib/map_tile.rb'
require_remote './lib/map.rb'

Window.load_resources do
  Window.fps = 60
  Window.width = 512
  Window.height = 448

  megaman = Megaman.new
  map = Map.create

  Window.loop do
    Sprite.update([megaman])
    map.offset = megaman.offset
    Sprite.update(map.tiles)
    Sprite.draw(map.tiles)
    Sprite.draw([megaman])
  end
end
