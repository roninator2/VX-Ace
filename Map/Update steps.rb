# Modified the move command so that move route steps are also counted as steps
class Game_Character < Game_CharacterBase
  alias r2_move_route_update_step   process_move_command
  def process_move_command(command)
    r2_move_route_update_step(command)
    case command.code
    when ROUTE_MOVE_DOWN;         $game_party.increase_steps
    when ROUTE_MOVE_LEFT;         $game_party.increase_steps
    when ROUTE_MOVE_RIGHT;        $game_party.increase_steps
    when ROUTE_MOVE_UP;           $game_party.increase_steps
    when ROUTE_MOVE_LOWER_L;      $game_party.increase_steps
    when ROUTE_MOVE_LOWER_R;      $game_party.increase_steps
    when ROUTE_MOVE_UPPER_L;      $game_party.increase_steps
    when ROUTE_MOVE_UPPER_R;      $game_party.increase_steps
    when ROUTE_MOVE_RANDOM;       $game_party.increase_steps
    when ROUTE_MOVE_TOWARD;       $game_party.increase_steps
    when ROUTE_MOVE_AWAY;         $game_party.increase_steps
    when ROUTE_MOVE_FORWARD;      $game_party.increase_steps
    when ROUTE_MOVE_BACKWARD;     $game_party.increase_steps
    end
  end
end
