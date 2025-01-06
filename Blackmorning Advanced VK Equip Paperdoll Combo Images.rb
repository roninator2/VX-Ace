# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Paperdoll Combo Images       ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Change paperdoll image              ║    18 Sep 2021     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ When equipping several armours together, the base image  ║
# ║ will change if the combination is set in the script.     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║   Specify the combination for each armour sets           ║
# ║      [1,4] => 10                                         ║
# ║      [1,4,8] => 11                                       ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║   2021 09 28 -> fixed checking for combos                ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Requires:                                                ║
# ║   BlackMorning - Basic Module                            ║
# ║   BlackMorning - Advanced Equip                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝

module R2_Paperdoll_Combo
  Paperdoll = {
    [62,63] => 64,
    [63,62] => 65,
    [62,62,62] => 66,
    [63,63] => 67,
  }
end

class Window_EquipActor < Window_Base
  def draw_all_items
    return unless @actor
    draw_actor_name(@actor,0,0)
    draw_mini_face
    @equip_image = false
    if BM::EQUIP::PAPER_DOLL_MODE
      item_max.times {|i| draw_item2(i) }  
    else
      item_max.times {|i| draw_item(i) }
    end
    draw_equip_dummy(0, 0) if @equip_image == false
  end
  def draw_pd_equip_image(item, x, y)
    return unless item
    return if item.eb_image.nil?
    @actor.equips.each_with_index { |eb, indx|
      next if eb.nil?
      ebfile = eb.eb_image if eb.eb_image != nil
      if ebfile != item.eb_image
        item = eb
      end
    }
    item2 = item_combine(item)
    if item2 != item
      item = item2
    end
    bitmap = Cache.equip_body(item.eb_image)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x, y, bitmap, rect)
    @equip_image = true
  end
  def item_combine(item)
    prev = item
    @image_combo = []
    @result = nil
    @id = 0
    @cnt = 0
    @actor.equips.each { |equip|
      next if equip.nil?
      @image_combo.push(equip.id)
    }
    R2_Paperdoll_Combo::Paperdoll.each { |data|
      if @image_combo[2] == data[0][2] && (data[0][2] != nil || @image_combo[2] != nil) &&
        (@image_combo[1] == data[0][1]) && (@image_combo[0] == data[0][0])
        cnt = 3
      elsif (@image_combo[1] == data[0][1]) && (@image_combo[0] == data[0][0]) && data[0][2].nil?
        cnt = 2
      else
        cnt = 1
      end
      if @cnt < cnt && cnt > 1
        @cnt = cnt
        @id = data[1]
      end
    }
    @result = $data_armors[@id]
    image = @result
    image = prev if @result.nil?
    return image
  end
end
