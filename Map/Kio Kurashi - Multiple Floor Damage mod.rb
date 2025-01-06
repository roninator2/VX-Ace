#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Damage for more types of Floors Script v 1.2
#Author = Kio Kurashi
#Credit = Kio Kurashi
#Modded by Roninator2
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Notes:
#  Currently this script only works for three types of Floor damage. It doesn't
#  nessesarily need to be Poison, Lava, and Shock, however. If more than the
#  provided number of Floors are needed I can add more. 
#  Options added to allow inflicting states when damaged
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Instructions:
#  The editable section is directly bellow. For each you will have a Terrain tag,
#  and a Damage ammount. The Terrain tag will be a number between 0 and 7.
#  as the number on the tiles. Damage will be the Base damage that is
#  applied for each number.
#Important:
#  The map tileset must be properly configured.
#  The tile that will be a damage tile must be marked as a damage tile. go figure
#  The tile must also have the terrain tag matching the settings below.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Update: 
#  The script will now apply a damage effect at the specified interval
#  60 = 1 second
#  Also available is a switch to turn the interval damage off.
#  Turn switch on to stop interval damage.
#~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~     BEGINING OF EDITABLE SECTION
#~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module R2_Floor_Damage
  
NORMAL_TERRAIN_REGION = 0
NORMAL_TERRAIN_DAMAGE = 0
 
POISON_TERRAIN_REGION = 1   # Poison terrain tag
POISON_TERRAIN_DAMAGE = 10  # Poison damage
CHANCE_POISON = 15          # Chance to inflict poison
POISON_STATE = 2            # Poison state

LAVA_TERRAIN_REGION = 2     # Burn terrain tag
LAVA_TERRAIN_DAMAGE = 40    # Burn damage
CHANGE_BURN = 25            # Chance to inflict burn
BURN_STATE = 25             # Burn state

SHOCK_TERRAIN_REGION = 3    # Shock terrain tag
SHOCK_TERRAIN_DAMAGE = 20   # Shock damage
CHANGE_SHOCK = 50           # Chance to inflict shock
SHOCK_STATE = 35            # Shock state

FDR_DAMAGE_INT = 60         # interval at which the damage effect will apply again.
FDR_DAMAGE_SWITCH = 151     # Turn switch on to turn off interval damage

BLOCK_STATES = [160, 190]   # States that will block damage
INFLICT_STATE = 191         # Switch used to inflict states

end
#~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~     END OF EDITABLE SECTION
#~       Editing beyond this point without prior knowledge is dangerous!!
#~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
class Game_Actor
  def basic_floor_damage
    case $game_map.terrain_tag($game_player.x, $game_player.y)
    when R2_Floor_Damage::NORMAL_TERRAIN_REGION
      return R2_Floor_Damage::NORMAL_TERRAIN_DAMAGE
    when R2_Floor_Damage::POISON_TERRAIN_REGION
      return R2_Floor_Damage::POISON_TERRAIN_DAMAGE
    when R2_Floor_Damage::LAVA_TERRAIN_REGION
      return R2_Floor_Damage::LAVA_TERRAIN_DAMAGE
    when R2_Floor_Damage::SHOCK_TERRAIN_REGION
      return R2_Floor_Damage::SHOCK_TERRAIN_DAMAGE
    when nil
      return 10
    end
  end
end

class Game_Player < Game_Character
  alias r2_fdr_initialize initialize
  def initialize
    @standingtime = 0
    r2_fdr_initialize
  end
  alias r2_input_move_fdr move_by_input
  def move_by_input
    @standingtime = 0 if $game_player.moving?
    r2_input_move_fdr
  end
  alias r2_fdr_update_nonmoving update_nonmoving
  def update_nonmoving(last_moving)
    if !$game_switches[R2_Floor_Damage::FDR_DAMAGE_SWITCH]
      @standingtime += 1 if !$game_map.interpreter.running?
      actor.check_floor_effect if @standingtime > R2_Floor_Damage::FDR_DAMAGE_INT 
      @standingtime = 0 if @standingtime > R2_Floor_Damage::FDR_DAMAGE_INT
    end
    r2_fdr_update_nonmoving(last_moving)
  end
end

class Game_Actor < Game_Battler
  alias r2_state_block_floor_damage execute_floor_damage
  def execute_floor_damage
    state_ids = self.states.collect {|obj| obj.id }
    return if state_ids.include?(R2_Floor_Damage::BLOCK_STATES)
    r2_state_block_floor_damage
    case $game_map.terrain_tag($game_player.x, $game_player.y)
    when R2_Floor_Damage::POISON_TERRAIN_REGION
      chance = R2_Floor_Damage::CHANCE_POISON
      state = R2_Floor_Damage::POISON_STATE
    when R2_Floor_Damage::LAVA_TERRAIN_REGION
      chance = R2_Floor_Damage::CHANCE_BURN
      state = R2_Floor_Damage::BURN_STATE
    when R2_Floor_Damage::SHOCK_TERRAIN_REGION
      chance = R2_Floor_Damage::CHANCE_SHOCK
      state = R2_Floor_Damage::SHOCK_STATE
    else
      return
    end
    return if $game_switches[R2_Floor_Damage::INFLICT_STATE] == false
    roll = rand(100).to_i
    if roll <= chance
      act = $game_actors[@actor_id]
      act.add_state(state)
    end
  end
end
