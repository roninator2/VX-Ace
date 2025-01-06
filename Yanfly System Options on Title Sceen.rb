# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Title Options                ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║    Show Options Command             ╠════════════════════╣
# ║    on title screen                  ║    16 Mar 2021     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly's System Options                        ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Script allows accessing the options screen               ║
# ║  before starting the game                                ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║ 1.00 - 19 Mar 2021 - Script finished                     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝
module DataManager
  def self.setup_new_game
    $game_party.setup_starting_members
    $game_map.setup($data_system.start_map_id)
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    $game_player.refresh
    Graphics.frame_count = 0
  end
end
class Scene_Title < Scene_Base
  alias r2_title_options_start    start
  def start
    r2_title_options_start
    DataManager.create_game_objects if $game_switches.nil?
  end
  def create_command_window
    @command_window = Window_TitleCommand.new
    @command_window.set_handler(:new_game, method(:command_new_game))
    @command_window.set_handler(:continue, method(:command_continue))
    @command_window.set_handler(:options, method(:command_options))
    @command_window.set_handler(:shutdown, method(:command_shutdown))
  end
  def command_options
    close_command_window
    SceneManager.call(Scene_System)
  end
end

class Window_TitleCommand < Window_Command
  def make_command_list
    add_command(Vocab::new_game, :new_game)
    add_command(Vocab::continue, :continue, continue_enabled)
    add_command("Options", :options)
    add_command(Vocab::shutdown, :shutdown)
  end
end
