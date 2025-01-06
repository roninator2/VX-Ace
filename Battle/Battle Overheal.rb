# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Battle Overheal - no state             ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║  HP goes above max in battle                  ║    18 Sep 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Make Hp go above MHP in battle                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Plug and play                                                    ║
# ║   Effects are temporary                                            ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 18 Sep 2023 - Script finished                               ║
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

module BattleManager
  class << self
    alias :pro_vic :process_victory
    alias :pro_esp :process_escape
    alias :pro_abt :process_abort
  end
 
  #--------------------------------------------------------------------------
  # * Victory Processing
  #--------------------------------------------------------------------------
  def self.process_victory
    reset_hp
    pro_vic
  end
  #--------------------------------------------------------------------------
  # * Escape Processing
  #--------------------------------------------------------------------------
  def self.process_escape
    reset_hp
    pro_esp
  end
  #--------------------------------------------------------------------------
  # * Abort Processing
  #--------------------------------------------------------------------------
  def self.process_abort
    reset_hp
    pro_abt
  end
  #--------------------------------------------------------------------------
  # * Reset HP
  #--------------------------------------------------------------------------
  def self.reset_hp
    $game_party.members.each do |act|
      act.hp = act.mhp if act.hp > act.mhp
    end
  end
end

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    state_resist_set.each {|state_id| erase_state(state_id) }
    if SceneManager.scene_is?(Scene_Battle)
      if self.is_a?(Game_Actor)
        if self.hp > self.mhp
          @hp = [@hp, mhp].max
        else
          @hp = [[@hp, mhp].min, 0].max
        end
      else
        @hp = [[@hp, mhp].min, 0].max
      end
    else
      @hp = [[@hp, mhp].min, 0].max
    end
    @mp = [[@mp, mmp].min, 0].max
    @hp == 0 ? add_state(death_state_id) : remove_state(death_state_id)
  end
end
