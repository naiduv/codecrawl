require 'rubygems'
require 'gosu'

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class Gosu::Image
  def silhouette(window, color, tileable=false)
    # Ensure that color is really a color - not a AARRGGBB integer
    color = Gosu::Color.argb(color) if not color.is_a? Gosu::Color
    # Convert image to binary string
    binary_data = self.to_blob
    # Run a regex on this binary string - the /n option makes it binary, and the
    # /m option additionally ensures that line-breaks are ignored
    # This regex replaces the 'rgb' bytes in each 'rgba' quad by the rgb values
    # from the given color.
    binary_data.gsub! /...(.)/nm,
                      "#{color.red.chr}#{color.green.chr}#{color.blue.chr}\\1"
    # Create a small wrapper that has the same interface as RMagick::Image
    binary_string_adapter = Struct.new(:columns, :rows, :to_blob)
    adapter = binary_string_adapter.new(self.width, self.height, binary_data)
    # Tada - there's the new image
    Gosu::Image.new(window, adapter, tileable)
  end
end

class Player
  attr_reader :score

  def initialize(window)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @image = @image.silhouette(window, Gosu::Color::FUCHSIA)
    @beep = Gosu::Sample.new(window, "media/Beep.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end
  
  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Player, @angle)
  end
  
  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 35 then
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end
end

class Star
  attr_reader :x, :y
  
  def initialize(animation)
    @animation = animation
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 640
    @y = rand * 480
  end

  def draw  
    img = @animation[Gosu::milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::Stars, 1, 1, @color, :add)
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"
    
    @background_image = Gosu::Image.new(self, "media/Space.png", true)
    @background_image = @background_image.silhouette(self, 0xff887700, true)
    
    @player = Player.new(self)
    @player.warp(320, 240)

    @star_anim = Gosu::Image::load_tiles(self, "media/Star.png", 25, 25, false)
    @star_anim = @star_anim.map { |image| image.silhouette(self, Gosu::Color::WHITE) }
    @stars = Array.new
    
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    @player.move
    @player.collect_stars(@stars)
    
    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(Star.new(@star_anim))
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape then
      close
    end
  end
end

window = GameWindow.new
window.show