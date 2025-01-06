# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Throw Items Addon            ║  Version: 1.01     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:  Patch                    ║   Date Created     ║
# ║      Allow to throw item only if    ╠════════════════════╣
# ║      feature is allowed.            ║    08 Jan 2021     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Requires: Claimh - Throw Items Away                      ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║ Original script allowed to throw items. This will        ║
# ║ block the item if it is not allowed.                     ║
# ║                                                          ║
# ║ Determine if you will use switches or                    ║
# ║ have the condition set for the entire game               ║
# ║                                                          ║
# ║ Specify note tag in the item to block it                 ║
# ║ from being discarded.                                    ║
# ║ <keep forever>                                           ║
# ║                                                          ║
# ║ obviously only if it is not a consumable item            ║
# ║ or sellable.                                             ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║ 1.00 - 08 Jan 2021 - Initial publish                     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Follow the Original Authors terms                        ║
# ╚══════════════════════════════════════════════════════════╝

module R2_Throw_Item
	Use_Switches = true # will allow only one option to be used
  
	# These will be used if Use_Switches is false
	Key_Item = true # true lets you discard key items
  Weapon = true # ture lets you discard weapons
  Armor = true # true lets you discard armor
	
	# these will be used if Use_Switches is true
  Item_SW = 1 # switch on lets you discard items
	Key_Item_SW = 2 # Switch on lets you discard key items
	Weapon_SW = 3 # switch on lets you discard weapons
	Armor_SW = 4 # switch on lets you discard armor
	
	Item_Block = /<keep[-_ ]forever>/im
end

if R2_Throw_Item::Use_Switches == true
	class Scene_Item < Scene_ItemBase
		def item_dumpable?
			return if item.nil?
      return false if item.note.match(R2_Throw_Item::Item_Block)
			return false if $game_switches[R2_Throw_Item::Item_SW] == false && 
			item.is_a?(RPG::Item)
			return false if $game_switches[R2_Throw_Item::Key_Item_SW] == false && 
			item.is_a?(RPG::Item) && (item.key_item?)
			return false if $game_switches[R2_Throw_Item::Weapon_SW] == false && item.is_a?(RPG::Weapon)
			return false if $game_switches[R2_Throw_Item::Armor_SW] == false && item.is_a?(RPG::Armor)
			return true unless item.nil?
		end
	end
else
	class Scene_Item < Scene_ItemBase
		def item_dumpable?
      return false if item.note.match(R2_Throw_Item::Item_Block)
			return false if (R2_Throw_Item::Key_Item == false && 
			item.is_a?(RPG::Item) && (item.key_item?)) || item.note.match(R2_Throw_Item::Item_Block)
			return false if (R2_Throw_Item::Weapon == false && item.is_a?(RPG::Weapon)) ||
			item.note.match(R2_Throw_Item::Item_Block)
			return false if (R2_Throw_Item::Armor == false && item.is_a?(RPG::Armor)) ||
			item.note.match(R2_Throw_Item::Item_Block)
			return true unless item.nil?
		end
	end
end
