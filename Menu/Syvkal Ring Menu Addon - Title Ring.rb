# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Syvkal Ring Menu Addon - Title Ring    ║  Version: 1.03     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║      Add ring menu to title menu              ║    02 Jan 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Syvkal's Ring Menu - Optional                            ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Add ring menu to title menu                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Using code from Syvkal's Ring Menu                               ║
# ║   I created the title screen menu                                  ║
# ║                                                                    ║
# ║   If other options are added, it will require changes.             ║
# ║   Icons must be in the format of ''choice' + space + icon'         ║
# ║   example                                                          ║
# ║   'yes icon'.png or 'no icon'.png  - without quotes                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 02 Jan 2021 - Initial publish                               ║
# ║ 1.01 - 02 Jan 2021 - Created Circle Background                     ║
# ║ 1.02 - 03 Jan 2021 - Added color options for background            ║
# ║ 1.03 - 04 Jan 2021 - Made independent of Syvkals script            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Syvkal                                                           ║
# ║   Spaceferryblues                                                  ║
# ║   Masked                                                           ║
# ║   Shiroyasha                                                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  Anyone using this script in their project before these terms      ║
# ║  were changed are allowed to use this script even if it conflicts  ║
# ║  with these new terms. New terms effective 03 Apr 2024             ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_Title_Shade
  Use_Background = true
  # Set colors to the circle image
  Background_Red = 0
  Background_Green = 0
  Background_Blue = 0
  Background_Opacity = 180
end

module R2_Syvkal_Ring
  RING_R = 75
  STARTUP_FRAMES = 20
  MOVING_FRAMES = 15
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** Window_TitleCommand
#------------------------------------------------------------------------------
#  This window is for selecting New Game/Continue on the title screen.
#==============================================================================
class Window_TitleCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    @cx = contents.width / 2; @cy = contents.height / 2
    @icons = []
    @titlecom = []
    @startup = R2_Syvkal_Ring::STARTUP_FRAMES
    @steps = @startup
    @list.clear
    make_command_list
    update_placement
    make_title_icons
    select(1) if continue_enabled
    select(0) if !continue_enabled
    self.opacity = 0
    if R2_Title_Shade::Use_Background
      create_back_bitmap_turn
      create_back_sprite_turn
    end
    @mode = :start
    open
    activate
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh Start Period
  #--------------------------------------------------------------------------
  def refresh_start
    d1 = 2.0 * Math::PI / item_max
    d2 = 1.0 * Math::PI / @startup
    r = R2_Syvkal_Ring::RING_R - 1.0 * R2_Syvkal_Ring::RING_R * @steps / @startup
    for i in 0...item_max
      j = i - index
      d = d1 * j + d2 * @steps
      x = @cx + ( r * Math.sin( d ) ).to_i
      y = @cy - ( r * Math.cos( d ) ).to_i
      draw_item_icons(x, y, i)
    end
    @steps -= 1
    if @steps < 0
      @mode = :wait
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh Wait Period
  #--------------------------------------------------------------------------
  def refresh_wait
    d = 2.0 * Math::PI / item_max
    for i in 0...item_max
      j = i - index
      x = @cx + ( R2_Syvkal_Ring::RING_R * Math.sin( d * j) ).to_i 
      y = @cy - ( R2_Syvkal_Ring::RING_R * Math.cos( d * j) ).to_i 
      draw_item_icons(x, y, i)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh Movement Period
  #--------------------------------------------------------------------------
  def refresh_move( mode )
    d1 = 2.0 * Math::PI / item_max
    d2 = d1 / R2_Syvkal_Ring::MOVING_FRAMES
    d2 *= -1 unless mode != 0
    for i in 0...item_max
      j = i - index
      d = d1 * j + d2 * @steps
      x = @cx + ( R2_Syvkal_Ring::RING_R * Math.sin( d ) ).to_i
      y = @cy - ( R2_Syvkal_Ring::RING_R * Math.cos( d ) ).to_i
      draw_item_icons(x, y, i)
    end
    @steps -= 1
    if @steps < 0
      @mode = :wait
    end
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    refresh if animation? 
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh    
    self.contents.clear
    case @mode
    when :start
      refresh_start
    when :wait
      refresh_wait
    when :mover
      refresh_move(1)
    when :movel
      refresh_move(0)
    end
    rect = Rect.new(self.x, self.y + 60, self.contents.width, line_height)
    draw_text(rect, choice_name(index), 1)
  end
  #--------------------------------------------------------------------------
  # * Determines if is moving
  #--------------------------------------------------------------------------
  def animation?
    return @mode != :wait
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap)
    cursor_right(wrap)
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap)
    cursor_left(wrap)
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap)
    unless animation?
      select((index + 1) % item_max)
      @mode = :mover
      @steps = R2_Syvkal_Ring::MOVING_FRAMES
      Sound.play_cursor
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap)
    unless animation?
      select((index - 1 + item_max) % item_max)
      @mode = :movel
      @steps = R2_Syvkal_Ring::MOVING_FRAMES
      Sound.play_cursor
    end
  end
  #--------------------------------------------------------------------------
  # * Update Window Position
  #--------------------------------------------------------------------------
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height * 1.6 - height) / 2.2
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Continue
  #--------------------------------------------------------------------------
  def continue_enabled
    DataManager.save_file_exists?
  end
  #--------------------------------------------------------------------------
  # * make_title_icons
  #--------------------------------------------------------------------------
  def make_title_icons
    @titlecom.each_with_index do |command, i|
      @icons.push(Cache::picture(command + ' Icon'))
      rect = Rect.new(self.x, self.y, @icons[i].width / 2, @icons[i].height / 2)
      draw_item_icons(x, y, i)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    return Graphics.height
  end 
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    @titlecom = []
    add_command(Vocab::new_game, :new_game)
    add_command(Vocab::continue, :continue, continue_enabled)
    add_command(Vocab::shutdown, :shutdown)
    @titlecom.push(Vocab::new_game)
    @titlecom.push(Vocab::continue)
    @titlecom.push(Vocab::shutdown)
  end
  #--------------------------------------------------------------------------
  # * Get Command Name
  #--------------------------------------------------------------------------
  def choice_name(index)
    return if @titlecom == nil
    @titlecom[index]
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     i     : item number
  #--------------------------------------------------------------------------
  def draw_item_icons(x, y, i)
    return if @icons.nil?
    rect = Rect.new(0, 0, @icons[i].width, @icons[i].height)
    if i == index
      self.contents.blt(x - rect.width/2, y - rect.height/2, @icons[i], rect )
      unless command_enabled?(index)
        self.contents.blt(x - rect.width/2, y - rect.height/2, ICON_DISABLE, rect )
      end
    else
      self.contents.blt(x - rect.width/2, y - rect.height/2, @icons[i], rect, 128 )
    end
  end
  #--------------------------------------------------------------------------
  # * Create Background Bitmap
  #--------------------------------------------------------------------------
  def create_back_bitmap_turn
        @back_bitmap_turn = Bitmap.new(width, height)
    r = R2_Title_Shade::Background_Red
    g = R2_Title_Shade::Background_Green
    b = R2_Title_Shade::Background_Blue
    o = R2_Title_Shade::Background_Opacity
    @back_bitmap_turn.draw_circle(275,200,100,Color.new(r,g,b,o))
  end
  #--------------------------------------------------------------------------
  # * Create Background Sprite
  #--------------------------------------------------------------------------
  def create_back_sprite_turn
        @back_sprite_turn = Sprite.new
        @back_sprite_turn.bitmap = @back_bitmap_turn
        @back_sprite_turn.z = z - 1
    @back_sprite_turn.y = self.y
        @back_sprite_turn.x = self.x
  end
  #--------------------------------------------------------------------------
  # * Free Background Bitmap
  #--------------------------------------------------------------------------
  def dispose_back_bitmap_turn
        @back_bitmap_turn.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Background Sprite
  #--------------------------------------------------------------------------
  def dispose_back_sprite_turn
        @back_sprite_turn.dispose
  end
  #--------------------------------------------------------------------------
  # * Dispose Background
  #--------------------------------------------------------------------------
  alias r2_title_back_dispose dispose
  def dispose
    r2_title_back_dispose
        dispose_back_bitmap_turn
        dispose_back_sprite_turn
  end
end
#==============================================================================
# ** Bitmap
#==============================================================================
class Bitmap
  #----------------------------------------------------------------------------
  # * Drawing a circle
  #----------------------------------------------------------------------------
def draw_circle(y,x,r,color)
 
  for i in (y - r).. (y + r)
    j1 = Math.sqrt((r**2) - ((i - y)*(i - y))) + x
    j2 = - Math.sqrt((r**2) - ((i - y)*(i - y))) + x
    j1 = j1.to_i
    j2 = j2.to_i
 
    for k in j2..j1
      self.set_pixel(i,k,color)
    end
   
  end
 
  for j in (x - r).. (x + r)
    i1 = Math.sqrt((r**2) - ((j - x)*(j - x))) + y
    i2 = - Math.sqrt((r**2) - ((j - x)*(j - x))) + y
    self.set_pixel(i1,j,color)
    self.set_pixel(i2,j,color)
  end
end
end
