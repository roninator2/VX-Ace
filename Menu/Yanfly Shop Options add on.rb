# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Yanfly Shop Options add on             ║  Version: 1.03     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Show total count including equips             ║    16 Jan 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly Engine Ace - Ace Shop Options                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Script adjusts Ace Shop to show the total amount of                ║
# ║ items in party inventory, including equipment.                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 16 Jan 2021 - Initial publish                               ║
# ║ 1.01 - 17 Jan 2021 - Accounted for dual wield                      ║
# ║ 1.02 - 18 Jan 2021 - Added support for Hime Instance item          ║
# ║ 1.03 - 19 Jan 2021 - Fixed dual wield bug                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║ Follow the Original Authors terms                                  ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Draw Quantity Possessed
  #--------------------------------------------------------------------------
  def draw_possession(x, y)
    rect = Rect.new(x, y, contents.width - 4 - x, line_height)
    change_color(system_color)
    draw_text(rect, Vocab::Possession)
    change_color(normal_color)
    eqinc = 0
    $game_party.all_members.each {|actor|
      if actor.equips.include?(@item)
        eqinc += 1 if !@item.nil?
        eqinc += 1 if actor.dual_wield? && !@item.nil? &&
          @item.is_a?(RPG::Weapon)
        eqinc -= 1 if actor.dual_wield? && !@item.nil? &&
          (actor.equips[0].id != actor.equips[1].id)
      end
    }
    if $imported["TH_InstanceItems"]
      item = InstanceManager.get_instance(@item)
      $game_party.all_members.each {|actor|
      eqitem = nil
        actor.equip_slots.each_with_index {|e, i| 
          if item != nil && item.is_a?(RPG::EquipItem)
            eqitem = actor.equips[i] if e == item.etype_id
          end
        }
      if eqitem != nil && item != nil
        if eqitem.is_a?(RPG::EquipItem) || item.is_a?(RPG::EquipItem)
          if eqitem.etype_id == item.etype_id
            eqinc += 1 if item.template_id == eqitem.template_id
            eqinc += 1 if actor.dual_wield? && !item.nil? &&
              item.is_a?(RPG::Weapon) && !actor.equips[1].nil? &&
              actor.equips[1].template_id == item.template_id
            eqinc -= 1 if actor.dual_wield? && !item.nil? && !actor.equips[1].nil? &&
              actor.equips[1].template_id != actor.equips[0].template_id
          end
        end
      end
      }
    end
    draw_text(rect, $game_party.item_number(@item) + eqinc, 2)
  end
end
