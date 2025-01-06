# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Damage Repair                ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║   Allow repair and damage           ╠════════════════════╣
# ║   of weapons and armor              ║    26 Dec 2020     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Script addon to allow for damaging of items or           ║
# ║ partial repair of items or specifying                    ║
# ║ what currency to use for a specific item                 ║
# ║                                                          ║
# ║ Turn switches on to enable Damage and Partial Repair     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Follow the Original Authors terms   ║
# ╚═════════════════════════════════════╝

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
    Gold_Icon = 361
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
  # Create cost (number) window
  #============================================================================
  def create_cost_window
    wy = @command_window.y
    wh = 160
    @cost_window = Window_ShopNumber.new(50, wy, wh)
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
    when :partial
        @cost_window.set(item, item.max_durability - item.durability, item.repair_point, $game_party.gold)
      @cost_window.show.activate
    when :damage
        @cost_window.set(item, item.durability, item.repair_point, $game_party.gold)
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
    when :damage
      previous = item.repair_price
      item.damage_durability(@cost_window.number)
      current = item.repair_price
      $game_party.gain_gold((current - previous)/2)
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
# ■ Window_ShopNumber
#==============================================================================
class Window_ShopNumber < Window_Selectable
  attr_accessor :damage_price
  #============================================================================
  # Draw the total cost for repair
  #============================================================================
  def draw_total_price
    width = contents_width - 8
    icon_index = TH_Instance::Scene_Repair::Gold_Icon
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
      draw_currency_value(@price * @number, icon, -15, price_y, width)
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
    return true if item.is_a?(RPG::EquipItem) && item.can_repair? && $game_party.gold >=  item.repair_price
    return true if @equip_damage
    return true if @partial_repair && item.can_repair? && 
    $game_party.gold >= item.repair_point
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
          @help_window.set_text(TH_Instance::Scene_Repair::Damage_Item + base_cost.to_s + "\nfor each point of damage")
        else
          @help_window.set_text(TH_Instance::Scene_Repair::Can_Not_Repair)
        end
      else
        if partial_repair          
          @help_window.set_text(TH_Instance::Scene_Repair::Selected_Item + base_cost.to_s + " for each point of repair")
        elsif equip_damage
          base_cost = base_cost / 2
          @help_window.set_text(TH_Instance::Scene_Repair::Damage_Item + base_cost.to_s + "\nfor each point of damage")
        else
          @help_window.set_text(TH_Instance::Scene_Repair::Selected_Item + base_cost.to_s + " for each point of repair")
        end
      end
    end
  end
  #============================================================================
  # Include
  #============================================================================
  def include?(item)
    !item.is_a?(RPG::Item) && !item.nil? && (item.use_durability || equip_damage)
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
end
