# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Actor Equip Default                    ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Equip basic equipment on actor              ║    18 Sep 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   When an actor has a slot unequipped, this will                   ║
# ║   automatically equip a base item for that slot.                   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Specify the equipment for each actor                             ║
# ║      {  # actor 1                                                  ║
# ║    :slot1 => [1,1],   # short sword                                ║
# ║  0 = items, 1 = weapons, 2 = armour : item number                  ║
# ║  items are included in case you have items equippable              ║
# ║    :slot2 => [2,46],   # wood shield                               ║
# ║    :slot3 => [2,3],   # metal plate                                ║
# ║    :slot4 => [2,6],   # bandana                                    ║
# ║    :slot5 => [2,51],  # amulet                                     ║
# ║  },                                                                ║
# ║                                                                    ║
# ║  Add or remove slots to accomdate your game.                       ║
# ║  Add or remove sections to accomdate your game.                    ║
# ║                                                                    ║
# ║  Always remember the comma after each closing                      ║
# ║  curly bracket                                                     ║
# ║                                                                    ║
# ║  You are responsible for making sure the actor can equip           ║
# ║  the item, otherwise the slot will be blank when                   ║
# ║  removing the item in the current slot.                            ║
# ║                                                                    ║
# ║  Due to the nature of equipping items, it is recommended           ║
# ║  that you use items the player cannot sell, and cannot             ║
# ║  obtain anywhere. That way the default items are not               ║
# ║  saved in the inventory.                                           ║
# ║                                                                    ║
# ║  This script will delete items from the party inventory            ║
# ║  if the player tries to remove the item intended to be             ║
# ║  a base item. This is to prevent someone from simply               ║
# ║  trying to remove the item to an empty slot and gaining            ║
# ║  the base items for free, since this script does not               ║
# ║  party inventory.                                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 18 Sep 2021 - Script finished                               ║
# ║                                                                    ║
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

module R2_Equip_defaults
  # actors 1-10 included here
       ACTORS = [
      { # actor 1 
    :slot0 => [1,1],   # short sword
    :slot1 => [2,46],  # wood shield
    :slot2 => [2,6],   # bandana
    :slot3 => [2,1],   # casual clothes
    :slot4 => [2,51],  # amulet
    },
      { # actor 2
    :slot0 => [1,1],
    :slot1 => [2,46],
    :slot2 => [2,6],
    :slot3 => [2,1],
    :slot4 => [2,51],
    },
      { # actor 3
    :slot0 => [1,1],
    :slot1 => [2,46],
    :slot2 => [2,6],
    :slot3 => [2,1],
    :slot4 => [2,51],
    },
      { # actor 4
    :slot0 => [1,1],
    :slot1 => [2,46],
    :slot2 => [2,6],
    :slot3 => [2,1],
    :slot4 => [2,51],
    },
      { # actor 5
    :slot0 => [1,1],
    :slot1 => [2,46],
    :slot2 => [2,6],
    :slot3 => [2,1],
    :slot4 => [2,51],
    },
      { # actor 6
    :slot0 => [1,1],
    :slot1 => [2,46],
    :slot2 => [2,6],
    :slot3 => [2,1],
    :slot4 => [2,51],
    },
      { # actor 7
    :slot0 => [1,1],
    :slot1 => [2,46],
    :slot2 => [2,6],
    :slot3 => [2,1],
    :slot4 => [2,51],
    },
      { # actor 8
    :slot0 => [1,1],
    :slot1 => [2,46],
    :slot2 => [2,6],
    :slot3 => [2,1],
    :slot4 => [2,51],
    },
      { # actor 9
    :slot0 => [1,1],
    :slot1 => [2,46],
    :slot2 => [2,6],
    :slot3 => [2,1],
    :slot4 => [2,51],
    },
      { # actor 10
    :slot0 => [1,1],
    :slot1 => [2,46],
    :slot2 => [2,6],
    :slot3 => [2,1],
    :slot4 => [2,51],
    },
    ]
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Game_Actor < Game_Battler
  def change_equip(slot_id, item)
    return unless trade_item_with_party(item, equips[slot_id])
    return if item && equip_slots[slot_id] != item.etype_id
    @equips[slot_id].object = item
      eslot = R2_Equip_defaults::ACTORS[id - 1]
      case slot_id
      when 0
        data = eslot[:slot0]
      when 1
        data = eslot[:slot1]
      when 2
        data = eslot[:slot2]
      when 3
        data = eslot[:slot3]
      when 4
        data = eslot[:slot4]
      end
      slottype = data[0]
      case slottype
      when 0
        item2 = $data_items[data[1]]
      when 1
        item2 = $data_weapons[data[1]]
      when 2
        item2 = $data_armors[data[1]]
      end
    if item == nil
      @equips[slot_id].object = item2
      $game_party.lose_item(item2, 1, false) if $game_party.has_item?(item2, false)
    end
    if $game_party.has_item?(item2, false)
      $game_party.lose_item(item2, 1, false)
    end
    refresh
  end
end
