# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Achievement switch           ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║ Calestians Achievement System -     ╠════════════════════╣
# ║ Add a switch                        ║    01 Nov 2020     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Add in a switch to the Achievement data and then         ║
# ║ you can hide the achievement until the switch is on      ║
# ║                                                          ║
# ║ For example                                              ║
# ║    1 => {                                                ║
# ║      :Name              => "Treasure Hunter",            ║
# ║      :Tiers             => [50, 100, 150, 200, 250],     ║
# ║      :Help              => "Find Treasures",             ║
# ║      :Title             => "Treasure Sluth",             ║
# ║      :RewardItem        => :none,                        ║
# ║      :RewardGold        => :none,                        ║
# ║      :Category          => "General",                    ║
# ║      :AchievementPoints => :none,                        ║
# ║      :Prerequisite      => :none,                        ║
# ║      :Repeatable        => 5,                            ║
# ║      :Switch            => 15,                           ║
# ║    },                                                    ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Follow the Original Authors terms   ║
# ╚═════════════════════════════════════╝
module Clstn_Achievement_System
  
  def self.get_category_achievements
    category = []
    Achievement_Categories.each { |key|
      temp = []
      Achievements.each_value { |value|
        temp.push(value[:Name]) if (value[:Category] == key[0]) &&
        ($game_switches[value[:Switch]] == true)
      }
      category.push(temp.empty? ? 0 : temp)
    }
    return category
  end

end
