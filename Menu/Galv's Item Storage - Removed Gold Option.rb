#------------------------------------------------------------------------------#
#  Galv's Item Storage
#------------------------------------------------------------------------------#
#  For: RPGMAKER VX ACE
#  Version 1.9. -1/4 - for removing gold
#  Mod by roninator2
#------------------------------------------------------------------------------#
#  2016-06-09 - Version 1.9 - Bug with removing an entire stack fixed
#  2015-11-12 - Version 1.8 - Bug with stored item stacks and counting.
#  2012-10-24 - Version 1.7 - Added multiple storages controlled with variable.
#                           - Changed name to Item/Bank Storage
#                           - changed alias naming for compatibility
#  2012-10-19 - Version 1.6 - Bug fixes
#  2012-10-19 - Version 1.5 - Fixed a max gold and withdrawing issue.
#                           - Added deposit all and withdraw all gold buttons.
#                           - party gold and item limits can now be set or use
#                           - the limit from a limit breaking script. (in theory)
#  2012-10-18 - Version 1.4 - Other small fixes
#  2012-10-18 - Version 1.3 - Added banking SE
#  2012-10-18 - Version 1.2 - Added gold storage and more script calls
#  2012-10-17 - Version 1.1 - Added script calls to control stored items.
#  2012-10-16 - Version 1.0 - Released
#------------------------------------------------------------------------------#
#  An item storage script. Allows the player to store as many items as he/she
#  requires in bank-like storage that can be accessed from anywhere.
#    
#  This script differs to my "Multiple Storage containers" script in that you
#  can have "banks" that store items and gold and can be accessed from anywhere.
#  It was designed to be used for one bank, but now has option to have more if
#  required.
#
#  My "Multiple Storage Containers" script stores only items within certain
#  events that can only be accessed by activating the particular event. This was
#  designed for location specific containers like chests, barrels, etc.
#
#  Here are some script calls that might be useful:
#------------------------------------------------------------------------------#
#
#  open_storage                         # Opens the item storage scene
#
#  store_add(type, id, amount)          # creates an item in storage
#  store_rem(type, id, amount)          # destroys an item in storage
#  store_count(type, id)                # returns amount of an item in storage
#
#------------------------------------------------------------------------------#
#  EXPLAINATION:
#  type      this can be "weapon", "armor" or "item"
#  id        the ID of the item/armor/weapon
#  amount    the number of the item/armor/weapon/gold you want to remove
#
#  EXAMPLE OF USE:
#  store_add("weapon", 5, 20)
#  store_rem("item", 18, 99)
#  store_count("armor", 1)
#------------------------------------------------------------------------------#
#  More setup options further down.
#------------------------------------------------------------------------------#
 
$imported = {} if $imported.nil?
$imported["Item_Storage"] = true
 
module Storage
 
#------------------------------------------------------------------------------#
#  SCRIPT SETUP OPTIONS
#------------------------------------------------------------------------------#
 
  # BOX VARIABLE
  BOX_VAR = 3    # This is the variable ID to use to determine which box you are
                 # adding/removing items from. Set the variable to a box number
                 # right before any add/remove or opening storage script calls
                 # to tell them which box they will affect.
                 # Set to 0 if you only want 1 box storage in your game. You
                 # then don't have to change a variable before each script call.
 
 
  # COMMAND LIST VOCAB
  STORE = "Store Item"
  REMOVE = "Remove Item"
  CANCEL = "Cancel"
 
  # OTHER VOCAB
  IN_STORAGE = "In Storage"
  IN_INVENTORY = "In Inventory"
   
  # OTHER OPTIONS
  SE = ["Equip2", 90, 100]        # Sound effect when storing/removing an item
  SE_BANK = ["Shop", 50, 150]     # Repeating sound effect when banking gold
                                  # ["SE Name", volume, pitch]
   
  STORE_PRICELESS = true          # Items worth 0 can be stored? true or false
  STORE_KEY = true                # Key items can be stored? true or false
 
   
  # PARTY LIMITS
  # NOTE: These limits set to 0 will use the default limits. In theory this will
  # be compatible with a limit breaker script by leaving them at 0. Or you can
  # set the party limits below to whatever you like.
   
                                  # This will overwrite the default limit.
                                  # 0 means do not use this.
 
  MAX_ITEMS = 0                   # Max items your PARTY can carry. 
                                  # This will overwrite the default limit.
                                  # 0 means do not use this.
 
 
#------------------------------------------------------------------------------#
#  SCRIPT SETUP OPTIONS
#------------------------------------------------------------------------------#
 
end
 
 
class Scene_ItemBank < Scene_MenuBase
  def start
    super
    check_storage_exists
    create_help_window
    create_command_window
    create_dummy_window
    create_number_window
    create_status_window
    create_category_window
    create_take_window
    create_give_window
     
  end
   
  def check_storage_exists
    if $game_party.multi_storage.nil?
      $game_party.create_storage_contents
    end
  end
   
   
  #--------------------------------------------------------------------------
  # Create Windows
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_BankCommand.new(Graphics.width)
    @command_window.viewport = @viewport
    @command_window.y = @help_window.height
    @command_window.set_handler(:give,   method(:command_give))
    @command_window.set_handler(:take,    method(:command_take))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  def create_dummy_window
    wy = @command_window.y + @command_window.height
    wh = Graphics.height - wy
    @dummy_window = Window_Base.new(0, wy, Graphics.width, wh)
    @dummy_window.viewport = @viewport
  end
  def create_number_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @number_window = Window_BankNumber.new(0, wy, wh)
    @number_window.viewport = @viewport
    @number_window.hide
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
  end
  def create_status_window
    wx = @number_window.width
    wy = @dummy_window.y
    ww = Graphics.width - wx
    wh = @dummy_window.height
    @status_window = Window_BankItems.new(wx, wy, ww, wh)
    @status_window.viewport = @viewport
    @status_window.hide
  end
  def create_category_window
    @category_window = Window_ItemCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @dummy_window.y
    @category_window.hide.deactivate
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:on_category_cancel))
  end
  def create_give_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @give_window = Window_BankGive.new(0, wy, Graphics.width, wh)
    @give_window.viewport = @viewport
    @give_window.help_window = @help_window
    @give_window.hide
    @give_window.set_handler(:ok,     method(:on_give_ok))
    @give_window.set_handler(:cancel, method(:on_give_cancel))
    @category_window.item_window = @give_window
  end
  def create_take_window
    wy = @command_window.y + @command_window.height
    wh = Graphics.height - wy
    @take_window = Window_BankTake.new(0, wy, Graphics.width, wh)
    @take_window.viewport = @viewport
    @take_window.help_window = @help_window
    @take_window.hide
    @take_window.set_handler(:ok,     method(:on_take_ok))
    @take_window.set_handler(:cancel, method(:on_take_cancel))
    @category_window.item_window = @take_window
  end
 
  #--------------------------------------------------------------------------
  # * Activate Windows
  #--------------------------------------------------------------------------
  def activate_give_window
    @category_window.show
    @give_window.refresh
    @give_window.show.activate
    @status_window.hide
  end
  def activate_take_window
    @take_window.select(0)
    @take_window.refresh
    @take_window.show.activate
    @status_window.hide
  end
  #--------------------------------------------------------------------------
  # HANDLER METHODS
  #--------------------------------------------------------------------------
  def on_category_ok
    activate_give_window
    @give_window.select(0) 
  end
  def on_category_cancel
    @command_window.activate
    @dummy_window.show
    @category_window.hide
    @give_window.hide
  end
  def command_give
    @dummy_window.hide
    @category_window.show.activate
    @give_window.show
    @give_window.unselect
    @give_window.refresh
  end
  def on_give_ok
    @item = @give_window.item
    if @item.nil?
      RPG::SE.stop
      Sound.play_buzzer
      @give_window.activate
      @give_window.refresh
      return
    else
      @status_window.item = @item
      @category_window.hide
      @give_window.hide
      @number_window.set(@item, max_give)
      @number_window.show.activate
      @status_window.show
    end
  end
  def on_give_cancel
    @give_window.unselect
    @category_window.activate
    @status_window.item = nil
    @help_window.clear
  end
  def command_take
    @dummy_window.hide
    activate_take_window
    @take_window.show
    @take_window.refresh
  end
  def on_take_ok
    @item = @take_window.item
    if @item.nil? || $game_party.multi_storage.empty? || $game_party.item_number(@item) == $game_party.max_item_number(@item)
      RPG::SE.stop
      Sound.play_buzzer
      @take_window.activate
      @take_window.refresh
      return
    elsif
      @item = @take_window.item
      @status_window.item = @item
      @take_window.hide
      @number_window.set(@item, max_take)
      @number_window.show.activate
      @status_window.show
    end
  end
  def on_take_cancel
    @take_window.unselect
    @command_window.activate
    @dummy_window.show
    @take_window.hide
    @status_window.item = nil
    @help_window.clear
  end
  def on_number_ok
    RPG::SE.new(Storage::SE[0], Storage::SE[1], Storage::SE[2]).play
    case @command_window.current_symbol
    when :take
      do_take(@number_window.number)
    when :give
      do_give(@number_window.number)
    end
    end_number_input
    @status_window.refresh
  end
  def on_number_cancel
    Sound.play_cancel
    end_number_input
  end
  def end_number_input
    @number_window.hide
    case @command_window.current_symbol
    when :take
      activate_take_window
    when :give
      activate_give_window
    end
  end  
   
  #--------------------------------------------------------------------------
  # * Giving and taking methods
  #--------------------------------------------------------------------------
  def max_take
    if $game_party.multi_storage(@item) > $game_party.max_item_number(@item) - $game_party.item_number(@item)
      $game_party.max_item_number(@item) - $game_party.item_number(@item)
    else
      $game_party.multi_storage(@item)
    end
  end
  def max_give
    $game_party.item_number(@item)
  end
  def do_give(number)
    $game_party.lose_item(@item, number)
    if $game_party.multi_storage(@item).nil? || $game_party.multi_storage(@item) <= 0
      $game_party.multi_storage_set(@item,number)
    else
      $game_party.multi_storage_change(@item,number)
    end
  end
  def do_take(number)
    return if @item.nil?
    $game_party.gain_item(@item, number)
    $game_party.multi_storage_change(@item,-number)
    #$game_party.multi_storage.delete(@item) if $game_party.multi_storage(@item) <= 0
    if $game_party.multi_storage.empty?
      @take_window.activate
    end
  end
   
end # Scene_ItemBank < Scene_MenuBase
 
 
#------------------------------------------------------------------------------#
#  Window Stored Items
#------------------------------------------------------------------------------#
 
class Window_StoreList_Bank < Window_Selectable
  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
  end
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  def col_max
    return 2
  end
  def item_max
    @data ? @data.size : 1
  end
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  def current_item_enabled?
    enable?(@data[index])
  end
  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end
  def enable?(item)
    $game_party.multi_storage.has_key?(item)
  end
  def make_item_list
    @data = $game_party.multi_storage_all.keys {|item| include?(item) }
    @data.push(nil) if include?(nil)
  end
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_number(rect, item)
    end
  end
  def draw_item_number(rect, item)
    draw_text(rect, sprintf(":%2d", $game_party.multi_storage(item)), 2)
  end
  def update_help
    @help_window.set_item(item)
  end
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end # Window_StoreList_Bank < Window_Selectable
 
 
#------------------------------------------------------------------------------#
#  Window Stored Item amount
#------------------------------------------------------------------------------#
 
class Window_BankNumber < Window_Selectable
  attr_reader :number
  def initialize(x, y, height)
    super(x, y, window_width, height)
    @item = nil
    @max = 1
    @number = 1
  end
  def window_width
    return 304
  end
  def set(item, max)
    @item = item
    @max = max
    @number = 1
    refresh
  end
  def refresh
    contents.clear
    draw_item_name(@item, 0, item_y)
    draw_number
  end
  def draw_number
    change_color(normal_color)
    draw_text(cursor_x - 28, item_y, 22, line_height, "×")
    draw_text(cursor_x, item_y, cursor_width - 4, line_height, @number, 2)
  end
  def item_y
    contents_height / 2 - line_height * 3 / 2
  end
  def cursor_width
    figures * 10 + 12
  end
  def cursor_x
    contents_width - cursor_width - 4
  end
  def figures
    return 2
  end
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
  def update_number
    change_number(1)   if Input.repeat?(:RIGHT)
    change_number(-1)  if Input.repeat?(:LEFT)
    change_number(10)  if Input.repeat?(:UP)
    change_number(-10) if Input.repeat?(:DOWN)
  end
  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
  end
  def update_cursor
    cursor_rect.set(cursor_x, item_y, cursor_width, line_height)
  end
   
end # Window_BankNumber < Window_Selectable
 
 
#------------------------------------------------------------------------------#
#  Window Store Item Status
#------------------------------------------------------------------------------#
 
class Window_BankItems < Window_Base
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item = nil
    @page_index = 0
    refresh
  end
  def refresh
    contents.clear
    draw_possession(4, 0)
    draw_stored(4, line_height)
    draw_equip_info(4, line_height * 2) if @item.is_a?(RPG::EquipItem)
  end
  def item=(item)
    @item = item
    refresh
  end
  def draw_possession(x, y)
    rect = Rect.new(x, y, contents.width - 4 - x, line_height)
    change_color(system_color)
    draw_text(rect, Storage::IN_INVENTORY)
    change_color(normal_color)
    draw_text(rect, $game_party.item_number(@item), 2)
  end
  def draw_stored(x, y)
    rect = Rect.new(x, y, contents.width - 4 - x, line_height)
    change_color(system_color)
    draw_text(rect, Storage::IN_STORAGE)
    change_color(normal_color)
    stored_amount = $game_party.multi_storage(@item)
    stored_amount = 0 if stored_amount.nil?
    draw_text(rect, stored_amount, 2)
  end
  def draw_equip_info(x, y)
    status_members.each_with_index do |actor, i|
      draw_actor_equip_info(x, y + line_height * (i * 2.4), actor)
    end
  end
  def status_members
    $game_party.members[@page_index * page_size, page_size]
  end
  def page_size
    return 4
  end
  def page_max
    ($game_party.members.size + page_size - 1) / page_size
  end
  def draw_actor_equip_info(x, y, actor)
    enabled = actor.equippable?(@item)
    change_color(normal_color, enabled)
    draw_text(x, y, 112, line_height, actor.name)
    item1 = current_equipped_item(actor, @item.etype_id)
    draw_actor_param_change(x, y, actor, item1) if enabled
    draw_item_name(item1, x, y + line_height, enabled)
  end
  def draw_actor_param_change(x, y, actor, item1)
    rect = Rect.new(x, y, contents.width - 4 - x, line_height)
    change = @item.params[param_id] - (item1 ? item1.params[param_id] : 0)
    change_color(param_change_color(change))
    draw_text(rect, sprintf("%+d", change), 2)
  end
  def param_id
    @item.is_a?(RPG::Weapon) ? 2 : 3
  end
  def current_equipped_item(actor, etype_id)
    list = []
    actor.equip_slots.each_with_index do |slot_etype_id, i|
      list.push(actor.equips[i]) if slot_etype_id == etype_id
    end
    list.min_by {|item| item ? item.params[param_id] : 0 }
  end
  def update
    super
    update_page
  end
  def update_page
    if visible && Input.trigger?(:A) && page_max > 1
      @page_index = (@page_index + 1) % page_max
      refresh
    end
  end
   
end # Window_BankItems < Window_Base
 
 
#------------------------------------------------------------------------------#
#  Window Give Item
#------------------------------------------------------------------------------#
 
class Window_BankGive < Window_ItemList
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
  def current_item_enabled?
 
    enable?(@data[index])
  end
  def enable?(item)
    if item.is_a?(RPG::Item) 
      return false if item.key_item? && !Storage::STORE_KEY
    end
    if Storage::STORE_PRICELESS
      true
    else
      item && item.price > 0
    end
  end
end
 
 
#------------------------------------------------------------------------------#
#  Window Take Item
#------------------------------------------------------------------------------#
 
class Window_BankTake < Window_StoreList_Bank
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
  def current_item_enabled?
    enable?(@data[index])
  end
  def enable?(item)
    $game_party.multi_storage[item] != 0 && $game_party.item_number(item) < $game_party.max_item_number(@item)
  end
end
 
 
#------------------------------------------------------------------------------#
#  Window Command
#------------------------------------------------------------------------------#
 
class Window_BankCommand < Window_HorzCommand
  def initialize(window_width)
    @window_width = window_width
    super(0, 0)
  end
  def window_width
    @window_width
  end
  def col_max
    return 3
  end
  def make_command_list
    add_command(Storage::STORE,    :give)
    add_command(Storage::REMOVE,   :take)
    add_command(Storage::CANCEL, :cancel)
  end
end
 
#------------------------------------------------------------------------------#
#  Game Party Additions
#------------------------------------------------------------------------------#
 
 
class Game_Party < Game_Unit
  attr_accessor :multi_storage
  attr_accessor :gold_stored
   
  alias galv_bank_init_all_items init_all_items
  def init_all_items
    galv_bank_init_all_items
    @storage = {}
  end
   
  def multi_storage(item = nil)
    # Test for storage, create if not there.
    @storage[$game_variables[Storage::BOX_VAR]] ||= {:w => {},:a => {}, :i => {}}
     
    if !item
      return @storage[$game_variables[Storage::BOX_VAR]]
    else
      type = mstore_type(item)
      @storage[$game_variables[Storage::BOX_VAR]][type][item.id] ||= 0
      return @storage[$game_variables[Storage::BOX_VAR]][type][item.id]
    end
  end
   
  def multi_storage_all
    all = {}
     
    @storage[$game_variables[Storage::BOX_VAR]][:i].each { |id|
      all[$data_items[id[0]]] = id[1] if id[1] > 0
    }
    @storage[$game_variables[Storage::BOX_VAR]][:w].each { |id|
      all[$data_weapons[id[0]]] = id[1] if id[1] > 0
    }
    @storage[$game_variables[Storage::BOX_VAR]][:a].each { |id|
      all[$data_armors[id[0]]] = id[1] if id[1] > 0
    }
    return all
  end
   
  def mstore_type(item)
    if item.is_a?(RPG::Weapon)
      return :w
    elsif item.is_a?(RPG::Armor)
      return :a
    else
      return :i
    end
  end
   
  def multi_storage_change(item,amount)
    type = mstore_type(item)
    @storage[$game_variables[Storage::BOX_VAR]][type][item.id] ||= 0
    @storage[$game_variables[Storage::BOX_VAR]][type][item.id] += amount
     
    if @storage[$game_variables[Storage::BOX_VAR]][type][item.id] <= 0
      @storage[$game_variables[Storage::BOX_VAR]][type].delete_if { |key,value|
        value <= 0
      }
    end
     
  end
   
  def multi_storage_set(item, amount)
    type = mstore_type(item)
    @storage[$game_variables[Storage::BOX_VAR]][type][item.id] ||= 0
    @storage[$game_variables[Storage::BOX_VAR]][type][item.id] = amount
     
    if @storage[$game_variables[Storage::BOX_VAR]][type][item.id] <= 0
      @storage[$game_variables[Storage::BOX_VAR]][type].delete_if { |key,value|
        key >= 0
      }
    end
  end
 
  alias galv_bank_max_item_number max_item_number
  def max_item_number(item)
    return Storage::MAX_ITEMS if Storage::MAX_ITEMS > 0
    return 99 if item.nil?
    galv_bank_max_item_number(item)
  end
   
end # Game_Party < Game_Unit
 
 
class Game_Interpreter
  def store_add(type, id, amount)
    if $game_party.multi_storage.nil?
      $game_party.create_storage_contents
    end
    case type
    when "weapon"
      @item = $data_weapons[id]
    when "item"
      @item = $data_items[id]
    when "armor"
      @item = $data_armors[id]
    end
    if $game_party.multi_storage(@item).nil?
      $game_party.multi_storage_set(@item,amount)
    else
      $game_party.multi_storage_change(@item,amount)
    end
  end
  def store_rem(type, id, amount)
    if $game_party.multi_storage.nil?
      $game_party.create_storage_contents
    end
    case type
    when "weapon"
      @item = $data_weapons[id]
    when "item"
      @item = $data_items[id]
    when "armor"
      @item = $data_armors[id]
    end
    return if $game_party.multi_storage(@item).nil?
    if $game_party.multi_storage(@item) <= amount
      #$game_party.multi_storage.delete(@item)
      $game_party.multi_storage_set(@item,-amount)
    else
      $game_party.multi_storage_change(@item,-amount)
    end
  end
 
  def store_count(type, id)
    if $game_party.multi_storage.nil?
      $game_party.create_storage_contents
    end
    case type
    when "weapon"
      @item = $data_weapons[id]
    when "item"
      @item = $data_items[id]
    when "armor"
      @item = $data_armors[id]
    end
    # Issue here with item instance being different when game saves - therefore
    # the count is incorrect.
    # This issue is also persistant when adding things to storage
    # needs fixing
    # p "Store item referring issue"
    return 0 if $game_party.multi_storage(@item).nil?
    $game_party.multi_storage(@item)
  end
 
  def open_storage
    SceneManager.call(Scene_ItemBank)
  end
end

# GGZiron mod
class Game_Interpreter

  # Snippet that allows to move all items from inventory
  # to the storage. Addon to Galv's Item/Bank Storage
  # Script calls:
  # move_all_items_to_storage
  # Will move all items without the equipments
  #
  # move_all_items_to_storage(true)
  # Will move all items including the equipments

  def move_all_items_to_storage(equips_included = false)
    if equips_included
      $game_party.all_members.each do |member|
        member.clear_equipments
      end
    end

    $game_party.instance_variable_get(:@items).each do |k, v|
      store_add("item", k, v)
    end

    $game_party.instance_variable_get(:@weapons).each do |k, v|
      store_add("weapon", k, v)
    end

    $game_party.instance_variable_get(:@armors).each do |k, v|
      store_add("armor", k, v)
    end

    $game_party.galv_bank_init_all_items
  end

end
