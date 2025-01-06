# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Equip From Menu - Falco ABS  ║  Version: 1.06     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║    For Falco ABS Game               ╠════════════════════╣
# ║ Equip items from Item menu          ║    04 Mar 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Requires:                                                ║
# ║   Theoallen Limited Inventory                            ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║   Fixed system equipping weapons before selecting actor  ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Free for all uses in RPG Maker      ║
# ╚═════════════════════════════════════╝

module Theo
  module LimInv
    EquipVocab      = "Equip item"    # Use item
    SkillVocab      = "Equip Skill"
    UseSKVocab      = "Use Skill"
  end
end

class Window_ItemUseCommand < Window_Command
  def make_command_list
    add_command(EquipVocab, :equip)
    add_command(UseVocab, :use) if $game_party.usable?(@item)
    add_command(DiscardVocab, :discard, discardable?(@item))
    add_command(CancelVocab, :cancel)
  end
end

class Scene_Item < Scene_ItemBase
  attr_reader :actor
  def create_usecommand_window
    @use_command = Window_ItemUseCommand.new
    @use_command.to_center
    @use_command.set_handler(:equip, method(:equip_command_ok))
    @use_command.set_handler(:use, method(:use_command_ok))
    @use_command.set_handler(:discard, method(:on_discard_ok))
    @use_command.set_handler(:cancel, method(:on_usecmd_cancel))
    @use_command.viewport = @viewport
  end
 
  def create_slot_confirm
    return if @slot_confirm
    @slot_confirm = Window_SlotConfirm.new(Graphics.width / 2 - 60 / 2,
     Graphics.height / 2 - 85 / 2, :item)
    if @sel_item.class == RPG::Item
      @slot_confirm.set_handler(:slot1,     method(:open_slots))
      @slot_confirm.set_handler(:slot2,     method(:open_slots))
      @slot_confirm.set_handler(:cancel,    method(:equip_cancel))
    else
      @slot_confirm.set_handler(:slot1,     method(:open_slots))
      @slot_confirm.set_handler(:slot2,     method(:open_slots))
      @slot_confirm.set_handler(:slot3,     method(:open_slots))
      @slot_confirm.set_handler(:slot4,     method(:open_slots))
      @slot_confirm.set_handler(:cancel,    method(:equip_cancel))
    end
  end

  def open_slots
    if @sel_item.class == RPG::Item
      case @slot_confirm.current_symbol
      when :slot1 then @actor.assigned_item  = @sel_item
      when :slot2 then @actor.assigned_item2 = @sel_item
      when :cancel then @sel_item = nil
      end
    else
      case @slot_confirm.current_symbol
      when :slot1 then @actor.assigned_skill  = @sel_item
      when :slot2 then @actor.assigned_skill2 = @sel_item
      when :slot3 then @actor.assigned_skill3 = @sel_item
      when :slot4 then @actor.assigned_skill4 = @sel_item
      when :cancel then @sel_item = nil
      end
    end
    Sound.play_equip
    @item_window.activate
    @slot_confirm.deactivate
    @slot_confirm.close
  end

  def equip_command_ok
    @use_command.close
    @actor_window.select_equip_item(item)
    show_sub_window(@actor_window)
    @actor_window.select(0)
  end
 
  def sub_select_ok
    id = @actor_window.index
    @actor = $game_party.members[id]
    if @sel_item.etype_id < 2
      perform_item_ok(@sel_item, @actor)
    else
      hide_sub_window(@actor_window)
      Sound.play_buzzer
      @use_command.activate
    end
  end

  def equip_item
    id = @actor_window.index
    @actor = $game_party.members[id]
    hide_sub_window(@actor_window)
    create_slot_confirm
    @slot_confirm.open
    @slot_confirm.z = 1000
    @item_window.deactivate
    @slot_confirm.activate
  end
 
  def sel_itm
    return @sel_item
  end
 
  alias r2_liminv_item_ok on_item_ok
  def on_item_ok
    @sel_item = @item_window.item
    r2_liminv_item_ok
  end

  def perform_item_ok(item, actor)
    return if item.nil?
    case item
    when RPG::Weapon
      actor.change_equip_by_id(0, item.id)
    when RPG::Armor
      actor.change_equip_by_id(1, item.id)
    end
  end
 
  def on_actor_ok
    if @actor.equippable?(item)
      sub_select_ok
      equip_tool
    elsif item.is_a?(RPG::Item) && !item.key_item? && @use_command.index == 1
      use_item
    elsif item.is_a?(RPG::Item)
      equip_item
    else
      Sound.play_buzzer
    end
  end
 
  def equip_tool
    user.equippable?(item)
    Sound.play_equip
    check_common_event
    check_gameover
    hide_sub_window(@actor_window)
  end
 
  def equip_cancel
    @item_window.activate
    @slot_confirm.deactivate
    @slot_confirm.dispose
    @slot_confirm = nil
  end
end

class Window_MenuActor < Window_MenuStatus
  def select_equip_item(item)
    select($game_party.menu_actor.index)
  end
end

class Window_Selectable < Window_Base
  def process_ok
    if current_item_enabled?
      Sound.play_ok
      Input.update
      deactivate
      call_ok_handler
    else
      if SceneManager.scene_is?(Scene_Item)
        if SceneManager.scene.actor.equippable?(SceneManager.scene.sel_itm)
          return
        else
          Sound.play_buzzer
        end
      else
        Sound.play_buzzer
      end
    end
  end
end

class Window_SlotConfirm < Window_Command
  def window_height() return @kind == :item ? 100 : 140   end
  def make_command_list
    case @kind
    when :item
      add_command('Slot ' + Key::Item[1],    :slot1)
      add_command('Slot ' + Key::Item2[1],   :slot2)
      add_command('Cancel',   :cancel)
    when :skill
      add_command('Slot ' + Key::Skill[1],   :slot1)
      add_command('Slot ' + Key::Skill2[1],  :slot2)
      add_command('Slot ' + Key::Skill3[1],  :slot3)
      add_command('Slot ' + Key::Skill4[1],  :slot4)
      add_command('Cancel',   :cancel)
    end
  end
end

class Window_SkillList < Window_Selectable
  def enable?(item)
    @actor
  end
end

class Window_EquipUseCommand < Window_Command
  include Theo::LimInv

  def initialize
    super(Graphics.width / 2 - window_width / 2, Graphics.height / 2 - 48)
    self.openness = 0
  end
 
  def window_width
    160
  end
 
  def set_skill(skill)
    @skill = skill
  end
 
  def make_command_list
    add_command(SkillVocab, :equip)
    add_command(UseSKVocab, :use)
    add_command(CancelVocab, :cancel)
  end
 
  def to_center
    self.x = Graphics.width/2 - width/2
    self.y = Graphics.height/2 - height/2
  end
 
end

class Scene_Skill < Scene_ItemBase
  alias r2_skill_equip_falco_start  start
  def start
    r2_skill_equip_falco_start
    create_equip_window
  end
 
  def command_equip
    @use_command.close
    create_slot_confirm
    @slot_confirm.z = 1000
    @item_window.deactivate
    @slot_confirm.activate
  end
 
  alias r2_equip_skill_ok on_item_ok
  def on_item_ok
    if item.nil?
      @item_window.activate
      return
    end
    @use_command.open
    @use_command.activate
    @use_command.select(0)
  end
 
  def use_command_ok
    if @actor.usable?(item)
      r2_equip_skill_ok
      @use_command.close
    else
      Sound.play_buzzer
      @use_command.activate
      return
    end
  end

  def on_usecmd_cancel
    @item_window.activate
    @use_command.close
    @use_command.deactivate
  end

  def create_equip_window
    @use_command = Window_EquipUseCommand.new
    @use_command.to_center
    @use_command.set_handler(:equip,    method(:command_equip))
    @use_command.set_handler(:use, method(:use_command_ok))
    @use_command.set_handler(:cancel, method(:on_usecmd_cancel))
    @use_command.viewport = @viewport
  end

  def create_slot_confirm
    @slot_confirm = Window_SlotConfirm.new(Graphics.width / 2 - 60 / 2,
    Graphics.height / 2 - 85 / 2, :skill)
    @slot_confirm.set_handler(:slot1,     method(:open_slots))
    @slot_confirm.set_handler(:slot2,     method(:open_slots))
    @slot_confirm.set_handler(:slot3,     method(:open_slots))
    @slot_confirm.set_handler(:slot4,     method(:open_slots))
  end

  def open_slots
    case @slot_confirm.current_symbol
    when :slot1 then @actor.assigned_skill  = item
    when :slot2 then @actor.assigned_skill2 = item
    when :slot3 then @actor.assigned_skill3 = item
    when :slot4 then @actor.assigned_skill4 = item
    end
    Sound.play_equip
    @item_window.activate
    @slot_confirm.deactivate
    @slot_confirm.dispose
    @slot_confirm = nil
  end
 
end
