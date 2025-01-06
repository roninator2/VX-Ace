#==============================================================================
# Szyu's Item's Class Restriction
# Version 1.3		# Mod by Roninator2
# By Szyu
#
# About:
# Easily specify items, weapons and armors, which can only be used/equipped
# by certain classes
#
# Instructions:
# - Place below "▼ Materials" but above "▼ Main Process".
#
# How to Use:
# - An item's note have to contain one of these:
# <classes: x> # This will allow specified classes to use this item
# <!classes: x> # This will forbit specified classes to use this item
#
# Seperate multiple classes with ','!
# Allowed Database Items, which can be restricted by this script:
# - Items
# - Weapons
# - Armors
#
# If There is none of those tags in the items note, every class is permitted to
# use or equip this item
#
#
# Requires:
# - RPG Maker VX Ace
#
# Terms of Use:
# - Free for commercal and non-commercial use. Please list me
#   in the credits to support my work.
#
#
# Changelog:
# - Same syntax can now be used to restrict for actors:
#   <actors: x>
#   <!actors: x>
# - Added Use Restriction for battles too. Restricted classes and actors can no
#   longer use restricted items in battle
#
#==============================================================
#   * Game_BattlerBase
#==============================================================
class Game_BattlerBase
  alias sz_iucr_equippable? equippable?
 
  def equippable?(item)
    return false unless item.is_a?(RPG::EquipItem)
    return false if self.is_a?(Game_Actor) &&
      (item.forbid_classes.include?(self.class_id) || item.forbid_actors.include?(self.id))
    return sz_iucr_equippable?(item)
  end
end
#==============================================================
#   * Game_Battler
#==============================================================
class Game_Battler < Game_BattlerBase
  alias sz_iucr_item_test item_test
 
  def item_test(user, item)
  return sz_iucr_item_test(user, item) if self.is_a?(Game_Enemy)
  if SceneManager.scene_is?(Scene_Battle)
    return false if item.is_a?(RPG::Item) &&
     (item.forbid_classes.include?(user.class_id) || item.forbid_actors.include?(user.id))
   else
     return false if item.is_a?(RPG::Item) &&
     (item.forbid_classes.include?(self.class_id) || item.forbid_actors.include?(self.id))
   end
   return sz_iucr_item_test(user, item)
    end
end
 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
#==============================================================
#   * Initialize BaseItems
#==============================================================
module DataManager
  class << self
    alias load_db_iucr_sz load_database
  end
 
  def self.load_database
    load_db_iucr_sz
    load_iucr_items
  end
 
  def self.load_iucr_items
    groups = [$data_items, $data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_iucr_notetags_sz
      end
    end
  end
end

#==============================================================================
# ** Window_BattleActor
#------------------------------------------------------------------------------
#  This window is for selecting an actor's action target on the battle screen.
#==============================================================================
class Window_BattleActor < Window_BattleStatus
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return false if !BattleManager.actor.input.item.is_a?(RPG::UsableItem) ||
      BattleManager.actor.input.item.forbid_classes.include?(BattleManager.actor.input.subject.class_id) ||
      BattleManager.actor.input.item.forbid_actors.include?(BattleManager.actor.input.subject.id)
    return true
  end
end
 
#==============================================================================
# ** Window_BattleActor
#------------------------------------------------------------------------------
#  This window is for selecting an actor's action target on the battle screen.
#==============================================================================
class Window_BattleEnemy < Window_Selectable
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return false if !BattleManager.actor.input.item.is_a?(RPG::UsableItem) ||
      BattleManager.actor.input.item.forbid_classes.include?(BattleManager.actor.input.subject.class_id) ||
      BattleManager.actor.input.item.forbid_actors.include?(BattleManager.actor.input.subject.id)
    return true
  end
end

#==============================================================
#   * Content of Recycling Items
#==============================================================
class RPG::BaseItem
  attr_accessor :forbid_classes
  attr_accessor :forbid_actors
 
  def load_iucr_notetags_sz
    @forbid_classes = []
    @forbid_actors = []
    self.note.split(/[\r\n]+/).each do |line|
      # Forbid Classes
      if line =~ /<classes:([\d+,?\s*]+)>/i
        $data_classes.each do |cl|
          @forbid_classes.push(cl.id) if cl
        end
        $1.scan(/\s*,?\d+,?\s*/i).each do |cl|
          @forbid_classes.delete(cl.to_i)
        end
      elsif line =~ /<!classes:([\d+,?\s*]+)>/i
        $1.scan(/\s*,?\d+,?\s*/i).each do |cl|
          @forbid_classes.push(cl.to_i)
        end
        # Forbid Actors
      elsif line =~ /<actors:([\d+,?\s*]+)>/i
        $data_actors.each do |ac|
          @forbid_actors.push(ac.id) if ac
        end
        $1.scan(/\s*,?\d+,?\s*/i).each do |ac|
          @forbid_actors.delete(ac.to_i)
        end
      elsif line =~ /<!actors:([\d+,?\s*]+)>/i
        $1.scan(/\s*,?\d+,?\s*/i).each do |ac|
          @forbid_actors.push(ac.to_i)
        end
      end
    end
  end  
  def forbid_classes
    load_iucr_notetags_sz unless @forbid_classes
    return @forbid_classes
  end
  def forbid_actors
    load_iucr_notetags_sz unless @forbid_actors
    return @forbid_actors
  end
end

# you can not select a restricted actor to use the item on,
class Scene_Battle < Scene_Base
  def on_actor_ok
    user = $game_party.members[@actor_window.index]
    if @item.is_a?(RPG::Item) && (@item.forbid_classes.include?(user.class_id) || @item.forbid_actors.include?(user.id))
      Sound.play_buzzer
      @actor_window.activate
      return
    end
    BattleManager.actor.input.target_index = @actor_window.index
    @actor_window.hide
    @skill_window.hide
    @item_window.hide
    next_command
  end
end

# actor's name be greyed out when using an item on them is forbidden
module BattleManager
  def self.item_disabled(item)
    @actor_item = item
  end
  def self.actor_item_restrict
    return @actor_item
  end
end
class Window_BattleStatus < Window_Selectable
  def draw_actor_name(actor, x, y, width = 112)
    change_color(hp_color(actor))
    if @greyed == true
      change_color(Color.new(128, 128, 128, 255))
    end
    draw_text(x, y, width, line_height, actor.name)
  end
  def draw_basic_area(rect, actor)
    @item = BattleManager.actor_item_restrict
    if @item.is_a?(RPG::Item) && 
      (@item.forbid_classes.include?(actor.class_id) || @item.forbid_actors.include?(actor.id))
      @greyed = true
    end
    draw_actor_name(actor, rect.x + 0, rect.y, 100)
    draw_actor_icons(actor, rect.x + 104, rect.y, rect.width - 104)
    @greyed = false
  end
end
class Scene_Battle < Scene_Base
  def select_actor_selection
    BattleManager.item_disabled(@item)
    @actor_window.refresh
    @actor_window.show.activate
  end
end
