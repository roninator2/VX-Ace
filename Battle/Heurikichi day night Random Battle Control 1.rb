# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Random Day Battle                      ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Set specific troops for                     ╠════════════════════╣
# ║   battles during the day or night             ║    01 Nov 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires:                                                          ║
# ║       Heurikichi day/night script                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║      Control Troops to specific time of day                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Place below Heurikichi day/night script                          ║
# ║   Specify in the map, the note tag stating                         ║
# ║   which troops will be at what time                                ║
# ║      Map has 12 troops in the list                                 ║
# ║   <RDB: Time, troop 1 id, troop 2 id, etc>                         ║
# ║   <RDB: 6, 1, 2, 3>                                                ║
# ║   <RDB: 12, 4, 5, 6>                                               ║
# ║   <RDB: 18, 7, 8, 9>                                               ║
# ║   <RDB: 24, 10, 11, 12>                                            ║
# ║                                                                    ║
# ║  Hour is checked from 0 forward.                                   ║
# ║  So if it is 1500, then the third one will take action             ║
# ║  0-6 = false, 7-12 = false, 13-18 = true, 19-24 = false            ║
# ║                                                                    ║
# ║  You can split is up as much as you want.                          ║
# ║  * note that is you have 2 troops and specifiy them                ║
# ║    as <RTB: 1, 1, 2, 3>                                            ║
# ║    then the battle will only occur between 0000 and 0100           ║
# ║    and it will not do any other battle                             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║   2022-Jul-04 - Initial publish                                    ║
# ║   2022-Jul-04 - Bug fixes                                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Heurikichi                                                       ║
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


module R2_RDB_MAP
  RDB = /<RDB:[ ]*(\d+(?:\s*,\s*\d+)*)>/i
  Time_Intervals = 6 # needs to be set intervals that work with your note tags
end
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class RPG::Map
  attr_accessor :random_day_battle
  attr_accessor :random_day_battle_time
  def load_notetags_rdb
    r2td = {}
    r2data = []
    @random_day_battle_time = []
    @random_day_battle = []
    i = 0
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when R2_RDB_MAP::RDB
        $1.scan(/\d+/).each { |num|
        r2data.push(num.to_i) if num.to_i > 0 }
      end
      r2td[i] = r2data
      r2data = []
      i += 1
    }
    i = 0
    return if r2td.empty?
    r2td.each_value do |r2se|
      @random_day_battle_time[i] = r2se[0]
      adj = r2se
      adj.shift
      @random_day_battle[i] = adj
      i += 1
    end
  end
end

class Game_Map
  attr_accessor :random_day_battle
  attr_accessor :random_day_battle_time
  alias game_map_setup_rdb setup
  def setup(map_id)
    game_map_setup_rdb(map_id)
    @map.load_notetags_rdb
    @random_day_battle = @map.random_day_battle
    @random_day_battle_time = @map.random_day_battle_time
  end
end

class Game_Player < Game_Character
  def make_encounter_troop_id
    encounter_list = []
    weight_sum = 0
    rdb = false
    @timebattleid = -1
    etime = $game_clock.hour24
    btime = $game_clock.hour24 - R2_RDB_MAP::Time_Intervals
    btime = 0 if btime < 0
    if $game_map.random_day_battle == []
      $game_map.encounter_list.each do |encounter|
        next unless encounter_ok?(encounter)
        encounter_list.push(encounter)
        weight_sum += encounter.weight
      end
    else
      $game_map.random_day_battle_time.each_with_index do |cl, b|
        if (cl < etime) 
          if (cl > btime)
          @timebattleid = b
          end
        end
        rdb = true if cl != nil
      end
      $game_map.encounter_list.each do |encounter|
        next unless encounter_ok?(encounter)
        if rdb == true
          next if !$game_map.random_day_battle[@timebattleid].include?(encounter.troop_id)
        end
        encounter_list.push(encounter)
        weight_sum += encounter.weight
      end
    end
    if weight_sum > 0
      value = rand(weight_sum)
      encounter_list.each do |encounter|
        value -= encounter.weight
        return encounter.troop_id if value < 0
      end
    end
    return 0
  end
end
