# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Split Damage on Skills                 ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Split damage amongst enemy targets            ║    24 Jan 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Skills can split the damage amongst the enemies              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Use <split damage> to have a skill split the damage              ║
# ║   for the enemies targeted. i.e. target 2 random, split 2          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 24 Jan 2022 - Script finished                               ║
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

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Calculate Damage
  #--------------------------------------------------------------------------
  alias r2_make_damage_split_troop  make_damage_value
  def make_damage_value(user, item)
    r2_make_damage_split_troop(user, item)
    value = @result.hp_damage
    return if value == 0
    split = item.note =~ /<split damage>/i ? true : false
    enmysz = $game_troop.alive_members.size.to_i
    enmy = 0
    case item.scope
    when 1 || 3
      enmy = 1
    when 2
      enmy = $game_troop.alive_members.size.to_i
    when 4
      enmy = 2
      enmy = enmysz if enmysz < enmy
    when 5
      enmy = 3
      enmy = enmysz if enmysz < enmy
    when 6
      enmy = 4
      enmy = enmysz if enmysz < enmy
    end
    value = value / enmy if (enmy > 0) && (split == true)
    @result.make_damage(value.to_i, item)
  end
end
