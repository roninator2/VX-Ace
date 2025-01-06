#==============================================================================
# 
# ▼ Yanfly Engine Ace - Skill Cost Manager - Item cost addon v1.01
# -- Last Updated: 2024.01.02
# -- Level: Normal, Hard, Lunatic
# -- Requires: n/a
# 
#==============================================================================

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2024.01.02 - Started Script and Finished.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <custom cost item requirement: list order, item needed, item type, 
#         item number, consume>
# <custom cost item requirement:   0              3           i 
#             1           c>
# <custom cost item requirement: 0 3 i 1 c>
# this would be for requirement # 0 -> you need 3 of item #1 (potion)
# starts at 0 and must be in order. You can't have 0, 1, 3, with 2 missing.
# teh c is to indicate if the item is to be consumed when the skill is used
# 
# <custom cost item requirement: 1 2 i 3>
# this would be for requirement # 1 -> you need 2 of item #3 (hi potion)
#
# <custom cost item requirement: 2 1 w 3>
# this would be for requirement # 2 -> you need 1 of weapon #3 (axe)
#
# Sets the custom cost item requirement of the skill with specifying the item 
# using numbers to indicate what item type and quantity
# The first digit is to structure the order. If you place them in order
# of 2, 0, 1 for the note tags, you will see them in order, 0, 1, 2.
# 
# this will use the item icon and show the numbers required with the 
# amount in inventory
#==============================================================================

module YEA
  module REGEXP
    module SKILL
      CUSTOM_COST_ITEM_REQ = 
        /<custom cost item requirement:[ -_](\d+)[ -_](\d+)[ -_](\w+)[ -_](\d+)(?:|[ -_](\w+))>/i
    end
  end
end

class RPG::Skill < RPG::UsableItem
  attr_accessor :custom_cost_item_requirement
  attr_accessor :use_custom_item_cost
  alias r2_use_item_req_notetags  load_notetags_scm
  def load_notetags_scm
    r2_use_item_req_notetags
    # ---
    @custom_cost_item_requirement = []
    @use_custom_item_cost = false
    # ---
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when YEA::REGEXP::SKILL::CUSTOM_COST_ITEM_REQ
        @use_custom_item_cost = true
        @custom_cost_item_requirement[$1.to_i] = [$2.to_i, $3.to_s, $4.to_i, $5.to_s]
      end
    end
  end
  
end # RPG::Skill
    
#==============================================================================
# ?! Window_BattleStatusAid
#==============================================================================

class Window_BattleSkillAid < Window_SkillList
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :skill_window
  
  #--------------------------------------------------------------------------
  # overwrite method: initialize
  #--------------------------------------------------------------------------
  def initialize(x, y, window_width, window_height)
    super
    self.visible = false
    self.openness = 255
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_width
  #--------------------------------------------------------------------------
  def window_width; return 128; end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_height
  #--------------------------------------------------------------------------
  def window_height; return 128; end
  
  #--------------------------------------------------------------------------
  # new method: close skill
  #--------------------------------------------------------------------------
  def close_skill
    self.visible = false
  end
  
  #--------------------------------------------------------------------------
  # new method: close skill
  #--------------------------------------------------------------------------
  def open_skill
    self.visible = true
    @skill = @skill_window.item
    refresh
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    close_skill if @skill_window.nil?
    return if @skill_window.nil?
    close_skill unless @skill_window.item.use_custom_item_cost
    return unless @skill_window.item.use_custom_item_cost
    self.height = window_height
    lines = 0
    4.times do |i|
      self.height -= 24 if @skill.custom_cost_item_requirement[i] == nil
      lines += 1 if !@skill.custom_cost_item_requirement[i].nil?
    end
    contents.dispose
    self.contents = Bitmap.new(contents_width, lines * 24)
    contents.clear
    self.y = Graphics.height - self.height - window_height + 8
    num = @skill.custom_cost_item_requirement.size
    j = 0
    
    num.times { |i|
              if @skill.custom_cost_item_requirement[i] == nil
                j += 1 
                next
              end
              rect = item_rect(i-j)
              draw_custom_cost(rect, i, @skill) 
            }
  end
  
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    data = 4
    return data if @skill_window.nil?
    return data if !@skill_window.item.use_custom_item_cost
    4.times do |h|
      data -= 1 if @skill.custom_cost_item_requirement[h] == nil
    end
    return data
  end
  
  #--------------------------------------------------------------------------
  # * Get Row Count
  #--------------------------------------------------------------------------
  def row_max
    item_max
  end
  
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    row_max * item_height
  end
  
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  
  #--------------------------------------------------------------------------
  # * update
  #--------------------------------------------------------------------------
  alias r2_update_window  update
  def update
    r2_update_window
    open_skill if @skill != @skill_window.item
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: refresh
  #--------------------------------------------------------------------------
  def draw_custom_cost(rect, i, skill)
    # new data
    return if skill.custom_cost_item_requirement[i].nil?
    quantity = skill.custom_cost_item_requirement[i][0]
    item_type = skill.custom_cost_item_requirement[i][1].downcase
    item_num = skill.custom_cost_item_requirement[i][2]
    item = nil
    case item_type
    when "i"
      item = $data_items[item_num]
    when "a"
      item = $data_armors[item_num]
    when "w"
      item = $data_weapons[item_num]
    end
    icon = item.icon_index
    if icon > 0
      draw_icon(icon, rect.x, rect.y, enable?(skill))
      rect.width -= 24
    end
    rect.x += 24
    text = "x #{$game_party.item_number(item)} / #{quantity}"
    draw_text(rect, text, 2)
  end
    
end # Window_BattleStatusAid

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: skill_cost_payable?
  #--------------------------------------------------------------------------
  def skill_cost_payable?(skill)
    return false if hp <= skill_hp_cost(skill)
    return false unless gold_cost_met?(skill)
    return false unless custom_cost_met?(skill)
    return false unless custom_item_cost_met?(skill)
    return game_battlerbase_skill_cost_payable_scm(skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: custom_cost_met?
  #--------------------------------------------------------------------------
  def custom_item_cost_met?(skill)
    return true unless skill.use_custom_item_cost
    total = skill.custom_cost_item_requirement.size
    pass = true
    total.times do |i|
      next if skill.custom_cost_item_requirement[i].nil?
      quantity = skill.custom_cost_item_requirement[i][0]
      item_type = skill.custom_cost_item_requirement[i][1].downcase
      item_num = skill.custom_cost_item_requirement[i][2]
      item = nil
      case item_type
      when "i"
        item = $data_items[item_num]
      when "a"
        item = $data_armors[item_num]
      when "w"
        item = $data_weapons[item_num]
      end
      num = $game_party.item_number(item)
      pass = false if num < quantity
    end
    return pass
  end
  
  #--------------------------------------------------------------------------
  # alias method: pay_skill_cost
  #--------------------------------------------------------------------------
  alias r2_pay_skill_cost_custom_items   pay_skill_cost
  def pay_skill_cost(skill)
    r2_pay_skill_cost_custom_items(skill)
    pay_custom_item_cost(skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: pay_custom_item_cost
  #--------------------------------------------------------------------------
  def pay_custom_item_cost(skill)
    return unless skill.use_custom_item_cost
    total = skill.custom_cost_item_requirement.size
    total.times do |i|
      next if skill.custom_cost_item_requirement[i].nil?
      quantity = skill.custom_cost_item_requirement[i][0]
      item_type = skill.custom_cost_item_requirement[i][1].downcase
      item_num = skill.custom_cost_item_requirement[i][2]
      consume = skill.custom_cost_item_requirement[i][3].downcase
      item = nil
      case item_type
      when "i"
        item = $data_items[item_num]
      when "a"
        item = $data_armors[item_num]
      when "w"
        item = $data_weapons[item_num]
      end
      $game_party.lose_item(item, quantity) if consume == "c"
    end
  end
  
end

class Scene_Battle < Scene_Base

  #--------------------------------------------------------------------------
  # * Create All Windows
  #--------------------------------------------------------------------------
  alias r2_create_skill_custom_cost_window  create_all_windows
  def create_all_windows
    r2_create_skill_custom_cost_window
    create_battle_skill_aid_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_battle_status_aid_window
  #--------------------------------------------------------------------------
  def create_battle_skill_aid_window
    @skill_aid_window = Window_BattleSkillAid.new(640,640,128,128)
    @skill_aid_window.skill_window = @skill_window
    @skill_aid_window.x = Graphics.width - @skill_aid_window.width
    @skill_aid_window.y = Graphics.height - @skill_aid_window.height * 2 + 8
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_custom_skill_cost
  #--------------------------------------------------------------------------
  def draw_custom_skill_cost
    skill = @skill_window.item
    return if skill.nil?
    return unless skill.use_custom_item_cost
    @skill_aid_window.open_skill
  end
  
  #--------------------------------------------------------------------------
  # * [Skill] Command
  #--------------------------------------------------------------------------
  alias r2_skill_ok_custom_cost   command_skill
  def command_skill
    r2_skill_ok_custom_cost
    draw_custom_skill_cost
  end

  #--------------------------------------------------------------------------
  # * Skill [OK]
  #--------------------------------------------------------------------------
  alias r2_skill_ok_custom_cost_hide  on_skill_ok
  def on_skill_ok
    r2_skill_ok_custom_cost_hide
    if @skill.for_opponent?
    elsif @skill.for_friend?
    else
      @skill_aid_window.close_skill
    end
  end

  #--------------------------------------------------------------------------
  # * Skill [Cancel]
  #--------------------------------------------------------------------------
  alias r2_on_skill_cancel_custom_cost    on_skill_cancel
  def on_skill_cancel
    @skill_aid_window.close_skill
    r2_on_skill_cancel_custom_cost
  end

  #--------------------------------------------------------------------------
  # * Actor [OK]
  #--------------------------------------------------------------------------
  alias r2_on_actor_ok_custom_item_cost   on_actor_ok
  def on_actor_ok
    @skill_aid_window.close_skill
    r2_on_actor_ok_custom_item_cost
  end
  
  #--------------------------------------------------------------------------
  # * Enemy [OK]
  #--------------------------------------------------------------------------
  alias r2_on_enemy_ok_custom_item_cost   on_enemy_ok
  def on_enemy_ok
    @skill_aid_window.close_skill
    @skill_aid_window.hide
    r2_on_enemy_ok_custom_item_cost
  end
end
