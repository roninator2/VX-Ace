# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Order Battler Patch - Class Icons      ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Patch for Yami order battlers Class Icons   ║    13 Sep 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly Battle Engine                                     ║
# ║           Yami Order Battlers                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║     Order Battlers - Show Class Icons                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Place below Order Battlers                                       ║
# ║   Class Notetags - These notetags go in the class notebox          ║
# ║     in the database.                                               ║
# ║                                                                    ║
# ║   <battler class icon: x>                                          ║
# ║   Change actor's icon into x for class                             ║
# ║                                                                    ║
# ║   <class icon hue: x>                                              ║
# ║   Change icon hue.                                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 13 Sep 2022 - Script finished                               ║
# ║ 1.01 - 13 Sep 2022 - added fix for memory leaks                    ║
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

module YSA
  module REGEXP
    module ACTOR
      BATTLER_CLASS_ICON = /<(?:BATTLER_CLASS_ICON|battler class icon):[ ](\d+)?>/i
      CLASS_ICON_HUE = /<(?:CLASS_ICON_HUE|class icon hue):[ ](\d+)?>/i
    end # ACTOR
  end
end

class RPG::Class < RPG::BaseItem
  attr_accessor :battler_class_icon
  attr_accessor :class_icon_hue
    def load_notetags_orbt
    @battler_class_icon = YSA::ORDER_GAUGE::DEFAULT_ACTOR_ICON
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YSA::REGEXP::ACTOR::BATTLER_CLASS_ICON
        @battler_class_icon = $1.to_i
      when YSA::REGEXP::ACTOR::CLASS_ICON_HUE
        @class_icon_hue = $1.to_i
      end
    }
  end
end

class Game_Battler < Game_BattlerBase
  def battler_class_icon
    aci = $data_classes[actor.class_id]
    aci.battler_class_icon
  end
  def battler_class_icon_hue
    aci = $data_classes[actor.class_id]
    aci.class_icon_hue
  end
end

module DataManager
  def self.load_notetags_orbt
    groups = [$data_enemies + $data_actors + $data_classes]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_orbt
      end
    end
  end
end # DataManager

class Sprite_OrderBattler < Sprite_Base
  def create_dtb_style
    bitmap = Bitmap.new(24, 24)
    if $imported["YEA-BattleEngine"]
      icon_bitmap = $game_temp.iconset 
    else
      icon_bitmap = Cache.system("IconSet")
    end
    #--- Create Battler Background ---
    icon_index = @battler.actor? ? YSA::ORDER_GAUGE::BATTLER_ICON_BORDERS[:actor][0] : YSA::ORDER_GAUGE::BATTLER_ICON_BORDERS[:enemy][0]
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    bitmap.blt(0, 0, icon_bitmap, rect)
    #--- Create Battler Icon ---
    ######## edited for class icons
    if @battler.actor?
      if @battler.battler_class_icon == YSA::ORDER_GAUGE::DEFAULT_ACTOR_ICON
        icon_index = @battler.battler_icon
      else
        icon_index = @battler.battler_class_icon
      end
    else
      icon_index = @battler.battler_icon
    end
    ########
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    temp_bitmap = Bitmap.new(24, 24)
    temp_bitmap.blt(0, 0, icon_bitmap, rect)
    ######## edited for class hue
    if @battler.actor?
      temp_bitmap.hue_change(@battler.battler_icon_hue) if @battler.battler_icon_hue
      temp_bitmap.hue_change(@battler.battler_class_icon_hue) if @battler.battler_class_icon_hue
    else
      temp_bitmap.hue_change(@battler.battler_icon_hue) if @battler.battler_icon_hue
    end
    ########
    bitmap.blt(0, 0, temp_bitmap, Rect.new(0, 0, 24, 24))
    temp_bitmap.dispose
    #--- Create Battler Border ---
    icon_index = @battler.actor? ? YSA::ORDER_GAUGE::BATTLER_ICON_BORDERS[:actor][1] : YSA::ORDER_GAUGE::BATTLER_ICON_BORDERS[:enemy][1]
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    bitmap.blt(0, 0, icon_bitmap, rect)
    #---
    self.bitmap.dispose if self.bitmap != nil
    self.bitmap = bitmap
    return if @created_icon
    @created_icon = true
    self.ox = 12; self.oy = 12
    self.x = 24 if @battle != :pctb2 && @battle != :pctb3
    self.y = 24
    self.z = 8000
  end
end
