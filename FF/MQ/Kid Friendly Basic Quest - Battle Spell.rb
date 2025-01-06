# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Battle Spell            ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Battle Spell Window    ║    12 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  none                                                    ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Window_SkillList
#==============================================================================
class KFBQ_BattleSpellList < Window_ItemList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    self.z = 400
    self.back_opacity = 0
    @actor = nil
    @data = []
    self.unselect
    self.deactivate
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
    return 4
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
        ox = 45
      when 1
        ox = 55
      when 2
        ox = 65
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
  # * Set Cursor Position
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    update_cursor
    call_update_help
  end
end

#==============================================================================
# ** Window_BattleSkill
#==============================================================================
class KFBQ_BattleSpell < KFBQ_BattleSpellList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     info_viewport : Viewport for displaying information
  #--------------------------------------------------------------------------
  def initialize(help_window, info_viewport)
    super(250, 280, 280, 100)
    self.visible = false
    self.tone.set(Color.new(0,0,0))
    self.opacity = 255
    self.back_opacity = 255
    self.contents_opacity = 255
    @datawhite = []
    @datablack = []
    @datawizard = []
    @data = []
    @spellgroup = 1
    @help_window = help_window
    @info_viewport = info_viewport
    update_padding
    select(0)
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    @actor = actor
    @spell_type.actor = @actor
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Set Help Window
  #--------------------------------------------------------------------------
  def help_window=(help_window)
    @help_window = help_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Set Row text
  #--------------------------------------------------------------------------
  def type_window=(type_window)
    @spell_type = type_window
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    make_item_list
    draw_all_items
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    case @spellgroup
    when 1
      if @datawhite.empty? || @datawhite.nil?
        return 1
      else
        @datawhite.size
      end
    when 2
      if @datablack.empty? || @datablack.nil?
        return 1
      else
        @datablack.size
      end
    when 3
      if @datawizard.empty? || @datawizard.nil?
        return 1
      else
        @datawizard.size
      end
    else
      return 1
    end
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 4
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
  # * Create Skill List
  #--------------------------------------------------------------------------
  def make_item_list
    @datawhite = []
    @datablack = []
    @datawizard = []
    for i in 3..$data_skills.size - 1
      spell = $data_skills[i]
      if !spell.kfbq_exclude? and @actor.skills.include?(spell)
        case spell.stype_id
        when 1;  @datawhite << spell
        when 2;  @datablack << spell
        when 3;  @datawizard << spell
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    case @spellgroup
    when 1
      @data = @datawhite
      @spell_type.update_type = 1
    when 2
      @data = @datablack
      @spell_type.update_type = 2
    when 3
      @data = @datawizard
      @spell_type.update_type = 3
    end
    skill = @data[index]
    pos = index % 4
    case pos
    when 0
      ox = 25
    when 1
      ox = 35
    when 2
      ox = 45
    when 3
      ox = 55
    end
    if skill
      rect = item_rect(index)
      rect.width -= 4
      draw_icon(skill.icon_index, rect.x + 15, rect.y, enable?(skill))
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    case @spellgroup
    when 1
      @spellgroup = 2
      @spell_type.update_type = 2
      select(0)
    when 2
      @spellgroup = 3
      @spell_type.update_type = 3
      select(0)
    when 3
      @spellgroup = 1
      @spell_type.update_type = 1
      select(0)
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    case @spellgroup
    when 1
      @spellgroup = 3
      @spell_type.update_type = 3
      select(0)
    when 2
      @spellgroup = 1
      @spell_type.update_type = 1
      select(0)
    when 3
      @spellgroup = 2
      @spell_type.update_type = 2
      select(0)
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    ensure_cursor_visible
    cursor_rect.set(item_rect(@index))
    cursor_rect.x += 13
  end
  #--------------------------------------------------------------------------
  # * Select Last
  #--------------------------------------------------------------------------
  def select_last
    select(0)
  end
  #--------------------------------------------------------------------------
  # * Row Max
  #--------------------------------------------------------------------------
  def row_max
    [(item_max + col_max - 1) / col_max, 1].max
  end
end

#==============================================================================
# ** Window_Spell_Command
#==============================================================================
class KFBQ_Spell_Command < Window_Base
  #--------------------------------------------------------------------------
  # * Iniatilize
  #--------------------------------------------------------------------------
  def initialize
    super(40, 280, 200, fitting_height(1))
    self.tone.set(Color.new(-255,-255,-255))
    self.opacity = 255
    self.arrows_visible = false
    self.pause = false
    self.back_opacity = 255
    self.contents_opacity = 255
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
    name = "Spell"
    draw_text(0, 0, 180, line_height, name, 1)
  end
end

#==============================================================================
# ** Window_Spell_Type
#==============================================================================
class KFBQ_Spell_Type < Window_Base
  #--------------------------------------------------------------------------
  # * Iniatilize
  #--------------------------------------------------------------------------
  def initialize(type)
    super(250, 340, 300, fitting_height(1))
    self.tone.set(Color.new(0,0,0))
    self.opacity = 0
    self.arrows_visible = false
    self.pause = false
    self.back_opacity = 0
    self.contents_opacity = 255
    self.z = 500
    @type = type
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def update_type=(type)
    @type = type
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
    case @type
    when 1
      draw_text(0, 0, 80, line_height, "WHITE", 0)
      draw_text(90, 0, 80, line_height, "MAGIC", 1)
      draw_text(170, 0, 60, line_height, "LEFT", 1)
      draw_text(230, 0, 30, line_height, @actor.whitespells, 2)
    when 2
      draw_text(0, 0, 80, line_height, "BLACK", 0)
      draw_text(90, 0, 80, line_height, "MAGIC", 1)
      draw_text(170, 0, 60, line_height, "LEFT", 1)
      draw_text(230, 0, 30, line_height, @actor.blackspells, 2)
    when 3
      draw_text(0, 0, 100, line_height, "WIZARD", 0)
      draw_text(90, 0, 80, line_height, "MAGIC", 1)
      draw_text(170, 0, 60, line_height, "LEFT", 1)
      draw_text(230, 0, 30, line_height, @actor.wizardspells, 2)
    end
  end
end

#==============================================================================
# ** Window_Spell_Row
#==============================================================================
class KFBQ_Spell_Arrow < Window_Base
  #--------------------------------------------------------------------------
  # * Iniatilize
  #--------------------------------------------------------------------------
  def initialize
    super(255, 295, 50, fitting_height(4))
    self.tone.set(Color.new(0,0,0))
    self.opacity = 0
    self.arrows_visible = false
    self.pause = false
    self.back_opacity = 0
    self.contents_opacity = 255
    self.z = 500
    refresh
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
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
    bitmap1 = Cache.system("Spell_Arrows")
    rect1 = Rect.new(0, 0, bitmap1.width, bitmap1.height)
    contents.blt(0, 0, bitmap1, rect1, 255)
  end
end
