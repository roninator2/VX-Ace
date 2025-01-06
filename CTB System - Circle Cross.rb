#==============================================================================
# □ CTB（2013/03/08）
#------------------------------------------------------------------------------
# 　CTB introduction
#==============================================================================

module R2_CTB_SETTINGS
#==============================================================================
# ☆ Customization here.
#==============================================================================

  # Set the AP required to act.
  CC_CTB_AP_ACTION_LIMIT = 100
 
  # Select whether to set AP to 0 after action.
  # Specify true to set to 0, false otherwise.
  CC_CTB_AP_RESET = true
 
  # Set combat speed. Smaller is faster.
  # Set a value greater than 0.
  CC_CTB_BATTLE_SPEED = 20.0
 
  # Adjust or set combat speed to be constant regardless of agility.
  # When true, make battle speed constant.
  CC_CTB_BATTLE_SPEED_ADJUST = true
 
  # Sets the battle speed when CC_CTB_BATTLE_SPEED_ADJUST is true.
  # Higher values are faster.
  CC_CTB_ADJUSTED_SPEED = 20.0
 
  # Set the timing of automatic recovery.
  # At the end of action = 0, at the time of TP natural increase = 1
  CC_CTB_REGENERATE_TIMING = 1
 
  # Adjust the auto-recovery speed. Smaller is faster.
  # Set a value greater than 0.
  CC_CTB_REGENERATE_SPEED = 20.0
 
  # Set the AP consumed when using the item.
  CC_CTB_ITEM_AP_COST = CC_CTB_AP_ACTION_LIMIT
 
#==============================================================================
# ☆ Customization here.
#==============================================================================
end
#==============================================================================
# □ BattleManager
#------------------------------------------------------------------------------
# 　A module that manages the progress of battles.
#==============================================================================

module BattleManager
  class << self
    #--------------------------------------------------------------------------
    # ○ Combat start
    #--------------------------------------------------------------------------
    alias cc_ctb_battle_start battle_start
    def battle_start
      cc_ctb_battle_start
      if @preemptive
        $game_party.members.each {|member| member.ap += R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT / 2 }
      elsif @surprise
        $game_troop.members.each {|member| member.ap += R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT / 2 }
      end
      speed_adjust_set if R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST
    end
    #--------------------------------------------------------------------------
    # ○ Creating action sequences
    #--------------------------------------------------------------------------
    def make_action_orders
      @action_battlers = [next_action_battler]
      @action_battlers[0].increase_turn if @action_battlers[0].is_a?(Game_Enemy)
    end
    #--------------------------------------------------------------------------
    # ○ Acquiring the next battler to act
    #--------------------------------------------------------------------------
    def next_action_battler
      battlers = []
      battlers += $game_party.alive_members unless @surprise
      battlers += $game_troop.alive_members unless @preemptive
      battlers.sort! {|a,b| b.agi - a.agi }
      battlers.min_by {|battler|
        (R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT - battler.ap) / battler.agi
      }
    end
    #--------------------------------------------------------------------------
    # ○ Get Combat Speed Modifier
    #--------------------------------------------------------------------------
    def speed_adjust_set
      battlers = $game_party.members + $game_troop.members
      $cc_ctb_speed_adjust = battlers.max_by {|battler| battler.agi }.agi / R2_CTB_SETTINGS::CC_CTB_ADJUSTED_SPEED
    end
  end
end

#==============================================================================
# □ Game_BattlerBase
#------------------------------------------------------------------------------
# 　This is the basic class that handles battlers. 
#  Mainly contains methods for ability score calculation. child
#  class is used as the superclass of the Game_Battler class.
#==============================================================================

class Game_BattlerBase
  alias cc_ctb_hrg hrg
  alias cc_ctb_mrg mrg
  alias cc_ctb_trg trg
  def hrg;  cc_ctb_hrg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 ? 
    R2_CTB_SETTINGS::CC_CTB_REGENERATE_SPEED : 1);  end    # HP再生率   Hp ReGeneration rate
  def mrg;  cc_ctb_mrg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 ? 
    R2_CTB_SETTINGS::CC_CTB_REGENERATE_SPEED : 1);  end    # MP再生率   Mp ReGeneration rate
  def trg;  cc_ctb_trg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 ? 
    R2_CTB_SETTINGS::CC_CTB_REGENERATE_SPEED : 1);  end    # TP再生率   Tp ReGeneration rate
  #--------------------------------------------------------------------------
  # ○ public instance variables
  #--------------------------------------------------------------------------
  attr_reader   :ap                       # AP
  #--------------------------------------------------------------------------
  # ○ object initialization
  #--------------------------------------------------------------------------
  alias cc_atb_initialize initialize
  def initialize
    @ap = 0
    cc_atb_initialize
  end
  #--------------------------------------------------------------------------
  # ○ AP change of
  #--------------------------------------------------------------------------
  def ap=(ap)
    @ap = [[ap, max_ap].min, 0].max
  end
  #--------------------------------------------------------------------------
  # ○ AP get the percentage of
  #--------------------------------------------------------------------------
  def ap_rate
    @ap.to_f / max_ap
  end
  #--------------------------------------------------------------------------
  # ○ AP get the maximum value of
  #--------------------------------------------------------------------------
  def max_ap
    return R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT
  end
  #--------------------------------------------------------------------------
  # ○ Skill AP consumption calculation
  #--------------------------------------------------------------------------
  def skill_ap_cost(skill)
    skill.speed
  end
  #--------------------------------------------------------------------------
  # ○ Ability to pay for skill use cost
  #--------------------------------------------------------------------------
  alias cc_ctb_skill_cost_payable? skill_cost_payable?
  def skill_cost_payable?(skill)
    (!$game_party.in_battle || ap >= skill_ap_cost(skill)) && cc_ctb_skill_cost_payable?(skill)
  end
  #--------------------------------------------------------------------------
  # ○ Pay skill use cost
  #--------------------------------------------------------------------------
  alias cc_ctb_pay_skill_cost pay_skill_cost
  def pay_skill_cost(skill)
    cc_ctb_pay_skill_cost(skill)
    self.ap -= skill_ap_cost(skill) if $game_party.in_battle
  end
  #--------------------------------------------------------------------------
  # ○ action judgment
  #--------------------------------------------------------------------------
  def action?
    ap >= R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT && self == BattleManager.next_action_battler
  end
end

#==============================================================================
# □ Game_Battler
#------------------------------------------------------------------------------
# 　A Butler class with sprite and action related methods added. this class
#  is used as the superclass for the Game_Actor and Game_Enemy classes.
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ○ AP initialization of
  #--------------------------------------------------------------------------
  def init_ap
    self.ap = rand * 25
  end
  #--------------------------------------------------------------------------
  # ○ Battle start process
  #--------------------------------------------------------------------------
  alias cc_ctb_on_battle_start on_battle_start
  def on_battle_start
    cc_ctb_on_battle_start
    init_ap
  end
  #--------------------------------------------------------------------------
  # ○ Combat action creation
  #--------------------------------------------------------------------------
  alias cc_ctb_make_actions make_actions
  def make_actions
    cc_ctb_make_actions
    @actions = [] if self != BattleManager.next_action_battler
  end
  #--------------------------------------------------------------------------
  # ○ Judgment that command input is possible
  #--------------------------------------------------------------------------
  alias cc_ctb_inputable? inputable?
  def inputable?
    cc_ctb_inputable? && action?
  end
  #--------------------------------------------------------------------------
  # ○ HP the playback of
  #--------------------------------------------------------------------------
  def regenerate_hp
    damage = -(mhp * hrg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 && 
    R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST ? $cc_ctb_speed_adjust : 1)).to_i
    perform_map_damage_effect if $game_party.in_battle && damage > 0
    @result.hp_damage = [damage, max_slip_damage].min
    self.hp -= @result.hp_damage
  end
  #--------------------------------------------------------------------------
  # ○ MP the playback of
  #--------------------------------------------------------------------------
  def regenerate_mp
    @result.mp_damage = -(mmp * mrg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 && 
    R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST ? $cc_ctb_speed_adjust : 1))
    self.mp -= @result.mp_damage
  end
  #--------------------------------------------------------------------------
  # ○ TP the playback of
  #--------------------------------------------------------------------------
  def regenerate_tp
    self.tp += R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT * trg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 && 
    R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST ? $cc_ctb_speed_adjust : 1)
  end
  #--------------------------------------------------------------------------
  # ○ Processing at the end of combat action
  #--------------------------------------------------------------------------
  alias cc_ctb_on_action_end on_action_end
  def on_action_end
    cc_ctb_on_action_end
    regenerate_all if R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 0
  end
  #--------------------------------------------------------------------------
  # ○ TP consumption when acting
  #--------------------------------------------------------------------------
  def cc_ctb_ap_action_cost
    if (R2_CTB_SETTINGS::CC_CTB_AP_RESET || !current_action) && action?
      self.ap -= R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT
    elsif current_action && current_action.item.is_a?(RPG::Item)
      self.ap -= R2_CTB_SETTINGS::CC_CTB_ITEM_AP_COST
    end
  end
  #--------------------------------------------------------------------------
  # ○ End of turn process
  #--------------------------------------------------------------------------
  def on_turn_end
    @result.clear
    remove_states_auto(2)
  end
end

#==============================================================================
# □ Game_Enemy
#------------------------------------------------------------------------------
# 　A class that handles enemy characters. This class is the Game_Troop class 
#  ($game_troop) Used internally.
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ○ public instance variables
  #--------------------------------------------------------------------------
  attr_reader   :turn_count               # Enemy group index
  #--------------------------------------------------------------------------
  # ○ object initialization
  #--------------------------------------------------------------------------
  alias cc_ctb_initialize initialize
  def initialize(index, enemy_id)
    cc_ctb_initialize(index, enemy_id)
    @turn_count = 1
  end
  #--------------------------------------------------------------------------
  # ○ Action condition match judgment [number of turns]
  #--------------------------------------------------------------------------
  def conditions_met_turns?(param1, param2)
    n = @turn_count
    if param2 == 0
      n == param1
    else
      n > 0 && n >= param1 && n % param2 == param1 % param2
    end
  end
  #--------------------------------------------------------------------------
  # ○ increase in turns
  #--------------------------------------------------------------------------
  def increase_turn
    @turn_count += 1
  end
end

#==============================================================================
# □ Window_Base
#------------------------------------------------------------------------------
# 　The superclass of all windows in the game.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ○ Acquisition of various character colors
  #--------------------------------------------------------------------------
  def ap_gauge_color1;   text_color(30);  end;    # AP gauge 1
  def ap_gauge_color2;   text_color(31);  end;    # AP gauge 2
  #--------------------------------------------------------------------------
  # ○ AP get the text color of
  #--------------------------------------------------------------------------
  def ap_color(actor)
    return normal_color
  end
  #--------------------------------------------------------------------------
  # ○ AP Drawing of
  #--------------------------------------------------------------------------
  def draw_actor_ap(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.ap_rate, ap_gauge_color1, ap_gauge_color2)
    #change_color(system_color)
    #draw_text(x, y, 30, line_height, Vocab::ap_a)
    #change_color(ap_color(actor))
    #draw_text(x + width - 42, y, 42, line_height, actor.ap.to_i, 2)
  end
  #--------------------------------------------------------------------------
  # ○ HP Drawing of
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(x, y, width, actor.hp.to_i, actor.mhp,
      hp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # ○ MP Drawing of
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(x, y, width, actor.mp.to_i, actor.mmp,
      mp_color(actor), normal_color)
  end
end

#==============================================================================
# □ Window_BattleStatus
#------------------------------------------------------------------------------
# 　A window that displays the status of party members on the battle screen.
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ○ Draw a basic area
  #--------------------------------------------------------------------------
  alias cc_atb_draw_basic_area draw_basic_area
  def draw_basic_area(rect, actor)
    draw_actor_ap(actor, rect.x + 0, rect.y, 100)
    cc_atb_draw_basic_area(rect, actor)
  end
end

#==============================================================================
# □ Window_Selectable
#------------------------------------------------------------------------------
# 　Window class with cursor movement and scrolling functions.
#==============================================================================

class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # ○ Redraw all items
  #--------------------------------------------------------------------------
  def redraw_all_items
    item_max.times {|i| clear_item(i) }
    item_max.times {|i| draw_item(i) }
  end
end

#==============================================================================
# □ Scene_Battle
#------------------------------------------------------------------------------
# 　A class that processes the battle screen.
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ○ Redraw the information in the status window
  #--------------------------------------------------------------------------
  def redraw_status
    @status_window.redraw_all_items
    @enemy_window.redraw_all_items
  end
  #--------------------------------------------------------------------------
  # ○ Update information in status window
  #--------------------------------------------------------------------------
  def refresh_status
    @status_window.refresh
    @enemy_window.refresh
  end
  #--------------------------------------------------------------------------
  # ○ Frame update (AP increase)
  #--------------------------------------------------------------------------
  def update_ap
    all_alive_members.each do |member|
      member.ap += member.agi / R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED / (R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST ? $cc_ctb_speed_adjust : 1)
      member.regenerate_all if R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1
    end
    redraw_status
    update_basic
  end
  #--------------------------------------------------------------------------
  # ○ Start party command selection
  #--------------------------------------------------------------------------
  def start_party_command_selection
    unless scene_changing?
      refresh_status
      @status_window.unselect
      @status_window.open
      while BattleManager.next_action_battler.ap < R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT
        update_ap
      end
      if BattleManager.input_start
        @actor_command_window.close
        @party_command_window.setup
      else
        @party_command_window.deactivate
        turn_start
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ Acquisition of all battle members including enemies and allies
  #--------------------------------------------------------------------------
  def all_movable_members
    $game_party.movable_members + $game_troop.movable_members
  end
  #--------------------------------------------------------------------------
  # ○ Acquisition of all surviving members including enemies and allies
  #--------------------------------------------------------------------------
  def all_alive_members
    $game_party.alive_members + $game_troop.alive_members
  end
  #--------------------------------------------------------------------------
  # ○ Command [Escape]
  #--------------------------------------------------------------------------
  alias cc_ctb_command_escape command_escape
  def command_escape
    cc_ctb_command_escape
    $game_party.movable_members.each do |member|
      member.ap = 0
    end
  end
  #--------------------------------------------------------------------------
  # ○ start of turn
  #--------------------------------------------------------------------------
  def turn_start
    @party_command_window.close
    @actor_command_window.close
    @status_window.unselect
    @subject = nil
    BattleManager.turn_start
    @log_window.clear
  end
  #--------------------------------------------------------------------------
  # ○ Handling Combat Actions
  #--------------------------------------------------------------------------
  def process_action
    return if scene_changing?
    if !@subject || !@subject.current_action
      @subject = BattleManager.next_subject
    end
    return turn_end unless @subject
    if @subject.action?
      @subject.update_state_turns
      @subject.update_buff_turns
    end
    if @subject.current_action
      @subject.current_action.prepare
      if @subject.current_action.valid?
        @status_window.open
        execute_action
      end
    end
    if @subject.action?
      @subject.cc_ctb_ap_action_cost
    end
    if @subject.current_action
      @subject.remove_current_action
    end
    process_action_end unless @subject.current_action
  end
end
