# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Mr Trivel Crafting Simple - addon      ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Specify super items that are not consumed   ║    11 Jun 2019     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Mr. Trivel - Crafting Simple                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   Adds returning of items if they are specified in the note tag    ║
# ║   Essentially making it so that you do not lose the tagged item    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   I designed this for my own game Path of Life                     ║
# ║   The concept is that you can have items that are 'super' items    ║
# ║   which will not be lost and replace other items in the recipe     ║
# ║                                                                    ║
# ║   The tagged item must be in your inventory                        ║
# ║   Can only substitute items for items, weapons for weapons etc     ║
# ║                                                                    ║
# ║   Place the note tag                                               ║
# ║         <swap craft: X>                                            ║
# ║   on the item, weapon, armor you wish to be recovered              ║
# ║   in the item that would normally get consumed                     ║
# ║   So on item 15 you say <swap craft: 20>                           ║
# ║   The recipe needs item 15, but it gets substituted for item 20    ║
# ║   When you craft the item, item 20 is not lost, neither is item 15 ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Mr. Trivel                                                       ║
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

module R2
  module Trivel_Craft
    Regex = /<swap[-_ ]craft:[-_ ]\s*(\d+)\s*>/imx
  end
end

class MrTS_Requirements_Window < Window_Base

  def set_recipe(item)
    return unless item
    @recipe = item
    @item_list = []
    @saveitem = []
    MrTS::Crafting::RECIPES[@recipe][:ingredients].each { |i| 
      type = i[0].to_i
      if type == 0
        item = $data_items[i[1]]
        results = item.note.scan(R2::Trivel_Craft::Regex)
        results.each do |res|
          repitem = res[0].to_i
          if $game_party.has_item?($data_items[repitem], false)
            @item_list.delete(i)
            i = [type, repitem, 1]
            @saveitem << i
            @saveitem.uniq!
          end
        end
      end
      if type == 1
        item = $data_weapons[i[1]]
        results = item.note.scan(R2::Trivel_Craft::Regex)
        results.each do |res|
          repitem = res[0].to_i
          if $game_party.has_item?($data_weapons[repitem], false)
            @item_list.delete(i)
            i = [type, repitem, 1]
            @saveitem << i
            @saveitem.uniq!
          end
        end
      end
      if type == 2
        item = $data_armors[i[1]]
        results = item.note.scan(R2::Trivel_Craft::Regex)
        results.each do |res|
          repitem = res[0].to_i
          if $game_party.has_item?($data_armors[repitem], false)
            @item_list.delete(i)
            i = [type, repitem, 1]
            @saveitem << i
            @saveitem.uniq!
          end
        end
      end
      @item_list.push(get_true_item(i)) 
      @item_list.uniq!
    }
    refresh
  end
  
  alias r2_trivel_craft_item_83v    craft_item
  def craft_item
    r2_trivel_craft_item_83v
    @saveitem.each do |il|
      keep = get_true_item(il)
      $game_party.gain_item(keep[0], keep[1])
    end
  end

end
