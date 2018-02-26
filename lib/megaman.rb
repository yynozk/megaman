# coding: utf-8
class Megaman < Sprite
  Image.register(:megaman, "data/megaman.png")

  RUN_SPEED = 3
  JUMP_SPEED = -13
  FALL_SPEED = 0.5

  ANIMATIONS = {
    entry_right:  [3,  [0,  1,  2], :stand],
    stand_right:  [7, [4]],
    stand_left:   [7, [5]],
    run_right:    [7, [9,  10, 11, 10]],
    run_left:     [7, [13, 14, 15, 14]],
    jump_right:   [7, [24]],
    jump_left:    [7, [26]],
  }

  def initialize
    super
    @images = Image[:megaman].slice_tiles(4, 12)

    self.x, self.y = 100, 280

    @vx, @vy = 0, 0
    @action = :entry
    @direction = :right
    start_animation
  end

  def update
    @vx = 0
    pre_action, pre_direction = @action, @direction
    case @action
    when *[:stand, :run]
      if Input.key_down?(K_RIGHT)
        @action, @direction = :run, :right
        @vx = RUN_SPEED
      elsif Input.key_down?(K_LEFT)
        @action, @direction = :run, :left
        @vx = -RUN_SPEED
      else
        @action = :stand
      end

      if Input.key_push?(K_X)
        @action = :jump
        @vy = JUMP_SPEED
      end
    when :jump
      @vy += FALL_SPEED
      if Input.key_down?(K_RIGHT)
        @direction = :right
        @vx = RUN_SPEED
      elsif Input.key_down?(K_LEFT)
        @direction = :left
        @vx = -RUN_SPEED
      end
    end

    self.x += @vx
    self.y += @vy

    case @action
    when :jump
      if self.y >= 280
        @action = :stand
        self.y = 280
        @vy = 0
      end
    end

    start_animation if [@action, @direction] != [pre_action, pre_direction]
    animate
  end

  def animate
    if @animation_count.zero?
      if @animation[1].empty?
        @action = (@animation[2] || @action)
        start_animation
      end
      self.image = @images[@animation[1].shift]
    end
    @animation_count += 1
    @animation_count %= @animation[0]
  end

  def start_animation
    key = "#{@action}_#{@direction}".to_sym
    a = ANIMATIONS[key]
    @animation = [a[0], a[1].clone, a[2]]
    @animation_count = 0
  end
end
