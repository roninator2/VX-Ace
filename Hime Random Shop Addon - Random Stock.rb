# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Hime Random Shop + Stock     ║  Version: 1.04.1   ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Random Shop for Hime Shop Manager   ║    11 Jul 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║   Script order                                           ║
# ║     Galv's Random Loot                                   ║
# ║     Hime Shop Manager                                    ║
# ║     Hime Shop Stock                                      ║
# ║     This Script                                          ║
# ║                                                          ║
# ║   Script Call                                            ║
# ║     random_shop(type, # of items, Quantity minimum,      ║
# ║         Quantity maximum, Shop ID, Sell Only,            ║
# ║          Family, Rarity, Rarity min, Rarity Max )        ║
# ║                                                          ║
# ║     type = 0 -> items                                    ║
# ║            1 -> weapons                                  ║
# ║            2 -> armours                                  ║
# ║            3 -> mix of all three                         ║
# ║                                                          ║
# ║     # of items is how many items to have in the shop     ║
# ║                                                          ║
# ║     Quantity is the minimum and maximum number available ║
# ║       for each item in the shop.                         ║
# ║                                                          ║
# ║     Shop ID is the number used to register with the shop ║
# ║       manager script.                                    ║
# ║                                                          ║
# ║     Sell only is to specify is the player can only buy.  ║
# ║                                                          ║
# ║     Family is the group of items that will be included.  ║
# ║                                                          ║
# ║     Rarity is the odds of it being in the shop           ║
# ║       values range from 1-100                            ║
# ║       Follow Galv's Random Loot settings                 ║
# ║                                                          ║
# ║     random_shop(3, 6, 1, 3, 45, true, 1, 5, 10, 70)      ║
# ║                                                          ║
# ║   If the shop number 45 exists then it will pull up that ║
# ║     shop and not create a new one.                       ║
# ║                                                          ║
# ║   Tag items in database with <random shop item>          ║
# ║     then it will be included as an item that can be      ║
# ║     selected for the random shop.                        ║
# ║                                                          ║
# ║                                                          ║
# ║   Reset Shops                                            ║
# ║     If you need to clear out a random shop, then you     ║
# ║     can use this script command                          ║
# ║         reset_shop(id)                                   ║
# ║     The id will be the shop id. Be careful this will     ║
# ║     also remove any shops created.                       ║
# ║   If you use the wrong number, it will remove that shop. ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║ 11 Jul 2023 - Initial Publish                            ║
# ║ 12 Jul 2023 - Added Galv Random Loot support             ║
# ║ 12 Jul 2023 - Added Resetting shops, fixed bug           ║
# ║ 13 Jul 2023 - Added sell shops, fixed bug                ║
# ║ 11 Nov 2023 - ReAdded random min/max                		 ║
# ║ 11 Nov 2023 - Altered Random to be independent functions ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except Nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#===============================================================================

module Random_Shop_Item_Tags
  def random_item
    if @random_shop_item.nil?
      if @note =~ /<random shop item>/i
        @random_shop_item = true
      else
        @random_shop_item = false
      end
    end
    @random_shop_item
  end
end

#===============================================================================
 
class RPG::Item
  include Random_Shop_Item_Tags
end
class RPG::Weapon
  include Random_Shop_Item_Tags
end
class RPG::Armor
  include Random_Shop_Item_Tags
end

#===============================================================================

module ShopManager
  def self.reset_shop(shop_id)
    $game_shops[shop_id] = nil
  end
end

class Game_Interpreter
  def random_shop(type, num, min, max, shop_id, sell, family=0, rarity=0, rmin=0, rmax=0)
    # initialize local variables
    goods = []
    loot = []
    list = []
    stack = []
    # Check if shop exists
    shop = ShopManager.get_shop(shop_id)
    if shop == nil
      #--- Determine Type
      if type == 0
        loot = $data_items
      elsif type == 1
        loot = $data_weapons
      elsif type == 2
        loot = $data_armors
      elsif type == 3
        loot = $data_items + $data_weapons + $data_armors
      end
      # Get all qualifing items
      loot.each do |itm|
        next if itm.nil?
        if itm.random_item
          list.push(itm)
        end
      end
      # return if list is empty
      return if list.empty?
      # If family selection is used
      if family > 0
        # Select based on family
        list = list.select do |thing|
          thing.loot_family == family
        end
      end
      # return if list is empty
      return if list.empty?
      if rmax < rmin
        rmax = rmin
      end
      if rarity > 0
        list = list.select do |thing|
          (100 - (thing.loot_rarity.to_i * 10)) <= rand(100)
        end
	  end
      if (rmin > 0) || (rmax > 0)
	    luck_bonus = random_loot_luck_bonus()
	    rchance = rand(rmax - rmin) + rmin + luck_bonus + 1
        list = list.select do |thing|
          thing.loot_rarity <= rchance
        end
      end
      # return if list is empty
      return if list.empty?
      # Get list size
      cnt = list.size
      i = 0
      # find whichever is larger, list or number requested
      count = (cnt < num) ? cnt : num
      count.times do 
        # iterate through numbers if list is small
        if cnt < num
          n = i
        else
          n = rand(cnt)
        end
        item = list[n]
        while stack.include?(item) do
          n = rand(cnt)
          item = list[n]
        end
        # add item to checking list
        stack.push(item)
        # Get random item count
        q = rand(max) + 1
        @shop_stock[i] = q
        itype = 0 if item.is_a?(RPG::Item)
        itype = 1 if item.is_a?(RPG::Weapon)
        itype = 2 if item.is_a?(RPG::Armor)
        # create item for Hime's script
        good = make_good([itype, item.id, 0, item.price], i)
        goods.push(good)
        i += 1
      end
      # create shop
      shop = ShopManager.setup_shop(shop_id, goods, sell, :Shop)
      setup_shop(shop)
    end
    # Goto shop
    ShopManager.call_scene(shop)
    Fiber.yield
  end
  
  # Make a shop empty for recreating
  def reset_shop(id)
    ShopManager.reset_shop(id)
  end
end

#===============================================================================
# END OF SCRIPT
#===============================================================================
