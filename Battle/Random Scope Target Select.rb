# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Random Scope Target Select             ║  Version: 1.03     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║  Alter Random Selection                       ║    20 May 2022     ║
# ╚═════════════════════════════════════════════v═╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow Target scope to change                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║    Place note tag on the skill you wish to alter                   ║
# ║                                                                    ║
# ║    Skill must be set to select random enemies 1-4                  ║
# ║                                                                    ║
# ║      <select random: indiv>                                        ║
# ║    Allows choosing the enemies up to number of random              ║
# ║       enemies is set in the skill                                  ║
# ║                                                                    ║
# ║      <select random: group>                                        ║
# ║    Will select all enemies of the same type up to                  ║
# ║        the number of random enemies set for the skill.             ║
# ║        Example - two bats on screen. You select bat and            ║
# ║        skill is set to 4 random enemies. It will                   ║
# ║        randomly select from the two to complete                    ║
# ║        the taregets (bat1, bat1, bat2, bat1)                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 20 May 2022 - Initial publish                               ║
# ║ 1.01 - 30 May 2022 - Fixed typo                                    ║
# ║ 1.02 - 03 Nov 2022 - Fixed alias bug                               ║
# ║ 1.03 - 03 Nov 2022 - Added Support for Yanfly Battle Engine        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║                                                                    ║
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

module R2_Random_Enemy_Select
  X_POS = 100 # window x position
  Y_POS = 100 # window y position
  WIDTH = 270 # window width
  HEIGHT = 50 # window height
  Extra = false # add more to the window width if text is long
  Extra_Space = 20 # how much space to add.
  REGEX = /<select[-_ ]random:[ ](\w+)>/i # regex code for script
  Enemy_Text = "Choose the Targets" # text shown in window
  Enemy_Group = "Choose the Target Group" # text shown in window
  # IMPORTANT - set and forget. Used internally to hold targets
  Variable = 9
end

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
 
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_r2prev_esel load_database; end
  def self.load_database
    load_database_r2prev_esel
    load_notetags_r2_sk_esel
  end
 
  #--------------------------------------------------------------------------
  # new method: load_notetags_lse
  #--------------------------------------------------------------------------
  def self.load_notetags_r2_sk_esel
    for r2skesel in $data_skills
      next if r2skesel.nil?
      r2skesel.load_notetags_r2_sk_esel
    end
  end
 
end # DataManager

#==============================================================================
# ■ RPG::Skill
#==============================================================================

class RPG::Skill < RPG::UsableItem
 
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :enm_sel_sk

  #--------------------------------------------------------------------------
  # common cache: load_notetags_lse
  #--------------------------------------------------------------------------
  def load_notetags_r2_sk_esel
    @enm_sel_sk = ""
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when R2_Random_Enemy_Select::REGEX
        return if $1.nil?
        @enm_sel_sk = ($1.upcase.to_s)
      end
    } # self.note.split
    #---
  end
 
end # RPG::Skill

class Window_Enemy_Random < Window_Base
  attr_accessor :enemy_selected
  attr_accessor :enemy_group
  attr_accessor :enemy_count
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    x = R2_Random_Enemy_Select::X_POS
    y = R2_Random_Enemy_Select::Y_POS
    super(x, y, window_width, window_height)
    self.width += R2_Random_Enemy_Select::Extra_Space if R2_Random_Enemy_Select::Extra == true
    @enemy_group = false
    @enemy_count = 0
    @enemy_selected = 0
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    R2_Random_Enemy_Select::WIDTH
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    R2_Random_Enemy_Select::HEIGHT
  end
  #--------------------------------------------------------------------------
  # * Set Skill
  #--------------------------------------------------------------------------
  def set_skill(skill)
    return if skill.enm_sel_sk == []
    skill.enm_sel_sk == "GROUP" ? @enemy_group = true : @enemy_group = false
    @enemy_count = skill.scope.to_i - 2
    @enemy_selected = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Set selected
  #--------------------------------------------------------------------------
  def add_selected(num)
    @enemy_selected += num
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    reset_font_settings
    text2 = @enemy_selected.to_s + "/" + @enemy_count.to_s
    if @enemy_group == false
      text1 = R2_Random_Enemy_Select::Enemy_Text.to_s
      text = text1 + ": " + text2
    else
      text = R2_Random_Enemy_Select::Enemy_Group.to_s
    end
    draw_text(0, -15, window_width, window_height, text, 0)
  end
end

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Create All Windows
  #--------------------------------------------------------------------------
  alias r2_create_all_enemy_select_windows_824f7  create_all_windows
  def create_all_windows
    r2_create_all_enemy_select_windows_824f7
    enemy_selected_window
  end
  #--------------------------------------------------------------------------
  # * Create Message Window
  #--------------------------------------------------------------------------
  def enemy_selected_window
    @enemy_select_window = Window_Enemy_Random.new
    @enemy_select_window.hide
  end
 
  #--------------------------------------------------------------------------
  # * Start Enemy Selection
  #--------------------------------------------------------------------------
  def select_enemy_random_selection
    @enm_list = []
    @enm_selected = []
    $game_variables[R2_Random_Enemy_Select::Variable] = []
    @enemy_select_window.set_skill(@skill)
    @enemy_window.refresh
    @enemy_window.show.activate
    @enemy_select_window.show
  end
  #--------------------------------------------------------------------------
  # * Pick enemies from the group
  #--------------------------------------------------------------------------
  def pick_enemy
    amt = @enm_selected.size
    num = rand(amt)
    return @enm_selected[num]
  end
  #--------------------------------------------------------------------------
  # * Enemy [OK]
  #--------------------------------------------------------------------------
  alias r2_enemy_ok_skill_check_group on_enemy_ok
  def on_enemy_ok
    if (@actor_command_window.current_symbol == :skill) && (@skill.enm_sel_sk == "GROUP")
      BattleManager.actor.input.target_index = @enemy_window.enemy.index
      choosen = @enemy_window.enemy
      $game_troop.alive_members.each { |enemy|
        @enm_selected.push(enemy) if enemy.enemy_id == choosen.enemy_id
      }
      for i in 1..(@skill.scope.to_i - 2)
        @enm_list.push(pick_enemy)
      end
      $game_variables[R2_Random_Enemy_Select::Variable] = @enm_list
      @enemy_select_window.hide
      @enemy_window.hide
      @skill_window.hide
      @item_window.hide
      next_command
    elsif (@actor_command_window.current_symbol == :skill) && (@skill.enm_sel_sk == "INDIV")
      BattleManager.actor.input.target_index = @enemy_window.enemy.index
      $game_variables[R2_Random_Enemy_Select::Variable].push(@enemy_window.enemy)
      @enemy_select_window.add_selected(1)
      if @enemy_select_window.enemy_selected == (@skill.scope.to_i - 2)
        @enemy_select_window.hide
        @enemy_window.hide
        @skill_window.hide
        @item_window.hide
        next_command
      else
        @enemy_window.refresh
        @enemy_window.show.activate
        @enemy_select_window.show
      end
    else
      r2_enemy_ok_skill_check_group
    end
  end
  #--------------------------------------------------------------------------
  # * Skill [OK]
  #--------------------------------------------------------------------------
  if $imported["YEA-BattleEngine"]
    def on_skill_ok
      @skill = @skill_window.item
      $game_temp.battle_aid = @skill
      BattleManager.actor.input.set_skill(@skill.id)
      BattleManager.actor.last_skill.object = @skill
      if @skill.enm_sel_sk != ""
        select_enemy_random_selection
      elsif @skill.for_opponent?
        select_enemy_selection
      elsif @skill.for_friend?
        select_actor_selection
      else
        @skill_window.hide
        next_command
        $game_temp.battle_aid = nil
      end
    end
  else
    def on_skill_ok
      @skill = @skill_window.item
      BattleManager.actor.input.set_skill(@skill.id)
      BattleManager.actor.last_skill.object = @skill
      if @skill.enm_sel_sk != ""
        select_enemy_random_selection
      elsif !@skill.need_selection?
        @skill_window.hide
        next_command
      elsif @skill.for_opponent?
        select_enemy_selection
      else
        select_actor_selection
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Enemy [Cancel]
  #--------------------------------------------------------------------------
  alias r2_on_enemy_cancel_group_enemy  on_enemy_cancel
  def on_enemy_cancel
    @enemy_select_window.hide
    r2_on_enemy_cancel_group_enemy
  end
end

class Game_Unit
  #--------------------------------------------------------------------------
  # * Random Selection of Target
  #--------------------------------------------------------------------------
  def random_specific
    select = $game_variables[R2_Random_Enemy_Select::Variable][0]
    return nil if select == nil
    $game_variables[R2_Random_Enemy_Select::Variable].shift
    return select
  end
end

class Game_Action
  #--------------------------------------------------------------------------
  # * OVERWRITE - Random Selection of Target
  #--------------------------------------------------------------------------
  def targets_for_opponents
    if item.for_random?
      if item.is_a?(RPG::Skill) && item.enm_sel_sk != ""
        Array.new(item.number_of_targets) { opponents_unit.random_specific }
      else
        Array.new(item.number_of_targets) { opponents_unit.random_target }
      end
    elsif item.for_one?
      num = 1 + (attack? ? subject.atk_times_add.to_i : 0)
      if @target_index < 0
        [opponents_unit.random_target] * num
      else
        [opponents_unit.smooth_target(@target_index)] * num
      end
    else
      opponents_unit.alive_members
    end
  end
end
