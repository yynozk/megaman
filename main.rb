require 'dxopal'
include DXOpal

require_remote './lib/megaman.rb'

Window.load_resources do
  megaman = Megaman.new

  Window.loop do
    Sprite.update([megaman])
    Sprite.draw([megaman])
  end
end
