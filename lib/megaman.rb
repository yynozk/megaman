# coding: utf-8
class Megaman < SpriteEx
  Image.register(:megaman, "data/megaman.png")

  RUN_SPEED = 3
  JUMP_SPEED = -9
  FALL_SPEED = 0.5
  STAND_Y = 96

  ANIMATIONS = {
    entry_right:  [3,  [0,  1,  2], :stand],
    stand_right:  [7, [4]],
    stand_left:   [7, [5]],
    run_right:    [7, [9,  10, 11, 10]],
    run_left:     [7, [13, 14, 15, 14]],
    jump_right:   [7, [24]],
    jump_left:    [7, [26]],
  }
  SHOT_ANIMATION_FRAME_NUM = 20
  SHOT_FLIP_INDEXES = [
    nil, nil, nil, nil,
    16, 20, nil, nil,
    16, 17, 18, 19,
    20, 21, 22, 23,
    4, 9, 10, 11,
    5, 13, 14, 15,
    25, 24, 27, 26,
    30, 31, 28, 29,
  ]

  def initialize
    super
    @images = Image[:megaman].slice_tiles(4, 12)

    @_x, @_y = 100, STAND_Y
    @vx, @vy = 0, 0
    @offset = {x: 0, y: 0}
    @pre_state = nil
    @state = {action: :entry, direction: :right}
    @collided = false
    @image_index = 0
    @shot_animation_count = nil
    @bullets = []
    start_animation
    animate
    self.collision = [24, 5, 54, 63]
  end

  def update
    @collided = false
    @vx = 0
    @vy += FALL_SPEED

    case @state[:action]
    when *[:stand, :run]
      if Input.key_down?(K_RIGHT)
        @state.update({action: :run, direction: :right})
        @vx = RUN_SPEED
      elsif Input.key_down?(K_LEFT)
        @state.update({action: :run, direction: :left})
        @vx = -RUN_SPEED
      else
        @state.update({action: :stand})
      end

      if Input.key_push?(K_X)
        @state.update({action: :jump})
        @vy = JUMP_SPEED
      end

      if Input.key_push?(K_C) and @bullets.length < 3
        @shot_animation_count = 0
        @bullets << Bullet.new(@_x, @_y, @offset[:x], @offset[:y], @state[:direction])
      end
    when :jump
      if Input.key_down?(K_RIGHT)
        @state.update({direction: :right})
        @vx = RUN_SPEED
      elsif Input.key_down?(K_LEFT)
        @state.update({direction: :left})
        @vx = -RUN_SPEED
      end

      if Input.key_push?(K_C) and @bullets.length < 3
        @shot_animation_count = 0
        @bullets << Bullet.new(@_x, @_y, @offset[:x], @offset[:y], @state[:direction])
      end
    end

    @_x += @vx
    @_y += @vy

    move

    Sprite.update(@bullets)
    @bullets.delete_if {|b| b.vanished? }
  end

  def shot(obj)
    return if obj.bg
    @collided = true

    if self.pre_bottom <= obj.top and self.bottom > obj.top
      @state.update({action: :stand}) if @state[:action] == :jump
      @vy = 0
      self.bottom = obj.top
    end

    same_row = self.bottom >= obj.top + 1 and self.top <= obj.bottom

    if same_row and self.pre_right <= obj.left and self.right > obj.left
      self.right = obj.left
    elsif same_row and self.pre_left >= obj.right and self.left < obj.right
      self.left = obj.right
    elsif self.pre_top >= obj.bottom and self.top < obj.bottom
      self.top = obj.bottom
      @vy = 0
    end

    move
  end

  def draw
    Sprite.draw(@bullets)

    @state.update({action: :jump}) unless @collided

    start_animation if @state != @pre_state
    animate
    @pre_state = @state.clone
    super
  end

  def animate
    if @animation_count.zero?
      if @animation[1].empty?
        @state[:action] = (@animation[2] || @state[:action])
        start_animation
      end
      @image_index = @animation[1].shift
      self.image = @images[@image_index]
    end

    @animation_count += 1
    @animation_count = @animation_count % @animation[0]

    # ショット中のアニメーション差し替え
    return unless @shot_animation_count

    if @shot_animation_count >= 0
      self.image = @images[SHOT_FLIP_INDEXES[@image_index]]
      @shot_animation_count += 1
      if @shot_animation_count >= 14
        @shot_animation_count = nil
        self.image = @images[SHOT_FLIP_INDEXES[@image_index]]
      end
    end
  end

  def start_animation
    key = "#{@state[:action]}_#{@state[:direction]}".to_sym
    a = ANIMATIONS[key]
    @animation = [a[0], a[1].clone, a[2]]
    @animation_count = 0
  end

  def update_offset
    @offset[:x] = @_x - 256 if (256..1792) === @_x
    move

    @offset
  end


  private

  def move
    self.x = @_x - @offset[:x]
    self.y = @_y - @offset[:y]
  end

  # def left
  #   @_x + self.collision[0]
  # end

  # def right
  #   @_x + self.collision[2]
  # end

  # def top
  #   @_y + self.collision[1]
  # end

  # def bottom
  #   @_y + self.collision[3]
  # end

  def pre_left
    self.left - @vx
  end

  def pre_right
    self.right - @vx
  end

  def pre_top
    self.top - @vy
  end

  def pre_bottom
    self.bottom - @vy
  end

  def left=(val)
    @_x = val - self.collision[0]
  end

  def right=(val)
    @_x = val - self.collision[2]
  end

  def top=(val)
    @_y = val - self.collision[1]
  end

  def bottom=(val)
    @_y = val - self.collision[3]
  end
end
