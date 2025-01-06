# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Actor HUD on screen     ║  Version: 1.01     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Actor HUD              ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Set the Level to have the additional HP split.          ║
# ║  At 23 the HP meter will show 23 HP bars before          ║
# ║  changing to allow a second row.                         ║
# ║                                                          ║
# ║  Set the file name of the base image used                ║
# ║     Base_File =                                          ║
# ║  This is the image that is shown when the player MHP     ║
# ║   goes up.                                               ║
# ║                                                          ║
# ║  Set the file name for the active HP file name           ║
# ║     HP_File =                                            ║
# ║  This is the image that is shown when the player HP      ║
# ║  is higher than the main HP bar.                         ║
# ║                                                          ║
# ║  ====================================================    ║
# ║                                                          ║
# ║  Setting window colours:                                 ║
# ║                                                          ║
# ║  Below is the constants used to configure the window     ║
# ║  colour settings. with this addition you can now         ║
# ║  specify what colour the window will be when the actor   ║
# ║  is making an action in battle and when done.            ║
# ║                                                          ║
# ║  USE_SYSTEM_COLOURS = true                               ║
# ║    will use the first two constants not the second       ║
# ║                                                          ║
# ║  WINDOW_LIGHT = [76,100] & WINDOW_DARK = [124,108]       ║
# ║    these corrospond to the windowskin graphic file       ║
# ║    starting at 64,96 is the top left corner of the       ║
# ║    colour palet.                                         ║
# ║                                                          ║
# ║  WINDOW_RGBLIGHT = [100,200,100] and                     ║
# ║  WINDOW_RGBDARK = [100,0,100]                            ║
# ║    these corrospond to RGB colours Red, Green, Blue      ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Module Actor HUD
#==============================================================================
module R2_Hud_Data
  Level = 23  # amount of levels the player can be before the health bar doubles
  Base_File = "HP-Base-extra" # Health block base
  HP_File = "HP-Active-extra" # Health block active
  HP_BAR_COLOUR_1 = 2
  HP_BAR_COLOUR_2 = 21
  # highlighting windows with system colours or RGB colours
  USE_SYSTEM_COLOURS = false
  WINDOW_LIGHT = [76,100] # windowskin pixel
  WINDOW_DARK = [124,108] # windowskin pixel
  # RGB colours
  WINDOW_RGBLIGHT = [100,200,100] # RGB colours
  WINDOW_RGBDARK = [100,0,100] # RGB colours
end

#==============================================================================
# ** Game Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Level = to set level value
  #--------------------------------------------------------------------------
  def level=(value)
    @level = value
  end
end

#==============================================================================
# ** Actor Hud Window
#==============================================================================
class Actor_Hud_Window < Window_Base
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(id)
    @actor = $game_actors[id]
    @actcln = @actor.clone
    @actcln.level = 1
    @barhp = @actcln.mhp
    x = @actor == $game_party.members[0] ? 0 : Graphics.width / 2
    y = Graphics.height - 100
    w = Graphics.width / 2
    h = Graphics.height - y
    super(x,y,w,h)
    self.tone.set(self.windowskin.get_pixel(R2_Hud_Data::WINDOW_DARK[0],R2_Hud_Data::WINDOW_DARK[1]))
    @tone = self.tone
    self.z = 2
    self.opacity = 255
    self.back_opacity = 0
    self.contents_opacity = 255
    refresh if @actor
  end
  #--------------------------------------------------------------------------
  # * Change tone when active
  #--------------------------------------------------------------------------
  def change_tone
    self.back_opacity = 255
    if R2_Hud_Data::USE_SYSTEM_COLOURS
      self.tone.set(self.windowskin.get_pixel(R2_Hud_Data::WINDOW_LIGHT[0],R2_Hud_Data::WINDOW_LIGHT[1]))
    else
      self.tone.set(Color.new(R2_Hud_Data::WINDOW_RGBLIGHT[0],R2_Hud_Data::WINDOW_RGBLIGHT[1],R2_Hud_Data::WINDOW_RGBLIGHT[2]))
    end
    @tone = self.tone
  end
  #--------------------------------------------------------------------------
  # * Clear tone
  #--------------------------------------------------------------------------
  def clear_tone
    self.back_opacity = 0
    if R2_Hud_Data::USE_SYSTEM_COLOURS
      self.tone.set(self.windowskin.get_pixel(R2_Hud_Data::WINDOW_DARK[0],R2_Hud_Data::WINDOW_DARK[1]))
    else
      self.tone.set(Color.new(R2_Hud_Data::WINDOW_RGBDARK[0],R2_Hud_Data::WINDOW_RGBDARK[1],R2_Hud_Data::WINDOW_RGBDARK[2]))
    end
    @tone = self.tone
  end
  #--------------------------------------------------------------------------
  # * Update Tone
  #--------------------------------------------------------------------------
  def update_tone
    @tone.nil? ? self.tone.set($game_system.window_tone) : @tone
    # self.tone.set(Tone.new(-255,-255,-255))
  end
  #--------------------------------------------------------------------------
  # * Get Actor
  #--------------------------------------------------------------------------
  def actor?
    return @actor
  end
  #--------------------------------------------------------------------------
  # * Draw Actor HUD HP
  #--------------------------------------------------------------------------
  def draw_actor_hud_hp(actor, x, y, width = 130)
    if $game_system.life_indicator?
      draw_text(0, y + 5, contents.width/2, line_height, "LIFE", 0)
      draw_text(x + 10, y + 25, 62, line_height, @actor.hp, 2)
      draw_text(x + 80, y + 25, 12, line_height, "/", 2)
      draw_text(x + 90, y + 25, 62, line_height, @actor.mhp, 2)
    else
      draw_gauge(x, y, width, hp_rate, text_color(R2_Hud_Data::HP_BAR_COLOUR_1), text_color(R2_Hud_Data::HP_BAR_COLOUR_2))
    end
  end
  #--------------------------------------------------------------------------
  # * Get HP Rate
  #--------------------------------------------------------------------------
  def hp_rate
    if @actor.mhp > @barhp
      a = (@actor.hp / @barhp).to_i
      b = a * @barhp
      c = @actor.hp - b
      d = c == 0 ? @barhp : c
      d.to_f / @barhp
    else
      @actor.hp.to_f / @actor.mhp
    end
  end
  #--------------------------------------------------------------------------
  # * Draw HP Gauges
  #--------------------------------------------------------------------------
  def draw_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    height = 20
    height = 10 if @actor.level > R2_Hud_Data::Level
    contents.fill_rect(x, gauge_y, width, height, text_color(18))
    contents.gradient_fill_rect(x, gauge_y, fill_w, height, color1, color2)
    bitmap1 = Cache.system(R2_Hud_Data::Base_File)
    bitmap2 = Cache.system(R2_Hud_Data::HP_File)
    rect1 = Rect.new(0, 0, bitmap1.width, bitmap1.height)
    rect2 = Rect.new(0, 0, bitmap2.width, bitmap2.height)
    # find how many health bars to show
    mhp_value = (@actor.mhp / @barhp).to_i - 1
    a = (@actor.hp / @barhp).to_i
    b = a * @barhp
    c = @actor.hp - b
    d = c > 0 ? 1 : 0
    hp_value = d + a - 1
    # Draw Base
    if (@actor.level > 1) && (@actor.level < (R2_Hud_Data::Level + 1))
      mhp_value.times do |i|
        p = i*7
        contents.blt(0+p, 50, bitmap1, rect1, 255)
      end
    elsif @actor.level > (R2_Hud_Data::Level)
      row2 = mhp_value - (R2_Hud_Data::Level - 1)
      row2 = (R2_Hud_Data::Level - 1) if (@actor.level > (R2_Hud_Data::Level * 2 - 1))
      row1 = R2_Hud_Data::Level - 1
      row1.times do |i|
        p = i*7
        contents.blt(0+p, 40, bitmap1, rect1, 255)
      end
      row2.times do |i|
        p = i*7
        contents.blt(0+p, 50, bitmap1, rect1, 255)
      end
    end
    # Draw Health
    if (@actor.level > 1) && (@actor.level < (R2_Hud_Data::Level + 1))
      hp_value.times do |i|
        p = i*7
        contents.blt(0+p, 50, bitmap2, rect2, 255)
      end
    elsif @actor.level > (R2_Hud_Data::Level)
      row4 = [0, hp_value - (R2_Hud_Data::Level - 1)].max
      row4 = (R2_Hud_Data::Level - 1) if hp_value >= (R2_Hud_Data::Level * 2 - 1)
      row3 = 0
      row3 = [hp_value, (R2_Hud_Data::Level - 1)].min if hp_value >= 1
      return if row3 == 0
      row3.times do |i|
        p = i*7
        contents.blt(0+p, 40, bitmap2, rect2, 255)
      end
      row4.times do |i|
        p = i*7
        contents.blt(0+p, 50, bitmap2, rect2, 255)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear unless disposed?
    return if disposed?
    @actor_current_hp = @actor.hp
    @previous_actor = @actor
    @level = @actor.level
    width = Graphics.width
    draw_actor_hud_hp(@actor, 0, 10, 150)
    draw_actor_weapon(@actor.equips[0].id) if !@actor.equips[0].nil?
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Weapon
  #--------------------------------------------------------------------------
  def draw_actor_weapon(id)
    bitmap = Cache.system("Weapons\\Weapon" + id.to_s)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(180, 20, bitmap, rect, 255)
    return if @actor == $game_party.members[0]
    if $game_party.members[1].equips[0] == $data_weapons[16]
      text = ($game_party.ninja_stars?).to_s
      draw_text(175,15,50, 24, text)
    end
  end
  #--------------------------------------------------------------------------
  # * Check if HUD data Changed
  #--------------------------------------------------------------------------
  def hud_data_changed
    return true if @actor_current_hp != @actor.hp
    return true if @level != @actor.level
    return false
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias r2_hud_update    update
  def update
    refresh if hud_data_changed
    r2_hud_update
  end
end

#==============================================================================
# ** Actor Level Window
#==============================================================================
class Actor_Level_Window < Window_Base
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(id)
    @actor = $game_actors[id]
    x = @actor == $game_party.members[0] ? 5 : Graphics.width / 2 + 5
    y = Graphics.height - 38
    w = name_width
    h = 45
    super(x,y,w,h)
    self.z = 1240
    self.windowskin = Cache.system("Window_Border")
    self.tone.set(Color.new(0,0,0))
    self.opacity = 255
    self.back_opacity = 0
    self.contents_opacity = 255
    @actor_alive = true
    @level = @actor.level
    refresh if @actor
  end
  #--------------------------------------------------------------------------
  # * Set the Name Width for Window Width
  #--------------------------------------------------------------------------
  def name_width
    name = @actor_alive ? " LEVEL " : " FATAL "    
    wdth = name.size * 15
    return wdth
  end
  #--------------------------------------------------------------------------
  # * Remove Padding
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear unless disposed?
    return if disposed?
    self.width = name_width
    draw_level if @actor.hp != 0
    draw_fatal if @actor.hp == 0
  end
  #--------------------------------------------------------------------------
  # * Draw Level
  #--------------------------------------------------------------------------
  def draw_level
    name = "LEVEL"
    draw_text(5, 10, contents.width, line_height, name, 0)
    draw_text(0, 10, contents.width, line_height, @actor.level, 2)
    @level = @actor.level
    @actor_alive = @actor.dead?
  end
  #--------------------------------------------------------------------------
  # * Draw Fatal if dead
  #--------------------------------------------------------------------------
  def draw_fatal
    name = "FATAL"
    change_color(knockout_color)
    draw_text(0, 0, contents.width, line_height, name, 0)
    @actor_alive = @actor.dead?
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    refresh if @actor_alive != !@actor.dead?
    refresh if @level != @actor.level
  end
end

#==============================================================================
# ** Actor Control Window
#==============================================================================
class Actor_Control_Window < Window_Base
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(id)
    @actor = $game_actors[id]
    x = Graphics.width / 2 + 180
    y = Graphics.height - 95
    w = name_width
    h = 20
    super(x,y,w,h)
    self.z = 140
    self.windowskin = Cache.system("Window_Border")
    self.tone.set(Color.new(0,0,0))
    self.opacity = 255
    self.arrows_visible = false
    self.pause = false
    self.back_opacity = 0
    self.contents_opacity = 255
    @control = $game_system.autobattle?
    contents.font.size -= 8
    refresh if @actor
  end
  #--------------------------------------------------------------------------
  # * Set the Name Width for Window Width
  #--------------------------------------------------------------------------
  def name_width
    name = $game_system.autobattle? ? " AUTO " : " MANUAL  "    
    wdth = name.size * 10
    return wdth
  end
  #--------------------------------------------------------------------------
  # * Remove Padding
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear unless disposed?
    return if disposed?
    self.width = name_width
    draw_control
  end
  #--------------------------------------------------------------------------
  # * Darw Control
  #--------------------------------------------------------------------------
  def draw_control
    name = $game_system.autobattle? ? " AUTO " : " MANUAL "
    draw_text(5, 0, 100, line_height, name, 0)
    @control = $game_system.autobattle?
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    refresh if @control != $game_system.autobattle?
  end
end

#==============================================================================
# ** Actor Name Window
#==============================================================================
class Actor_Name_Window < Window_Base
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
 def initialize(id)
    @actor = $game_actors[id]
    x = @actor == $game_party.members[0] ? 15 : Graphics.width / 2 + 15
    y = Graphics.height - 95
    w = name_width
    h = 20
    super(x,y,w,h)
    self.z = 140
    self.windowskin = Cache.system("Window_Border")
    self.tone.set(Color.new(0,0,0))
    self.opacity = 255
    self.arrows_visible = false
    self.pause = false
    self.back_opacity = 0
    self.contents_opacity = 255
    refresh if @actor
  end
  #--------------------------------------------------------------------------
  # * Set the Name Width for Window Width
  #--------------------------------------------------------------------------
  def name_width
    text = @actor.name
    total = text.size * 14
    return total
  end
  #--------------------------------------------------------------------------
  # * Remove Padding
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear unless disposed?
    return if disposed?
    draw_actor_name
  end
  #--------------------------------------------------------------------------
  # * Draw Control
  #--------------------------------------------------------------------------
  def draw_actor_name
    name = @actor.name
    draw_text(5, 0, 100, line_height, name, 0)
  end
end

#==============================================================================
# ** Actor Hud Back
#==============================================================================
class Actor_Hud_Back < Window_Base
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    x = 0
    y = Graphics.height - 100
    w = Graphics.width
    h = 100
    super(x,y,w,h)
    self.z = 1
    self.windowskin = Cache.system("Window_Border")
    self.tone.set(Color.new(0,0,0))
    self.opacity = 255
    self.arrows_visible = false
    self.pause = false
    self.back_opacity = 255
    self.contents_opacity = 255
  end
  #--------------------------------------------------------------------------
  # * Remove Padding
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    self.tone.set(Color.new(0,0,0))
  end
end
