# Ability Menu by Arttroy (advised and corrected by Estheone)
# Contact on https://www.rpg-maker.fr/index.php?page=membre&id=22277
# Modified by Roninator2
# 2021-11-11
# V 1.1
#==============================================================================
#  Instructions :
#
# * Modification of skills obtained and their level:
#
# Line 78 :
#   Skills = [[3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14]]
#
#  The id of skills matches that of the database, modify it as you want
#-------------------------------------------------------------
# 
# * Modification of the level when skill will be obtained
#
# Line 80 :
#   Learn_Level = [[3, 6, 10], [3, 10, 30], [3, 10, 30], [3, 10, 30]]
#
#  You can modify the level of category when skill will be obtained.
#
# These two lines are matching together, if you want to add a skill you 
# must also modify the line for the level
# Maximum of 4 skills supported
# 
#-------------------------------------------------------------
# * Modification of the actor parameters:
#  
# Line 124 :
#   @augmentation = [0, 0, 0, 0, 0, 0, 0, 0]
#  
# Read this like :
#   @augmentation = [HP, MP, Atk, Def, Mat, Mdf, Agi, Luk]
# You will have to modify the values of the method addedstats_calculation 
# (Line 156)
#
#   @augmentation[2] = Random.new.rand(3..8) 
# 
#-------------------------------------------------------------
# * Modification of the Crystal Images
#  
# Line 751:
# @crystal_pictures = ["Crystal", "Glowing_Crystal", "Red_Crystal", "Glowing_Red_Crystal", "Blue_Crystal", "Glowing_Blue_Crystal",
#     "Yellow_Crystal", "Glowing_Yellow_Crystal", "Green_Crystal", "Glowing_Green_Crystal", "Orange_Crystal", "Glowing_Orange_Crystal"]
#     
# Instructions on line 743 - two crystal files per column 
#   The first is the default no skill level
#-------------------------------------------------------------
# You can modify the values of random. At the same time modify the display values 
# from the line 759 (def refresh of the Scene_Ability).
#
# If you want to modify the parameter growth 
# you will have to change the display of contents for the adds. 
# I advise not to do this if you don't know how to do this.
#
# Do not forget to insert images in the folder Pictures
#-------------------------------------------------------------
# Added Feature:
# abilitypoints_up -> actor gains one ability point
#   make an item with hp damage. Formula = b.abilitypoints_up; 0
#   Add in gain_tp 0% feature. Formula Variance 0
#==============================================================================
 
module R2_Ability_Options
  # Set the max level for all ability crystals
  MAX_LEVEL = 30
  # Show equiment icons or just the accessory name
  Show_All_Equip = false
  # show numbers on status page, by default only shows + sign
  Show_Numbers = true
  # true means the player will the numbers. This has a negative effect
  # as the player can easily figure out that you can cancel and select
  # again to have the numbers regenerated
  Confirm_Text = " Add a point to this category?"
  # Designate skills to learn when ability reaches the level below
  Skills = [[3, 4, 5, 8], [6, 7, 8], [9, 10, 11], [12, 13, 14], [18, 19, 20]]
  # 0 => 3, 4, 5 -> level 3, 6, 10 = 3 -> 3, 4 -> 6,  5 -> 10
  Learn_Level = [[3, 6, 10, 12], [3, 10, 30], [3, 10, 30], [3, 10, 30], [4, 11, 32]]
end

#==============================================================================
# ** Game_Temp
#==============================================================================
class Game_Temp
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :ability_index            # Index for ability menu
  
  #--------------------------------------------------------------------------
  # * Aliasing method initialize
  #--------------------------------------------------------------------------
  alias ability_initialize initialize
  def initialize
    @ability_index = 0
    ability_initialize
  end
end
 
#==============================================================================
# ** Game_Actor
#==============================================================================
 
class Game_Actor < Game_Battler
  
  attr_reader   :ability_level            # for ability level
  attr_reader   :ability_points           # for new skill by levelling ability
  attr_reader   :ability_new_skills_id    # for new skill by levelling ability
  attr_reader   :ability_new_skills_level # required level for new skills
  attr_reader   :augmentation             # for added stats by levelling ability
 
  #--------------------------------------------------------------------------
  # * Aliasing method setup(actor_id)
  #--------------------------------------------------------------------------
  alias ability_setup setup
  def setup(actor_id)
    @ability_level = [0, 0, 0, 0, 0]
    @ability_points = 0
    @ability_new_skills_id = R2_Ability_Options::Skills
    @ability_new_skills_level = R2_Ability_Options::Learn_Level
    @augmentation = [0, 0, 0, 0, 0, 0, 0, 0]
    ability_setup(actor_id)
  end
  
  #--------------------------------------------------------------------------
  # * Check if ability_level is equal to skill_level - 1
  #--------------------------------------------------------------------------
  def check_ability_skills_learning(n)
    level = @ability_level[n]
    for i in 0...@ability_new_skills_id[n].size
      skill = @ability_new_skills_id[n][i]
      required_level = @ability_new_skills_level[n][i]
      learn_skill(skill) if level >= required_level
    end
  end
  
  #--------------------------------------------------------------------------
  # * Ability Maximum Level
  #--------------------------------------------------------------------------
  def ability_max_level
    return R2_Ability_Options::MAX_LEVEL
  end
  #--------------------------------------------------------------------------
  # * Determine Maximum Level
  #--------------------------------------------------------------------------
  def ability_max_level?
    @ability_level >= ability_max_level
  end
 
  #--------------------------------------------------------------------------
  # * Calculate Stats Augmentation
  #--------------------------------------------------------------------------  
  def addedstats_calculation
    case $game_temp.ability_index
      when 0
        if @ability_level[0].between?(0, 9)
          @augmentation[2] = Random.new.rand(2..3)
          @augmentation[3] = Random.new.rand(2..3)
          @augmentation[0] = Random.new.rand(20..35)
        elsif @ability_level[0].between?(10, 19)
          @augmentation[2] = Random.new.rand(3..4)
          @augmentation[3] = Random.new.rand(3..4)
          @augmentation[0] = Random.new.rand(40..50)
        elsif @ability_level[0].between?(20, 29)
          @augmentation[2] = Random.new.rand(5..6)
          @augmentation[3] = Random.new.rand(5..6)
          @augmentation[0] = Random.new.rand(60..70)
        elsif @ability_level[0].between?(30, 39)
          @augmentation[2] = Random.new.rand(7..9)
          @augmentation[3] = Random.new.rand(7..9)
          @augmentation[0] = Random.new.rand(80..100)
        elsif @ability_level[0].between?(40, 49)
          @augmentation[2] = Random.new.rand(10..14)
          @augmentation[3] = Random.new.rand(10..14)
          @augmentation[0] = Random.new.rand(100..120)
        elsif @ability_level[0].between?(50, 59)
          @augmentation[2] = Random.new.rand(15..20)
          @augmentation[3] = Random.new.rand(15..20)
          @augmentation[0] = Random.new.rand(120..150)
        end
      when 1
        if @ability_level[1].between?(0, 9)
          @augmentation[4] = Random.new.rand(2..3)
          @augmentation[5] = Random.new.rand(2..3)
          @augmentation[1] = Random.new.rand(10..15)
        elsif @ability_level[1].between?(10, 19)
          @augmentation[4] = Random.new.rand(4..5)
          @augmentation[5] = Random.new.rand(4..5)
          @augmentation[1] = Random.new.rand(15..20)
        elsif @ability_level[1].between?(20, 29)
          @augmentation[4] = Random.new.rand(6..7)
          @augmentation[5] = Random.new.rand(6..7)
          @augmentation[1] = Random.new.rand(20..30)
        elsif @ability_level[1].between?(30, 39)
          @augmentation[4] = Random.new.rand(8..10)
          @augmentation[5] = Random.new.rand(8..10)
          @augmentation[1] = Random.new.rand(40..50)
        elsif @ability_level[1].between?(40, 49)
          @augmentation[4] = Random.new.rand(10..15)
          @augmentation[5] = Random.new.rand(10..15)
          @augmentation[1] = Random.new.rand(60..70)
        elsif @ability_level[1].between?(50, 59)
          @augmentation[4] = Random.new.rand(16..20)
          @augmentation[5] = Random.new.rand(16..20)
          @augmentation[1] = Random.new.rand(80..90)
        end
      when 2
        if @ability_level[2].between?(0, 9)
          @augmentation[6] = Random.new.rand(2..3)
          @augmentation[7] = Random.new.rand(2..3)
          @augmentation[4] = Random.new.rand(1..2)
          @augmentation[5] = Random.new.rand(1..2)
        elsif @ability_level[2].between?(10, 19)
          @augmentation[6] = Random.new.rand(4..6)
          @augmentation[7] = Random.new.rand(4..6)
          @augmentation[4] = Random.new.rand(2..3)
          @augmentation[5] = Random.new.rand(2..3)
        elsif @ability_level[2].between?(20, 29)
          @augmentation[6] = Random.new.rand(7..9)
          @augmentation[7] = Random.new.rand(7..9)
          @augmentation[4] = Random.new.rand(4..6)
          @augmentation[5] = Random.new.rand(4..6)
        elsif @ability_level[2].between?(30, 39)
          @augmentation[6] = Random.new.rand(10..12)
          @augmentation[7] = Random.new.rand(10..12)
          @augmentation[4] = Random.new.rand(7..9)
          @augmentation[5] = Random.new.rand(7..9)
        elsif @ability_level[2].between?(40, 49)
          @augmentation[6] = Random.new.rand(14..16)
          @augmentation[7] = Random.new.rand(14..16)
          @augmentation[4] = Random.new.rand(10..12)
          @augmentation[5] = Random.new.rand(10..12)
        elsif @ability_level[2].between?(50, 59)
          @augmentation[6] = Random.new.rand(18..20)
          @augmentation[7] = Random.new.rand(18..20)
          @augmentation[4] = Random.new.rand(14..15)
          @augmentation[5] = Random.new.rand(14..15)
        end
      when 3
        if @ability_level[3].between?(0, 9)
          @augmentation[2] = Random.new.rand(2..3)
          @augmentation[4] = Random.new.rand(2..3)
          @augmentation[0] = Random.new.rand(15..25)
          @augmentation[1] = Random.new.rand(5..10)
        elsif @ability_level[3].between?(10, 19)
          @augmentation[2] = Random.new.rand(4..6)
          @augmentation[4] = Random.new.rand(4..6)
          @augmentation[0] = Random.new.rand(25..35)
          @augmentation[1] = Random.new.rand(10..15)
        elsif @ability_level[3].between?(20, 29)
          @augmentation[2] = Random.new.rand(7..9)
          @augmentation[4] = Random.new.rand(7..9)
          @augmentation[0] = Random.new.rand(40..50)
          @augmentation[1] = Random.new.rand(20..25)
        elsif @ability_level[3].between?(30, 39)
          @augmentation[2] = Random.new.rand(10..12)
          @augmentation[4] = Random.new.rand(10..12)
          @augmentation[0] = Random.new.rand(50..75)
          @augmentation[1] = Random.new.rand(30..35)
        elsif @ability_level[3].between?(40, 49)
          @augmentation[2] = Random.new.rand(15..17)
          @augmentation[4] = Random.new.rand(15..17)
          @augmentation[0] = Random.new.rand(80..85)
          @augmentation[1] = Random.new.rand(35..40)
        elsif @ability_level[3].between?(50, 59)
          @augmentation[2] = Random.new.rand(18..20)
          @augmentation[4] = Random.new.rand(18..20)
          @augmentation[0] = Random.new.rand(90..95)
          @augmentation[1] = Random.new.rand(40..50)
        end
      when 4
        if @ability_level[4].between?(0, 9)
          @augmentation[3] = Random.new.rand(2..4)
          @augmentation[5] = Random.new.rand(2..4)
          @augmentation[6] = Random.new.rand(2..3)
          @augmentation[7] = Random.new.rand(2..3)
        elsif @ability_level[4].between?(10, 19)
          @augmentation[3] = Random.new.rand(4..6)
          @augmentation[5] = Random.new.rand(4..6)
          @augmentation[6] = Random.new.rand(4..5)
          @augmentation[7] = Random.new.rand(4..5)
        elsif @ability_level[4].between?(20, 29)
          @augmentation[3] = Random.new.rand(7..9)
          @augmentation[5] = Random.new.rand(7..9)
          @augmentation[6] = Random.new.rand(6..8)
          @augmentation[7] = Random.new.rand(6..8)
        elsif @ability_level[4].between?(30, 39)
          @augmentation[3] = Random.new.rand(10..12)
          @augmentation[5] = Random.new.rand(10..12)
          @augmentation[6] = Random.new.rand(8..10)
          @augmentation[7] = Random.new.rand(8..10)
        elsif @ability_level[4].between?(40, 49)
          @augmentation[3] = Random.new.rand(12..14)
          @augmentation[5] = Random.new.rand(12..14)
          @augmentation[6] = Random.new.rand(10..12)
          @augmentation[7] = Random.new.rand(10..12)
        elsif @ability_level[4].between?(50, 59)
          @augmentation[3] = Random.new.rand(15..18)
          @augmentation[5] = Random.new.rand(15..18)
          @augmentation[6] = Random.new.rand(12..14)
          @augmentation[7] = Random.new.rand(12..14)
        end
    end
  end
  #--------------------------------------------------------------------------
  # * Add Stats Augmentation
  #--------------------------------------------------------------------------  
  def stats_augmentation
    case $game_temp.ability_index
    when 0
      add_param(2, @augmentation[2])
      add_param(3, @augmentation[3])
      add_param(0, @augmentation[0])
    when 1
      add_param(4, @augmentation[4])
      add_param(5, @augmentation[5])
      add_param(1, @augmentation[1])
    when 2
      add_param(6, @augmentation[6])
      add_param(7, @augmentation[7])
      add_param(4, @augmentation[4])
      add_param(5, @augmentation[5])
    when 3
      add_param(2, @augmentation[2])
      add_param(4, @augmentation[4])
      add_param(0, @augmentation[0])
      add_param(1, @augmentation[1])
    when 4
      add_param(3, @augmentation[3])
      add_param(5, @augmentation[5])
      add_param(6, @augmentation[6])
      add_param(7, @augmentation[7])
    end
  end
 
  #--------------------------------------------------------------------------
  # * Ability Points Down
  #--------------------------------------------------------------------------
  def abilitypoints_down
    @ability_points -= 1
  end
  
  #--------------------------------------------------------------------------
  # * Ability Points Up
  #--------------------------------------------------------------------------
  def abilitypoints_up
    @ability_points += 1
  end

  #--------------------------------------------------------------------------
  # * Aliasing method Level Up
  #--------------------------------------------------------------------------
  alias ability_level_up level_up
  def level_up
    @ability_points += 1
    ability_level_up
  end
end
 
#==============================================================================
# ** Window_MenuCommand
#==============================================================================
 
class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Overwrite method Adding Original Commands
  #--------------------------------------------------------------------------
  def add_original_commands
    add_command("Ability", :ability, main_commands_enabled)
  end
end  
 
#==============================================================================
# ** Scene_Menu
#==============================================================================
 
class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Overwrite method Create Command Window
  #--------------------------------------------------------------------------
  alias r2_ability_command_2837r    create_command_window
  def create_command_window
    r2_ability_command_2837r
    @command_window.set_handler(:ability,   method(:command_ability))
  end
  
  #--------------------------------------------------------------------------
  # * [Ability] Command
  #--------------------------------------------------------------------------
  def command_ability
    @status_window.select_last
    @status_window.activate
    @status_window.set_handler(:ok,     method(:on_ability_ok))
    @status_window.set_handler(:cancel, method(:on_ability_cancel))
  end
 
  #--------------------------------------------------------------------------
  # * Ability [OK]
  #--------------------------------------------------------------------------
  def on_ability_ok
    if @status_window.pending_index >= 0
      @status_window.pending_index = @status_window.index
    end
    @status_window.activate
    SceneManager.call(Scene_Ability)
  end
  #--------------------------------------------------------------------------
  # * Ability [Cancel]
  #--------------------------------------------------------------------------
  def on_ability_cancel
    if @status_window.pending_index >= 0
      @status_window.pending_index = -1
      @status_window.activate
    else
      @status_window.unselect
      @command_window.activate
    end
  end
end
 
#===============================================================================
#   ** Scene_Ability
#===============================================================================
 
class Scene_Ability < Scene_MenuBase
    
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    $game_temp.ability_index = 0
    create_abilitystatus_window
    create_category_windows
    create_adds_windows
    create_command_window
    create_choices_windows
    create_addedstats_window
    create_showskill_window
    create_images
    @abilitymessage_window.visible = false
    @addedstats_window.visible = false
    refresh
  end 
 
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    @crystal_sprites.each(&:dispose)
  end
 
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update    
    super    
    if @command_window.active
      if Input.trigger?(:LEFT)
        Sound.play_cursor
        $game_temp.ability_index = ($game_temp.ability_index-1)%5
        @showskill_asi_window.hide
        @showskill_atk_window.hide
        @showskill_mgc_window.hide
        @showskill_agl_window.hide
        @showskill_ble_window.hide
        @mgc_adds_window.visible = true
        @agl_adds_window.visible = true
        @asi_adds_window.visible = true
        @atk_adds_window.visible = true
        @ble_adds_window.visible = true
      elsif Input.trigger?(:RIGHT)
        Sound.play_cursor
        $game_temp.ability_index = ($game_temp.ability_index+1)%5
        @showskill_asi_window.hide
        @showskill_atk_window.hide
        @showskill_mgc_window.hide
        @showskill_agl_window.hide
        @showskill_ble_window.hide
        @asi_adds_window.visible = true
        @atk_adds_window.visible = true
        @mgc_adds_window.visible = true
        @agl_adds_window.visible = true
        @ble_adds_window.visible = true
      elsif Input.trigger?(:DOWN)
        case $game_temp.ability_index
        when 0
          @showskill_atk_window.refresh
          @showskill_atk_window.show
          @atk_adds_window.visible = false
        when 1
          @showskill_mgc_window.refresh
          @showskill_mgc_window.show
          @mgc_adds_window.visible = false
        when 2
          @showskill_agl_window.refresh
          @showskill_agl_window.show
          @agl_adds_window.visible = false
        when 3
          @showskill_asi_window.refresh
          @showskill_asi_window.show
          @asi_adds_window.visible = false
        when 4
          @showskill_ble_window.refresh
          @showskill_ble_window.show
          @ble_adds_window.visible = false
        end
      elsif Input.trigger?(:UP)
        case $game_temp.ability_index
        when 0
          @showskill_atk_window.hide
          @atk_adds_window.visible = true
        when 1
          @showskill_mgc_window.hide
          @mgc_adds_window.visible = true
        when 2
          @showskill_agl_window.hide
          @agl_adds_window.visible = true
        when 3
          @showskill_asi_window.hide
          @asi_adds_window.visible = true
        when 4
          @showskill_ble_window.hide
          @ble_adds_window.visible = true
        end        
      elsif Input.trigger?(:C)
        if @actor.ability_points != 0 && 
          @actor.ability_level[$game_temp.ability_index] < @actor.ability_max_level
          @abilitymessage_window.visible = true
          @actor.addedstats_calculation
          @addedstats_window.refresh
          @addedstats_window.visible = true
          @command_window.active = false
          @abilitychoices_window.start
        else
          Sound.play_buzzer
        end
      end
    end
    5.times do |i|      
      j = $game_temp.ability_index == i ? 1 : 0      
      bitmap_name = @actor.ability_level[i] == 0 ? @crystal_pictures[j] : @crystal_pictures[i*2+2+j]      
      @crystal_sprites[i].bitmap = Cache.picture(bitmap_name)    
    end    
    pattern = (Graphics.frame_count/5)%6
    sprite = @crystal_sprites[$game_temp.ability_index]    
    w, h = sprite.bitmap.width/6, sprite.bitmap.height    
    sprite.src_rect.set(w*pattern, 0, w, h)  
  end
  
  #--------------------------------------------------------------------------
  # * Ability Status Window creation
  #--------------------------------------------------------------------------
  def create_abilitystatus_window
    @abilitystatus_window = Window_AbilityStatus.new
    @abilitystatus_window.actor = @actor
  end
 
  #--------------------------------------------------------------------------
  # * Ability Category Window creation
  #--------------------------------------------------------------------------
  def create_category_windows
    @atk_category_window = Window_AbilityCategory.new
    @atk_category_window.x = 50
    @atk_category_window.contents.draw_text(4, 0, 60, 20, "ATK")
    @mgc_category_window = Window_AbilityCategory.new
    @mgc_category_window.x = 150
    @mgc_category_window.contents.draw_text(2, 0, 60, 20, "MGC")
    @agl_category_window = Window_AbilityCategory.new
    @agl_category_window.x = 250
    @agl_category_window.contents.draw_text(2, 0, 60, 20, "AGL")
    @asi_category_window = Window_AbilityCategory.new
    @asi_category_window.x = 350
    @asi_category_window.contents.draw_text(2, 0, 60, 20, "ASI")
    @ble_category_window = Window_AbilityCategory.new
    @ble_category_window.x = 450
    @ble_category_window.contents.draw_text(2, 0, 60, 20, "BLE")
  end
 
  #--------------------------------------------------------------------------
  # * Ability Status Window creation
  #--------------------------------------------------------------------------
  def create_adds_windows
    @atk_adds_window = Window_AbilityAdds.new(25, 290)
    @atk_adds_window.actor = @actor
    @atk_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[0].to_s, 1)
    @mgc_adds_window = Window_AbilityAdds.new(125, 290)
    @mgc_adds_window.actor = @actor
    @mgc_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[1].to_s, 1)
    @agl_adds_window = Window_AbilityAdds.new(225, 290)
    @agl_adds_window.actor = @actor
    @agl_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[2].to_s, 1)
    @asi_adds_window = Window_AbilityAdds.new(325, 290)
    @asi_adds_window.actor = @actor
    @asi_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[3].to_s, 1)
    @ble_adds_window = Window_AbilityAdds.new(425, 290)
    @ble_adds_window.actor = @actor
    @ble_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[4].to_s, 1)
  end
 
  #--------------------------------------------------------------------------
  # * Ability Command Window creation
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_Ability_Command.new
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end
 
  #--------------------------------------------------------------------------
  # * Ability Choices Windows creation
  #--------------------------------------------------------------------------  
  def create_choices_windows
    @abilitymessage_window = Window_Ability_Confirmation.new
    @abilitychoices_window = Window_Ability_ChoiceList.new
    @abilitychoices_window.set_handler(:yes,    method(:add_ability_points))
    @abilitychoices_window.set_handler(:no,     method(:return_category))
    @abilitychoices_window.set_handler(:cancel, method(:return_category))    
  end
  
  def create_addedstats_window
    @addedstats_window = Window_Ability_AddedStats.new
    @addedstats_window.actor = @actor
  end
  
  def create_showskill_window
    @showskill_atk_window = Window_AbilitySkillList.new(25, 290, 0)
    @showskill_atk_window.actor = @actor
    @showskill_mgc_window = Window_AbilitySkillList.new(125, 290, 1)
    @showskill_mgc_window.actor = @actor
    @showskill_agl_window = Window_AbilitySkillList.new(225, 290, 2)
    @showskill_agl_window.actor = @actor
    @showskill_asi_window = Window_AbilitySkillList.new(325, 290, 3)
    @showskill_asi_window.actor = @actor
    @showskill_ble_window = Window_AbilitySkillList.new(425, 290, 4)
    @showskill_ble_window.actor = @actor
    @showskill_asi_window.hide
    @showskill_atk_window.hide
    @showskill_mgc_window.hide
    @showskill_agl_window.hide
    @showskill_ble_window.hide
  end
  
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @abilitystatus_window.actor = @actor
    @addedstats_window.actor = @actor
    @atk_adds_window.actor = @actor
    @mgc_adds_window.actor = @actor
    @agl_adds_window.actor = @actor
    @asi_adds_window.actor = @actor
    @ble_adds_window.actor = @actor
    @showskill_atk_window.actor = @actor
    @showskill_mgc_window.actor = @actor
    @showskill_agl_window.actor = @actor
    @showskill_asi_window.actor = @actor
    @showskill_ble_window.actor = @actor
    @command_window.activate
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Add Ability Points
  #--------------------------------------------------------------------------
  def add_ability_points
    if @actor.ability_points == 0
      Sound.play_buzzer
    else
      case $game_temp.ability_index
        when 0
          @actor.ability_level[0] += 1
          @actor.abilitypoints_down
          @actor.stats_augmentation
          @actor.check_ability_skills_learning(0)
          @atk_adds_window.refresh
        when 1
          @actor.ability_level[1] += 1
          @actor.abilitypoints_down
          @actor.stats_augmentation
          @actor.check_ability_skills_learning(1)
          @mgc_adds_window.refresh
        when 2
          @actor.ability_level[2] += 1
          @actor.abilitypoints_down
          @actor.stats_augmentation
          @actor.check_ability_skills_learning(2)
          @agl_adds_window.refresh
        when 3
          @actor.ability_level[3] += 1
          @actor.abilitypoints_down
          @actor.stats_augmentation
          @actor.check_ability_skills_learning(3)
          @asi_adds_window.refresh
        when 4
          @actor.ability_level[4] += 1
          @actor.abilitypoints_down
          @actor.stats_augmentation
          @actor.check_ability_skills_learning(4)
          @ble_adds_window.refresh
        end
      Sound.play_cursor
    end
    refresh
    @abilitystatus_window.refresh
    @abilitymessage_window.visible = false
    @addedstats_window.visible = false
    @addedstats_window.refresh
    @abilitychoices_window.deactivate
    @abilitychoices_window.openness = 0
    @command_window.activate
  end
 
  #--------------------------------------------------------------------------
  # * Return to category choice
  #--------------------------------------------------------------------------  
  def return_category
    Sound.play_cancel
    @abilitymessage_window.visible = false
    @addedstats_window.visible = false
    @addedstats_window.refresh
    @abilitychoices_window.openness = 0
    @abilitychoices_window.deactivate
    @command_window.activate
  end
 
  #--------------------------------------------------------------------------
  # * Images creation
  #--------------------------------------------------------------------------
  def create_images    
    @crystal_sprites = []    
    5.times do |i|      
    @crystal_sprites[i] = Sprite.new      
    @crystal_sprites[i].x = 50+100*i      
    @crystal_sprites[i].y = 130    
  end    
  # crystal order 
  # unskilled -> crystal , glowing crystal
  # Column 0 -> red crystal, glowing red
  # Column 1 -> blue crystal, glowing blue
  # Column 2 -> yellow crystal, glowing yellow
  # Column 3 -> Green crystal, glowing green
  # Column 4 -> Orange crystal, glowing orange
  # The order can be swapped around to your preference
    @crystal_pictures = ["Crystal", "Glowing_Crystal", "Red_Crystal", "Glowing_Red_Crystal", "Blue_Crystal", "Glowing_Blue_Crystal",
    "Yellow_Crystal", "Glowing_Yellow_Crystal", "Green_Crystal", "Glowing_Green_Crystal", "Orange_Crystal", "Glowing_Orange_Crystal"]
    update  
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @command_window.index = 0
    @command_window.refresh
    @atk_adds_window.refresh
    @mgc_adds_window.refresh
    @agl_adds_window.refresh
    @asi_adds_window.refresh
    @ble_adds_window.refresh
    @atk_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[0].to_s, 1)
    @atk_adds_window.contents.draw_text(0, 30, 40, 14, "ATK")
    @atk_adds_window.contents.draw_text(0, 42, 40, 14, "DEF")
    @atk_adds_window.contents.draw_text(0, 54, 40, 14, "HP")
    if @actor.ability_level[0].between?(0, 9) 
      @atk_adds_window.contents.draw_text(2, 30, 60, 14, "+ 2/3", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(2, 42, 60, 14, "+ 2/3", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(16, 54, 60, 14, "+ 20/35", 2) if @actor.ability_level[0] < @actor.ability_max_level
    elsif @actor.ability_level[0].between?(10, 19)
      @atk_adds_window.contents.draw_text(2, 30, 60, 14, "+ 3/4", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(2, 42, 60, 14, "+ 3/4", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(16, 54, 60, 14, "+ 40/50", 2) if @actor.ability_level[0] < @actor.ability_max_level
    elsif @actor.ability_level[0].between?(20, 29)
      @atk_adds_window.contents.draw_text(2, 30, 60, 14, "+ 5/6", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(2, 42, 60, 14, "+ 5/6", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(16, 54, 60, 14, "+ 60/70", 2) if @actor.ability_level[0] < @actor.ability_max_level
    elsif @actor.ability_level[0].between?(30, 39)
      @atk_adds_window.contents.draw_text(2, 30, 60, 14, "+ 7/9", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(2, 42, 60, 14, "+ 7/9", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(13, 54, 70, 14, "+ 80/100 ", 2) if @actor.ability_level[0] < @actor.ability_max_level
    elsif @actor.ability_level[0].between?(40, 49)
      @atk_adds_window.contents.draw_text(15, 30, 60, 14, "+ 10/14", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(15, 42, 60, 14, "+ 10/14", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(10, 54, 70, 14, "+ 100/120", 2) if @actor.ability_level[0] < @actor.ability_max_level
    elsif @actor.ability_level[0].between?(50, 59)
      @atk_adds_window.contents.draw_text(15, 30, 60, 14, "+ 15/20", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(15, 42, 60, 14, "+ 15/20", 2) if @actor.ability_level[0] < @actor.ability_max_level
      @atk_adds_window.contents.draw_text(10, 54, 70, 14, "+ 120/150", 2) if @actor.ability_level[0] < @actor.ability_max_level
    elsif @actor.ability_level[0] == 60
    end
    @mgc_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[1].to_s, 1)
    @mgc_adds_window.contents.draw_text(0, 30, 40, 14, "MAT")
    @mgc_adds_window.contents.draw_text(0, 42, 40, 14, "MDF")
    @mgc_adds_window.contents.draw_text(0, 54, 40, 14, "MP")
    if @actor.ability_level[1].between?(0, 9)
      @mgc_adds_window.contents.draw_text(2, 30, 60, 14, "+ 2/3", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(2, 42, 60, 14, "+ 2/3", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(16, 54, 60, 14, "+ 10/15", 2) if @actor.ability_level[1] < @actor.ability_max_level
    elsif @actor.ability_level[1].between?(10, 19)
      @mgc_adds_window.contents.draw_text(2, 30, 60, 14, "+ 4/5", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(2, 42, 60, 14, "+ 4/5", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(16, 54, 60, 14, "+ 15/20", 2) if @actor.ability_level[1] < @actor.ability_max_level
    elsif @actor.ability_level[1].between?(20, 29)
      @mgc_adds_window.contents.draw_text(2, 30, 60, 14, "+ 6/7", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(2, 42, 60, 14, "+ 6/7", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(16, 54, 60, 14, "+ 20/30", 2) if @actor.ability_level[1] < @actor.ability_max_level
    elsif @actor.ability_level[1].between?(30, 39)
      @mgc_adds_window.contents.draw_text(9, 30, 60, 14, "+ 8/10", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(9, 42, 60, 14, "+ 8/10", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(16, 54, 60, 14, "+ 40/50", 2) if @actor.ability_level[1] < @actor.ability_max_level
    elsif @actor.ability_level[1].between?(40, 49)
      @mgc_adds_window.contents.draw_text(15, 30, 60, 14, "+ 10/15", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(15, 42, 60, 14, "+ 10/15", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(16, 54, 60, 14, "+ 60/70", 2) if @actor.ability_level[1] < @actor.ability_max_level
    elsif @actor.ability_level[1].between?(50, 59)
      @mgc_adds_window.contents.draw_text(15, 30, 60, 14, "+ 16/20", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(15, 42, 60, 14, "+ 16/20", 2) if @actor.ability_level[1] < @actor.ability_max_level
      @mgc_adds_window.contents.draw_text(16, 54, 60, 14, "+ 80/90", 2) if @actor.ability_level[1] < @actor.ability_max_level
    elsif @actor.ability_level[1] == 60
    end    
    @agl_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[2].to_s, 1)
    @agl_adds_window.contents.draw_text(0, 30, 40, 14, "AGI")
    @agl_adds_window.contents.draw_text(0, 42, 40, 14, "LUK")
    @agl_adds_window.contents.draw_text(0, 54, 40, 14, "MAT")    
    @agl_adds_window.contents.draw_text(0, 66, 40, 14, "MDF")    
    if @actor.ability_level[2].between?(0, 9)
      @agl_adds_window.contents.draw_text(2, 30, 60, 14, "+ 2/3", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 42, 60, 14, "+ 2/3", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 54, 60, 14, "+ 1/2", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 66, 60, 14, "+ 1/2", 2) if @actor.ability_level[2] < @actor.ability_max_level
    elsif @actor.ability_level[2].between?(10, 19)
      @agl_adds_window.contents.draw_text(2, 30, 60, 14, "+ 4/6", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 42, 60, 14, "+ 4/6", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 54, 60, 14, "+ 2/3", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 66, 60, 14, "+ 2/3", 2) if @actor.ability_level[2] < @actor.ability_max_level
    elsif @actor.ability_level[2].between?(20, 29)
      @agl_adds_window.contents.draw_text(2, 30, 60, 14, "+ 7/9", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 42, 60, 14, "+ 7/9", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 54, 60, 14, "+ 4/6", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 66, 60, 14, "+ 4/6", 2) if @actor.ability_level[2] < @actor.ability_max_level
    elsif @actor.ability_level[2].between?(30, 39)
      @agl_adds_window.contents.draw_text(15, 30, 60, 14, "+ 10/12", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(15, 42, 60, 14, "+ 10/12", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 54, 60, 14, "+ 7/9", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(2, 66, 60, 14, "+ 7/9", 2) if @actor.ability_level[2] < @actor.ability_max_level
    elsif @actor.ability_level[2].between?(40, 49)
      @agl_adds_window.contents.draw_text(15, 30, 60, 14, "+ 14/16", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(15, 42, 60, 14, "+ 14/16", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(15, 54, 60, 14, "+ 10/12", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(15, 66, 60, 14, "+ 10/12", 2) if @actor.ability_level[2] < @actor.ability_max_level
    elsif @actor.ability_level[2].between?(50, 59)
      @agl_adds_window.contents.draw_text(15, 30, 60, 14, "+ 18/20", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(15, 42, 60, 14, "+ 18/20", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(15, 54, 60, 14, "+ 14/15", 2) if @actor.ability_level[2] < @actor.ability_max_level
      @agl_adds_window.contents.draw_text(15, 66, 60, 14, "+ 14/15", 2) if @actor.ability_level[2] < @actor.ability_max_level
    elsif @actor.ability_level[2] == 60
    end    
    @asi_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[3].to_s, 1)
    @asi_adds_window.contents.draw_text(0, 30, 40, 14, "ATK")
    @asi_adds_window.contents.draw_text(0, 42, 40, 14, "MAT")
    @asi_adds_window.contents.draw_text(0, 54, 40, 14, "HP")
    @asi_adds_window.contents.draw_text(0, 66, 40, 14, "MP")
    if @actor.ability_level[3].between?(0, 9)
      @asi_adds_window.contents.draw_text(2, 30, 60, 14, "+ 2/3", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(2, 42, 60, 14, "+ 2/3", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 54, 60, 14, "+ 15/25", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(10, 66, 60, 14, "+ 5/10", 2) if @actor.ability_level[3] < @actor.ability_max_level
    elsif @actor.ability_level[3].between?(10, 19)
      @asi_adds_window.contents.draw_text(2, 30, 60, 14, "+ 4/6", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(2, 42, 60, 14, "+ 4/6", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 54, 60, 14, "+ 25/35", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 66, 60, 14, "+ 10/15", 2) if @actor.ability_level[3] < @actor.ability_max_level
    elsif @actor.ability_level[3].between?(20, 29)
      @asi_adds_window.contents.draw_text(2, 30, 60, 14, "+ 7/9", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(2, 42, 60, 14, "+ 7/9", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 54, 60, 14, "+ 40/50", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 66, 60, 14, "+ 20/25", 2) if @actor.ability_level[3] < @actor.ability_max_level
    elsif @actor.ability_level[3].between?(30, 39)
      @asi_adds_window.contents.draw_text(15, 30, 60, 14, "+ 10/12", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(15, 42, 60, 14, "+ 10/12", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 54, 60, 14, "+ 50/75", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 66, 60, 14, "+ 30/35", 2) if @actor.ability_level[3] < @actor.ability_max_level
    elsif @actor.ability_level[3].between?(40, 49)
      @asi_adds_window.contents.draw_text(15, 30, 60, 14, "+ 15/17", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(15, 42, 60, 14, "+ 15/17", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 54, 60, 14, "+ 80/85", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 66, 60, 14, "+ 35/40", 2) if @actor.ability_level[3] < @actor.ability_max_level
    elsif @actor.ability_level[3].between?(50, 59)
      @asi_adds_window.contents.draw_text(15, 30, 60, 14, "+ 18/20", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(15, 42, 60, 14, "+ 18/20", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 54, 60, 14, "+ 90/95", 2) if @actor.ability_level[3] < @actor.ability_max_level
      @asi_adds_window.contents.draw_text(16, 66, 60, 14, "+ 40/50", 2) if @actor.ability_level[3] < @actor.ability_max_level
    elsif @actor.ability_level[3] == 60
    end    
    @ble_adds_window.contents.draw_text(30, 0, 40, 20, @actor.ability_level[4].to_s, 1)
    @ble_adds_window.contents.draw_text(0, 30, 40, 14, "DEF")
    @ble_adds_window.contents.draw_text(0, 42, 40, 14, "MDF")
    @ble_adds_window.contents.draw_text(0, 54, 40, 14, "AGI")
    @ble_adds_window.contents.draw_text(0, 66, 40, 14, "LUK")
    if @actor.ability_level[4].between?(0, 9)
      @ble_adds_window.contents.draw_text(2, 30, 60, 14, "+ 2/4", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(2, 42, 60, 14, "+ 2/4", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(2, 54, 60, 14, "+ 2/3", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(2, 66, 60, 14, "+ 2/3", 2) if @actor.ability_level[4] < @actor.ability_max_level
    elsif @actor.ability_level[4].between?(10, 19)
      @ble_adds_window.contents.draw_text(2, 30, 60, 14, "+ 4/6", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(2, 42, 60, 14, "+ 4/6", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(2, 54, 60, 14, "+ 4/5", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(2, 66, 60, 14, "+ 4/5", 2) if @actor.ability_level[4] < @actor.ability_max_level
    elsif @actor.ability_level[4].between?(20, 29)
      @ble_adds_window.contents.draw_text(2, 30, 60, 14, "+ 7/9", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(2, 42, 60, 14, "+ 7/9", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(2, 54, 60, 14, "+ 6/8", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(2, 66, 60, 14, "+ 6/8", 2) if @actor.ability_level[4] < @actor.ability_max_level
    elsif @actor.ability_level[4].between?(30, 39)
      @ble_adds_window.contents.draw_text(15, 30, 60, 14, "+ 10/12", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(15, 42, 60, 14, "+ 10/12", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(7, 54, 60, 14, "+ 8/10", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(7, 66, 60, 14, "+ 8/10", 2) if @actor.ability_level[4] < @actor.ability_max_level
    elsif @actor.ability_level[4].between?(40, 49)
      @ble_adds_window.contents.draw_text(15, 30, 60, 14, "+ 12/14", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(15, 42, 60, 14, "+ 12/14", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(15, 54, 60, 14, "+ 10/12", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(15, 66, 60, 14, "+ 10/12", 2) if @actor.ability_level[4] < @actor.ability_max_level
    elsif @actor.ability_level[4].between?(50, 59)
      @ble_adds_window.contents.draw_text(15, 30, 60, 14, "+ 15/18", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(15, 42, 60, 14, "+ 15/18", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(15, 54, 60, 14, "+ 12/14", 2) if @actor.ability_level[4] < @actor.ability_max_level
      @ble_adds_window.contents.draw_text(15, 66, 60, 14, "+ 12/14", 2) if @actor.ability_level[4] < @actor.ability_max_level
    elsif @actor.ability_level[4] == 60
    end    
  end
end
 
#===============================================================================
#   ** Window_AbilityStatus
#-------------------------------------------------------------------------------
#   This class perform the status window for the Ability system
#===============================================================================
 
class Window_AbilityStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------  
  def initialize
    super(22, 6, 500, 120)
    self.contents.font.size = 16
    @actor = nil
    @temp_actor = nil
    refresh
  end
    
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    return 4
  end
  
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_actor_face(@actor, 0, 0) if @actor
    draw_actor_name(@actor, 104, 0) if @actor
    draw_actor_hp(@actor, 104, 20, width = 60) if @actor
    draw_actor_mp(@actor, 212, 20, width = 60) if @actor
    draw_item(100, 38, 0)
    draw_ability_points(@actor, 0, 0) if @actor
    draw_actor_accessory(@actor, 0, 0) if @actor
  end
 
  #--------------------------------------------------------------------------
  # * Set Temporary Actor After Equipment Change
  #--------------------------------------------------------------------------
  def set_temp_actor(temp_actor)
    return if @temp_actor == temp_actor
    @temp_actor = temp_actor
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Draw Max Value in Fractional Format
  #     max     : Maximum value
  #     color1  : Color of maximum value
  #--------------------------------------------------------------------------
  def draw_max_values(x, y, width, max, color1)
    xr = x + width
    if width < 96
      draw_text(xr - 40, y, 42, line_height, max, 2)
    else
      draw_text(xr - 42, y, 42, line_height, max, 2)
    end
  end
 
  #--------------------------------------------------------------------------
  # * Draw HP
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 124)
    contents.font.size = 17
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_max_values(x + 12, y, width, actor.mhp, normal_color)
  end
  #--------------------------------------------------------------------------
  # * Draw MP
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 124)
    contents.font.size = 17
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_max_values(x + 22, y, width, actor.mmp, normal_color)
  end
 
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(x, y, param_id)
    draw_param_name(x + 4, y, 2)
    draw_current_param(x + 46, y, 2) if @actor
    draw_param_name(x + 4, y + 18, 3)
    draw_current_param(x + 46, y + 18, 3) if @actor
    draw_param_name(x + 4, y + 36, 6)
    draw_current_param(x + 46, y + 36, 6) if @actor
    draw_param_name(x + 112, y, 4)
    draw_current_param(x + 164, y, 4) if @actor
    draw_param_name(x + 112, y + 18, 5)
    draw_current_param(x + 164, y + 18, 5) if @actor
    draw_param_name(x + 112, y + 36, 7)
    draw_current_param(x + 164, y + 36, 7) if @actor
  end
  
  #--------------------------------------------------------------------------
  # * Draw Parameter Name
  #--------------------------------------------------------------------------
  def draw_param_name(x, y, param_id)
    contents.font.size = 17
    change_color(normal_color)
    draw_text(x, y, 80, line_height, Vocab::param(param_id))
  end
  #--------------------------------------------------------------------------
  # * Draw Current Parameter
  #--------------------------------------------------------------------------
  def draw_current_param(x, y, param_id)
    contents.font.size = 17
    change_color(normal_color)
    draw_text(x, y, 32, line_height, @actor.param(param_id), 2)
  end
   
  #--------------------------------------------------------------------------
  # * Draw actor ability points
  #--------------------------------------------------------------------------
  def draw_ability_points(actor, x, y)
    contents.font.size = 20
    draw_text(330, 4, 160, 20, "Ability Points:")
    draw_text(360, 24, 40, 20, actor.ability_points.to_s, 1)
  end
  
  #--------------------------------------------------------------------------
  # * Draw actor accessory
  #--------------------------------------------------------------------------
  def draw_actor_accessory(actor, x, y)
    contents.font.size = 20
    if R2_Ability_Options::Show_All_Equip == true
      draw_text(330, 50, 160, line_height, "Equipment:")
      draw_icon(actor.equips[0].icon_index, 320, 72) if !actor.equips[0].nil?
      draw_icon(actor.equips[1].icon_index, 350, 72) if !actor.equips[1].nil?
      draw_icon(actor.equips[2].icon_index, 380, 72) if !actor.equips[2].nil?
      draw_icon(actor.equips[3].icon_index, 410, 72) if !actor.equips[3].nil?
      draw_icon(actor.equips[4].icon_index, 440, 72) if !actor.equips[4].nil?
    else
      draw_text(320, 50, 160, line_height, "Equipped Accessory:")
      draw_item_name(actor.equips[4], 340, 72)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Draw Item Name
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    contents.font.size = 17
    change_color(normal_color, enabled)
    draw_text(x, y, width, line_height, item.name)
  end
end
 
#===============================================================================
#   ** Window_AbilityCategory
#-------------------------------------------------------------------------------
#   This class handle the category_name for the Ability system
#===============================================================================
 
class Window_AbilityCategory < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 240, 60, 40)
    self.contents.font.size = 19
  end
end
 
#===============================================================================
#   ** Window_AbilityAdds
#-------------------------------------------------------------------------------
#   This class handle the lvl, stats & skill added by the Ability system
#===============================================================================
 
class Window_AbilityAdds < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, 102, 125)
    self.contents.font.size = 17
    @actor = nil
    @temp_actor = nil
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_text(5, 0, 100, 20, "Level")
    self.contents.draw_text(4, 14, 100, 20, "Next Level:")
    self.contents.draw_text(60, 85, 100, 20, "↓")
  end 
  
  #--------------------------------------------------------------------------
  # * Set Temporary Actor After Equipment Change
  #--------------------------------------------------------------------------
  def set_temp_actor(temp_actor)
    return if @temp_actor == temp_actor
    @temp_actor = temp_actor
    refresh
  end
end
 
#==============================================================================
# ** Window_Ability_Command
#------------------------------------------------------------------------------
#  This class perform the Command Window for the Ability System
#==============================================================================
 
class Window_Ability_Command < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(115, 295)
    self.contents.font.size = 20
    self.opacity = 0
    self.back_opacity = 0
    cursor_rect.empty
    refresh
  end
    
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 150
  end
 
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
  end
 
  #--------------------------------------------------------------------------
  # * Processing When Cancel Button Is Pressed
  #--------------------------------------------------------------------------
  def process_cancel
    Sound.play_cancel
    Input.update
    deactivate
    call_cancel_handler
    cursor_rect.empty
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    clear_command_list
    make_command_list
    cursor_rect.empty
    self.arrows_visible = false
    super
  end
end
 
#==============================================================================
# ** Window_Ability_Confirmation
#------------------------------------------------------------------------------
#  This class perform the Confirmation Window for the Ability System
#==============================================================================
 
class Window_Ability_Confirmation < Window_Base
 
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(118,126,300,120)
    self.contents.font.size = 23
    self.z = 500
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    draw_text(28, 28, 230, 24, R2_Ability_Options::Confirm_Text)
  end
end
 
#==============================================================================
# ** Window_Ability_ChoiceList
#------------------------------------------------------------------------------
#  This window is used for showing choices on Ability Confirmation Window
#==============================================================================
 
class Window_Ability_ChoiceList < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(196, 190)
    self.opacity = 0
    self.back_opacity = 0
    self.z = 501
    self.openness = 0
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Start Input Processing
  #--------------------------------------------------------------------------
  def start
    update_placement
    refresh
    select(0)
    open
    activate
  end
 
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  #--------------------------------------------------------------------------
  # * Update Window Position
  #--------------------------------------------------------------------------
  def update_placement
    self.width = 160
    self.height = 80
  end
 
  #--------------------------------------------------------------------------
  # * Get Maximum Width of Choices
  #--------------------------------------------------------------------------
  def max_choice_width
    $game_message.choices.collect {|s| text_size(s).width }.max
  end
 
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command("Yes", :yes)
    add_command("No",  :no)
  end
 
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    if current_item_enabled?
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
end
 
#===============================================================================
#   ** Window_AbilityAddedStats
#-------------------------------------------------------------------------------
#   This class perform the window for the Added Stats of the Ability system
#===============================================================================
 
class Window_Ability_AddedStats < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------  
  def initialize
    super(22, 6, 500, 120)
    self.contents.font.size = 17
    self.opacity = 0
    self.back_opacity = 0
    @actor = nil
    @temp_actor = nil
    refresh
  end
    
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    return 5
  end
  
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_added_stats(@actor, 180, 20) if @actor
  end
 
  #--------------------------------------------------------------------------
  # * Set Temporary Actor After Equipment Change
  #--------------------------------------------------------------------------
  def set_temp_actor(temp_actor)
    return if @temp_actor == temp_actor
    @temp_actor = temp_actor
    refresh
  end
  
  #--------------------------------------------------------------------------
  # * Draw Plus
  #--------------------------------------------------------------------------
  def draw_plus(x, y)
    draw_text(x, y, 22, line_height, "↑", 1)
  end
 
  #--------------------------------------------------------------------------
  # * Draw Added Stats
  #--------------------------------------------------------------------------
  def draw_added_stats(actor, x, y)
    # 172 -> left column
    # 290 -> right column
    case $game_temp.ability_index
    when 0
      change_color(hp_gauge_color1)
      3.times do |i|
        draw_plus(172, 20 + 18 * i)
      end
    when 1
      change_color(system_color)
      3.times do |i|
        draw_plus(290, 20 + 18 * i)
      end
    when 2
      change_color(tp_cost_color)
      3.times do |i|
        draw_plus(290, 38 + 18 * i)
      end
      draw_plus(172, 74)
    when 3
      change_color(power_up_color)
      2.times do |i|
        draw_plus(290, 20 + 18 * i)
      end
      2.times do |i|
        draw_plus(172, 20 + 18 * i)
      end
    when 4
      change_color(crisis_color)
      2.times do |i|
        draw_plus(290, 54 + 18 * i)
      end
      2.times do |i|
        draw_plus(172, 54 + 18 * i)
      end
    end
    if R2_Ability_Options::Show_Numbers == true
      case $game_temp.ability_index
      when 0
        change_color(hp_gauge_color1)
        draw_text(x, y, 30, line_height, actor.augmentation[0].to_s, 1)
        draw_text(x, y + 18, 30, line_height, actor.augmentation[2].to_s, 1)
        draw_text(x, y + 36, 30, line_height, actor.augmentation[3].to_s, 1)
      when 1
        change_color(system_color)
        draw_text(x + 118, y + 18, 30, line_height, actor.augmentation[4].to_s, 1)
        draw_text(x + 118, y + 36, 30, line_height, actor.augmentation[5].to_s, 1)
        draw_text(x + 118, y, 30, line_height, actor.augmentation[1].to_s, 1)
      when 2
        change_color(tp_cost_color)
        draw_text(x, y + 54, 30, line_height, actor.augmentation[6].to_s, 1)
        draw_text(x + 118, y + 54, 30, line_height, actor.augmentation[7].to_s, 1)
        draw_text(x + 118, y + 18, 30, line_height, actor.augmentation[4].to_s, 1)
        draw_text(x + 118, y + 36, 30, line_height, actor.augmentation[5].to_s, 1)
      when 3
        change_color(power_up_color)
        draw_text(x, y + 18, 30, line_height, actor.augmentation[2].to_s, 1)
        draw_text(x + 118, y + 18, 30, line_height, actor.augmentation[4].to_s, 1)
        draw_text(x, y, 30, line_height, actor.augmentation[0].to_s, 1)
        draw_text(x + 118, y, 30, line_height, actor.augmentation[1].to_s, 1)
      when 4
        change_color(crisis_color)
        draw_text(x, y + 36, 30, line_height, actor.augmentation[3].to_s, 1)
        draw_text(x + 118, y + 36, 30, line_height, actor.augmentation[5].to_s, 1)
        draw_text(x, y + 54, 30, line_height, actor.augmentation[6].to_s, 1)
        draw_text(x + 118, y + 54, 30, line_height, actor.augmentation[7].to_s, 1)
      end
    end
  end
end
 
#==============================================================================
# ** Window_AbilitySkillList
#------------------------------------------------------------------------------
#  This window is for displaying a list of available skills on the skill window.
#==============================================================================
 
class Window_AbilitySkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, index)
    super(x, y, 100, 125)
    self.contents.font.size = 12
    @actor = nil
    @temp_actor = nil
    @index = index
    refresh
  end
  
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    return 5
  end
  
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    return unless @actor
    for i in 0...@actor.ability_new_skills_id[@index].size
      if @actor.ability_level[@index] >= @actor.ability_new_skills_level[@index][i]
        text = $data_skills[@actor.ability_new_skills_id[@index][i]].name
        self.contents.draw_text(2, 20 + i * 18, 92, 20, text)
      end
    end
    self.contents.font.size = 18
    self.contents.draw_text(4, 4, 100, 20, "Skills:")
    self.contents.draw_text(60, 0, 100, 20, "↑")
    self.contents.font.size = 12
  end
  #--------------------------------------------------------------------------
  # * Set Temporary Actor After Equipment Change
  #--------------------------------------------------------------------------
  def set_temp_actor(temp_actor)
    return if @temp_actor == temp_actor
    @temp_actor = temp_actor
    refresh
  end
end
