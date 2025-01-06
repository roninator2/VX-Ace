#===============================================================
#==================== CATEGORIZE ITEM SCENE v1.0 ===============
#===============================================================
#= Ported from RMVX to RMVXAce
#= Author: Seiryuki
#= Date: 2019-Aug-15
#= Type: VXA/RGSS3
#= Additions: a few more customisation options
#= Mod by Roninator2
#---------------------------------------------------------------
#= RMVX Title: KGC's Categorize Item Script
#= Author: KGC
#= Date: 2008-Apr-10
#= Translated by: Mr. Anonymous
#= The original untranslated version of the VX script can be found here:
#= http://f44.aaa.livedoor.jp/~ytomy/tkool/rpgtech/php/tech.php?tool=VX&cat=tech_vx/item&tech=categorize_item
#===============================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DESCRIPTION:
# While RMVXAce already categorises the items in the items scene
# into Items, Weapons, Armor, and Key Items this script allows
# you to create your own categories and assign items, weapons,
# and armor to any of them using notebox tags.
#
# This script also allows you to customise the size and location
# of the help, category, and item windows.
# See the Custom Layout Section for more information.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPATIBILITY:
# May not be compatible with scripts that redo the item scene.
# May be compatible with scripts that modify the item categories
# for shops.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# INSTRUCTIONS:
# Place this script above Main and below Materials.
#
# To assign an item to a category, place <category IDENTIFIER> tag
# in the item's (or weapon, or armor) notebox where IDENTIFIER
# is the label listed in the CATEGORY_IDENTIFIER array in the
# Customisation Section below.
# You can add to or remove from the CATEGORY_IDENTIFIER list.
#
# NOTE: The following symbols are reserved and MUST NOT be used in
#	the CATEGORY_IDENTIFIER list:
#	   :item, :weapon, :armor, :key_item, :all_item
#
# You can assign an item to multiple categories by simply placing
# more <category IDENTIFIER> tags in the item's notebox.
# NOTE: When doing that, make sure that ALLOW_DUPLICATE is set to
# true (see Customisation Section) or else only the last tag in
# the notebox will be used as the category for the item.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#===============================================================



$data_system = load_data("Data/System.rvdata2") if $data_system == nil

module ICAT
#=============================================================================#
# CUSTOMISATION SECTION - Do not make changes unless you understand completely
# what you are doing. Read and follow the below instructions very carefully.
#=============================================================================#
#-----------------------------------------------------------------------------#
#>> HIDECATEGORIES - When true it will hide categories 
#   when no items are present for that category.
 HIDECATEGORIES = true

#>> CATEGORY_IDENTIFIER - Create your categories here.
#   You can add or remove categories from this list.
#   On the left is the symbol used to identify the category.
#   On the right is the category label that will be used when setting
#   the e.g. <category Potions> tag in the notebox, where Potions is
#   the label.
#
#   IMPORTANT - You cannot use the following as symbols as they are
#   reserved:
#	   :item, :weapon, :armor, :key_item, :all_item
 CATEGORY_IDENTIFIER = {
:potion => "Potions", #example tag: <category Potions>
:ammunition => "Ammunition", #example tag: <category Ammunition>
}

#>> VISIBLE_CATEGORY_INDEX - Set the categories that would be visible
#	 in the item category window.
#   On the left is identifying symbol from the CATEGORY_IDENTIFIER list
#   above. It must be a symbol present in that list above, OR, one of the
#   reserved symbols stated above. Make sure spelling is correct!
#   On the right is the text to display, and can be any text desired.
#   (see below customisation section for RESERVED_CATEGORY_INDEX list).
#
#   Only what is present in the VISIBLE_CATEGORY_INDEX will be shown in the
#   item category window (so you can remove any from the list).
#   This list can be arranged in any order desired.
 VISIBLE_CATEGORY_INDEX = {
  :item => "Common", #reserved symbol, but can be removed.
  :weapon => "Weapons", #reserved symbol, but can be removed.
  :armor => "Armor", #reserved symbol, but can be removed.
  :key_item => "Special", #reserved symbol, but can be removed.
  :all_item => "*ALL*", #reserved symbol, but can be removed.
  :potion => "Potions",
  :ammunition => "Ammo",
 }

# NEW
#>> CategoryConditions - Specifies if a category is to be shown
#   On the left is identifying symbol from the CATEGORY_IDENTIFIER list
#   above and VISIBLE_CATEGORY_INDEX list. 
#   It must be a symbol present in that list above, OR, one of the
#   reserved symbols stated above. Make sure spelling is correct!
#   On the right the conditions used to determine if the category is displayed.
#   The CATEGORY_IDENTIFIER list must have the identifying symbol
#   on the left and on the right and they must be the same.
 CategoryConditions = {
  :item => lambda { !$game_party.items.empty? && $game_party.items.any? {|item| !item.key_item? }},
  :weapon => lambda { !$game_party.weapons.empty? },
  :armor => lambda { !$game_party.armors.empty? },
  :key_item => lambda { !$game_party.items.empty? && $game_party.items.any? {|item| item.key_item? }},
  :all_item => lambda { !$game_party.all_items.empty? },
  
  # CATEGORY_IDENTIFIER
  :potion => lambda { $game_party.all_items.any? {|item| item.find_category == :potion} },
  :ammunition => lambda { $game_party.all_items.any? {|item| item.find_category == :ammunition} },
 }
 
# UPDATED
#>> CATEGORY_DESCRIPTION - Simple. The list below creates descriptions
#	 that will be shown in the help window. 
 CATEGORY_DESCRIPTION = {
  :item => "Viewing basic items.",
  :weapon => "Viewing attack-type items for use in battles.",
  :armor => "Viewing head, body, arm and leg equipment.",
  :key_item => "Viewing important items.",
  :all_item => "Viewing all items.",
  :potion => "Viewing potions.",
  :ammunition => "Viewing ammunition.",
 }

#>> I'm not sure how important setting this is.
 ITEM_DEFAULT_CATEGORY = :item #default= :item
 ITEM_DEFAULT_CATEGORY_INDEX = CATEGORY_IDENTIFIER.index(ITEM_DEFAULT_CATEGORY)

#>> AUTOFIT_CATEGORY_COLUMNS - Set to true if you want all the
#	 categories to autofit in the width of the item category window.
#	 Set to false if you only want CATEGORY_WINDOW_MAX_COLUMNS number
#	 of categories visible in the window width. If there are more
#	 categories than CATEGORY_WINDOW_MAX_COLUMNS, the rest will still be
#	 accessible to the right of the last category.
 AUTOFIT_CATEGORY_COLUMNS = true #default=true
 CATEGORY_WINDOW_MAX_COLUMNS = 5 #If autofit=false, this number is used.

#>> ALLOW_DUPLICATE - This is for when items have multiple tags
#	 in the notebox.
#   Set to true if you want to allow an item in other categories.
#   Setting to false will only choose the last category tag from the
#   item's notebox as the item's category.
 ALLOW_DUPLICATE = true #default=true

#>> CATEGORY_WINDOW_COL_WIDTH - Specify the width of the column to
#	 be used for each category. The category's text is auto-squished
#	 to fit.
 CATEGORY_WINDOW_COL_WIDTH = 50 #default=50

#>> CATEGORY_WINDOW_COL_SPACE - The amount of space-padding to be
#	 used on either end of the column.
 CATEGORY_WINDOW_COL_SPACE = 2 #default=2

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#>> DEFAULT_SCENE_ITEM_LAYOUT - If you want the normal item scene
#	 layout where the help window is on top, categories in the
#	 middle, and item list below set this to TRUE.
#	 If you wish to move and resize the windows yourself, set to
#	 FALSE and modify the CUSTOM LAYOUT SECTION below.
 DEFAULT_SCENE_ITEM_LAYOUT = true #default=true

#>> CUSTOM LAYOUT SECTION:
#	 The default settings below recreate the layout as if
#	 DEFAULT_SCENE_ITEM_LAYOUT was set to true above.
#-----------
# DEFAULTS:
#-----------
#  HELP_WINDOW_POSITION	  = [0, 0]
#  HELP_WINDOW_WIDTH		 = Graphics.width #or enter your own number
#  HELP_WINDOW_NUM_OF_LINES  = 2
#  CATEGORY_WINDOW_POSITION  = [0, 72]
#  CATEGORY_WINDOW_WIDTH	 = Graphics.width #or enter your own number
#  ITEMLIST_WINDOW_POSITION  = [0, 120]
#  ITEMLIST_WINDOW_HEIGHT	= 296

 HELP_WINDOW_POSITION	  = [0, 0]
 HELP_WINDOW_WIDTH		 = Graphics.width #or enter your own number
 HELP_WINDOW_NUM_OF_LINES  = 2
 CATEGORY_WINDOW_POSITION  = [0, 72]
 CATEGORY_WINDOW_WIDTH	 = Graphics.width #or enter your own number
 ITEMLIST_WINDOW_POSITION  = [0, 120]
 ITEMLIST_WINDOW_HEIGHT	= 296
#>> END OF LAYOUT SECTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#-----------------------------------------------------------------------------#
#=============================================================================#
# END OF CUSTOMISATION SECTION
#=============================================================================#
#-----------------------------------------------------------------------------#
# DO NOT MODIFY ANYTHING BELOW HERE UNLESS YOU ARE SURE OF WHAT YOU'RE DOING! #
#-----------------------------------------------------------------------------#
#=============================================================================#
#=============================================================================#

 RESERVED_CATEGORY_INDEX = {
"All Items" => CATEGORY_IDENTIFIER.index(:all_item),
"Key Items" => CATEGORY_IDENTIFIER.index(:key_item),
"Weapons" => CATEGORY_IDENTIFIER.index(:weapon),
"Armor" => CATEGORY_IDENTIFIER.index(:armor),
"Items" => CATEGORY_IDENTIFIER.index(:item),
 }

 module Regexp
module BaseItem
  # Category tag string
  CATEGORY = /^<(?:CATEGORY|classification|category?)[ ]*(.*)>/i
end
 end

end # END OF module: ICAT

#=============================================================================#
# Creates the item category window from VISIBLE_CATEGORY_INDEX hash above.
#=============================================================================#
class ICAT_WindowItemCategory < Window_ItemCategory

 def initialize
  @category_list = []
  super
  self.z = 1000
  self.index = 0
 end

 #updated
 def update_help
  @help_window.set_text(ICAT::CATEGORY_DESCRIPTION[@category_list[self.index]])
 end

 # updated
if ICAT::HIDECATEGORIES

 alias icat_make_command_list make_command_list
 def make_command_list
    ICAT::VISIBLE_CATEGORY_INDEX.each do |symbol, label|
    add_command(label, symbol) if ICAT::CategoryConditions[symbol].call
    @category_list << symbol if ICAT::CategoryConditions[symbol].call
    end
 end
  
else
  
 alias icat_make_command_list make_command_list
 def make_command_list
  ICAT::VISIBLE_CATEGORY_INDEX.each { |symbol, label|
    add_command(label, symbol)
    @category_list << symbol
  }
 end

end

 def col_max
  if ICAT::AUTOFIT_CATEGORY_COLUMNS
    cols = @category_list.length / 2
  else
    cols = ICAT::CATEGORY_WINDOW_MAX_COLUMNS
  end
  return cols == 0 ? 1 : cols
 end

 def window_width
  if ICAT::CATEGORY_WINDOW_WIDTH == nil
    return Graphics.width
  else
    return ICAT::CATEGORY_WINDOW_WIDTH
  end
 end

 def spacing
  return ICAT::CATEGORY_WINDOW_COL_SPACE
 end

end #class



#=============================================================================#
# Creates category array from BASEITEM database.
#=============================================================================#
class RPG::BaseItem
 attr_reader :icat

 def create_categorize_item_cache
  if @icat == nil
    @icat = []
  else
    @icat.compact!
  end
  self.note.split(/[\r\n]+/).each { |line|
    if line =~ ICAT::Regexp::BaseItem::CATEGORY
    c = ICAT::CATEGORY_IDENTIFIER.key($1)
    @icat << c if c != nil
    end
  }
  if @icat.empty?
    @icat << ICAT::ITEM_DEFAULT_CATEGORY_INDEX
  elsif !ICAT::ALLOW_DUPLICATE
    @icat = [@icat.pop]
  end
 end

 def item_category
  create_categorize_item_cache if @icat == nil
  return @icat
 end

 # new
 def find_category
  self.note.split(/[\r\n]+/).each { |line|
    if line =~ ICAT::Regexp::BaseItem::CATEGORY
    c = ICAT::CATEGORY_IDENTIFIER.key($1)
    return c if c != nil 
    end
  }
 end

end #class



#=============================================================================#
# Creates category array from USABLEITEM database.
#=============================================================================#
class RPG::UsableItem < RPG::BaseItem

 def create_categorize_item_cache
  @icat = []
  if key_item?
    @icat << ICAT::RESERVED_CATEGORY_INDEX.key("Key Items")
  elsif !key_item?
    @icat << ICAT::RESERVED_CATEGORY_INDEX.key("Items")
  end
  super
 end

end #class



#=============================================================================#
# Creates category array from WEAPON database.
#=============================================================================#
class RPG::Weapon < RPG::EquipItem

 def create_categorize_item_cache
  @icat = []
  @icat << ICAT::RESERVED_CATEGORY_INDEX.key("Weapons")
  super
 end

end #class



#=============================================================================#
# Creates category array from ARMOR database.
#=============================================================================#
class RPG::Armor < RPG::EquipItem

 def create_categorize_item_cache
  @icat = []
  @icat << ICAT::RESERVED_CATEGORY_INDEX.key("Armor")
  super
 end

end #class



#=============================================================================#
# Creates item window, categorised by RESERVED_CATEGORY_INDEX and by your own
# custom VISIBLE_CATEGORY_INDEX hash above.
#=============================================================================#
class Window_ItemList < Window_Selectable

 alias icat_initialize initialize
 def initialize(x, y, width, height)
  icat_initialize(x, y, width, height)
  @category = ICAT::VISIBLE_CATEGORY_INDEX
 end

 def include?(item)
  return false if item == nil
  case @category
  when :item
    item.is_a?(RPG::Item) && !item.key_item?
  when :weapon
    item.is_a?(RPG::Weapon)
  when :armor
    item.is_a?(RPG::Armor)
  when :key_item
    item.is_a?(RPG::Item) && item.key_item?
  when :all_item
    item.is_a?(RPG::Item) || item.is_a?(RPG::Armor) || item.is_a?(RPG::Weapon)
  else
    ###### NEED TO CHECK FOR CUSTOM CATEGORIES HERE AND
    ###### DECIDE IF TO INCLUDE THE ITEM TO IT
    @icategory = item.item_category
    for i in @icategory do
    if @category == i
      return item.item_category.include?(@category)
    end
    end
    return false
  end #when
 end #def

end #class



#=============================================================================#
# Allows for the customisation of the help window.
#=============================================================================#
class Window_Help < Window_Base

 alias icat_help_initialize initialize
 def initialize(line_number = 2)
  if ICAT::DEFAULT_SCENE_ITEM_LAYOUT
    super(0, 0, Graphics.width, fitting_height(line_number))
  else
    super(
    ICAT::HELP_WINDOW_POSITION[0],
    ICAT::HELP_WINDOW_POSITION[1],
    ICAT::HELP_WINDOW_WIDTH,
    fitting_height(ICAT::HELP_WINDOW_NUM_OF_LINES))
  end
 end

end #class



#=============================================================================#
# Creates the entire item scene: item window, item categories, help window.
#=============================================================================#
class Scene_Item < Scene_ItemBase

 alias icat_create_category_window create_category_window
 #Create the item category window.
 def create_category_window
@category_window = ICAT_WindowItemCategory.new
@category_window.viewport = @viewport
@category_window.help_window = @help_window
@category_window.x = ICAT::CATEGORY_WINDOW_POSITION[0]
if ICAT::DEFAULT_SCENE_ITEM_LAYOUT #customise check
  @category_window.y = @help_window.height
else
  @category_window.y = ICAT::CATEGORY_WINDOW_POSITION[1]
end
@category_window.set_handler(:ok,	 method(:on_category_ok))
@category_window.set_handler(:cancel, method(:return_scene))
@category_window.opacity = 255 #255=totally opaque
@category_window.back_opacity = 255 #255=totally opaque
@category_window.contents_opacity = 255 #255=totally opaque
 end

 #Create the item list window.
 alias icat_create_item_window create_item_window
 def create_item_window
if ICAT::DEFAULT_SCENE_ITEM_LAYOUT #customise check
  wy = @category_window.y + @category_window.height
  wh = Graphics.height - wy
else
  wy = ICAT::ITEMLIST_WINDOW_POSITION[1]
  wh = ICAT::ITEMLIST_WINDOW_HEIGHT
end
@item_window = Window_ItemList.new(0, wy, Graphics.width, wh)
@item_window.viewport = @viewport
@item_window.help_window = @help_window
@item_window.set_handler(:ok,	 method(:on_item_ok))
@item_window.set_handler(:cancel, method(:on_item_cancel))
@category_window.item_window = @item_window
 end

end #class

#=============================================================================#
# -------------------------------END OF SCRIPT------------------------------- #
#=============================================================================#
