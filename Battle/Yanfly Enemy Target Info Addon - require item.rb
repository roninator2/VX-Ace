# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Yanfly Enemy Target Info Addon         ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Require Item to use Target Info             ║    19 Dec 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires:                                                          ║
# ║        Yanfly Enemy Target Info                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   When viewing the enemy you will need to have the item            ║
# ║   in order to see the enemy stats.                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Specify the Item required to use the Target Info                 ║
# ║   Item must be in your inventory for it to work                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 19 Dec 2021 - Script finished                               ║
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

module R2_Compare_Book_Found
  ITEM_ID = 25
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_Comparison < Window_Base
  def process_enemy_window_input
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless SceneManager.scene.enemy_window.active
    return if SceneManager.scene.enemy_window.select_all?
    return unless $game_party.items.include?($data_items[R2_Compare_Book_Found::ITEM_ID])
    SceneManager.scene.toggle_enemy_info if Input.trigger?(@button) unless self.visible
    return unless self.visible
    SceneManager.scene.enemy_info_page_up if Input.trigger?(:L)
    SceneManager.scene.enemy_info_page_down if Input.trigger?(:R)
  end
end

class Window_ComparisonHelp < Window_Base
  def update_text
    return unless self.visible
    return unless $game_party.items.include?($data_items[R2_Compare_Book_Found::ITEM_ID])
    if @info_window.visible
      text = YEA::ENEMY_INFO::HELP_INFO_SWITCH
    else
      text = YEA::ENEMY_INFO::HELP_INFO_SHOW
    end
    return if @text == text
    @text = text
    refresh
  end
end
