# )----------------------------------------------------------------------------(
# )--     AUTHOR:     Mr Trivel                                              --(
# )--     NAME:       Hurt Sounds Mod by Roninator2                          --(
# )--     CREATED:    2020-10-10                                             --(
# )--     VERSION:    1.2                                                    --(
# )--     Request by: Rimaka                                                 --(
# )----------------------------------------------------------------------------(
# )--                         VERSION HISTORY                                --(
# )--  1.0 - Initial scream.                                                 --(
# )--  1.1 - No more screaming on healing.                                   --(
# )--  1.2 - Randomize and multiple sounds.                                  --(
# )----------------------------------------------------------------------------(
# )--                          DESCRIPTION                                   --(
# )--  Enemies and actors will play Sound Effect when getting hit.           --(
# )----------------------------------------------------------------------------(
# )--                          INSTRUCTIONS                                  --(
# )--  Add <Hurt: SE_name, volume, pitch, %chance to play, force play>       --(
# )--  to your Actor or Enemy note box.                                      --(
# )--  Example: <Hurt: Bite, 100, 100, 40, true>                             --(
# )--  If force play is true and random chance fails to play a sound,        --(
# )--  the sound that is specified as forced will play                       --(
# )--  only specify one sound to force play                                  --(
# )--  Place multiple tags to use more than one sound                        --(
# )----------------------------------------------------------------------------(
# )--                          LICENSE INFO                                  --(
# )--   Free for commercial and non-commercial games as long as credit is    --(
# )--   given to Mr. Trivel.                                                 --(
# )----------------------------------------------------------------------------(
module R2_trivel_hurt_sound
	CHANCE = 35
end
# )----------------------------------------------------------------------------(
# )--  Class: Game_Battler                                                   --(
# )----------------------------------------------------------------------------(
class Game_Battler < Game_BattlerBase
  alias :mrts_hurt_execute_damage :execute_damage
 
  # )--------------------------------------------------------------------------(
  # )--  Alias Method: execute_damage                                        --(
  # )--------------------------------------------------------------------------(
  def execute_damage(user)
    mrts_hurt_execute_damage(user)
    return unless @hurt_sound && @result.hp_damage > 0
		for c in 0..@hurt_sound.size - 1
			if @hurt_sound[c][4] == true
				play = true
				pos = c
			end
			num = rand(100)
			s = rand(@hurt_sound.size)
			if user.hp <= 0 && num < @death_sound[3]
				Audio.se_play(@death_sound[0], @death_sounds[1], @death_sound[2])
				break
			end
			if num < @hurt_sound[s][3]
				Audio.se_play(@hurt_sound[s][0], @hurt_sounds[s][1], @hurt_sound[s][2])
				break
			elsif play == true
				Audio.se_play(@hurt_sound[pos][0], @hurt_sounds[pos][1], @hurt_sound[pos][2])
			end
		end
  end
end
 
# )----------------------------------------------------------------------------(
# )--  Class: Game_Actor                                                     --(
# )----------------------------------------------------------------------------(
class Game_Actor < Game_Battler
  alias :mrts_hurt_setup :setup
 
  # )--------------------------------------------------------------------------(
  # )--  Alias Method: setup                                                 --(
  # )--------------------------------------------------------------------------(
  def setup(actor_id)
    mrts_hurt_setup(actor_id)
    results = actor.note.scan(/<Hurt:[ ]*(\w*),[ ]*(\d*),[ ]*(\d+),[ ]*(\d+),[ ]*(\w*)>/i)
		results.each do |i|
			@hurt_sound << ["Audio/SE/"+$1, $2.to_i, $3.to_i, $4.to_i, $5]
		end
    actor.note.scan(/<Death:[ ]*(\w*),[ ]*(\d*),[ ]*(\d+),[ ]*(\d+)>/i)
    $1 ? @death_sound = ["Audio/SE/"+$1, $2.to_i, $3.to_i, $4.to_i] : @death_sound = nil
  end
end
 
# )----------------------------------------------------------------------------(
# )--  Class: Game_Enemy                                                     --(
# )----------------------------------------------------------------------------(
class Game_Enemy < Game_Battler
  alias :mrts_hurt_initialize :initialize
 
  # )--------------------------------------------------------------------------(
  # )--  Alias Method: initialize                                            --(
  # )--------------------------------------------------------------------------(
  def initialize(index, enemy_id)
    mrts_hurt_initialize(index, enemy_id)
		results = enemy.note.scan[/<Hurt:[ ]*(\w*),[ ]*(\d*),[ ]*(\d+),[ ]*(\d+)>/i]
		results.each do |i|
		  @hurt_sound << ["Audio/SE/"+$1, $2.to_i, $3.to_i, $4.to_i]
		end
    enemy.note.scan(/<Death:[ ]*(\w*),[ ]*(\d*),[ ]*(\d+),[ ]*(\d+)>/i)
    $1 ? @death_sound = ["Audio/SE/"+$1, $2.to_i, $3.to_i, $4.to_i] : @death_sound = nil
  end
end
