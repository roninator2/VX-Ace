=begin
#===============================================================================
 Title: Actor Inventory - Gold
 Mod: Roninator2
 Latest Revision Date: Mar 29, 2022
--------------------------------------------------------------------------------
 ** Change log
 Mar 29, 2022
   - Removed improper reference
 Mar 28, 2022
   - Fixed lose gold error and added Battle gold/item fix
 Mar 27, 2022
   - Fixed lose gold and added Menu gold fix
 Mar 23, 2022
   - Initial release
--------------------------------------------------------------------------------
 ** Terms of Use
 * Follow Tsukihime's original terms of use
--------------------------------------------------------------------------------
 ** Description
 
 This script is an add on to Hime's Actor Inventory script
 
 You will need to use script calls to add gold to members.
 
 This script does not provide any scenes or windows so you will need to
 install other scripts that will provide those. This script also does not
 provide a way to exchange items between actors.
 
--------------------------------------------------------------------------------
 ** Required
 
 Core - Inventory
 (http://himeworks.wordpress.com/2013/07/27/core-inventory/)
 Actor Inventory
 Shop Inventory
 
--------------------------------------------------------------------------------
 ** Installation
 
 Place this script below Shop Inventory and above Main
 All custom menus should be placed below the actor inventory scenes.

--------------------------------------------------------------------------------
 ** Usage
 
 The following script calls are available:
 
   gain_gold(amount, actor_id)
   lose_gold(amount, actor_id)

 Where `amount` is the amount of you want to add/remove, and
 `actor_id` is the actor that you want to add to or remove from.
 
 Option to show the player name in the shop. Change setting below
 to turn it on or off.
 
#===============================================================================
=end

module R2_Gold_Shop_Actor
 
  Show_Name = true
  Gold_Actors = 4
end

$imported = {} if $imported.nil?
$imported["TH_ActorInventory_Gold"] = true
#===============================================================================
# ** Rest of script
#===============================================================================

class Game_Interpreter
  def gain_gold(amount, actor_id)
    $game_actors[actor_id].gain_gold(amount)
  end
  def lose_gold(amount, actor_id)
    $game_actors[actor_id].lose_gold(amount)
  end
end

class Game_ActorInventory < Game_Inventory
  attr_accessor :gold
  alias r2_actor_inventory_gold_addon initialize
  def initialize(actor)
    r2_actor_inventory_gold_addon(actor)
    @gold = 0
  end
  def gain_gold(amount)
    @gold += amount
  end
end

class Game_Actor < Game_Battler
  def inventory_gold
    @inventory.gold
  end
  def gain_gold(amount)
    @inventory.gain_gold(amount)
  end
  def lose_gold(amount)
    @inventory.gold -= amount
  end
end

class Scene_Shop < Scene_MenuBase
  alias :r2_actor_inventory_gold_start :start
  def start
    r2_actor_inventory_gold_start
    create_dummy_actor_window if R2_Gold_Shop_Actor::Show_Name
  end
  def do_buy(number)
    $game_actors[@actor.id].lose_gold(number * buying_price)
    @actor.gain_item(@item, number)
  end
  def do_sell(number)
    $game_actors[@actor.id].gain_gold(number * selling_price)
    @actor.lose_item(@item, number)
  end
  def create_dummy_actor_window
    x = @gold_window.x
    y = @gold_window.y - @gold_window.height + 10
    w = @gold_window.width
    h = @gold_window.height - 10
    @dummy_actor_window = Window_ActorStatus.new(x, y, w, h)
    @dummy_actor_window.viewport = @viewport
    @dummy_actor_window.actor = @actor
  end
  alias :r2_actor_gold_create_gold_window :create_gold_window
  def create_gold_window
    r2_actor_gold_create_gold_window
    @gold_window.actor = $game_party.leader
  end
  alias :r2_actor_inventory_create_command_window :create_command_window
  def create_command_window
    r2_actor_inventory_create_command_window
    @command_window.set_handler(:pagedown, method(:next_com_actor))
    @command_window.set_handler(:pageup,   method(:prev_com_actor))
  end
  alias :r2_actor_inventory_create_category_window :create_category_window
  def create_category_window
    r2_actor_inventory_create_category_window
    @category_window.set_handler(:pagedown, method(:next_cat_actor))
    @category_window.set_handler(:pageup,   method(:prev_cat_actor))
  end
  def on_actor_command_change
    @gold_window.actor = @actor
    @gold_window.refresh
    @dummy_actor_window.actor = @actor if R2_Gold_Shop_Actor::Show_Name
    @dummy_actor_window.refresh if R2_Gold_Shop_Actor::Show_Name
    @status_window.actor = @actor
    @command_window.activate
  end
  def on_actor_category_change
    @gold_window.actor = @actor
    @gold_window.refresh
    @dummy_actor_window.actor = @actor if R2_Gold_Shop_Actor::Show_Name
    @dummy_actor_window.refresh if R2_Gold_Shop_Actor::Show_Name
    @status_window.actor = @actor
    @sell_window.actor = @actor
    @sell_window.refresh
    @category_window.activate
  end
  alias :r2_on_actor_change_gold  :on_actor_change
  def on_actor_change
    @gold_window.actor = @actor
    @gold_window.refresh
    @dummy_actor_window.actor = @actor if R2_Gold_Shop_Actor::Show_Name
    @dummy_actor_window.refresh if R2_Gold_Shop_Actor::Show_Name
    r2_on_actor_change_gold
    @buy_window.money = money
    @buy_window.refresh
    @sell_window.refresh
  end
  def next_com_actor
    @actor = $game_party.menu_actor_next
    on_actor_command_change
  end
  def prev_com_actor
    @actor = $game_party.menu_actor_prev
    on_actor_command_change
  end
  def next_cat_actor
    @actor = $game_party.menu_actor_next
    on_actor_category_change
  end
  def prev_cat_actor
    @actor = $game_party.menu_actor_prev
    on_actor_category_change
  end
end

class Window_Gold < Window_Base
  def initialize
    super(0, 0, window_width, fitting_height(1))
  end
  def value
    $game_actors[@actor.id].inventory_gold
  end
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
end

class Window_ActorStatus < Window_Base
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item = nil
    @page_index = 0
  end
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  def refresh
    contents.clear
    draw_actor_info
  end
  def draw_actor_info
    change_color(normal_color)
    draw_text(0, 0, 160, line_height, @actor.name, 1)
  end
  def line_height
    return 24
  end
  def standard_padding
    return 5
  end
end

class Scene_Menu < Scene_MenuBase
  def create_gold_window
    @gold_window = Window_MenuGold.new
    @gold_window.x = 0
    @gold_window.y = Graphics.height - @gold_window.height
  end
end

class Window_MenuGold < Window_Base
  def initialize
    super(0, 0, window_width, fitting_height(R2_Gold_Shop_Actor::Gold_Actors))
    refresh
  end
  def window_width
    return 160
  end
  def standard_padding
    return 5
  end
  def refresh
    contents.clear
    @memb = R2_Gold_Shop_Actor::Gold_Actors
    for i in 0..@memb - 1
      next if $game_party.members[i].nil?
      id = $game_actors[$game_party.members[i].id].id
      actor = $game_actors[id]
      change_color(normal_color)
      draw_text(0, line_height * i, 160, line_height, actor.name, 0)
      draw_currency_value(value(id), currency_unit, 4, line_height * i, contents.width - 8)
    end
  end
  def value(id)
    $game_actors[id].inventory_gold
  end
  def currency_unit
    Vocab::currency_unit
  end
  def open
    refresh
    super
  end
end

module BattleManager
  def self.gain_gold
    if $game_troop.gold_total > 0
      div = $game_party.battle_members.size
      funds = ($game_troop.gold_total / div).to_i
      text = sprintf(Vocab::ObtainGold, funds)
      $game_message.add('\.' + text)
      $game_party.battle_members.each do |actor|
        actor.gain_gold(funds)
      end
    end
    wait_for_message
  end
  def self.gain_drop_items
    div = $game_party.battle_members.size
    $game_troop.make_drop_items.each do |item|
      act = rand(div)
      $game_party.battle_members[act].gain_item(item, 1)
      $game_message.add(sprintf(Vocab::ObtainItem, item.name))
    end
    wait_for_message
  end
end
