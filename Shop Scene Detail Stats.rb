# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Shop Scene Detail Stats                ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Adjusts number window to show               ╠════════════════════╣
# ║   equipment stats on two pages                ║    12 Feb 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Show stats in shop for items                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║  Script provides the ability to see equipment stats,               ║
# ║  for the item selected to purchase, before accepting.              ║
# ║  Made to have two screens, can be adjusted to have only            ║
# ║  one. Simply change the rows value.                                ║
# ║  Default resolution allows 11 rows per screen                      ║
# ║  So if you want to display lots of stats on your                   ║
# ║  equipmnent, you can use 33 to get three pages.                    ║
# ║  However all equipment will have three pages.                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 12 Feb 2021 - Script finished                               ║
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

module R2_SHOP_STATS

  # Determine the number of lines the number window will have
  # Default of 22 provides two pages at default resolution
  # Instruct players to press L or R ( Q & W ) to switch pages
  ITEM_ROWS = 22 # adjust for data shown

  ITEMS_PER_PAGE = 11 # used to control the cursor
  # specify how many rows are on a page. Only controls the cursor
  # count how many rows show up.
  #------------------------------------------------------------------------
  # PURCHASE WINDOW OPTIONS
  #------------------------------------------------------------------------

  # The following determines the text displayed at the amount selection
  # screen. Change the information here accordingly.
  PURCHASE = "L < Page     Purchase     Page > R"
  # Title of purchasing information.
  COST_ICN = 361                  # Icon of total cost.
  COST_TXT = "Total Cost"         # Text for total cost.
  ITEM_STAT = "Item Info"         # Text for item data.
  WPN_STAT = "Weapon Info"        # Text for weapon data.
  ARM_STAT = "Armour Info"        # Text for armour data.
  FONTSIZE = 20 # Use 18 or 20    # Font size used for data text.
  USE_SPACES = false               # Attempt to separate section

  # Draw stats for items?
  ITEM_STATES = true              # Show item states applied
  ITEM_BUFFS  = true              # Show item buffs added/removed
  ITEM_STATS  = true              # Show item stat additions
  ITEM_SKILL  = true              # Show skills learned from the item

  ITEM_STAT_HP_DAM = "HP Damage"  # Text for item stats
  ITEM_STAT_MP_DAM = "MP Damage"  # Text for item stats
  ITEM_STAT_HP_REC = "HP Recover" # Text for item stats
  ITEM_STAT_MP_REC = "MP Recover" # Text for item stats
  ITEM_STAT_HP_DRN = "HP Drain"   # Text for item stats
  ITEM_STAT_MP_DRN = "MP Drain"   # Text for item stats

  ITEM_DAM_TYPE = "Damage Type"   # Text for item stats

  ITEM_ADD_BUFF   = "Add Buff"        # Text for item buffs
  ITEM_ADD_DEBUFF = "Add Debuff"      # Text for item buffs
  ITEM_RM_BUFF    = "Remove Buff"     # Text for item buffs
  ITEM_RM_DEBUFF  = "Remove Debuff"   # Text for item buffs

  # text for when an item had effects that change the base stats
  R2_SHOP_STATS::ITEM_STAT_TEXT = "Change Base Stats"

  # text for when an item adds skills to the player
  R2_SHOP_STATS::ITEM_SKILL_ADD = "Skill(s) Learned"

  # text for when an equipment adds skills to the player
  R2_SHOP_STATS::EQUIP_SKILL_ADD = "Skill(s) Learned"

  TEXT_ADD_STATES = "States Added"       # States added text
  TEXT_RM_STATES  = "States Removed"     # States removed text
  TEXT_SEAL_STATES  = "Skill(s) Sealed"  # States sealed text

  # This part defines the data used for item/equipment properties.
  HP_HEAL_TEXT = "HP Effect"      # Text used for HP recovery.
  HP_HEAL_ICON = 128              # Icon used for HP recovery.
  MP_HEAL_TEXT = "MP Effect"      # Text used for MP recovery.
  MP_HEAL_ICON = 202              # Icon used for MP recovery.
  ERASE_STATE  = "Removes Status" # Text used for removing states.
  APPLY_STATE  = "Applies Status" # Text used for applying states.
  PARAM_BOOST  = "Raises %s"      # Text used for parameter raising.
  SPELL_EFFECT = "Spell Effect"   # Text used for spell effect items.
  SPELL_DAMAGE = "%d Base Dmg"    # Text used for spell damage.
  SPELL_HEAL   = "%d Base Heal"   # Text used for spell healing.
  NO_EQ_STAT   = "---"            # Text used when no equip
  EQ_ELEMENT_W = "Apply Element"  # Text used to represent equip elements.
  EQ_ELEMENT_A = "Guard Element"  # Text used to represent equip elements.
  EQ_STATUS_W  = "Apply Status"   # Text used to represent equip states.
  EQ_STATUS_A  = "Guard Status"   # Text used to represent equip states.
  STATE_RESIST = "State Resist"   # Text used to represent resist states.

  STATS_TEXT = "Item Parameters"
  # These are the general icons and text used for various aspects of new
  # shop windows. Used for items and equips alike.
  ICON_HP  = 32           # Icon for MAXHP
  ICON_MP  = 33           # Icon for MAXMP
  ICON_ATK = 34           # Icon for ATK
  ICON_DEF = 35           # Icon for DEF
  ICON_MAT = 36           # Icon for SPI
  ICON_MDF = 37           # Icon for AGI
  ICON_AGI = 38           # Icon for HIT
  ICON_LUK = 39           # Icon for EVA

  TEXT_HP  = "HP"         # Text for HP
  TEXT_MP  = "MP"         # Text for MP
  TEXT_TP  = "TP"         # Text for TP
  ICON_TP  = 33           # Icon for TP

  # set to true to show ex paramaters in number window
  SHOW_EX_PARAM = true
  EXSTATS_TEXT = "Extra Parameters"
  SHOW_EXTEXT = true
  ICON_HIT = 184          #
  TEXT_HIT = "HIT"        #
  ICON_EVA = 185          #
  TEXT_EVA = "EVA"        #
  ICON_CRI = 186          #
  TEXT_CRI = "CRI"        #
  ICON_CEV = 187          #
  TEXT_CEV = "CEV"        #
  ICON_MEV = 188          #
  TEXT_MEV = "MEV"        #
  ICON_MRF = 189          #
  TEXT_MRF = "MRF"        #
  ICON_CNT = 190          #
  TEXT_CNT = "CNT"        #
  ICON_HRG = 191          #
  TEXT_HRG = "HRG"        #
  ICON_MRG = 192          #
  TEXT_MRG = "MRG"        #
  ICON_TRG = 193          #
  TEXT_TRG = "TRG"        #

  # set to true to show sp paramaters in number window
  SHOW_SP_PARAM = true
  SPSTATS_TEXT = "Special Parameters"
  SHOW_SPTEXT = true
  ICON_TGR = 368          #
  TEXT_TGR = "TGR"        #
  ICON_GRD = 369          #
  TEXT_GRD = "GRD"        #
  ICON_REC = 370          #
  TEXT_REC = "REC"        #
  ICON_PHA = 371          #
  TEXT_PHA = "PHA"        #
  ICON_MCR = 372          #
  TEXT_MCR = "MCR"        #
  ICON_TCR = 373          #
  TEXT_TCR = "TCR"        #
  ICON_PDR = 374          #
  TEXT_PDR = "PDR"        #
  ICON_MDR = 375          #
  TEXT_MDR = "MDR"        #
  ICON_FDR = 376          #
  TEXT_FDR = "FDR"        #
  ICON_EXR = 377          #
  TEXT_EXR = "EXR"        #

  # The following determines which elements can be shown in the elements
  # list. If an element is not included here, it is ignored.
  DRAW_ELEMENTS = true
  SHOWN_ELEMENTS ={
  # Element ID => Icon ID
        1 => 11,
        2 => 16,
        3 => 96,
        4 => 97,
        5 => 98,
        6 => 99,
        7 => 100,
        8 => 101,
        9 => 102,
        10 => 103,
    } # Do not remove this.

  DRAW_STATES = true # Draw states applied to the weapon or armour
  EQUIP_SKILL = true # Show skills learned from weapon or armour
  EQUIP_SKILL_SEAL = true # Show skills sealed from weapon or armour
  EQUIP_DEBUFF = true # Show Debuff Rates

  # Text for stating a debuff rate is applied
  EQUIP_DEBUFF_TEXT = "Debuff Rate"

  EQUIP_ATTACK_STATE = true # Show attack states
  # Text for stating attack states are applied
  # Be sure no not have more than 3, otherwise the script will need changing
  EQUIP_ATTACK_STATE_TEXT = "Attack state(s)"

  EQUIP_ATTACK_SPEED = true # Show attack speed for item
  # Text for showing attack speed
  EQUIP_ATTACK_SPEED_TEXT = "Attack Speed"

  EQUIP_ATTACK_TIMES = true # Show attack times for item
  # Text for showing attack times value
  EQUIP_ATTACK_TIMES_TEXT = "Attack Times"

  EQUIP_ACTION_TIMES = true # Show action times for item
  # Text for showing action times
  EQUIP_ACTION_TIMES_TEXT = "Action Times"

  EQUIP_PARTY_ABILITY = true # Show if party gains an ability from item

end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Scene_Shop < Scene_MenuBase
  alias r2_on_number_cancel_number_stats   on_number_cancel
  def on_number_cancel
    @number_window.num_reset
    @number_window.cursor_pageup
    r2_on_number_cancel_number_stats
  end
end

#===============================================================================
# Window_ShopNumber
#===============================================================================

class Window_ShopNumber < Window_Selectable

  alias r2_shop_number_stat_init  initialize
  def initialize(x, y, height)
    @num_page = 0
    r2_shop_number_stat_init(x, y, height)
  end

  #--------------------------------------------------------------------------
  # overwrite refresh
  #--------------------------------------------------------------------------
  def refresh
    dy = 0
    sw = self.width - 32
    contents.clear
    change_color(system_color)
    contents.font.size = Font.default_size
    draw_text(-10, dy, 300, 24, R2_SHOP_STATS::PURCHASE, 1)
    dy += 24
    change_color(normal_color)
    draw_item_name(@item, 0, dy)
    draw_text(212, dy, 20, 24, "×")
    draw_text(218, dy, 50, 24, @number, 2)
    cursor_rect.set(207, dy, 64, 24)
    dy += 24
    draw_icon(R2_SHOP_STATS::COST_ICN, 0, dy)
    draw_text(24, dy, sw-24, 24, R2_SHOP_STATS::COST_TXT)
    draw_currency_value(@price * @number, @currency_unit, 4, dy, 264)
    dy += 24
    if @item.is_a?(RPG::Item)
      draw_text(0, dy, sw-24, 24, R2_SHOP_STATS::ITEM_STAT, 1)
      draw_item_stats(dy, sw)
    elsif @item.is_a?(RPG::Weapon)
      draw_text(0, dy, sw-24, 24, R2_SHOP_STATS::WPN_STAT, 1)
      draw_equip_stats(dy, sw)
    else
      draw_text(0, dy, sw-24, 24, R2_SHOP_STATS::ARM_STAT, 1)
      draw_equip_stats(dy, sw)
    end
  end

  def num_reset
    @num_page = 0
  end

  #--------------------------------------------------------------------------
  # overwrite cursor rect - set to size of purchase number
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.set(207, 24, 64, 24)
  end
  
  #--------------------------------------------------------------------------
  # overwrite item row - change in module above
  #--------------------------------------------------------------------------
  def item_max
    return R2_SHOP_STATS::ITEM_ROWS
  end

  #--------------------------------------------------------------------------
  # * Alias Cursor One Page Down - hides cursor
  #--------------------------------------------------------------------------
  alias r2_cursor_pagedown_hide cursor_pagedown
  def cursor_pagedown
    r2_cursor_pagedown_hide
    @num_page = @num_page + 1
    if @num_page > (R2_SHOP_STATS::ITEM_ROWS / R2_SHOP_STATS::ITEMS_PER_PAGE) - 1
      @num_page = (R2_SHOP_STATS::ITEM_ROWS / R2_SHOP_STATS::ITEMS_PER_PAGE) - 1
    end
    cursor_rect.set(0, 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # * Alias Cursor One Page Up - shows cursor
  #--------------------------------------------------------------------------
  def cursor_pageup
    @num_page = @num_page - 1
    if top_row > 0
      self.top_row -= page_row_max
      select([@index - page_item_max, 0].max) if @num_page == 0
    end
    @num_page = 0 if @num_page < 0
    update_cursor if @num_page == 0
  end

##########################################################################
  #--------------------------------------------------------------------------
  # draw_item_stats
  #--------------------------------------------------------------------------
##########################################################################
  def draw_item_stats(dy, sw)
    dy += 24
    if @item.damage.type != 0
      case @item.damage.type
      when 1
        text = R2_SHOP_STATS::ITEM_STAT_HP_DAM
      when 2
        text = R2_SHOP_STATS::ITEM_STAT_MP_DAM
      when 3
        text = R2_SHOP_STATS::ITEM_STAT_HP_REC
      when 4
        text = R2_SHOP_STATS::ITEM_STAT_MP_REC
      when 5
        text = R2_SHOP_STATS::ITEM_STAT_HP_DRN
      when 6
        text = R2_SHOP_STATS::ITEM_STAT_MP_REC
      end
      change_color(system_color)
      draw_text(0, dy, sw-24, 24, R2_SHOP_STATS::ITEM_DAM_TYPE, 0)
      contents.font.size = R2_SHOP_STATS::FONTSIZE
      change_color(normal_color)
      draw_text(130, dy + 2, sw/2-24, 24, text, 0)
      if @item.damage.element_id != 0
        if @item.damage.element_id != -1
        draw_icon(R2_SHOP_STATS::SHOWN_ELEMENTS[@item.damage.element_id], 250, dy, 2)
        end
      end
      dy += 24 if R2_SHOP_STATS::USE_SPACES
    end
    count = 0
    dy += 24 if R2_SHOP_STATS::USE_SPACES
    @item.effects.each do |set|
      case set.code
      when 11 #---HP---
        count += 1
        word = R2_SHOP_STATS::TEXT_HP
        icon = R2_SHOP_STATS::ICON_HP
      when 12 #---MP---
        count += 1
        word = R2_SHOP_STATS::TEXT_MP
        icon = R2_SHOP_STATS::ICON_MP
      when 13 #---TP---
        count += 1
        word = R2_SHOP_STATS::TEXT_TP
        icon = R2_SHOP_STATS::ICON_TP
      else
        next
      end
      num1 = 0
      num2 = 0
      if set.value1 != 0
        num1 = set.value1
        num1 = (num1 * 100).to_i
      end
      if set.value2 != 0
        num2 = set.value2.to_i
      end
      if num1 != 0 && num2 != 0
        text1 = sprintf("%d", num1)
        text2 = sprintf("%d", num2)
        text = "+" + text2 + " & " + text1 + "%"
      elsif num1 != 0 && set.code == 13
        text = sprintf("%d", num1)
        text = "+" + text
      elsif num1 != 0 && set.code != 13
        text = sprintf("%d", num1)
        text = text + "%"
      elsif num2 != 0
        text = sprintf("%d", num2)
        text = "+" + text
      end
      if count.odd?
        change_color(system_color)
        draw_text(29, dy, sw/2-24, 24, word)
        change_color(normal_color)
        draw_icon(icon, 0, dy, icon != 0)
        if (text.size * 8) > (sw / 5)
          draw_text(sw*1/6-50, dy, sw/2, 24, text, 2)
        else
          draw_text(sw*1/4, dy, sw/5, 24, text, 2)
        end
      else
        change_color(system_color)
        draw_text(sw/2+29, dy, sw/2-24, 24, word)
        change_color(normal_color)
        draw_icon(icon, sw/2, dy, icon != 0)
        if (text.size * 8) > (sw / 5)
          draw_text(sw*3/6, dy, sw/2, 24, text, 2)
        else
          draw_text(sw*3/4, dy, sw/5, 24, text, 2)
        end
      end
      if count % 2 == 0
        dy += 24
      end
    end
##########################################################################
    if R2_SHOP_STATS::ITEM_STATES
      add_states = []
      remove_states = []
      @item.effects.each do |set|
        next if set.code == 0
        if set.code == 21
          add_states.push(set.data_id)
        elsif set.code == 22
          remove_states.push(set.data_id)
        end
      end
      if add_states != [] # Draw Add States
        dy += 24
        text = R2_SHOP_STATS::TEXT_ADD_STATES
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        dx = sw - (add_states.size * 24)
        for i in add_states
          icon = $data_states[i].icon_index
          draw_icon(icon, dx, dy)
          dx += 24
        end
      end
      if remove_states != [] # Draw Remove States
        dy += 24
        text = R2_SHOP_STATS::TEXT_RM_STATES
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        dx = sw - (remove_states.size * 24)
        for i in remove_states
          icon = $data_states[i].icon_index
          draw_icon(icon, dx, dy)
          dx += 24
        end
      end
      dy += 24 if R2_SHOP_STATS::USE_SPACES
    end
##########################################################################
    if R2_SHOP_STATS::ITEM_BUFFS
      @item.effects.each do |set|
        case set.code
        when 31 #---ADD BUFF---
          buff = R2_SHOP_STATS::ITEM_ADD_BUFF
        when 32 #---ADD DEBUFF---
          buff = R2_SHOP_STATS::ITEM_ADD_DEBUFF
        when 33 #---REMOVE BUFF---
          buff = R2_SHOP_STATS::ITEM_RM_BUFF
        when 34 #---REMOVE DEBUFF---
          buff = R2_SHOP_STATS::ITEM_RM_DEBUFF
        else
          next
        end
        case set.data_id
        when 0 #---HP---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_HP
        when 1 #---MP---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_MP
        when 2 #---ATK---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_ATK
        when 3 #---DEF---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_DEF
        when 4 #---MAT---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_MAT
        when 5 #---MDF---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_MDF
        when 6 #---AGI---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_AGI
        when 7 #---LUK---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_LUK
        end
        num = 0
        if set.value1 != 0
          num = set.value1.to_i
        end
        if num != 0 && set.code == 31
          text = sprintf("%d", num)
          text = "+" + text + " turns"
        elsif num != 0 && set.code == 32
          text = sprintf("%d", num)
          text = "+" + text + " turns"
        end
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, buff)
        draw_text(90, dy, sw/2-24, 24, word)
        change_color(normal_color)
        draw_icon(icon, 120, dy, icon != 0)
        draw_text(150, dy, sw/3, 24, text, 2)
        dy += 24 if R2_SHOP_STATS::USE_SPACES
      end
    end
##########################################################################
    if R2_SHOP_STATS::ITEM_STATS
      @item.effects.each do |set|
        case set.code
        when 42 #---Grow Stat---
          buff = R2_SHOP_STATS::ITEM_STAT_TEXT
        else
          next
        end
        case set.data_id
        when 0 #---HP---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_HP
        when 1 #---MP---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_MP
        when 2 #---ATK---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_ATK
        when 3 #---DEF---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_DEF
        when 4 #---MAT---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_MAT
        when 5 #---MDF---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_MDF
        when 6 #---AGI---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_AGI
        when 7 #---LUK---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_LUK
        end
        num = 0
        if set.value1 != 0
          num = set.value1.to_i
        end
        if num != 0 && set.code == 42
          text = sprintf("%d", num)
          if num >= 1
            text = "+" + text
          else
            text = "-" + text
          end
        end
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, buff)
        draw_text(140, dy, sw/2-24, 24, word)
        change_color(normal_color)
        draw_icon(icon, 170, dy, icon != 0)
        draw_text(200, dy, sw/5, 24, text, 2)
        dy += 24 if R2_SHOP_STATS::USE_SPACES
      end
    end
##########################################################################
    if R2_SHOP_STATS::ITEM_SKILL
      skills_add = []
      text = R2_SHOP_STATS::ITEM_SKILL_ADD
      @item.effects.each do |set|
        case set.code
        when 43 #---Grow Stat---
          skills_add.push(set.data_id)
        else
          next
        end
      end
      if skills_add != [] # Draw States
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        dx = sw - (skills_add.size * 24)
        for i in skills_add
          icon = $data_skills[i].icon_index
          draw_icon(icon, dx, dy)
          dx += 24
        end
      end
    end
  end # end draw_item_stats

##########################################################################
  #--------------------------------------------------------------------------
  # draw_equip_stats
  #--------------------------------------------------------------------------
##########################################################################
  def draw_equip_stats(dy, sw)
    contents.font.size = R2_SHOP_STATS::FONTSIZE
    change_color(normal_color)
    dy += 24
    draw_text(0, dy, sw-24, 24, R2_SHOP_STATS::STATS_TEXT, 1)
    dy += 24
    count = 0
    i = 0
    @item.params.each do |param|
      if param != 0
        text = sprintf("%d", param)
        case i
        when 0 #---HP---
          count += 1
          word = Vocab::param(i)
          icon = R2_SHOP_STATS::ICON_HP
        when 1 #---MP---
          count += 1
          word = Vocab::param(i)
          icon = R2_SHOP_STATS::ICON_MP
        when 2 #---ATK---
          count += 1
          word = Vocab::param(i)
          icon = R2_SHOP_STATS::ICON_ATK
        when 3 #---DEF---
          count += 1
          word = Vocab::param(i)
          icon = R2_SHOP_STATS::ICON_DEF
        when 4 #---MAT---
          count += 1
          word = Vocab::param(i)
          icon = R2_SHOP_STATS::ICON_MAT
        when 5 #---MDF---
          count += 1
          word = Vocab::param(i)
          icon = R2_SHOP_STATS::ICON_MDF
        when 6 #---AGI---
          count += 1
          word = Vocab::param(i)
          icon = R2_SHOP_STATS::ICON_AGI
        when 7 #---LUK---
          count += 1
          word = Vocab::param(i)
          icon = R2_SHOP_STATS::ICON_LUK
        else
          next
        end
        if count.odd?
          change_color(system_color)
          draw_text(29, dy, sw/2-24, 24, word)
          change_color(normal_color)
          draw_icon(icon, 0, dy, icon != 0)
          draw_text(sw*1/4, dy, sw/5, 24, text, 2)
        else
          change_color(system_color)
          draw_text(sw/2+29, dy, sw/2-24, 24, word)
          change_color(normal_color)
          draw_icon(icon, sw/2, dy, icon != 0)
          draw_text(sw*3/4, dy, sw/5, 24, text, 2)
        end
        if count % 2 == 0
          dy += 24
        end
      end
      i += 1
    end
    dy += 24 if count.odd?
    dy += 24 if R2_SHOP_STATS::USE_SPACES && count > 0
##########################################################################
    if R2_SHOP_STATS::SHOW_EX_PARAM
      #------Ex Parameters------
      count = 0
      @item.features.each do |set|
        next unless set.code == 22
        change_color(normal_color)
        draw_text(0, dy, sw-24, 24, R2_SHOP_STATS::EXSTATS_TEXT, 1) if R2_SHOP_STATS::SHOW_EXTEXT
        dy += 24 if R2_SHOP_STATS::SHOW_EXTEXT
        num = (set.value * 100).to_i
        text = sprintf("%d", num)
        case set.data_id
        when 0 #---HIT---
          count += 1
          word = R2_SHOP_STATS::TEXT_HIT
          icon = R2_SHOP_STATS::ICON_HIT
        when 1 #---EVA---
          count += 1
          word = R2_SHOP_STATS::TEXT_EVA
          icon = R2_SHOP_STATS::ICON_EVA
        when 2 #---CRI---
          count += 1
          word = R2_SHOP_STATS::TEXT_CRI
          icon = R2_SHOP_STATS::ICON_CRI
        when 3 #---CEV---
          count += 1
          word = R2_SHOP_STATS::TEXT_CEV
          icon = R2_SHOP_STATS::ICON_CEV
        when 4 #---MEV---
          count += 1
          word = R2_SHOP_STATS::TEXT_MEV
          icon = R2_SHOP_STATS::ICON_MEV
        when 5 #---MRF---
          count += 1
          word = R2_SHOP_STATS::TEXT_MRF
          icon = R2_SHOP_STATS::ICON_MRF
        when 6 #---CNT---
          count += 1
          word = R2_SHOP_STATS::TEXT_CNT
          icon = R2_SHOP_STATS::ICON_CNT
        when 7 #---HRG---
          count += 1
          word = R2_SHOP_STATS::TEXT_HRG
          icon = R2_SHOP_STATS::ICON_HRG
        when 8 #---MRG---
          count += 1
          word = R2_SHOP_STATS::TEXT_MRG
          icon = R2_SHOP_STATS::ICON_MRG
        when 9 #---TRG---
          count += 1
          word = R2_SHOP_STATS::TEXT_TRG
          icon = R2_SHOP_STATS::ICON_TRG
        else
          next
        end
        if count.odd?
          change_color(system_color)
          draw_text(29, dy, sw/2-24, 24, word)
          change_color(normal_color)
          draw_icon(icon, 0, dy, icon != 0)
          draw_text(sw*1/4, dy, sw/5, 24, text + "%", 2)
        else
          change_color(system_color)
          draw_text(sw/2+29, dy, sw/2-24, 24, word)
          change_color(normal_color)
          draw_icon(icon, sw/2, dy, icon != 0)
          draw_text(sw*3/4, dy, sw/5, 24, text + "%", 2)
        end
        if count % 2 == 0
          dy += 24
        end
      end
      dy += 24 if count.odd?
      dy += 24 if R2_SHOP_STATS::USE_SPACES && count > 2
    end
##########################################################################
    if R2_SHOP_STATS::SHOW_SP_PARAM
      #------SP Parameters------
      count = 0
      @item.features.each do |set|
        next unless set.code == 23
        num = (set.value * 100).to_i
        text = sprintf("%d", num)
        change_color(normal_color)
        draw_text(0, dy, sw-24, 24, R2_SHOP_STATS::SPSTATS_TEXT, 1) if R2_SHOP_STATS::SHOW_SPTEXT
        dy += 24 if R2_SHOP_STATS::SHOW_SPTEXT
        case set.data_id
        when 0 #---TGR---
          count += 1
          word = R2_SHOP_STATS::TEXT_TGR
          icon = R2_SHOP_STATS::ICON_TGR
        when 1 #---GRD---
          count += 1
          word = R2_SHOP_STATS::TEXT_GRD
          icon = R2_SHOP_STATS::ICON_GRD
        when 2 #---REC---
          count += 1
          word = R2_SHOP_STATS::TEXT_REC
          icon = R2_SHOP_STATS::ICON_REC
        when 3 #---PHA---
          count += 1
          word = R2_SHOP_STATS::TEXT_PHA
          icon = R2_SHOP_STATS::ICON_PHA
        when 4 #---MCR---
          count += 1
          word = R2_SHOP_STATS::TEXT_MCR
          icon = R2_SHOP_STATS::ICON_MCR
        when 5 #---TCR---
          count += 1
          word = R2_SHOP_STATS::TEXT_TCR
          icon = R2_SHOP_STATS::ICON_TCR
        when 6 #---PDR---
          count += 1
          word = R2_SHOP_STATS::TEXT_PDR
          icon = R2_SHOP_STATS::ICON_PDR
        when 7 #---MDR---
          count += 1
          word = R2_SHOP_STATS::TEXT_MDR
          icon = R2_SHOP_STATS::ICON_MDR
        when 8 #---FDR---
          count += 1
          word = R2_SHOP_STATS::TEXT_FDR
          icon = R2_SHOP_STATS::ICON_FDR
        when 9 #---EXR---
          count += 1
          word = R2_SHOP_STATS::TEXT_EXR
          icon = R2_SHOP_STATS::ICON_EXR
        else
          next
        end
        if count.odd?
          change_color(system_color)
          draw_text(29, dy, sw/2-24, 24, word)
          change_color(normal_color)
          draw_icon(icon, 0, dy, icon != 0)
          draw_text(sw*1/4, dy, sw/5, 24, text + "%", 2)
        else
          change_color(system_color)
          contents.draw_text(sw/2+29, dy, sw/2-24, 24, word)
          change_color(normal_color)
          draw_icon(icon, sw/2, dy, icon != 0)
          draw_text(sw*3/4, dy, sw/5, 24, text + "%", 2)
        end
        if count % 2 == 0
          dy += 24
        end
      end
      dy += 24 if R2_SHOP_STATS::USE_SPACES && count > 0
    end
##########################################################################
    if R2_SHOP_STATS::DRAW_ELEMENTS
      #------ELEMENTS------
      drawn_elements = []
      elem = false
      @item.features.each do |set|
        next if set.data_id == 0
        case set.code
        when 31 # weapon
          drawn_elements.push(set.data_id)
          elem = true
        when 11 # armour
          drawn_elements.push(set.data_id)
          elem = true
        else
          next
        end
      end
      if drawn_elements != [] # Draw Elements
        drawn_elements = drawn_elements.sort!
        dy += 24
        if @item.is_a?(RPG::Weapon)
          text = R2_SHOP_STATS::EQ_ELEMENT_W
        else
          text = R2_SHOP_STATS::EQ_ELEMENT_A
        end
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        dx = sw - (drawn_elements.size * 24)
        for ele_id in drawn_elements
          draw_icon(R2_SHOP_STATS::SHOWN_ELEMENTS[ele_id], dx, dy)
          dx += 24
        end
      end
      dy += 24 if R2_SHOP_STATS::USE_SPACES && elem == true
    end
##########################################################################
    if R2_SHOP_STATS::DRAW_STATES
      #------STATES------
      drawn_states = []
      resist_states = []
      @item.features.each do |set|
        next if set.data_id == 0
        case set.code
        when 32 # weapons
          drawn_states.push(set.data_id)
        when 13 # armour
          drawn_states.push(set.data_id)
        when 14 # armour resist states
          resist_states.push(set.data_id)
        else
          next
        end
      end
      if drawn_states != [] # Draw States
        dy += 24
        if @item.is_a?(RPG::Weapon)
          text = R2_SHOP_STATS::EQ_STATUS_W
        else
          text = R2_SHOP_STATS::EQ_STATUS_A
        end
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        dx = sw - (drawn_states.size * 24)
        for icon in drawn_states
          draw_icon(icon, dx, dy)
          dx += 24
        end
      end
      if resist_states != [] # Draw Resist States (Armour)
        dy += 24
        text = R2_SHOP_STATS::STATE_RESIST
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        dx = sw - (resist_states.size * 24)
        for icon in resist_states
          draw_icon(icon, dx, dy)
          dx += 24
        end
      end
      dy += 24 if R2_SHOP_STATS::USE_SPACES && ((drawn_states != []) || (resist_states != []))
    end
##########################################################################
    if R2_SHOP_STATS::EQUIP_SKILL
      skills_add = []
      text = R2_SHOP_STATS::EQUIP_SKILL_ADD
      @item.features.each do |set|
        case set.code
        when 43 #---Grow Stat---
          skills_add.push(set.data_id)
        else
          next
        end
      end
      if skills_add != [] # Draw States
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        dx = sw - (skills_add.size * 24)
        for i in skills_add
          icon = $data_skills[i].icon_index
          draw_icon(icon, dx, dy)
          dx += 24
        end
      end
      dy += 24 if R2_SHOP_STATS::USE_SPACES
    end
##########################################################################
    if R2_SHOP_STATS::EQUIP_SKILL_SEAL
      skills_seal = []
      text = R2_SHOP_STATS::TEXT_SEAL_STATES
      @item.features.each do |set|
        case set.code
        when 44 #---Grow Stat---
          skills_seal.push(set.data_id)
        else
          next
        end
      end
      if skills_seal != [] # Draw States
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        dx = sw - (skills_seal.size * 24)
        for i in skills_seal
          icon = $data_skills[i].icon_index
          draw_icon(icon, dx, dy)
          dx += 24
        end
      end
    end
##########################################################################
    if R2_SHOP_STATS::EQUIP_DEBUFF
      @item.features.each do |set|
        case set.code
        when 12 #---DEBUFF RATE---
          debuff = R2_SHOP_STATS::EQUIP_DEBUFF_TEXT
        else
          next
        end
        case set.data_id
        when 0 #---HP---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_HP
        when 1 #---MP---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_MP
        when 2 #---ATK---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_ATK
        when 3 #---DEF---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_DEF
        when 4 #---MAT---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_MAT
        when 5 #---MDF---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_MDF
        when 6 #---AGI---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_AGI
        when 7 #---LUK---
          word = Vocab::param(set.data_id)
          icon = R2_SHOP_STATS::ICON_LUK
        end
        num = 0
        if set.value != 0
          num = set.value.to_f
          num = (num * 100).to_i
          text = sprintf("%d", num)
          text = "+" + text + "%"
        end
        dy += 24 if R2_SHOP_STATS::USE_SPACES
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, debuff)
        draw_text(110, dy, sw/2-24, 24, word)
        change_color(normal_color)
        draw_icon(icon, 140, dy, icon != 0)
        draw_text(150, dy, sw/3, 24, text, 2)
      end
    end
##########################################################################
    if R2_SHOP_STATS::EQUIP_ATTACK_STATE
      attack_state = []
      attack_numb = []
      text = R2_SHOP_STATS::EQUIP_ATTACK_STATE_TEXT
      @item.features.each do |set|
        case set.code
        when 32 #---DEBUFF RATE---
          attack_state.push(set.data_id)
          value = (set.value * 100).round
          strng = value.to_s + "%"
          attack_numb.push(strng)
        else
          next
        end
      end
      if attack_state != [] # Draw States
        dy += 24 if R2_SHOP_STATS::USE_SPACES
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        dx = sw - (attack_state.size * 48)
        change_color(normal_color)
        n = 0
        for i in attack_state
          icon = $data_states[i].icon_index
          numb = attack_numb[n]
          draw_icon(icon, dx, dy)
          draw_text(dx+24, dy, 24, 24, numb)
          dx += 48
          n += 1
        end
      end
    end
##########################################################################
    if R2_SHOP_STATS::EQUIP_ATTACK_SPEED
      speed_value = 0
      text = R2_SHOP_STATS::EQUIP_ATTACK_SPEED_TEXT
      @item.features.each do |set|
        case set.code
        when 33 #---Attack speed---
          speed_value = set.value.to_i
        else
          next
        end
      end
      if speed_value != 0
        dy += 24 if R2_SHOP_STATS::USE_SPACES
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        change_color(normal_color)
        dx = text.size * 10
        draw_text(dx + 20, dy, sw/3, 24, speed_value)
      end
    end
##########################################################################
    if R2_SHOP_STATS::EQUIP_ATTACK_TIMES
      text = R2_SHOP_STATS::EQUIP_ATTACK_TIMES_TEXT
      times_value = 0
      @item.features.each do |set|
        case set.code
        when 34 #---Attack Times---
          num = set.value.to_i
          times_value = "+" + num.to_s
        else
          next
        end
      end
      if times_value != 0
        dy += 24 if R2_SHOP_STATS::USE_SPACES
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        change_color(normal_color)
        dx = text.size * 10
        draw_text(dx + 20, dy, sw/3, 24, times_value)
      end
    end
##########################################################################
    if R2_SHOP_STATS::EQUIP_ACTION_TIMES
      text = R2_SHOP_STATS::EQUIP_ACTION_TIMES_TEXT
      action_value = 0
      @item.features.each do |set|
        case set.code
        when 61 #---Action times---
          num = (set.value * 100).to_i
          action_value = num.to_s + "%"
        else
          next
        end
      end
      if action_value != 0
        dy += 24 if R2_SHOP_STATS::USE_SPACES
        dy += 24
        change_color(system_color)
        draw_text(0, dy, sw/2, 24, text)
        change_color(normal_color)
        dx = text.size * 10
        draw_text(dx + 20, dy, sw/3, 24, action_value)
      end
    end
##########################################################################
    if R2_SHOP_STATS::EQUIP_PARTY_ABILITY
      @item.features.each do |set|
        if set.code == 64 # Party Ability
          case set.data_id
          when 0 #---TGR---
            ability = "Encounter Half"
          when 1 #---GRD---
            ability = "Encounter None"
          when 2 #---REC---
            ability = "Cancel Surprise"
          when 3 #---PHA---
            ability = "Raise Preemptive"
          when 4 #---MCR---
            ability = "Double Gold"
          when 5 #---TCR---
            ability = "Double Item Drop"
          else
            next
          end
          dy += 24 if R2_SHOP_STATS::USE_SPACES
          dy += 24
          change_color(system_color)
          draw_text(0, dy, sw/2, 24, ability)
          change_color(normal_color)
        end
      end
    end

  end

end # Window_ShopNumber
