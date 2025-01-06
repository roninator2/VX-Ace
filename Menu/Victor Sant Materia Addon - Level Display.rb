# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Materia Level Display        ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Adds Materia level on icon          ║    30 Jan 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Plug and Play                                            ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝

class RPG::Armor < RPG::EquipItem
  attr_accessor :ap_list
end

class Window_MateriaList < Window_Selectable
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    now = item.level.to_i
    max = item.ap_list.length.to_i
    num = now == max ? "M" : now
    draw_icon(item.icon_index, x, y, enabled, item)
    draw_text(x, y, width, line_height, num, 0)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
end

class Window_MateriaEquip < Window_Selectable
  def draw_materia_icons(x)
    actor.equip_slots.size.times do |i|
      next unless actor.materia_slots[i]
      actor.materia_slots[i].each_with_index do |m, y|
        draw_materia(m.icon_index, x + y * 32, i * 50 + 24, m, 200) if m
        now = m.level.to_i if m
        max = m.ap_list.length.to_i if m
        num = max == now ? "M" : now if m
        draw_text(x + y * 32, i * 50 + 24, 40, line_height, num, 0) if m
      end
    end
  end
end
