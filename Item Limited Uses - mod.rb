#==============================================================================
#
# ▼ Yanfly Engine Ace - Item Limited Uses v1.00
# -- Last Updated: 2023.09.01
# -- Level: Easy
# -- Requires: n/a
# -- Moded by Roninator2
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ItemLimitUse"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2023.09.01 - Started Script and Finished.
#
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Sometimes good game balance depends on restriction mechanics. One of these
# mechanics include the amount of times an item can be used (limited uses)
# This is intented to be used with items that you only get one of.
# Compatible with Instance Items (preferred)
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
#
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <limit use: x>
# This will allow the skill to only be usable x times throughout the course of
# battle. Once the skill is used x times, it is disabled until the battle is
# over. This effect only takes place during battle.
#
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
#
#==============================================================================

module YEA
  module ITEM_RESTRICT
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Limited Use Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Some skills have limited uses per battle. These limited uses are reset
    # at the start and end of each battle and do not apply when used outside of
    # battle. There are no effects that can affect limited uses.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    LIMIT_COLOUR  = 8          # Colour used from "Window" skin.
    LIMIT_SIZE    = 18         # Font size used
    LIMIT_TEXT    = "%s uses"  # Text used
    LIMIT_ICON    = 0          # Icon used. Set 0 to disable.
    
  end # SKILL_RESTRICT
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
    module ITEM
      LIMIT_USE = /<(?:LIMIT_USE|limit use):[ ](\d+)>/i
    end # ITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
 
  #--------------------------------------------------------------------------
  # self.itemlimit
  #--------------------------------------------------------------------------
  def self.itemlimit; return YEA::ITEM_RESTRICT::LIMIT_ICON; end
    
end # Icon

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
 
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_liu load_database; end
  def self.load_database
    load_database_liu
    load_notetags_liu
  end
 
  #--------------------------------------------------------------------------
  # new method: load_notetags_srs
  #--------------------------------------------------------------------------
  def self.load_notetags_liu
    for obj in $data_items
      next if obj.nil?
      obj.load_notetags_liu
    end
  end
 
end # DataManager

#==============================================================================
# ■ RPG::Item
#==============================================================================

class RPG::UsableItem
 
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :limit_use

  #--------------------------------------------------------------------------
  # common cache: load_notetags_liu
  #--------------------------------------------------------------------------
  def load_notetags_liu
    @limit_use = 0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ITEM::LIMIT_USE
        @limit_use = $1.to_i
      end
    } # self.note.split
    #---
  end
 
end # RPG::Items

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_Battler
 
  #--------------------------------------------------------------------------
  # * Consume Items
  #--------------------------------------------------------------------------
  def consume_item(item)
    if item.limit_use >= 1
      item.limit_use -= 1
    end
    $game_party.consume_item(item) if item.limit_use == 0
  end
    
end # Game_BattlerBase

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
 
  def limit_colour; text_color(YEA::ITEM_RESTRICT::LIMIT_COLOUR); end;
 
end # Window_Base

#==============================================================================
# ■ Window_SkillList
#==============================================================================

class Window_ItemList < Window_Selectable
 
  #--------------------------------------------------------------------------
  # alias method: draw_item
  #--------------------------------------------------------------------------
  alias window_itemlist_draw_item_liu draw_item
  def draw_item(index)
    if item_limit_restrict?(index)
      draw_item_restriction(index)
    else
      window_itemlist_draw_item_liu(index)
    end
  end
 
  #--------------------------------------------------------------------------
  # new method: limit_restricted?
  #--------------------------------------------------------------------------
  def item_limit_restrict?(index)
    item = @data[index]
    return true if item.limit_use >= 1
  end

  #--------------------------------------------------------------------------
  # new method: draw_item
  #--------------------------------------------------------------------------
  def draw_item_restriction(index)
    item = @data[index]
    rect = item_rect(index)
    rect.width -= 4
    draw_item_name(item, rect.x, rect.y, enable?(item))
    draw_item_limited(rect, item)
  end
 
  #--------------------------------------------------------------------------
  # new method: draw_skill_limited
  #--------------------------------------------------------------------------
  def draw_item_limited(rect, item)
    change_color(limit_colour, enable?(item))
    icon = Icon.itemlimit
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(item))
      rect.width -= 24
    end
    contents.font.size = YEA::ITEM_RESTRICT::LIMIT_SIZE
    text = sprintf(YEA::ITEM_RESTRICT::LIMIT_TEXT, item.limit_use)
    draw_text(rect, text, 2)
    reset_font_settings
  end
 
end # Window_SkillList

#==============================================================================
#
# ▼ End of File
#
#==============================================================================
