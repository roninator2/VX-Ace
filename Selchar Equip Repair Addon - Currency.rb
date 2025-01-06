# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Currency Repair              ║  Version: 1.03     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║   Allow repair with alternate       ╠════════════════════╣
# ║   currencies                        ║    26 Dec 2020     ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ 1.01 Corrected buying icon/error    ║    27 Dec 2020     ║
# ║ and fixed enabled method            ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ 1.02 Added icons for each item      ║    27 Dec 2020     ║
# ║ If true will show currency icon     ║                    ║
# ║ instead of equipemnt icon           ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ 1.03 Recreated shop number window   ║    27 Dec 2020     ║
# ║ due to conflict with yanfly shop    ║                    ║
# ║ options script. aka - new window    ║                    ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Script addon to allow for damaging of items or           ║
# ║ partial repair of items or specifying                    ║
# ║ what currency to use for a specific item                 ║
# ║                                                          ║
# ║ Use note tag <repair currency: X> # X = Currency ID      ║
# ║ to specify what currency to use from Calestian           ║
# ║ Multiple Currencies script. Default is 0 (Gold)          ║
# ║                                                          ║
# ║ Turn switches on to enable Damage and Partial Repair     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Follow the Original Authors terms   ║
# ╚═════════════════════════════════════╝
# update
#==============================================================================
# ■ Module for currency repair
#==============================================================================
module TH_Instance
  module Scene_Repair
    Partial = "Partial"
    Damage = "Damage"
    Damage_Item = "Each damage point will recover "
    Allow_Partial = 5 # switch to allow partial repair
    Allow_Damage = 6 # switch to allow damage of items
    Draw_Currency_Icon = true # draw currency instead of item icon on each item
  end
end

#==============================================================================
# ■ Window_RepairCommand
#==============================================================================
class Window_RepairCommand < Window_HorzCommand
  #============================================================================
  # Set max column
  #============================================================================
  def col_max
    col = 2
    col += 1 if $game_switches[TH_Instance::Scene_Repair::Allow_Partial]
    col += 1 if $game_switches[TH_Instance::Scene_Repair::Allow_Damage]
    return col
  end
  #============================================================================
  # Make command list
  #============================================================================
  def make_command_list
    add_command(TH_Instance::Scene_Repair::Vocab,    :repair)
    if $game_switches[TH_Instance::Scene_Repair::Allow_Partial]
      add_command(TH_Instance::Scene_Repair::Partial,    :partial) 
    end
    if $game_switches[TH_Instance::Scene_Repair::Allow_Damage]
      add_command(TH_Instance::Scene_Repair::Damage,    :damage)
    end
    add_command(Vocab::ShopCancel, :cancel)
  end
end

#==============================================================================
# ■ Scene_RepairEquip
#==============================================================================
class Scene_RepairEquip < Scene_ItemBase
  def start
    super
    create_help_window
    create_gold_window
    create_command_window
    create_item_window
    create_cost_window
  end
  #============================================================================
  # Create command window
  #============================================================================
  def create_command_window
    @command_window = Window_RepairCommand.new(@gold_window.x)
    @command_window.viewport = @viewport
    @command_window.y = @help_window.height
    @command_window.set_handler(:repair, method(:command_repair))
    @command_window.set_handler(:partial, method(:command_partial))
    @command_window.set_handler(:damage, method(:command_damage))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  #============================================================================
  # Create item windoww
  #============================================================================
  def create_item_window
    wy = @help_window.height + @command_window.height
    wh = Graphics.height - wy
    ww = Graphics.width - @gold_window.width
    @item_window = Window_EquipRepair.new(0, wy, ww, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @item_window.category = :item
  end
  #============================================================================
  # Create gold window. Configured for 544 x 416 window
  #============================================================================
  def create_gold_window
    if Clstn_Currencies::CURRCNT >= 10
      @gold_window = Window_Currencies_Repair.new
      @gold_window.x = Graphics.width - @gold_window.width
      @gold_window.y = 0
      @help_window.width = Graphics.width - @gold_window.width
    else
      @gold_window = Window_Currencies_Repair.new
      @gold_window.x = Graphics.width - @gold_window.width
      @gold_window.y = @help_window.height
    end
  end
  #============================================================================
  # Create cost (number) window
  #============================================================================
  def create_cost_window
    wy = @command_window.y
    wh = 160
    @cost_window = Window_CurrencyNumber.new(50, wy, wh)
    @cost_window.viewport = @viewport
    @cost_window.hide
    @cost_window.set_handler(:ok,     method(:on_number_ok))
    @cost_window.set_handler(:cancel, method(:on_number_cancel))
  end
  #============================================================================
  # Process item ok
  #============================================================================
  def on_item_ok
    case @command_window.current_symbol
    when :repair
      cost = (item.max_durability - item.durability) * item.repair_point
      if item.repair_currency == 0
        if cost <= $game_party.gold
          $game_party.lose_gold(item.repair_price)
          item.repair
          @gold_window.refresh
          on_item_sound
          activate_item_window
          @item_window.refresh
        else
          Sound.play_cancel
        end
      else
        if cost <= $game_party.currency[item.repair_currency]
          $game_party.lose_gold(item.repair_price, item.repair_currency)
          item.repair
          @gold_window.refresh
          on_item_sound
          activate_item_window
          @item_window.refresh
        else
          Sound.play_cancel
        end
      end
    when :partial
      if item.repair_currency == 0
        @cost_window.set(item, item.max_durability - item.durability, item.repair_point, $game_party.gold)
      else
        @cost_window.set(item, item.max_durability - item.durability, item.repair_point, $game_party.currency[item.repair_currency])
      end
      @cost_window.show.activate
    when :damage
      if item.repair_currency == 0
        @cost_window.set(item, item.durability, item.repair_point, $game_party.gold)
      else
        @cost_window.set(item, item.durability, item.repair_point, $game_party.currency[item.repair_currency])
      end
      @cost_window.show.activate
    end
  end
  #============================================================================
  # Process number ok
  #============================================================================
  def on_number_ok
    case @command_window.current_symbol
    when :partial
      cost = @cost_window.number * item.repair_point
      if item.repair_currency == 0
        if cost <= $game_party.gold
          item.partial_repair(@cost_window.number)
          $game_party.lose_gold(cost)
          on_item_sound
          activate_item_window
          @item_window.refresh
          end_number_input
        else
          Sound.play_cancel
          @cost_window.activate
        end
      else
        if cost <= $game_party.currency[item.repair_currency]
          item.partial_repair(@cost_window.number)
          $game_party.lose_gold(cost, item.repair_currency)
          on_item_sound
          activate_item_window
          @item_window.refresh
          end_number_input
        else
          Sound.play_cancel
          @cost_window.activate
        end
      end
    when :damage
      previous = item.repair_price
      item.damage_durability(@cost_window.number)
      current = item.repair_price
      $game_party.gain_gold((current - previous)/2, item.repair_currency)
      on_item_sound
      activate_item_window
      @item_window.refresh
      end_number_input
    end
    @gold_window.refresh
  end
  #============================================================================
  # Process number cancel
  #============================================================================
  def on_number_cancel
    Sound.play_cancel
    end_number_input
    @item_window.refresh
  end
  #============================================================================
  # Process end number input
  #============================================================================
  def end_number_input
    @cost_window.hide
    @gold_window.refresh
    on_item_sound
    activate_item_window
    @item_window.refresh
  end
  #============================================================================
  # Process item cancel
  #============================================================================
  def on_item_cancel
    @item_window.unselect
    @item_window.deactivate
    @command_window.activate
    @help_window.set_text('')
    @item_window.equip_damage = false
    @item_window.partial_repair = false
    @cost_window.damage_price = false
    @item_window.refresh
  end
  #============================================================================
  # Command for Partial repair
  #============================================================================
  def command_partial
    @item_window.partial_repair = true
    @command_window.deactivate
    @item_window.activate
    @item_window.refresh
    @item_window.select(0)
  end
  #============================================================================
  # Command for Damage item
  #============================================================================
  def command_damage
    @item_window.equip_damage = true
    @cost_window.damage_price = true
    @command_window.deactivate
    @item_window.activate
    @item_window.refresh
    @item_window.select(0)
  end
end

#==============================================================================
# ■ Window_Help - adjusted for currencies window
#==============================================================================
class Window_Help < Window_Base
  #============================================================================
  # * Initialize. Adjust for Scene_Repair
  #============================================================================
  def initialize(line_number = 2)
    if SceneManager.scene_is?(Scene_RepairEquip)
      if Clstn_Currencies::CURRCNT >= 10
        super(0, 0, 544 - 160, fitting_height(line_number))
      else
        super(0, 0, Graphics.width, fitting_height(line_number))
      end
    else
      super(0, 0, Graphics.width, fitting_height(line_number))
    end
  end
end
#==============================================================================
# ■ Window_ShopNumber
#==============================================================================
class Window_CurrencyNumber < Window_Selectable
  attr_accessor :damage_price
  attr_reader   :number                   # quantity entered
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, height)
    super(x, y, window_width, height)
    @item = nil
    @max = 1
    @price = 0
    @number = 1
    @currency_unit = Vocab::currency_unit
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
  def set(item, max, price, currency_unit = nil)
    @item = item
    @max = max
    @price = price
    @currency_unit = currency_unit if currency_unit
    @number = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Set Currency Unit
  #--------------------------------------------------------------------------
  def currency_unit=(currency_unit)
    @currency_unit = currency_unit
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_item_name(@item, 0, item_y)
    draw_number
    draw_total_price
  end
  #--------------------------------------------------------------------------
  # * Draw Quantity
  #--------------------------------------------------------------------------
  def draw_number
    change_color(normal_color)
    draw_text(cursor_x - 28, item_y, 22, line_height, "×")
    draw_text(cursor_x, item_y, cursor_width - 4, line_height, @number, 2)
  end
  #--------------------------------------------------------------------------
  # * Y Coordinate of Item Name Display Line
  #--------------------------------------------------------------------------
  def item_y
    contents_height / 2 - line_height * 3 / 2
  end
  #--------------------------------------------------------------------------
  # * Y Coordinate of Price Display Line
  #--------------------------------------------------------------------------
  def price_y
    contents_height / 2 + line_height / 2
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
    cursor_rect.set(cursor_x, item_y, cursor_width, line_height)
  end
  #============================================================================
  # Draw the total cost for repair
  #============================================================================
  def draw_total_price
    width = contents_width - 8
    if SceneManager.scene_is?(Scene_RepairEquip)
      icon_index = Clstn_Currencies::Currencies[@item.repair_currency][0]
    else
      icon_index = Clstn_Currencies::Currencies[$game_temp.currency_index][0]
    end
    icon = draw_icon(icon_index, 260, 70)
    if SceneManager.scene_is?(Scene_RepairEquip)
      if @damage_price
        cost_cut = @item.repair_point / 2
        draw_currency_value(cost_cut * @number, nil, -15, price_y, width)
      else
        draw_currency_value(@item.repair_point * @number, nil, -15, price_y, width)
      end
    else
      draw_currency_value(@price * @number, @currency_unit, 4, price_y, width)
    end
  end
  def damage_price
    @damage_price
  end
end

#==============================================================================
# ■ Window_EquipRepair
#==============================================================================
class Window_EquipRepair < Window_ItemList
  attr_accessor :equip_damage
  attr_accessor :partial_repair
  #============================================================================
  # Is the item enabled?
  #============================================================================
  def enable?(item)
    return true if item.is_a?(RPG::EquipItem) && item.can_repair? && 
    $game_party.gold >=  item.repair_price if item.repair_currency == 0
    return true if item.is_a?(RPG::EquipItem) && item.can_repair? && 
    $game_party.currency[item.repair_currency] >=  item.repair_price if item.repair_currency >= 1
    return true if @equip_damage
    return true if @partial_repair && item.can_repair? && 
    $game_party.gold >= item.repair_point if item.repair_currency == 0
    return true if @partial_repair && item.can_repair? && 
    $game_party.currency[item.repair_currency] >= item.repair_point if item.repair_currency >= 1
    return false
  end
  #============================================================================
  # Command for Damage item
  #============================================================================
  def equip_damage
    @equip_damage
  end
  #============================================================================
  # Command for Partial repair of item
  #============================================================================
  def partial_repair
    @partial_repair
  end
  #============================================================================
  # * Draw Item Name
  #============================================================================
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    if SceneManager.scene_is?(Scene_RepairEquip)
      icon_index = Clstn_Currencies::Currencies[item.repair_currency][0]
    else
      icon_index = Clstn_Currencies::Currencies[$game_temp.currency_index][0]
    end
    if TH_Instance::Scene_Repair::Draw_Currency_Icon
      draw_icon(icon_index, x, y, enabled)
    else
      draw_icon(item.icon_index, x, y, enabled)
    end
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
  #============================================================================
  # Update help for items selected
  #============================================================================
   def update_help
    unless item
      @help_window.set_text(TH_Instance::Scene_Repair::No_Selected_Item)
    else
      base_cost = item.base_cost
      if item.repair_price.zero?
        if equip_damage
          base_cost = base_cost / 2
          @help_window.set_text(TH_Instance::Scene_Repair::Damage_Item + base_cost.to_s + " for each point")
        else
          @help_window.set_text(TH_Instance::Scene_Repair::Can_Not_Repair)
        end
      else
        if partial_repair          
          @help_window.set_text(TH_Instance::Scene_Repair::Selected_Item + base_cost.to_s + " for each point")
        elsif equip_damage
          base_cost = base_cost / 2
          @help_window.set_text(TH_Instance::Scene_Repair::Damage_Item + base_cost.to_s + " for each point")
        else
          if SceneManager.scene_is?(Scene_RepairEquip)
            icon_index = Clstn_Currencies::Currencies[item.repair_currency][0]
          else
            icon_index = Clstn_Currencies::Currencies[$game_temp.currency_index][0]
          end
          @help_window.set_text(TH_Instance::Scene_Repair::Selected_Item + item.repair_price.to_s)
        end
      end
    end
  end
  #============================================================================
  # Include
  #============================================================================
  def include?(item)
    !item.is_a?(RPG::Item) && !item.nil? && item.use_durability
  end
end

#==============================================================================
# ■ Window_Currencies_Repair
#==============================================================================
class Window_Currencies_Repair < Window_Selectable
 
  #============================================================================
  # * Initialize
  #============================================================================
  def initialize
      ww = 160
      wh = Graphics.height
      wx = Graphics.width - ww
    if Clstn_Currencies::CURRCNT >= 10
      wy = 0
      super(wx, wy, ww, wh)
    else
      wy = 72
      wh = Graphics.height - 72
      super(wx, wy, ww, wh)
    end
    refresh
  end
  #============================================================================
  # * Method: value
  #============================================================================
  def value(currency_index = $game_temp.currency_index)
    if currency_index == 0
      $game_party.gold
    else
      $game_party.currency[currency_index]
    end
  end
  #============================================================================
  # * Method: refresh
  #============================================================================
  def refresh
    contents.clear
    change_color(text_color(6))
    draw_text(30, -4, 100, 30,"Currencies")
    draw_horz_line(0, 6)
    draw_horz_line(3, 6)
    i = 0
    Clstn_Currencies::Currencies.each_value { |hash|
      icon_index = hash[0]
      draw_horz_line(37 + (32 * i), 0)
      currency_unit = draw_icon(icon_index, 110, 32 + (32 * i))
      draw_currency_value(value(i), currency_unit, -19, 33 + (32 * i), contents.width - 8)
      i += 1
    }
  end
  #============================================================================
  # * Method: draw_horz_line
  #============================================================================
  def draw_horz_line(dy, color)
    color = text_color(color)
    line_y = dy + line_height - 4
    contents.fill_rect(4, line_y, contents_width - 8, 3, Font.default_out_color)
    contents.fill_rect(5, line_y + 1, contents_width - 10, 1, color)
  end
end
#==============================================================================
# ■ Weapon specify settings
#==============================================================================
class RPG::Weapon
  #============================================================================
  # Partial Repair. for repairing equipment a small amount
  #============================================================================
  def partial_repair(amount = 0)
    @durability += amount
    @durability = max_durability if @durability > max_durability
    refresh_name
    refresh_price
  end
  #============================================================================
  # Damage_Durability
  #============================================================================
  def damage_durability(amount = 0)
    @durability -= amount
    @durability = 0 if @durability < 0
    refresh_name
    refresh_price
  end
  #============================================================================
  # Repair point - finds cost of repairing one point
  #============================================================================
  def repair_point
    adjust = max_durability - @durability
    return @price / 100 if adjust == 0
    return ((@non_durability_price - @price) / adjust).to_i
  end
  #============================================================================
  # Base Cost of repair
  #============================================================================
  def base_cost
    return @non_durability_price / @max_durability
  end
  #============================================================================
  # Repair Currency. Determine Calestians currency or use gold
  #============================================================================
  def repair_currency
    @note =~ /<repair[-_ ]?currency:\s*(.*)\s*>/i ? @repair_currency = $1.to_i : @repair_currency = 0
    @repair_currency
  end
end
#==============================================================================
# ■ Armor specify settings
#==============================================================================
class RPG::Armor
  #============================================================================
  # Partial Repair. for repairing equipment a small amount
  #============================================================================
  def partial_repair(amount = 0)
    @durability += amount
    @durability = max_durability if @durability > max_durability
    refresh_name
    refresh_price
  end
  #============================================================================
  # Damage_Durability
  #============================================================================
  def damage_durability(amount = 0)
    @durability -= amount
    @durability = 0 if @durability < 0
    refresh_name
    refresh_price
  end
  #============================================================================
  # Repair point - finds cost of repairing one point
  #============================================================================
  def repair_point
    adjust = max_durability - @durability
    return @price / 100 if adjust == 0
    return ((@non_durability_price - @price) / adjust).to_i
  end
  #============================================================================
  # Base Cost of repair
  #============================================================================
  def base_cost
    return @non_durability_price / @max_durability
  end
  #============================================================================
  # Repair Currency. Determine Calestians currency or use gold
  #============================================================================
  def repair_currency
    @note =~ /<repair[-_ ]?currency:\s*(.*)\s*>/i ? @repair_currency = $1.to_i : @repair_currency = 0
    @repair_currency
  end
end
