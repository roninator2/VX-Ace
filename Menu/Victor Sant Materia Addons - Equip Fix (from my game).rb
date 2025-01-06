# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Materia Equipment Fix        ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Fixes issues with my game           ║    30 Jan 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Plug and Play                                            ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝

class Game_Actor < Game_Battler
  def equip_materia(equip, slot, id, forced = false)
    old = @materia_slots[equip][slot]
    item = $game_party.materias[id].dup
    list = $game_party.materias
    total = $game_party.materias.size
    # adjust for materia list
    @materia_slots[equip][slot] = item
    $game_party.materias = list
    $game_party.lose_mater(item, id) unless forced
    $game_party.gain_item(old, 1) if old
    make_paired_materia
    update_materia_skills
    refresh
  end

  def unequip_materia(equip, slot)
    # gain item when equipment removed - Roninator2
    return if equip.nil?
    if slot == -1
      for i in 0..@materia_slots.size - 1
        next if @materia_slots[equip][i].nil?
        $game_party.gain_item(@materia_slots[equip][i], 1)
        @materia_slots[equip][i] = nil
      end
    else
      item = @materia_slots[equip][slot]
      $game_party.gain_item(@materia_slots[equip][slot], 1)
      @materia_slots[equip][slot] = nil
    end
    make_paired_materia
    update_materia_skills
    refresh
  end
end

class Scene_MateriaShop < Scene_MenuBase
  def on_sell_ok
    Sound.play_shop
    @item = @sell_window.materia
    $game_party.gain_gold(selling_price)
    $game_party.lose_materia(@sell_window.index)
    #added line for equipment listed - roninator2
    $game_party.lose_item(@item, 1)
    activate_sell_window
    index = @sell_window.index
    @sell_window.select([[index, @sell_window.item_max - 1].min, 0].max)
    refresh_windows
  end
end

class Game_Party < Game_Unit
  attr_writer   :materias
  def lose_mater(item, index)
    @materias.delete_at(index)
    @materias.compact!
    @materias.sort! {|a, b| a.id <=> b.id }
    # added to adjust item inventory
    container = item_container(item.class)
    return unless container
    last_number = item_number(item)
    new_number = last_number - 1
    container[item.id] = [[new_number, 0].max, max_item_number(item)].min
    container.delete(item.id) if container[item.id] == 0
  end
  def gain_item(item, amount, include_equip = false)
    if item && item.materia?
      gain_materia(item, amount)
    end
    # edit to add item to inventory
    gain_item_ve_materia_system(item, amount, include_equip)
  end
end
