# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Equip Common Event                     ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║  Run common events for equipping              ║    14 Apr 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Run CE on equip                                             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║    Add note tag to equipment to have them run                      ║
# ║    Common Events when equipped or unequipped                       ║
# ║                                                                    ║
# ║    <on add: x>  X = common event id                                ║
# ║    <on remove: x>                                                  ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 14 Apr 2023 - Initial publish                               ║
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

#==============================================================================
# ** Module Equip Common Event
#============================================================================== 
module R2_Equip_CE
  Equip_ADD_CE = /<on[-_ ]add:[-_ ](\d+)>/i
  Equip_REMOVE_CE = /<on[-_ ]remove:[-_ ](\d+)>/i
end

#==============================================================================
# ** Module DataManager
#============================================================================== 
module DataManager
  class <<self; alias load_database_equip_ce load_database; end
  def self.load_database
    load_database_equip_ce
    load_notetags_equip_ce
  end
  def self.load_notetags_equip_ce
    groups = [$data_items, $data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_equip_ce
      end
    end
  end
end

#==============================================================================
# ** Load Item Note Tags
#============================================================================== 
class RPG::BaseItem
  attr_accessor :equip_add_ce
  attr_accessor :equip_remove_ce
  def load_notetags_equip_ce
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when R2_Equip_CE::Equip_ADD_CE
        @equip_add_ce = $1.to_i
      when R2_Equip_CE::Equip_REMOVE_CE
        @equip_remove_ce = $1.to_i
      end
    }
  end
end

#==============================================================================
# ** Modify Change Equip
#============================================================================== 
class Game_Actor
  alias r2_equip_change_ce change_equip
  def change_equip(slot_id, item)
    old_item = @equips[slot_id].object
    r2_equip_change_ce(slot_id, item)
    if old_item
      $game_temp.reserve_common_event(old_item.equip_remove_ce)
    end
    if @equips[slot_id].object == item
      $game_temp.reserve_common_event(item.equip_add_ce)
    end
  end
end

#==============================================================================
# ** Modify Running Common Events
#============================================================================== 
class Game_Temp
  attr_reader :equip_common_events
  alias r2_common_event_array initialize
  def initialize
    r2_common_event_array
    @equip_common_events = []
  end
  def common_event_id
    @equip_common_events[0]
  end
  def reserve_common_event(common_event_id)
    return if common_event_id == nil
    @equip_common_events.push(common_event_id)
  end
  def common_event_reserved?
    @equip_common_events.size > 0
  end
  def reserved_common_event
    $data_common_events[@equip_common_events.shift]
  end
end
