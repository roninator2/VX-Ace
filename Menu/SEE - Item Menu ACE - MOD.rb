#===============================================================================
# * SEE - Item Menu ACE
# * By Crazyninjaguy
# * Requested by BizarreMonkey
# * Modified by Roniunator2
# * http://www.stormxstudios.co.uk
# * 11/11/2021 - V1.03
# * If you like my scripts, please show your appreciation by checking out
#   my friendly, helpful Game Development Community, StormCross Studios.
#  ---------------------------------------------------------------------------
# * Aliased Methods
#    - start (Scene_Item)
#    - update_item_selection (Scene_Item)
#    - terminate (Scene_Item)
#  ---------------------------------------------------------------------------
# * This script adds a new item description window with support for four text
#   text lines and a 96 x 96 picture in Graphics/Pictures.
# * To add a picture for your item, add this into the notebox of that item in
#   the database
# * <picture potionpicture>
# * Replacing potionpicture for your image filename.
#===============================================================================

#===============================================================================
# !!!!!!!If using Yanfly Item Menu, it must be placed above this script.!!!!!!!
#===============================================================================

$imported = {} if $imported == nil
$imported["SEE - Item Menu Ace"] = true

#===============================================================================
# * Main StormCross Engine Evolution Configuration Module
#===============================================================================
module SEE
 #=============================================================================
 # * Item Menu Configuration Module
 #=============================================================================
  module Item
  ITEMS = []
#===========================================================================
# * The number at the beginning of the ITEMS[1] is the item id in the
#   database.
# * Each line of text in quotes is a seperate line in the window.
#   Seperate each with a comma
#===========================================================================
  ITEMS[1] = ["This is a potion.", "It's very nice and restores 500hp.", "Costs 50 Gil in a shop.", "Has a purplish glow."]
  ITEMS[2] = ["This is a high potion.", "It's very nice and restores 2500hp.", "Costs 150 Gil in a shop.", "Has a purplish glow."]

  WEAPONS = []
  WEAPONS[1] = ["Derp", "", "", ""]

  ARMORS = []
  ARMORS[1] = ["", "", "", ""]

  ITEM_COLOURS = []
#===========================================================================
# * As with the previous, the number at the beginning of COLOURS[1] is the
#   item id in the database.
# * The numbers in the array correspond to the text_color() argument of
#   window base. 0 is white. You can find these by looking at the
#   Window.png graphic. Seperate each value with a comma.
#===========================================================================
  ITEM_COLOURS[1] = [0, 1, 2, 3]

  WEAPON_COLOURS = []
  WEAPON_COLOURS[1] = [0, 1, 2, 3]

  ARMOR_COLOURS = []
  ARMOR_COLOURS[1] = [0, 1, 2, 3]
 
  # Show Commands
  Use       = true
  Discard   = true
  Details   = true
  Cancel    = true
 
  end # Item
end # SEE

module ReadNote
  def read_note(note, tag, position = 1)
    note2 = note.dup
    lines = note2.scan(/<.+>/)
    for line in lines
      words = line.split(/[ <>]/)
      words.delete("")
      for word in words
        if word == tag
          result = words[words.index(word) + position]
          return true if result == nil
          return result
        end
      end
    end
    return false
  end
end

#==============================================================================
# ** Window_SubItemCategory
#------------------------------------------------------------------------------
#  This window is for selecting a category of normal items and equipment
# on the item screen or shop screen.
#==============================================================================

class Window_SubItemCategory < Window_Command
  attr_reader :item_window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @category = :none
    self.back_opacity = 255
    clear_command_list
    make_command_list
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 120
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number)
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command("Use", :use, @category == :item) if SEE::Item::Use == true
    add_command("Discard", :discard) if SEE::Item::Discard == true
    add_command("Details", :details) if SEE::Item::Details == true
    add_command("Cancel", :cancel) if SEE::Item::Cancel == true
  end
  def category=(category)
    return if @category == category
    @category = category
    refresh
  end
  def category(category)
    @category = category
    refresh
  end
  def update
    super
    @category = @item_window.current_symbol if @subitem_window
  end
end


class Scene_Item < Scene_ItemBase
  attr_accessor :item_window
  alias r2_start_item_for_yanfly    start
  def start
    r2_start_item_for_yanfly
    create_description_window
    create_sub_item_window
    create_number_window
    @description_index = 0
  end
  def create_description_window
    @description = Window_ItemDescription.new
    @description.hide
    @description.viewport = @viewport
    @description.set_handler(:cancel, method(:details_cancel))
  end
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @item_window = Window_ItemList.new(0, wy, Graphics.width, wh)
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_sub_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @category_window.item_window = @item_window
    @item_window.viewport = @viewport
  end
  def create_sub_item_window
    wy = @category_window.y + @category_window.height
    @subitem_window = Window_SubItemCategory.new(200, wy + 50)
    @subitem_window.set_handler(:use,     method(:on_item_ok))
    @subitem_window.set_handler(:discard,     method(:on_item_discard))
    @subitem_window.set_handler(:details,     method(:on_item_details))
    @subitem_window.set_handler(:cancel, method(:on_sub_item_cancel))
    @category_window.item_window = @item_window
    @subitem_window.viewport = @viewport
    @subitem_window.hide
  end
  def create_number_window
    wy = @category_window.y + @category_window.height
    wh = 48
    @number_window = Window_DiscardNumber.new(100, wy + 50, wh)
    @number_window.viewport = @viewport
    @number_window.hide
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
  end
  def activate_item_window
    @item_window.refresh
    @subitem_window.refresh
    @subitem_window.activate
  end
  def on_item_discard
    @subitem_window.deactivate
    @subitem_window.hide
    @number_window.set(item, $game_party.item_number(item))
    @number_window.activate
    @number_window.show
  end
  if $imported["YEA-ItemMenu"] == true
    def open_types
      @category_window.x = Graphics.width
      @types_window.x = 0
      @types_window.reveal(@category_window.current_symbol)
      @subitem_window.category(@category_window.current_symbol)
    end
  end
  alias r2_item_nil_count on_item_ok
  def on_item_ok
    if item == nil
      Sound.play_buzzer
      on_sub_item_cancel
      return
    end
    r2_item_nil_count
  end
  def on_sub_item_ok
    if @item_window.item == nil
      Sound.play_buzzer
      on_sub_item_cancel
    else
      @category_window.item_window = @subitem_window
      @subitem_window.activate
      @subitem_window.select(0)
      @subitem_window.show
      @item_window.deactivate
    end
  end
  def on_item_details
    @description.show
    @description.activate
    @description.z = 1000
    @subitem_window.deactivate
    @subitem_window.hide
    @item_window.deactivate
    update
  end
  def on_sub_item_cancel
    @subitem_window.deactivate
    @subitem_window.hide
    @item_window.activate
    @category_window.item_window = @item_window
  end
  def details_cancel
    @description.deactivate
    @description.hide
    @subitem_window.activate
    @subitem_window.show
    @subitem_window.select(0)
  end
  def on_number_ok
    discard(@number_window.number)
    play_se_for_item
    @number_window.hide
    @item_window.refresh
    on_sub_item_cancel
  end
  def discard(number)
    $game_party.lose_item(item, number)
  end
  def on_number_cancel
    Sound.play_cancel
    @number_window.hide
    on_sub_item_cancel
  end
  def update
    super
    if @description_index != @item_window.index
      @description.details(@item_window.item)
      @description_index = @item_window.index
    end
  end
end

class Window_ItemList < Window_Selectable
  def enable?(item)
    return true
  end
end

class Window_ItemDescription < Window_Selectable
  include ReadNote
  include SEE::Item
  def initialize(item = nil)
    super(0, 0, window_width, window_height)
    self.back_opacity = 255
    details(item)
  end # initialize
  def window_width
    Graphics.width
  end
  def window_height
    Graphics.height
  end
  def details(item)
    self.contents.clear
    if item != nil
      if item.is_a?(RPG::Item)
        picture = read_note($data_items[item.id].note, "picture")
      elsif item.is_a?(RPG::Weapon)
        picture = read_note($data_weapons[item.id].note, "picture")
      elsif item.is_a?(RPG::Armor)
        picture = read_note($data_armors[item.id].note, "picture")
      end
      if picture != false
        bitmap = Cache.picture(picture)
        rect = Rect.new(0, 0, 96, 96)
        self.contents.blt(0, 0, bitmap, rect)
      end
      if item.is_a?(RPG::Item)
        if ITEMS[item.id] != nil
          if ITEM_COLOURS[item.id] != nil
            self.contents.font.color = text_color(ITEM_COLOURS[item.id][0])
            self.contents.draw_text(96, 0, width - 128, 24, ITEMS[item.id][0])
            self.contents.font.color = text_color(ITEM_COLOURS[item.id][1])
            self.contents.draw_text(96, 24, width - 128, 24, ITEMS[item.id][1])
            self.contents.font.color = text_color(ITEM_COLOURS[item.id][2])
            self.contents.draw_text(96, 48, width - 128, 24, ITEMS[item.id][2])
            self.contents.font.color = text_color(ITEM_COLOURS[item.id][3])
            self.contents.draw_text(96, 72, width - 128, 24, ITEMS[item.id][3])
            self.contents.font.color = text_color(0)
          else
            self.contents.draw_text(96, 0, width - 128, 24, ITEMS[item.id][0])
            self.contents.draw_text(96, 24, width - 128, 24, ITEMS[item.id][1])
            self.contents.draw_text(96, 48, width - 128, 24, ITEMS[item.id][2])
            self.contents.draw_text(96, 72, width - 128, 24, ITEMS[item.id][3])
          end
        end
      elsif item.is_a?(RPG::Weapon)
        if WEAPONS[item.id] != nil
          if WEAPON_COLOURS[item.id] != nil
            self.contents.font.color = text_color(WEAPON_COLOURS[item.id][0])
            self.contents.draw_text(96, 0, width - 128, 24, WEAPONS[item.id][0])
            self.contents.font.color = text_color(WEAPON_COLOURS[item.id][1])
            self.contents.draw_text(96, 24, width - 128, 24, WEAPONS[item.id][1])
            self.contents.font.color = text_color(WEAPON_COLOURS[item.id][2])
            self.contents.draw_text(96, 48, width - 128, 24, WEAPONS[item.id][2])
            self.contents.font.color = text_color(WEAPON_COLOURS[item.id][3])
            self.contents.draw_text(96, 72, width - 128, 24, WEAPONS[item.id][3])
            self.contents.font.color = text_color(0)
          else
            self.contents.draw_text(96, 0, width - 128, 24, WEAPONS[item.id][0])
            self.contents.draw_text(96, 24, width - 128, 24, WEAPONS[item.id][1])
            self.contents.draw_text(96, 48, width - 128, 24, WEAPONS[item.id][2])
            self.contents.draw_text(96, 72, width - 128, 24, WEAPONS[item.id][3])
          end
        end
      elsif item.is_a?(RPG::Armor)
        if ARMORS[item.id] != nil
          if ARMOR_COLOURS[item.id] != nil
            self.contents.font.color = text_color(ARMOR_COLOURS[item.id][0])
            self.contents.draw_text(96, 0, width - 128, 24, ARMORS[item.id][0])
            self.contents.font.color = text_color(ARMOR_COLOURS[item.id][1])
            self.contents.draw_text(96, 24, width - 128, 24, ARMORS[item.id][1])
            self.contents.font.color = text_color(ARMOR_COLOURS[item.id][2])
            self.contents.draw_text(96, 48, width - 128, 24, ARMORS[item.id][2])
            self.contents.font.color = text_color(ARMOR_COLOURS[item.id][3])
            self.contents.draw_text(96, 72, width - 128, 24, ARMORS[item.id][3])
            self.contents.font.color = text_color(0)
          else
            self.contents.draw_text(96, 0, width - 128, 24, ARMORS[item.id][0])
            self.contents.draw_text(96, 24, width - 128, 24, ARMORS[item.id][1])
            self.contents.draw_text(96, 48, width - 128, 24, ARMORS[item.id][2])
            self.contents.draw_text(96, 72, width - 128, 24, ARMORS[item.id][3])
          end
        end
      end
    end
  end # refresh
end # Window_ItemDescription

#==============================================================================
# ** Window_DiscardNumber
#------------------------------------------------------------------------------
#  This window is for inputting quantity of items to buy or sell on the shop
# screen.
#==============================================================================

class Window_DiscardNumber < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :number                   # quantity entered
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, height)
    super(x, y, window_width, height)
    @item = nil
    @max = 1
    @number = 1
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 304
  end
  #--------------------------------------------------------------------------
  # * Set Item, Max Quantity, Price, and Currency Unit
  #--------------------------------------------------------------------------
  def set(item, max)
    @item = item
    @max = max
    @number = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_item_name(@item, 0, 0)
    draw_number
  end
  #--------------------------------------------------------------------------
  # * Draw Quantity
  #--------------------------------------------------------------------------
  def draw_number
    change_color(normal_color)
    draw_text(cursor_x - 28, 0, 22, line_height, "×")
    draw_text(cursor_x, 0, cursor_width - 4, line_height, @number, 2)
  end
  #--------------------------------------------------------------------------
  # * Get Cursor Width
  #--------------------------------------------------------------------------
  def cursor_width
    figures * 10 + 12
  end
  #--------------------------------------------------------------------------
  # * Get X Coordinate of Cursor
  #--------------------------------------------------------------------------
  def cursor_x
    contents_width - cursor_width - 4
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Number of Digits for Quantity Display
  #--------------------------------------------------------------------------
  def figures
    return 2
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if active
      last_number = @number
      update_number
      if @number != last_number
        Sound.play_cursor
        refresh
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Quantity
  #--------------------------------------------------------------------------
  def update_number
    change_number(1)   if Input.repeat?(:RIGHT)
    change_number(-1)  if Input.repeat?(:LEFT)
    change_number(10)  if Input.repeat?(:UP)
    change_number(-10) if Input.repeat?(:DOWN)
  end
  #--------------------------------------------------------------------------
  # * Change Quantity
  #--------------------------------------------------------------------------
  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.set(cursor_x, 0, cursor_width, line_height)
  end
end
