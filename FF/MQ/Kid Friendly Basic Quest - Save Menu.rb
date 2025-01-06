# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Save Menu Functions     ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Save Screens           ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Set the Windows to look like FFMQ.                      ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** DataManager
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # * Maximum Number of Save Files
  #--------------------------------------------------------------------------
  def self.savefile_max
    return 3
  end
  #--------------------------------------------------------------------------
  # * Create Save Header
  #--------------------------------------------------------------------------
  class << self
    alias r2_make_save_header make_save_header
  end 
  #--------------------------------------------------------------------------
  # Make Save Header
  #--------------------------------------------------------------------------
  def self.make_save_header
    header = r2_make_save_header
    header[:save_data] = $game_party.data_for_savefile
    header[:map] = $game_map.display_name
    header[:control] = $game_system.autobattle?
    header
  end
end

#==============================================================================
# ** Game_Party
#==============================================================================
class Game_Party
  def data_for_savefile
    battle_members.collect { |actor| [actor.id, actor.level, actor.name, actor.hp, actor.equips[0].id] }
  end
end

#==============================================================================
# ■ Window Kid Friendly Basic Quest Save Blank
#==============================================================================
class Window_KFBQSaveBlank < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    hgt = line_height * h
    super(x, y, w, hgt)
    self.back_opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Get Line Height
  #--------------------------------------------------------------------------
  def line_height
    return 21
  end  
end

#==============================================================================
# ** Window_SaveFile
#==============================================================================
class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :selected                 # selected
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     index : index of save files
  #--------------------------------------------------------------------------
  def initialize(height, index)
    super(0, index * height, Graphics.width, height)
    @file_index = index
    @height = height
    self.back_opacity = 0
    refresh
    @selected = false
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    frame_dispose
    contents.dispose unless disposed?
    super unless disposed?
  end
  #--------------------------------------------------------------------------
  # * Frame Dispose
  #--------------------------------------------------------------------------
  def frame_dispose
    if @index_window1; @index_window1.dispose unless disposed?; end
    if @index_window2; @index_window2.dispose unless disposed?; end
    if @map_window; @map_window.dispose unless disposed?; end
    if @no_actor; @no_actor.bitmap.dispose unless disposed?; end
    if @no_actor; @no_actor.dispose  unless disposed?; end
  end
  #--------------------------------------------------------------------------
  # * Window Frames for Screen
  #--------------------------------------------------------------------------
  def window_frames
    frame_dispose
    @index_window1 = Window_KFBQSaveBlank.new(0, @file_index * @height + 90, Graphics.width / 2, 4)
    @index_window1.z = 1
    @index_window2 = Window_KFBQSaveBlank.new(Graphics.width / 2, @file_index * @height + 90, Graphics.width / 2, 4)
    @index_window2.z = 1
    @map_window = Window_KFBQSaveBlank.new(Graphics.width / 4, @file_index * @height + 50, Graphics.width / 2, 2)
    @map_window.z = 1
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(normal_color)
    draw_empty_slot
    draw_data
  end
  #--------------------------------------------------------------------------
  # * Draw Party Characters
  #--------------------------------------------------------------------------
  def draw_empty_slot
    header = DataManager.load_header(@file_index)
    if header
      window_frames
    else
      name = "Empty!"
      @name_width = text_size(name).width
      draw_text((Graphics.width - @name_width) / 2, 0, 200, line_height, name)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Hud HP
  #--------------------------------------------------------------------------
  def draw_actor_hud_hp(actor, x, y, width = 130)
    if $game_system.life_indicator?
      draw_text(x, y + 5, contents.width/2, line_height, "LIFE", 0)
      draw_text(x + 10, y + 25, 62, line_height, actor.hp, 2)
      draw_text(x + 80, y + 25, 12, line_height, "/", 2)
      draw_text(x + 90, y + 25, 62, line_height, actor.mhp, 2)
    else
      draw_gauge(actor, x, y + 10, width, hp_rate(actor), text_color(17), text_color(17))
    end
  end
  #--------------------------------------------------------------------------
  # * HP Rate
  #--------------------------------------------------------------------------
  def hp_rate(actor)
    if actor.mhp > @barhp
      a = (actor.hp / @barhp).to_i
      b = a * @barhp
      c = actor.hp - b
      d = c == 0 ? @barhp : c
      d.to_f / @barhp
    else
      actor.hp.to_f / actor.mhp
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Gauge
  #--------------------------------------------------------------------------
  def draw_gauge(actor, x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    height = 20
    height = 10 if actor.level > R2_Hud_Data::Level
    contents.fill_rect(x, gauge_y, width, height, text_color(18))
    contents.gradient_fill_rect(x, gauge_y, fill_w, height, color1, color2)
    bitmap1 = Cache.system(R2_Hud_Data::Base_File)
    bitmap2 = Cache.system(R2_Hud_Data::HP_File)
    rect1 = Rect.new(0, 0, bitmap1.width, bitmap1.height)
    rect2 = Rect.new(0, 0, bitmap2.width, bitmap2.height)
    # find how many health bars to show
    mhp_value = (actor.mhp / @barhp).to_i - 1
    a = (actor.hp / @barhp).to_i
    b = a * @barhp
    c = actor.hp - b
    d = c > 0 ? 1 : 0
    hp_value = d + a - 1
    # Draw Base
    if (actor.level > 1) && (actor.level < (R2_Hud_Data::Level + 1))
      mhp_value.times do |i|
        p = i*7
        contents.blt(x+p, 70, bitmap1, rect1, 255)
      end
    elsif actor.level > (R2_Hud_Data::Level)
      row2 = mhp_value - (R2_Hud_Data::Level - 1)
      row2 = (R2_Hud_Data::Level - 1) if (actor.level > (R2_Hud_Data::Level * 2 - 1))
      row1 = R2_Hud_Data::Level - 1
      row1.times do |i|
        p = i*7
        contents.blt(x+p, 60, bitmap1, rect1, 255)
      end
      row2.times do |i|
        p = i*7
        contents.blt(x+p, 70, bitmap1, rect1, 255)
      end
    end
    # Draw Health
    if (actor.level > 1) && (actor.level < (R2_Hud_Data::Level + 1))
      hp_value.times do |i|
        p = i*7
        contents.blt(x+p, 70, bitmap2, rect2, 255)
      end
    elsif actor.level > (R2_Hud_Data::Level)
      row4 = [0, hp_value - (R2_Hud_Data::Level - 1)].max
      row4 = (R2_Hud_Data::Level - 1) if hp_value >= (R2_Hud_Data::Level * 2 - 1)
      row3 = 0
      row3 = [hp_value, (R2_Hud_Data::Level - 1)].min if hp_value >= 1
      return if row3 == 0
      row3.times do |i|
        p = i*7
        contents.blt(x+p, 60, bitmap2, rect2, 255)
      end
      row4.times do |i|
        p = i*7
        contents.blt(x+p, 70, bitmap2, rect2, 255)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Data
  #--------------------------------------------------------------------------
  def draw_data
    header = DataManager.load_header(@file_index)
    return unless header
    self.contents.clear
    change_color(normal_color)
    width = Graphics.width / 2
    actor1 = header[:save_data][0]
    # id, level, name, hp, weapon
    @actor1 = Game_Actor.new(actor1[0])
    @actcln = @actor1.clone
    @actcln.level = 1
    @barhp = @actcln.mhp
    @actor1.level = actor1[1]
    @actor1.name = actor1[2]
    @actor1.hp = actor1[3]
    weapon = actor1[4]
    draw_actor_name(@actor1, 10, 0)
    draw_actor_hud_hp(@actor1, 0, 20, 150)
    draw_actor_weapon(0, weapon)
    draw_level(0, @actor1)
    actor2 = nil
    actor2 = header[:save_data][1] if !header[:save_data][1].nil?
    if actor2
      @actor2 = Game_Actor.new(actor2[0])
      @actcln = @actor2.clone
      @actcln.level = 1
      @barhp = @actcln.mhp
      @actor2.level = actor2[1]
      @actor2.name = actor2[2]
      @actor2.hp = actor2[3]
      weapon = actor2[4]
      draw_actor_name(@actor2, Graphics.width / 2 + 160, 0)
      draw_actor_hud_hp(@actor2, Graphics.width / 2, 20, 150)
      draw_actor_weapon(Graphics.width / 2, weapon)
      draw_level(Graphics.width / 2, @actor2)
      draw_control(header[:control])
    else
      @no_actor = Sprite.new
      @no_actor.bitmap = Cache.system("Save_Actor")
      @no_actor.x = Graphics.width / 2
      @no_actor.y = @file_index * @height + 90
      @no_actor.z = 2
    end
    draw_map(header[:map])
    header[:characters].each_with_index do |data, i|
      draw_character(data[0], data[1], 160 + i * (Graphics.width / 2), 100)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Level
  #--------------------------------------------------------------------------
  def draw_level(x, actor)
    name = "LEVEL"
    draw_text(x + 5, 90, contents.width, line_height, name, 0)
    draw_text(x + 90, 90, contents.width, line_height, actor.level, 0)
  end
  #--------------------------------------------------------------------------
  # * Draw Map Name
  #--------------------------------------------------------------------------
  def draw_map(name)
    change_color(system_color)
    draw_text(0, 0, contents.width, line_height, name, 1)
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Control
  #--------------------------------------------------------------------------
  def draw_control(control)
    name = control ? " AUTO" : " MANUAL"
    contents.font.size -= 8
    draw_text(Graphics.width - 110, 35, 80, line_height, name, 1)
    reset_font_settings
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Weapon
  #--------------------------------------------------------------------------
  def draw_actor_weapon(x, id)
    bitmap = Cache.system("Weapons\\Weapon" + id.to_s)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x + 180, 50, bitmap, rect, 255)
  end
  #--------------------------------------------------------------------------
  # * Set Selected
  #--------------------------------------------------------------------------
  def selected=(selected)
    @selected = selected
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def standard_padding
    return 8
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @selected
      cursor_rect.set(0, 0, Graphics.width - 15, @height - 15)
    else
      cursor_rect.empty
    end
  end
end

#==============================================================================
# ** Window_Help
#==============================================================================
class Window_File_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(pos, line_number)
    if pos == 0
      super(0, 0, Graphics.width / 2, fitting_height(line_number))
    else
      super(Graphics.width / 2, 0, Graphics.width / 2, fitting_height(line_number))
    end
  end
  def dispose
    contents.dispose unless disposed?
    super unless disposed?
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_text("")
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    set_text(item ? item.description : "")
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(crisis_color)
    draw_text(-20, 0, Graphics.width / 2, line_height, @text, 1)
    change_color(normal_color)
  end
end

#==============================================================================
# ** Window_New_Game
#==============================================================================
class Window_New_Game < Window_Base
  attr_reader   :selected
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize(height, index)
    super(0, 0, 160, fitting_height(1))
    @file_index = 0
    refresh
    @selected = false
  end
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    contents.dispose unless disposed?
    super unless disposed?
  end
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(normal_color)
    name = "New Game"
    @name_width = text_size(name).width
    draw_text(4, 0, 200, line_height, name)
  end
  #--------------------------------------------------------------------------
  # Selected Item
  #--------------------------------------------------------------------------
  def selected=(selected)
    @selected = selected
    update_cursor
  end
  #--------------------------------------------------------------------------
  # Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @selected
      cursor_rect.set(0, 0, @name_width + 8, line_height)
    else
      cursor_rect.empty
    end
  end
end

#==============================================================================
# ** Scene_File
#==============================================================================
class Scene_File < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_savefile_viewport
    create_savefile_windows
    create_save_complete_window
    create_new_game if SceneManager.scene_is?(Scene_Load)
    init_selection
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_File_Help.new(1,1)
    @help_window.set_text(help_window_text)
  end
  #--------------------------------------------------------------------------
  # * Create Save Complete Window
  #--------------------------------------------------------------------------
  def create_save_complete_window
    @saved_window = Window_File_Help.new(0,1)
    @saved_window.set_text(save_window_text)
    @saved_window.hide
  end
  #--------------------------------------------------------------------------
  # * Get Help Window Text
  #--------------------------------------------------------------------------
  def help_window_text
    return ""
  end
  #--------------------------------------------------------------------------
  # * Get Save Window Text
  #--------------------------------------------------------------------------
  def save_window_text
    return ""
  end
  #--------------------------------------------------------------------------
  # * Create Save File Viewport
  #--------------------------------------------------------------------------
  def create_savefile_viewport
    @savefile_viewport = Viewport.new
    @savefile_viewport.rect.y = @help_window.height
    @savefile_viewport.rect.height -= @help_window.height
    @newfile_viewport = Viewport.new
    @newfile_viewport.rect.y = 0
    @newfile_viewport.rect.height = 48
    @newfile_viewport.rect.x = 0
  end
  #--------------------------------------------------------------------------
  # * Create Save File Window
  #--------------------------------------------------------------------------
  def create_savefile_windows
    @savefile_windows = Array.new(item_max) do |i|
      Window_SaveFile.new(savefile_height, i)
    end
    @savefile_windows.each {|window| window.viewport = @savefile_viewport }
  end
  #--------------------------------------------------------------------------
  # * Create Save File Window
  #--------------------------------------------------------------------------
  def create_new_game
    i = @savefile_windows.size
    @savefile_windows << Window_New_Game.new(@newfile_viewport.rect.height, i)
    @savefile_windows[i].viewport = @newfile_viewport
  end
  #--------------------------------------------------------------------------
  # * Get Number of Save Files to Show on Screen
  #--------------------------------------------------------------------------
  def visible_max
    return 3
  end
end

#==============================================================================
# ** Scene_Save
#==============================================================================
class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Get Help Window Text
  #--------------------------------------------------------------------------
  def help_window_text
    return "Save"
  end
  #--------------------------------------------------------------------------
  # * Get Save Window Text
  #--------------------------------------------------------------------------
  def save_window_text
    return "Save Completed"
  end
  #--------------------------------------------------------------------------
  # * Processing When Save Is Successful
  #--------------------------------------------------------------------------
  def on_save_success
    Sound.play_save
    @savefile_windows.each {|window| window.refresh }
    @saved_window.show
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  alias r2_cursor_down_close_window cursor_down
  def cursor_down(wrap)
    r2_cursor_down_close_window(wrap)
    @saved_window.hide
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  alias r2_cursor_up_close_window cursor_up
  def cursor_up(wrap)
    r2_cursor_up_close_window(wrap)
    @saved_window.hide
  end
end

#==============================================================================
# ** Scene_Load
#==============================================================================
class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Get Help Window Text
  #--------------------------------------------------------------------------
  def help_window_text
    return "Load"
  end
  #--------------------------------------------------------------------------
  # * Get Save Window Text
  #--------------------------------------------------------------------------
  def save_window_text
    return ""
  end
  #--------------------------------------------------------------------------
  # * Confirm Save File
  #--------------------------------------------------------------------------
  def on_savefile_ok
    super
    if @index == 3
      DataManager.setup_new_game
      fadeout_all
      $game_map.autoplay
      SceneManager.goto(Scene_Map)
    elsif DataManager.load_game(@index)
      on_load_success
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap)
    @index = (@index + 1) % (item_max + 1) if @index < item_max - 1 || wrap
    ensure_cursor_visible
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap)
    @index = (@index + item_max) % (item_max + 1) if @index > 0 || wrap
    ensure_cursor_visible
  end
end
