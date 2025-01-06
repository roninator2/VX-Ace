=begin
#=====================================================================
#   HIME's Dynamic Equip Slots - Add-on
#   Version 1.0.01
#   Author: Roninator2
#   Date: 18 Aug 2019
#   Latest: 18Aug 2019
#=====================================================================#
#   UPDATE LOG
#---------------------------------------------------------------------#
# 18 Aug 2019 - Created notetag to add slots by level
#=====================================================================#
#       NOTETAGS
#=====================================================================#

Notetag actors as many times as you require with the following:

    * <add slot: Level, etype_id>
    * e.g. <add slot: 5, 4>
 Where `etype_id` is the equip type ID. By default, they are as follows:
   0 - weapon
   1 - shield
   2 - headgear
   3 - bodygear
   4 - accessory
 
=end

module TH
  module Dynamic_Equip_Slots
    Regexlevel = /<add[-_ ]slot:[-_ ](\d+*)\,*.*?(\d+*)>/i
  end
end

module RPG
  class Actor
    attr_reader :level
    def load_notetag_level_equip_slots
      results = self.note.scan(TH::Dynamic_Equip_Slots::Regexlevel)
      results.each do |res|
        if $game_actors[@id].level == res[0].to_i
          $game_actors[@id].add_equip_slot(res[1].to_i)
        end
      end
    end
  end
end

class Game_Actor < Game_Battler
  alias :r2_level_up_97bfu  :level_up
  def level_up
    r2_level_up_97bfu
    actor.load_notetag_level_equip_slots
  end
end
