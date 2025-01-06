# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: HIME's Dynamic Equip Slots - Add-on    ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Alter Slot Additions                        ║    18 Aug 2019     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: HIME's Dynamic Equip Slots                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Created notetag to add slots by level                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Notetag actors as many times as you require with the following:  ║
# ║     * <add slot: Level, etype_id>                                  ║
# ║     * e.g. <add slot: 5, 4>                                        ║
# ║   This will add a slot type 4 to the actor when reaching level 5   ║
# ║                                                                    ║
# ║   Where `etype_id` is the equip type ID.                           ║
# ║   By default, they are as follows:                                 ║
# ║         0 - weapon                                                 ║
# ║         1 - shield                                                 ║
# ║         2 - headgear                                               ║
# ║         3 - bodygear                                               ║
# ║         4 - accessory                                              ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 18 Aug 2019 - Script finished                               ║
# ║ 1.00 - 22 Aug 2019 - Added Features                                ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Tsukihime                                                        ║
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

module TH
  module Dynamic_Equip_Slots
    Regexlevel = /<add[-_ ]slot:[-_ ](\d+*)\,*.*?(\d+*)>/i
    PlayCustSnd = true
    PlaySnd = true
    Equip_sound_effect  = ["Chime2", 80, 115]
    Gained_Slot_Text     = "%s has gained an equipment slot!"
    Showtxt = true
  end
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_slot_script
  #--------------------------------------------------------------------------
  # * required
  #   This method checks for the existance of the basic module and other
  #   VE scripts required for this script to work, don't edit this
  #--------------------------------------------------------------------------
  def self.required(name, req, type = nil)
    if !$imported["TH_DynamicEquipSlots"]
      msg = "The script '%s' requires the script\n"
      msg += "'HIME Dynamic Equip Slots' above to work properly"
      msgbox(sprintf(msg, self.script_name(name)))
      exit
    end
  end
  #--------------------------------------------------------------------------
  # * script_name
  #   Get the script name base on the imported value, don't edit this
  #--------------------------------------------------------------------------
  def self.script_name(name, ext = nil)
    name = name.to_s.gsub("_", " ").upcase.split
    name.collect! {|char| char == ext ? "#{char} -" : char.capitalize }
    name.join(" ")
  end
end

$imported = {} if $imported.nil?
$imported["TH_DynamicEquipSlots_Level_Addon"] = true
R2_slot_script.required("TH_DynamicEquipSlots_Level_Addon", "TH_DynamicEquipSlots", :above)

module RPG
  class Actor
    attr_reader :level
    def load_notetag_level_equip_slots
      results = self.note.scan(TH::Dynamic_Equip_Slots::Regexlevel)
      results.each do |res|
        if $game_actors[@id].level == res[0].to_i
          $game_actors[@id].add_equip_slot(res[1].to_i)
          if TH::Dynamic_Equip_Slots::PlayCustSnd
            RPG::SE.new(*TH::Dynamic_Equip_Slots::Equip_sound_effect).play
          elsif TH::Dynamic_Equip_Slots::PlaySnd
            Sound.play_equip
          end
          if TH::Dynamic_Equip_Slots::Showtxt
            $game_message.add(sprintf(TH::Dynamic_Equip_Slots::Gained_Slot_Text, @name))
          end
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
