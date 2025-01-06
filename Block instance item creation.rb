# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Block Instance Items         ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Allow some items to not be Instance ║    28 Apr 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║   Add note tag to the items that are to not become       ║
# ║   instance items.                                        ║
# ║   <instance_blocked>                                     ║
# ║   Non instance items will be treated like normal         ║
# ║   Required Tsukihime's Instance Items script             ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝

module RPG
  class Item < UsableItem
    attr_accessor :in_hand
    
    Instance_Blocked      = /<instance_blocked>/i
    def instance_blocked?
      self.note.split(/[\r\n]+/).each do |line|
        case line
        when Instance_Blocked
          return true
        end
      end
      return false
    end
    def in_hand
      @in_hand = 0 unless @in_hand
      return @in_hand
    end
  end
  
  class EquipItem < BaseItem    
    attr_accessor :in_hand
    
    Instance_Blocked      = /<instance_blocked>/i
    def instance_blocked?
      self.note.split(/[\r\n]+/).each do |line|
        case line
        when Instance_Blocked
          return true
        end
      end
      return false
    end
    
    def in_hand
      @in_hand = 0 unless @in_hand
      return @in_hand
    end
  end
end

class Game_Party < Game_Unit
  #-----------------------------------------------------------------------------
  # The gain item method performs various checks on the item that you want to
  # add to the inventory. Namely, it checks whether it is a template item or
  # an instance item, updates the item counts, and so on.
  #-----------------------------------------------------------------------------
  def gain_item(item, amount, include_equip = false)
    # special check for normal items
    if !instance_enabled?(item)
      th_instance_items_gain_item(item, amount, include_equip)
    else
      if item
        if amount > 0
          amount.times do |i|
            new_item = get_instance(item)
            if item.instance_blocked?
              add_instance_blocked_item(item)
            else
              add_instance_item(new_item)
            end
          end
        else
          amount.abs.times do |i|
            item_template = get_template(item)
            if item.is_template?
              # remove using template rules. If an item was lost, then decrease
              # template count by 1.
              lose_template_item(item, include_equip)
            else
              # remove the instance item, and decrease template count by 1
              if item.instance_blocked?
                lose_instance_blocked_item(item)
              else
                lose_instance_item(item)
              end
            end
          end
        end
      else
        th_instance_items_gain_item(item, amount, include_equip)
      end
    end
  end
  #-----------------------------------------------------------------------------
  # New. Adds the instance item to the appropriate list
  #-----------------------------------------------------------------------------
  def add_instance_blocked_item(item)
    container = item_container(item.class)
    container[item.template_id] ||= 0
    container[item.template_id] += 1
    container[item.in_hand] ||= 0
    container[item.in_hand] += 1 if container[item.in_hand] == 0
    container_list = item_container_list(item)
    if container_list == []
      container_list.push(item) 
    else
      item_found = false
      container_list.each do |itm|
        if item.template_id == itm.template_id
          itm.in_hand += 1 if itm.in_hand == 0
          itm.in_hand += 1
          item_found = true
        end
      end
      container_list.push(item) if !item_found
    end
  end
  
  #-----------------------------------------------------------------------------
  # New. Lose an instance item. Simply delete it from the appropriate container
  # list
  #-----------------------------------------------------------------------------
  def lose_instance_blocked_item(item)
    container = item_container(item.class)
    container[item.template_id] ||= 0
    container[item.template_id] -= 1
    container[item.in_hand] -= 1
    container_list = item_container_list(item)
    container_list.each do |itm|
      if item.template_id == itm.template_id
        itm.in_hand -= 1
        if itm.in_hand == 0
          container_list.delete(item)
        end
      end
    end
  end
end
