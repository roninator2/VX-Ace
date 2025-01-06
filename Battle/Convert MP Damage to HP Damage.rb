# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Convert MP Damage            ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Convert MP damage to HP damage      ║    01 Nov 2020     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ When you have a weapon or skills that does MP damage     ║
# ║ and during the course of a battle, the enemy has no      ║
# ║ MP left, then the damage will convert to HP.             ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Free for all uses in RPG Maker      ║
# ╚═════════════════════════════════════╝
class Game_ActionResult
  def make_damage(value, item)
    @critical = false if value == 0
    @hp_damage = value if item.damage.to_hp?
    @mp_damage = value if item.damage.to_mp?
    @mp_damage = [@battler.mp, @mp_damage].min
    if @mp_damage <= 0 && item.damage.to_mp?
      @hp_damage = value
      @success = true
    end
    @hp_drain = @hp_damage if item.damage.drain?
    @mp_drain = @mp_damage if item.damage.drain?
    @hp_drain = [@battler.hp, @hp_drain].min
    @success = true if item.damage.to_hp? || @mp_damage != 0
  end
end
