# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Spell Menu Functions    ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Spell Screens          ║    09 Mar 2023     ║
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
# ** Window_Help
#==============================================================================
class Window_SpellHelp < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = 1)
    super(0, 0, Graphics.width / 2, fitting_height(line_number))
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
    set_text(item ? item.name : "")
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
  end
end

#==============================================================================
# ** Window_Item_Command
#==============================================================================
class Window_Spell_Command < Window_Base
  #--------------------------------------------------------------------------
  # * Iniatilize
  #--------------------------------------------------------------------------
  def initialize
    super(Graphics.width / 2, 0, Graphics.width / 2, fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    contents.dispose unless disposed?
    super unless disposed?
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(crisis_color)
    name = "Spells"
    draw_text(4, 0, 200, line_height, name, 1)
  end
end

#==============================================================================
# ** Window_SkillList
#==============================================================================
class Window_SpellList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    self.back_opacity = 0
    @actor = nil
    @data = []
    self.unselect
    self.deactivate
    @active_window = 0
    @move_pos = 0
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 3
  end
  #--------------------------------------------------------------------------
  # * Get Data
  #--------------------------------------------------------------------------
  def check_data
    return @data
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    return 60
  end
  #--------------------------------------------------------------------------
  # * Get Skill
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return true
  end
  #--------------------------------------------------------------------------
  # * Include in Skill List? 
  #--------------------------------------------------------------------------
  def include?(item)
    return true
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def enable?(item)
    return true
  end
  #--------------------------------------------------------------------------
  # * Create Skill List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    subtract = 0
    for i in 3..$data_skills.size - 1
      spell = $data_skills[i]
      @data[i-3] = nil
      if !spell.kfbq_exclude?
        @data[i-3] = nil unless !@data[i-1].nil?
      else
        subtract += 1
        next
      end
      if @actor.skills.include?(spell)
        spell.note.split(/[\r\n]+/).each { |line|
          case line
          when /<position:[-_ ](\d+)>/i
            pos = $1.to_i
            @data[pos-1-subtract] = spell
          end
        }
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(0)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if skill
      rect = item_rect(index)
      rect.width -= 4
      pos = index % 3
      case pos
      when 0
        ox = 15
      when 1
        ox = 25
      when 2
        ox = 35
      end
      draw_icon(skill.icon_index, rect.x + ox, rect.y, enable?(skill))
    end
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Item Rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = 60
    rect.height = 60
    rect.x = index % col_max * (60)
    rect.y = index / col_max * (60)
    rect
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    ensure_cursor_visible
    cursor_rect.set(item_rect(@index))
    cursor_rect.height -= 10
    pos = @index % 3
    case pos
    when 0
      cursor_rect.x += 10
    when 1
      cursor_rect.x += 20
    when 2
      cursor_rect.x += 30
    end
  end
  #--------------------------------------------------------------------------
  # * Set Cursor Position
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    update_cursor
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    pos = @index % 3
    case pos
    when 2
      if @active_window == 0
        SceneManager.scene.swap_window_right(@index)
      end
    else
      if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
        select((index + 1) % item_max)
      end
    end
    if @move_index
      @index -= 1
      update_cursor
      @move_index = false
    end
  end
  #--------------------------------------------------------------------------
  # * Check if windows Changed
  #--------------------------------------------------------------------------
  def check_move=(move = false)
    @move_index = move
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    pos = @index % 3
    case pos
    when 0
      if @active_window == 1
        SceneManager.scene.swap_window_left(@index)
      end
    else
      if col_max >= 2 && (index > 0 || (wrap && horizontal?))
        select((index - 1 + item_max) % item_max)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Window Active
  #--------------------------------------------------------------------------
  def active_window=(win = 0)
    @active_window = win
  end
end

#==============================================================================
# ■ Window Spell Count
#==============================================================================
class Window_KFBQSpellCount < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    super(x, y, w, h)
    self.back_opacity = 255
    @actor1 = $game_party.members[0]
    @actor2 = $game_party.members[1]
    draw_data
  end
  #--------------------------------------------------------------------------
  # * Get Line Height
  #--------------------------------------------------------------------------
  def line_height
    return 24
  end
  #--------------------------------------------------------------------------
  # * Get Line Height
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_data
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    return if @spell_image.nil?
    @spell_image.bitmap.dispose
    @spell_image.dispose
    super
  end
  #--------------------------------------------------------------------------
  # * Draw Data
  #--------------------------------------------------------------------------
  def draw_data
    draw_base_image
    draw_spell_count
  end
  #--------------------------------------------------------------------------
  # * Draw Base Image
  #--------------------------------------------------------------------------
  def draw_base_image
    @spell_image = Sprite.new
    @spell_image.bitmap = Cache.system("Magic_Left")
    @spell_image.x = 0
    @spell_image.y = 332
    @spell_image.z = 70
  end
  #--------------------------------------------------------------------------
  # * Draw Spell Count
  #--------------------------------------------------------------------------
  def draw_spell_count
    draw_text(20, -5, 30, 24, @actor1.whitespells, 1)
    draw_text(100, -5, 30, 24, @actor1.blackspells, 1)
    draw_text(180, -5, 30, 24, @actor1.wizardspells, 1)
    if @actor2
      draw_text(325, -5, 30, 24, @actor2.whitespells, 1)
      draw_text(400, -5, 30, 24, @actor2.blackspells, 1)
      draw_text(480, -5, 30, 24, @actor2.wizardspells, 1)
    end
  end
end

#==============================================================================
# ** Scene_Spell
#==============================================================================
class Scene_Spell < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_spell_window
    create_spell_window2
    create_spell_command
    create_spell_count_window
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_SpellHelp.new
    @help_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Item Command Text Window
  #--------------------------------------------------------------------------
  def create_spell_command
    @command_window = Window_Spell_Command.new
    @command_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_spell_window
    ww = Graphics.width / 2
    wh = Graphics.height - 208
    @spell_window = Window_SpellList.new(0, 48, ww, wh)
    @spell_window.actor = $game_party.members[0]
    @spell_window.viewport = @viewport
    @spell_window.help_window = @help_window
    @spell_window.actor = $game_party.members[0]
    @spell_window.activate
    @spell_window.select(0)
    @spell_window.set_handler(:ok,     method(:on_item_ok))
    @spell_window.set_handler(:cancel, method(:return_scene))
    @left = true
  end
  #--------------------------------------------------------------------------
  # * Create Item Window2
  #--------------------------------------------------------------------------
  def create_spell_window2
    ww = Graphics.width / 2
    wh = Graphics.height - 208
    @spell_window2 = Window_SpellList.new(ww, 48, ww, wh)
    @spell_window2.actor = $game_party.members[1]
    @spell_window2.viewport = @viewport
    @spell_window2.help_window = @help_window
    @spell_window2.actor = $game_party.members[1]
    @spell_window2.set_handler(:ok,     method(:on_item_ok))
    @spell_window2.set_handler(:cancel, method(:return_scene))
    @spell_window2.deactivate
  end
  #--------------------------------------------------------------------------
  # * Swap Window from right to left
  #--------------------------------------------------------------------------
  def swap_window_left(index)
    @left = true
    @spell_window.active_window = 0
    @spell_window2.active_window = 0
    @spell_window2.unselect
    @spell_window2.deactivate
    @spell_window.activate
    @spell_window.select(index+2)
  end
  #--------------------------------------------------------------------------
  # * Swap Window from left to roght
  #--------------------------------------------------------------------------
  def swap_window_right(index)
    if @spell_window2.check_data == []
      Sound.play_buzzer
      return
    end
    @spell_window.active_window = 1
    @spell_window2.active_window = 1
    @spell_window.unselect
    @spell_window.deactivate
    @spell_window2.activate
    @left = false
    @spell_window2.select(index-2)
    @spell_window2.check_move=(true)
  end
  #--------------------------------------------------------------------------
  # * Specify Item
  #--------------------------------------------------------------------------
  def item
    if @left == true
      return @spell_window.item
    else
      return @spell_window2.item
    end
  end
  #--------------------------------------------------------------------------
  # * Show Actor Select Window
  #--------------------------------------------------------------------------
  def show_sub_window(window)
    window.show.activate
  end
  #--------------------------------------------------------------------------
  # * Activate Item Window
  #--------------------------------------------------------------------------
  def activate_item_window
    if @left == true
      @spell_window.activate
      @spell_window.select_last
    else
      @spell_window2.activate
      @spell_window2.select_last
    end
  end
  #--------------------------------------------------------------------------
  # * Confirm Item
  #--------------------------------------------------------------------------
  def determine_item
    if item.for_friend?
      show_sub_window(@actor_window)
      @actor_window.select_for_item(item)
    else
      use_item if SceneManager.scene_is?(Scene_Battle)
      activate_item_window
    end
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    @spell_window2.deactivate
    @spell_window.deactivate
    @actor.last_skill.object = item
    determine_item if !item.nil?
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    activate_item_window
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_skill
  end
  #--------------------------------------------------------------------------
  # * Create Spell Count Window
  #--------------------------------------------------------------------------
  def create_spell_count_window
    @spell_count_window = Window_KFBQSpellCount.new(0, Graphics.height - 160, Graphics.width, 60)
    @spell_count_window.z = 60
    @actor_window.spell_count = @spell_count_window
  end
end
