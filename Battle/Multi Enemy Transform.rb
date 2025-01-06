# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Multi Enemy Transform                  ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Transform Enemy when dead with state          ║    30 Apr 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Enemy transforms with state after death                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure Hash below to you preference                           ║
# ║   When the state is applied to the enemy,                          ║
# ║   the enemy will transform into a random enemy specified           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
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

module R2_Multi_Transform
  # { state id => [ enemy id 1, enemy id 2, enemy id 3, ... ] }
  State1 = { 10 => [ 15,16,17 ] }
  State2 = { 11 => [ 18,19,20 ] }
  State3 = { 28 => [ 3,4,5 ] }
end

class Game_Battler
  alias r2_check_state_transform_death execute_damage
  def execute_damage(user)
    @infected_states = self.states
    r2_check_state_transform_death(user)
    check_enemy_transform
    @infected_states = nil
  end
  def check_enemy_transform
    return if self.is_a?(Game_Actor) || self.hp > 0
    infected = []
    @infected_states.each do |state|
      infected << state.id
    end
    @tren = nil
    R2_Multi_Transform.constants.each do |i|
      hash_check = R2_Multi_Transform.const_get(i).to_hash
      state_check = hash_check.keys[0]
      @tren = hash_check.values[0] if infected.include?(state_check)
    end
    if !@tren.nil?
      tren = @tren.sample
    end
    remove_state(death_state_id) if @tren != nil
    transform(tren) if @tren != nil
    recover_all if @tren != nil
    @tren = nil
  end
end
