# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Shop Random Affixes                    ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Show Random Affixes in Shop                   ║    18 Sep 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Selchar's Random Shop                                    ║
# ║           Hime's Item Affixes                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Add affixes to shop items                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and Play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 18 Sep 2023 - Script finished                               ║
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

module RPG
  class EquipItem < BaseItem
    attr_accessor :affix_set
  end
end

class Window_ShopBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    return if @data != nil
    @data = []
    @price = {}
    @shop_goods.each do |goods|
      case goods[0]
      when 0;  item = $data_items[goods[1]]
      when 1
        item = $data_weapons[goods[1]]
        item = InstanceManager.get_instance(item)
        item = InstanceManager.setup_equip_instance(item) unless item.affix_set == true
      when 2
        item = $data_armors[goods[1]]
        item = InstanceManager.get_instance(item)
        item = InstanceManager.setup_equip_instance(item) unless item.affix_set == true
      end
      if item
        @data.push(item)
        @price[item] = goods[2] == 0 ? item.price : goods[3]
      end
    end
  end
  def disable_instance_item(io)
    return if io.is_a?(RPG::Item)
    @data.each_with_index do |itm, i|
      if itm == io
        @data[i] = nil
      end
    end
    @data.compact!
    refresh
  end
end

class Scene_Shop < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Execute Purchase
  #--------------------------------------------------------------------------
  def do_buy(number)
    $game_party.lose_gold(number * buying_price)
    $game_party.gain_item(@item, number)
    @buy_window.disable_instance_item(@item)
  end
end

module InstanceManager
  def self.setup_equip_instance(obj)
    random_affix_equip_setup(obj)
    return if TH_Instance::Equip::Random_Affix_Allowed[SceneManager.scene.class.to_s].nil?
    if eval(TH_Instance::Equip::Random_Affix_Allowed[SceneManager.scene.class.to_s])
      obj.prefix_id = obj.random_prefix unless obj.affix_set == true
      obj.suffix_id = obj.random_suffix unless obj.affix_set == true
      obj.affix_set = true
    end
  end
end
