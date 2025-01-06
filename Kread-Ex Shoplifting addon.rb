#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#  ▼ Shoplifting
#  Author: Kread-EX
#  Addon: Roninator2
#  Version 1.02.01 # addon
#  Release date: 13/12/2019
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=

#------------------------------------------------------------------------------
#  ▼ UPDATES
#------------------------------------------------------------------------------
# # 13/12/2019. Added steal_item to stop stealing everything.
# # 10/12/2012. Added class bonus and requirement. Couple bug fixes.
# # 02/12/2012. Added a variable to keep track of steal attempts.
#------------------------------------------------------------------------------
#  ▼ TERMS OF USAGE
#------------------------------------------------------------------------------
# #  You are free to adapt this work to suit your needs.
# #  You can use this work for commercial purposes if you like it.
# #  Credit is appreciated.
# #
# # For support:
# # grimoirecastle.wordpress.com
# # rpgmakerweb.com
#------------------------------------------------------------------------------
#  ▼ INTRODUCTION
#------------------------------------------------------------------------------
# # You can steal from shops, making you a THIEF. You can customize the %
# # chance of being caught, and how much agility and luck influence
# # your chances.
#------------------------------------------------------------------------------
#  ▼ INSTRUCTIONS
#------------------------------------------------------------------------------
# # In the item/weapon/armor database tabs, you must use the following notetag
# # to make the option to steal the item:

# # <steal_item> # must be used to specify if an item can be stolen
# #
#------------------------------------------------------------------------------

module KRX
  module REGEXP
    STEAL_ITEM = /<steal_item>/i
  end
end

module KRX
  module SHOPLIFT
    attr_reader   :steal_item
    attr_reader   :steal_chance
    attr_reader   :steal_agi
    attr_reader   :steal_luk
    def load_shoplift_notetags
      @note.split(/[\r\n]+/).each do |line|
        case line        
        when KRX::REGEXP::STEAL_CHANCE
          @steal_chance = $1.to_i
        when KRX::REGEXP::STEAL_AGILITY
          @steal_agi = $1.to_i
        when KRX::REGEXP::STEAL_LUCK
          @steal_luk = $1.to_i
        when KRX::REGEXP::STEAL_ITEM
          @steal_item = true
        end
      end
    end
    
  end
end

class Window_ShopSteal < Window_ShopBuy
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    leader = $game_party.leader
    chance = item.steal_chance || KRX::DEFAULT_STEAL_CHANCE
    chance += (leader.agi * (item.steal_agi || 0) / 100.00)
    chance += (leader.luk * (item.steal_luk || 0) / 100.00)
    chance += (leader.class.steal_class || 0)
    chance = 100 if chance > 100
    chance = chance.round
    draw_text(rect, chance.to_s + '%', 2) if item.steal_item
  end

  def enable?(item)
    item.steal_item
  end
end
