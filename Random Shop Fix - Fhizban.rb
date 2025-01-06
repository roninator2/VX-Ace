# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Random Shop Fix                        ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Compatibility for Hime and Fhizban            ║    26 May 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires:                                                          ║
# ║   Script order                                                     ║
# ║     Galv's Random Loot                                             ║
# ║     Hime Shop Manager                                              ║
# ║     Hime Shop Stock                                                ║
# ║     Fhizban Random Shop                                            ║
# ║     This fix                                                       ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Compatibility fix                                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Set switch number below                                          ║
# ║     Used to control if loading Hime Shop or Fhizban                ║
# ║                                                                    ║
# ║   Set option to show a message when the random shop                ║
# ║     does not produce any items                                     ║
# ║   Set message for empty shop                                       ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 26 May 2023 - Script finished                               ║
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

module R2_Fhizban_Hime_Random_Shop_Fix
  # Switch to activate random shop and not shop manager
  Switch = 5
  # show message that the shop is empty
  Show_Message = false
  Shop_Message = "The Shop is Empty"
end

#==============================================================================
# ** Game_Interpreter
#==============================================================================
class Game_Interpreter
  def random_shop(type, rarity_min, rarity_max, price=0, amount=0, subtype=0, family=0)
      $game_switches[R2_Fhizban_Hime_Random_Shop_Fix::Switch] = true
    
    @goods = []
    @loot = []
    
    #--- Determine Type
    if type == 0
      @loot = $data_items + $data_armors + $data_weapons
      subtype = 0
    elsif type == 1
      @loot = $data_items
      @itemtype = 0
      subtype = 0
    elsif type == 2
      @loot = $data_armors
      @itemtype = 2
    elsif type == 3
      @loot = $data_weapons
      @itemtype = 1
    else
      @loot = $data_items | $data_armors | $data_weapons
      subtype = 0
    end
 
    #--- Preperations
    @loot.shuffle
    rarity_max = rarity_min if rarity_max < rarity_min
    amount = Random_Shop::DEFAULT_AMOUNT if amount < 1
    subtype = 0 if subtype < 0 || subtype > 99
    subtype = 0 if family < 0 || family > 99
  
    #--- Determine Party Luck Bonus
    mem = 0
    eqs = 0
    luck_bonus = 0
    i = 0
    no_equips = $game_party.members.count * $game_party.members[0].equips.count
    $game_party.members.each do |mem|
      mem.equips.each do |eq|
        next if eq.nil?
        luck_bonus += eq.loot_lucky
      end
    end
        
    #--- Determine Rarity Chance
    checked = 0
    inventory = 0
    itemprice = 0
    duplicates = []
    restart = false
    continue = true
    no_items = @loot.count - 1
    rare_chance = rand(rarity_max - rarity_min) + rarity_min + luck_bonus + 1
    random_item = rand(no_items) + 1
    begin_count = rand(no_items) + 1

    #--- Determine Random Item
    no_items.times do |i|
      i = i + random_item
      begin_count += 1 if restart
      if i > no_items
        i = i - i + rand(no_items) + 1
        restart = true
      end
    
      #--- Get Random Item
      if family != 0 && @loot[i].loot_family != family
        continue = false
      end
      if subtype != 0 && type == 2
        if @loot[i].atype_id == subtype
          continue = false
        end
      end
      if subtype != 0 && type == 3
        if @loot[i].wtype_id == subtype
          continue = false
        end
      end

      #--- Setup Shop Inventory
      if continue
        next if @loot[i].nil?
        next if @loot[i].loot_noshop
        if @loot[i].loot_level_max >= $game_party.leader.level && 
          @loot[i].loot_level_min <= $game_party.leader.level
          if @loot[i].loot_rarity <= rare_chance
            if checked < no_items && inventory < amount
              if !duplicates.include?(@loot[i].id)
                #--- Recheck Item Type
                if @loot[i].is_a?(RPG::Item)
                  @itemtype = 0
                elsif @loot[i].is_a?(RPG::Weapon)
                  @itemtype = 1
                elsif @loot[i].is_a?(RPG::Armor)
                  @itemtype = 2
                end
                
                #--- Check Item Price
                if price != 0
                  itemprice = @loot[i].price + (@loot[i].price * (price/100))
                end
                if price <= 0
                  @goods.push([@itemtype, @loot[i].id, 0])
                else
                  @goods.push([@itemtype, @loot[i].id, 1, itemprice])
                end
                duplicates.push(@loot[i].id)
                inventory += 1
              end
            else
              break
            end
          end
        end
      end
      checked += 1
    end
    if @goods.size == 0 && R2_Fhizban_Hime_Random_Shop_Fix::Show_Message == true
      $game_message.add(R2_Fhizban_Hime_Random_Shop_Fix::Shop_Message)
    end

    if @goods.size > 0
      @goods.shuffle
      SceneManager.call(Scene_Shop)
      SceneManager.scene.prepare_original(@goods, true)
    end

  end
end # Game_Interpreter

#==============================================================================
# ** Window_ShopBuy
#==============================================================================

class Window_ShopBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    if $game_switches[R2_Fhizban_Hime_Random_Shop_Fix::Switch] == true
      item && price(item) <= @money && !$game_party.item_max?(item)
    else
      return false unless @goods[item].enable?
      th_shop_manager_enable?(item)
    end
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    if $game_switches[R2_Fhizban_Hime_Random_Shop_Fix::Switch] == true
      @data = []
      @price = {}
      @shop_goods.each do |goods|
        case goods[0]
        when 0;  item = $data_items[goods[1]]
        when 1;  item = $data_weapons[goods[1]]
        when 2;  item = $data_armors[goods[1]]
        end
        if item
          @data.push(item)
          @price[item] = goods[2] == 0 ? item.price : goods[3]
        end
      end
    else
      @data = []
      @goods = {}
      @price = {}
      @shop_goods.each do |shopGood|
        next unless include?(shopGood)
        item = shopGood.item
        @data.push(item)
        @goods[item] = shopGood
        @price[item] = shopGood.price
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    if $game_switches[R2_Fhizban_Hime_Random_Shop_Fix::Switch] == true
      item = @data[index]
      rect = item_rect(index)
      draw_item_name(item, rect.x, rect.y, enable?(item))
      rect.width -= 4
      draw_text(rect, price(item), 2)
    else
      th_shop_stock_draw_item(index)
      rect = item_rect(index)
      item = @data[index]
      shopGood = @goods[item]
      draw_text(rect, shopGood.stock, 1) unless shopGood.unlimited?
    end
  end
end

#==============================================================================
# ** Scene_Shop
#==============================================================================

class Scene_Shop < Scene_MenuBase
  #--------------------------------------------------------------------------
  # Adjusted. The scene now takes a Game_Shop object
  #--------------------------------------------------------------------------
  def prepare_original(goods, purchase_only)
    @goods = goods
    @purchase_only = purchase_only
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  alias r2_create_command_compat_fix  create_command_window
  def create_command_window
    r2_create_command_compat_fix
    @command_window.set_handler(:cancel, method(:close_compat))
  end
  def close_compat
    $game_switches[R2_Fhizban_Hime_Random_Shop_Fix::Switch] = false
    return_scene
  end
end
