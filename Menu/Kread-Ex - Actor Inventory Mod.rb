#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#  ▼ Actor Inventory Mod
#  Author: Roninator2
#  Version 1.1
#  Release date: 11/20/2020
#  Last Updated: 11/21/2020
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#------------------------------------------------------------------------------
#  ▼ UPDATES
#------------------------------------------------------------------------------
# # 11/20/2020. Patch allows multiple equipment slots for items.
# # 11/21/2020. added support to have accessories in extra slots
# # 11/21/2020. fixed bug with all armour allowed to be added in extra slots
# # 11/21/2020. Added option to have equipment act as items or skills
#------------------------------------------------------------------------------
#  ▼ TERMS OF USAGE
#------------------------------------------------------------------------------
# #  Follow original authors terms of use
#------------------------------------------------------------------------------
#  ▼ INSTRUCTIONS
#------------------------------------------------------------------------------
# # Put the following notetag on your equipment that will act as if it
# # is an item
# # <equip_uses: 1>
# # Then the equipment will do what a potion does
# # <equip_skill: 26>
# # Then the equipment will do what the skill does
# # If both tags are used, the item will be used not the skill.
# # If two of the same tag are used the last one will be used.
#------------------------------------------------------------------------------

module KRX
  ITEMS_ETYPE_ID2 = 5
  ITEMS_ETYPE_ID3 = 6
  module REGEXP
    ITEM_EQUIP_USE = /<equip_uses:[ ](\d+)>/i
    ITEM_EQUIP_SKILL = /<equip_skill:[ ](\d+)>/i
  end
end

module DataManager  
	#--------------------------------------------------------------------------
	# ● Loads the database
	#--------------------------------------------------------------------------
	class << self
		alias_method(:r2_actuse_dm_load_database, :load_database)
	end
	def self.load_database
		r2_actuse_dm_load_database
		load_actusearm_notetags
    load_actusewep_notetags
	end  
	def self.load_actusearm_notetags
		groups = [$data_armors]
		for group in groups
			for obj in group
				next if obj.nil?
				obj.load_actusearm_notetags
			end
		end
	end
	def self.load_actusewep_notetags
		groups = [$data_weapons]
		for group in groups
			for obj in group
				next if obj.nil?
				obj.load_actusewep_notetags
			end
		end
	end
end
class RPG::Item < RPG::UsableItem
  def etype_id2
    KRX::ITEMS_ETYPE_ID2
  end
  def etype_id3
    KRX::ITEMS_ETYPE_ID3
  end
end

class RPG::Weapon < RPG::EquipItem
  def etype_id2
    KRX::ITEMS_ETYPE_ID2
  end
  def etype_id3
    KRX::ITEMS_ETYPE_ID3
  end
  attr_accessor   :equip_use
  attr_accessor   :equip_skill
	def load_actusewep_notetags
		@note.split(/[\r\n]+/).each do |line|
			case line
			when KRX::REGEXP::ITEM_EQUIP_USE
        @equip_use = $1.to_i
			when KRX::REGEXP::ITEM_EQUIP_SKILL
        @equip_skill = $1.to_i
			end
		end
	end
end

class RPG::Armor < RPG::EquipItem
  def etype_id2
    KRX::ITEMS_ETYPE_ID2
  end
  def etype_id3
    KRX::ITEMS_ETYPE_ID3
  end
  attr_accessor   :equip_use
  attr_accessor   :equip_skill
	def load_actusearm_notetags
		@note.split(/[\r\n]+/).each do |line|
			case line
			when KRX::REGEXP::ITEM_EQUIP_USE
        @equip_use = $1.to_i
			when KRX::REGEXP::ITEM_EQUIP_SKILL
        @equip_skill = $1.to_i
			end
		end
	end
end

class Window_EquipItem < Window_ItemList
  #--------------------------------------------------------------------------
  # ● Determine if an item goes into the list
  #--------------------------------------------------------------------------
  def include?(item)
    if item.nil? && !@actor.nil?
      etype_id = @actor.equip_slots[@slot_id]
      return YEA::EQUIP::TYPES[etype_id][1]
    end
    return true if item.nil?
    return false if @slot_id < 0
    return false if (item.etype_id != @actor.equip_slots[@slot_id] &&
    item.etype_id2 != @actor.equip_slots[@slot_id] &&
    item.etype_id3 != @actor.equip_slots[@slot_id])
    return false if item.etype_id != @actor.equip_slots[@slot_id] && (item.is_a?(RPG::Armor) ||
    item.is_a?(RPG::Weapon)) && item.etype_id < (item.etype_id2 - 1)
    return @actor.equippable?(item)
  end
end

class Game_Actor < Game_Battler
  def change_equip(slot_id, item)
    return unless trade_item_with_party(item, equips[slot_id])
    if item.nil? && !@optimize_clear
      etype_id = equip_slots[slot_id]
      return unless YEA::EQUIP::TYPES[etype_id][1]
    elsif item.nil? && @optimize_clear
      etype_id = equip_slots[slot_id]
      return unless YEA::EQUIP::TYPES[etype_id][2]
    end
    if item.is_a?(RPG::Item) && !item.nil?
      @equips[slot_id].object = item
      @equips[slot_id] = Game_BaseItem.new if @equips[slot_id].nil?
    end
    if item.is_a?(RPG::Armor) && !item.nil?
      @equips[slot_id].object = item
      @equips[slot_id] = Game_BaseItem.new if @equips[slot_id].nil?
    end
    return if item && (equip_slots[slot_id] != item.etype_id)
    @equips[slot_id].object = item
    refresh
  end
  def release_unequippable_items(item_gain = true)
    loop do
      last_equips = equips.dup
      @equips.each_with_index do |item, i|
        next if item && item.object.is_a?(RPG::Item) || item.object.is_a?(RPG::Armor)
        if !equippable?(item.object) || item.object.etype_id != equip_slots[i]
          trade_item_with_party(nil, item.object) if item_gain
          item.object = nil
        end
      end
      return if equips == last_equips
    end
  end
end

class Window_ActorItem < Window_EquipSlot
  #--------------------------------------------------------------------------
  # ● Determine if a slot can be selected
  #--------------------------------------------------------------------------
  def enable?(index)
    item = @actor.equips[index]
    return true if item.is_a?(RPG::Item) && item.battle_ok?
    return true if !item.nil? && !item.equip_use.nil?
    return true if !item.nil? && !item.equip_skill.nil?
    return false
  end
  #--------------------------------------------------------------------------
  # ● Makes the window appear
  #--------------------------------------------------------------------------
  def show
    @help_window.show
    super
  end
  #--------------------------------------------------------------------------
  # ● Makes the window disappear
  #--------------------------------------------------------------------------
  def hide
    @help_window.hide unless @help_window.nil?
    super
  end
end

class Scene_Battle < Scene_Base
  def on_item_ok
    @item = @item_window.item
    $game_temp.item_equip_index = @item_window.index
    if $game_temp.item_equip_index < KRX::ITEMS_ETYPE_ID && !@item.nil?
      if !@item.equip_use.nil?
        @item = $data_items[@item.equip_use]
        $game_temp.item_equip_index = -1
      elsif !@item.equip_skill.nil?
        @skill = $data_skills[@item.equip_skill]
        $game_temp.item_equip_index = -1
        BattleManager.actor.input.set_skill(@skill.id)
        BattleManager.actor.last_skill.object = @skill
        if !@skill.need_selection?
          next_command
        elsif @skill.for_opponent?
          @item_window.hide
          select_enemy_selection
        else
          select_actor_selection
        end
        return
      end
    end
    if !@item.battle_ok?
      Sound.play_buzzer
      @item_window.activate
      $game_temp.battle_aid = nil
      return
    end
    $game_temp.battle_aid = @item
    BattleManager.actor.input.set_item(@item.id)
    if @item.for_opponent?
      select_enemy_selection
    elsif @item.for_friend?
      select_actor_selection
    else
      @item_window.hide
      next_command
      $game_temp.battle_aid = nil
    end
    $game_party.last_item.object = @item
  end
  def on_enemy_cancel
    if $imported["YEA-BattleEngine"]
      BattleManager.actor.input.clear
      @status_aid_window.refresh
      $game_temp.battle_aid = nil
    end
    if @skill_window.visible || @item_window.visible
      @help_window.show
    else
      @help_window.hide
      if $game_temp.item_equip_index == -1
        @item_window.show
        @item_window.activate
        @help_window.show
      end
    end
    @enemy_window.hide
    case @actor_command_window.current_symbol
    when :attack
      @actor_command_window.activate
    when :skill
      if $game_temp.item_equip_index == -1
        @item_window.show
        @item_window.activate
        @help_window.show
      else
        @skill_window.activate
      end
    when :item
      @item_window.activate
    end
  end
end
