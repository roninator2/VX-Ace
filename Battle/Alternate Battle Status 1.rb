# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Alternate Battle Status 1              ║  Version: 1.15     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Display Battle Status another way             ║    12 Oct 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Provide alternate battle status view                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║  Set the Icon value below for when the actor has no                ║
# ║  action selected.                                                  ║
# ║                                                                    ║
# ║  Otherwise plug and play                                           ║
# ║                                                                    ║
# ║  To show the states properly you need to use a scrolling state     ║
# ║  script such as Neon Black Scrolling States                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 12 Oct 2023 - Script finished                               ║
# ║ 1.01 - 12 Oct 2023 - bug fix                                       ║
# ║ 1.02 - 05 May 2024 - fixed Item selection                          ║
# ║ 1.03 - 05 May 2024 - Updated Actor Select Window                   ║
# ║ 1.04 - 08 May 2024 - Added Icon option for Gauge bars              ║
# ║ 1.05 - 10 May 2024 - Changed display and added CTB support         ║
# ║ 1.06 - 10 May 2024 - Changed windows display                       ║
# ║ 1.07 - 12 May 2024 - Cleaned up display and added enemy HP display ║
# ║ 1.08 - 12 May 2024 - Fixed stats not showing after party command   ║
# ║ 1.09 - 13 May 2024 - Fixed states not showing in right position    ║
# ║ 1.10 - 14 May 2024 - Redesigned for Max 4 party members in battle  ║
# ║ 1.11 - 18 May 2024 - Fixed scrolling icons                         ║
# ║ 1.12 - 27 May 2024 - Added scrolling icons for enemies             ║
# ║ 1.13 - 28 May 2024 - Moved Actor Command Window to the Left        ║
# ║ 1.14 - 17 May 2025 - Fixed enemy HP not aligning center            ║
# ║ 1.15 - 17 May 2025 - Increased the speed of Battle Status changing ║
# ║                      A fix for a visual glitch when doing commands ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Yanfly                                                           ║
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

module R2_ALT_BATTLE_STATUS_ONE
  ACTION_ICON = 185        # Action Icons
  SHOW_ACTION_ICONS = true # show action Icons
  HP_ICON = 10             # HP Icon
  MP_ICON = 11             # MP Icon
  TP_ICON = 12             # TP Icon
  SHOW_STAT_ICONS = true   # show stat Icons
  SHOW_ENEMY_ICONS = true  # show icons for enemy health + health
  ENEMY_COLUMNS = 1        # columns in enemy window
  MAX_PARTY = 4            # max number of members in party. Must be less than 5
  ICON_SCROLL_TIMER = 90   # frames to wait before next icon is shown.
  BLANK_ICON = 16          # icon shown for icon placement
  AP_GAUGE_WIDTH = 120     # width of AP gauge when using Circle Cross CTB
  SHOW_ENEMY_STATES = true # Show enemy inflicted states and buffs
end

#==============================================================================
# ** BattleManager
#==============================================================================
module BattleManager
  attr_reader :phase
  #--------------------------------------------------------------------------
  # * BattleManager Phase
  #--------------------------------------------------------------------------
  def self.phase?
    return @phase
  end
  #--------------------------------------------------------------------------
  # * Start Command Input
  #--------------------------------------------------------------------------
  def self.init_input
    if @phase != :init
      @phase = :init
    end
  end
end

#==============================================================================
# ** Game_Party
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Get Maximum Number of Battle Members
  #--------------------------------------------------------------------------
  def max_battle_members
    return R2_ALT_BATTLE_STATUS_ONE::MAX_PARTY
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :icon_scroll_index
  attr_accessor :icon_scroll_timer
  attr_accessor :icon_scroll_icons
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias :r2_icon_scroll_setup   :setup
  def setup(actor_id)
    @icon_scroll_index = 0
    @icon_scroll_timer = 0
    @icon_scroll_icons = []
    r2_icon_scroll_setup(actor_id)
  end
end

#==============================================================================
# ** Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :icon_scroll_index
  attr_accessor :icon_scroll_timer
  attr_accessor :icon_scroll_icons
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias :r2_icon_scroll_initialize   :initialize
  def initialize(index, enemy_id)
    @icon_scroll_index = 0
    @icon_scroll_timer = 0
    @icon_scroll_icons = []
    r2_icon_scroll_initialize(index, enemy_id)
  end
end

#==============================================================================
# ** Window_BattleStatus
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias :r2_update_icon_scroll_base :update
  def update
    r2_update_icon_scroll_base
    refresh_actor_scroll_icons
  end
  #--------------------------------------------------------------------------
  # * refresh_actor_scroll_icons
  #--------------------------------------------------------------------------
  def refresh_actor_scroll_icons
  end
end

#==============================================================================
# ** Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Get Row Count
  #--------------------------------------------------------------------------
  def row_max
    2
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    2
  end
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    return if index.nil?
    actor = $game_party.battle_members[index]
    return if actor.nil?
    rect = item_rect_for_sprite(index)
    contents.clear_rect(20,0,80,24)
    draw_text(20, 0, 80, 24, "Party")
    draw_actor_graphic(actor, rect.x, rect.y+16)
    draw_actor_action(actor, rect.x+10, rect.y-16) if
      R2_ALT_BATTLE_STATUS_ONE::SHOW_ACTION_ICONS == true
    if BattleManager.phase? != :input
      rect = item_rect_for_status(index)
      draw_actor_ap(actor, rect.x+30, rect.y, R2_ALT_BATTLE_STATUS_ONE::AP_GAUGE_WIDTH) if $imported && $imported["R2_CTB_CC"] == true
      draw_actor_name(actor, rect.x+10, rect.y, rect.width+20)
      if R2_ALT_BATTLE_STATUS_ONE::SHOW_STAT_ICONS == true
        draw_icon(R2_ALT_BATTLE_STATUS_ONE::HP_ICON, rect.x+30, rect.y+24)
        draw_current_and_max_values(rect.x+8, rect.y+24, rect.width,
          actor.hp, actor.mhp, hp_color(actor), normal_color)
      else
        draw_gauge(rect.x+30, rect.y+24, rect.width-20, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
        draw_current_and_max_values(rect.x+10, rect.y+24, rect.width,
          actor.hp, actor.mhp, hp_color(actor), normal_color)
        draw_text(rect.x+30, rect.y+24, 30, line_height, Vocab::hp_a)
      end
    else
      return if actor != BattleManager.actor
      rect = item_rect(index)
      draw_actor_face(actor, rect.x, rect.y+2, actor.alive?)
      draw_actor_name(actor, rect.x+100, rect.y, rect.width-8)
      if R2_ALT_BATTLE_STATUS_ONE::SHOW_STAT_ICONS == true
        draw_icon(R2_ALT_BATTLE_STATUS_ONE::HP_ICON, rect.x+120, line_height*1)
        draw_current_and_max_values(rect.x+100, line_height*1, rect.width - rect.x - 40,
          actor.hp, actor.mhp, hp_color(actor), normal_color)
        draw_icon(R2_ALT_BATTLE_STATUS_ONE::MP_ICON, rect.x+120, line_height*2)
        draw_current_and_max_values(rect.x+100, line_height*2, rect.width - rect.x - 40,
          actor.mp.to_i, actor.mmp, mp_color(actor), normal_color)
        draw_icon(R2_ALT_BATTLE_STATUS_ONE::TP_ICON, rect.x+120, line_height*3)
        draw_text(rect.x+187, line_height*3, 64, line_height, actor.tp.to_i, 2)
      else
        draw_actor_hp(actor, rect.x+120, line_height*1, rect.width - rect.x - 30)
        draw_actor_mp(actor, rect.x+120, line_height*2, rect.width - rect.x - 30)
        draw_actor_tp(actor, rect.x+120, line_height*3, rect.width - rect.x - 30)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw State and Buff/Debuff Icons
  #--------------------------------------------------------------------------
  def draw_actor_scroll_icons(actor)
    actor.icon_scroll_icons = (actor.state_icons + actor.buff_icons)
    if BattleManager.phase? != :input
      # turn phase
      index = 0
      $game_party.battle_members.each_with_index do |mem, i|
        index = i if mem.id == actor.id
      end
      rect = item_rect_for_status(index)
      rect.x += 130
    else
      # party select
      if BattleManager.phase? == :input && BattleManager.actor.nil?
        index = 0
        $game_party.battle_members.each_with_index do |mem, i|
          index = i if mem.id == actor.id
        end
        rect = item_rect_for_status(index)
        rect.x += 130
      else
        # actor command
        return if actor != BattleManager.actor
        rect = item_rect(0)
        rect.x += 260
      end
    end
    if actor.icon_scroll_timer > R2_ALT_BATTLE_STATUS_ONE::ICON_SCROLL_TIMER
      actor.icon_scroll_index += 1
      actor.icon_scroll_index = 0 if actor.icon_scroll_index > actor.icon_scroll_icons.size - 1
      actor.icon_scroll_timer = 0
    end
    contents.clear_rect(rect.x-2, rect.y - 2, 28, 28)
    draw_actor_state_icons(actor, rect.x, rect.y)
    actor.icon_scroll_timer += 1
  end
  #--------------------------------------------------------------------------
  # new method: draw_actor_action
  #--------------------------------------------------------------------------
  def draw_actor_state_icons(actor, dx, dy)
    draw_icon(state_icon(actor), dx, dy)
  end
  #--------------------------------------------------------------------------
  # new method: action_icon
  #--------------------------------------------------------------------------
  def state_icon(actor)
    return R2_ALT_BATTLE_STATUS_ONE::BLANK_ICON if actor.icon_scroll_icons == []
    return R2_ALT_BATTLE_STATUS_ONE::BLANK_ICON if actor.icon_scroll_icons[actor.icon_scroll_index].nil?
    return actor.icon_scroll_icons[0] if actor.icon_scroll_icons.size == 1
    return actor.icon_scroll_icons[actor.icon_scroll_index]
  end
  #--------------------------------------------------------------------------
  # * refresh_actor_scroll_icons
  #--------------------------------------------------------------------------
  def refresh_actor_scroll_icons
    if BattleManager.phase? != :input
      $game_party.battle_members.each do |mem|
        draw_actor_scroll_icons(mem)
      end
    else
      if BattleManager.phase? == :input && BattleManager.actor.nil?
        $game_party.battle_members.each do |mem|
          draw_actor_scroll_icons(mem)
        end
      else
        return if BattleManager.actor.nil?
        draw_actor_scroll_icons(BattleManager.actor)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * new method: item_rect_for_sprite
  #--------------------------------------------------------------------------
  def item_rect_for_sprite(index)
    rect = item_rect(index)
    rect.width -= 8
    line = (index / 2).ceil
    rect.x = index % 2 * 48 + 12
    rect.y = line * 35 + 40
    rect
  end
  #--------------------------------------------------------------------------
  # * new method: item_rect_for_status
  #--------------------------------------------------------------------------
  def item_rect_for_status(index)
    rect = item_rect(index)
    rect.width = 150
    line = (index / 2).ceil
    rect.x = (index % 2) * 150 + 80
    rect.y = line * line_height + line * 24
    rect
  end
  #--------------------------------------------------------------------------
  # overwrite method: item_rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.x = 100
    rect.height = contents.height
    rect.width = contents.width - rect.x
    rect.y = 0
    return rect
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_actor_data
    actor = BattleManager.actor
    actor.actions[0] = Game_Action.new(actor)
    refresh
  end
  #--------------------------------------------------------------------------
  # new method: draw_actor_action
  #--------------------------------------------------------------------------
  def draw_actor_action(actor, dx, dy)
    draw_icon(action_icon(actor), dx, dy)
  end
  #--------------------------------------------------------------------------
  # new method: action_icon
  #--------------------------------------------------------------------------
  def action_icon(actor)
    return R2_ALT_BATTLE_STATUS_ONE::ACTION_ICON if actor.current_action.nil?
    return R2_ALT_BATTLE_STATUS_ONE::ACTION_ICON if actor.current_action.item.nil?
    return actor.current_action.item.icon_index
  end
  #--------------------------------------------------------------------------
  # overwrite method: draw_face
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, x, y, enabled = true)
    bitmap = Cache.face(face_name)
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96, 96, 96)
    contents.blt(x, y-2, bitmap, rect, enabled ? 255 : translucent_alpha)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_name
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, dx, dy, dw = 112)
    reset_font_settings
    change_color(hp_color(actor))
    draw_text(dx+24, dy, dw-24, line_height, actor.name)
  end
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_hp
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, dx, dy, width = 124)
    draw_gauge(dx, dy, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    cy = (Font.default_size - contents.font.size) / 2 + 1
    draw_text(dx+2, dy+cy, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(dx, dy+cy, width, actor.hp, actor.mhp,
      hp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_mp
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, dx, dy, width = 124)
    draw_gauge(dx, dy, width, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    cy = (Font.default_size - contents.font.size) / 2 + 1
    draw_text(dx+2, dy+cy, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(dx, dy+cy, width, actor.mp.to_i, actor.mmp,
      mp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_tp
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, dx, dy, width = 124)
    draw_gauge(dx, dy, width, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
    change_color(system_color)
    cy = (Font.default_size - contents.font.size) / 2 + 1
    draw_text(dx+2, dy+cy, 30, line_height, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(dx + width - 42, dy+cy, 42, line_height, actor.tp.to_i, 2)
  end
end

#==============================================================================
# ** Window_BattleActor
#==============================================================================
class Window_BattleActor < Window_BattleStatus
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     info_viewport : Viewport for displaying information
  #--------------------------------------------------------------------------
  def initialize(info_viewport)
    super()
    self.y = info_viewport.rect.y
    self.visible = false
    self.openness = 255
    self.opacity = 255
  end
  #--------------------------------------------------------------------------
  # overwrite method: item_rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.x = 0
    rect.height = 32
    rect.width = 48
    rect.y = 0
    line = (index / 2).ceil
    rect.x = index % 2 * 48
    rect.y = line * 35 + 24
    rect
  end
  #--------------------------------------------------------------------------
  # * new method: item_rect_for_sprite
  #--------------------------------------------------------------------------
  def item_rect_for_sprite(index)
    rect = item_rect(index)
    rect.width -= 8
    line = (index / 2).ceil
    rect.x = index % 2 * 48 + 12
    rect.y = line * 35 + 40
    rect
  end
  #--------------------------------------------------------------------------
  # overwrite method: item_rect
  #--------------------------------------------------------------------------
  def item_face_rect(index)
    rect = Rect.new
    rect.x = 80
    rect.height = contents.height
    rect.width = contents.width - rect.x
    rect.y = 0
    return rect
  end
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    return if index.nil?
    actor = $game_party.battle_members[index]
    return if actor.nil?
    rect = item_rect_for_sprite(index)
    contents.clear_rect(20, 0, 80, 24)
    draw_text(20, 0, 80, 24, "Party")
    draw_actor_graphic(actor, rect.x, rect.y+16)
    draw_actor_action(actor, rect.x+10, rect.y-16)
  end
  #--------------------------------------------------------------------------
  # * Cursor Movement Processing
  #--------------------------------------------------------------------------
  alias :r2_cursor_move   :process_cursor_move
  def process_cursor_move
    last_index = @index
    r2_cursor_move
    refresh if @index != last_index
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias :r2_actor_refresh :refresh
  def refresh
    r2_actor_refresh
    draw_selection
  end
  #--------------------------------------------------------------------------
  # * Draw Current Selection for Actor
  #--------------------------------------------------------------------------
  def draw_selection
    @index = 0 if @index == -1
    actor = $game_party.battle_members[@index]
    rect = item_face_rect(index)
    draw_actor_face(actor, rect.x+20, rect.y+2, actor.alive?)
    draw_actor_name(actor, rect.x+120, rect.y, rect.width-8)
    if R2_ALT_BATTLE_STATUS_ONE::SHOW_STAT_ICONS == true
      draw_icon(R2_ALT_BATTLE_STATUS_ONE::HP_ICON, rect.x+140, line_height*1)
      draw_current_and_max_values(rect.x+80, line_height*1, rect.width - rect.x - 40,
        actor.hp, actor.mhp, hp_color(actor), normal_color)
      draw_icon(R2_ALT_BATTLE_STATUS_ONE::MP_ICON, rect.x+140, line_height*2)
      draw_current_and_max_values(rect.x+80, line_height*2, rect.width - rect.x - 40,
        actor.mp.to_i, actor.mmp, mp_color(actor), normal_color)
      draw_icon(R2_ALT_BATTLE_STATUS_ONE::TP_ICON, rect.x+140, line_height*3)
      draw_text(rect.x+207, line_height*3, 64, line_height, actor.tp.to_i, 2)
    else
      draw_actor_hp(actor, rect.x+140, line_height*1, rect.width - rect.x - 70)
      draw_actor_mp(actor, rect.x+140, line_height*2, rect.width - rect.x - 70)
      draw_actor_tp(actor, rect.x+140, line_height*3, rect.width - rect.x - 70)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Face Graphic
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, x, y, enabled = true)
    bitmap = Cache.face(face_name)
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96, 96, 96)
    contents.blt(x, y-2, bitmap, rect, enabled ? 255 : translucent_alpha)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Draw State and Buff/Debuff Icons
  #--------------------------------------------------------------------------
  def draw_actor_scroll_icons(actor)
    actor.icon_scroll_icons = (actor.state_icons + actor.buff_icons)
    rect = item_face_rect(0)
    rect.x += 280
    if actor.icon_scroll_timer > R2_ALT_BATTLE_STATUS_ONE::ICON_SCROLL_TIMER
      actor.icon_scroll_index += 1
      actor.icon_scroll_index = 0 if actor.icon_scroll_index > actor.icon_scroll_icons.size - 1
      actor.icon_scroll_timer = 0
    end
    contents.clear_rect(rect.x-2, rect.y - 2, 28, 28)
    draw_actor_state_icons(actor, rect.x, rect.y)
    actor.icon_scroll_timer += 1
  end
  #--------------------------------------------------------------------------
  # new method: draw_actor_action
  #--------------------------------------------------------------------------
  def draw_actor_state_icons(actor, dx, dy)
    draw_icon(state_icon(actor), dx, dy)
  end
  #--------------------------------------------------------------------------
  # new method: action_icon
  #--------------------------------------------------------------------------
  def state_icon(actor)
    return R2_ALT_BATTLE_STATUS_ONE::BLANK_ICON if actor.icon_scroll_icons == []
    return R2_ALT_BATTLE_STATUS_ONE::BLANK_ICON if actor.icon_scroll_icons[actor.icon_scroll_index].nil?
    return actor.icon_scroll_icons[0] if actor.icon_scroll_icons.size == 1
    return actor.icon_scroll_icons[actor.icon_scroll_index]
  end
  #--------------------------------------------------------------------------
  # * refresh_actor_scroll_icons
  #--------------------------------------------------------------------------
  def refresh_actor_scroll_icons
    return if BattleManager.actor.nil?
    actor = $game_party.battle_members[@index]
    draw_actor_scroll_icons(actor)
  end
end

#==============================================================================
# ** Window_BattleEnemy
#==============================================================================
class Window_BattleEnemy < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     info_viewport : Viewport for displaying information
  #--------------------------------------------------------------------------
  def initialize(info_viewport)
    super(0, info_viewport.rect.y, window_width, 120)
    refresh
    self.visible = false
    @info_viewport = info_viewport
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color)
    rect = item_rect_for_text(index)
    enmy = $game_troop.alive_members[index]
    name = enmy.name
    draw_text(rect, name)
    if R2_ALT_BATTLE_STATUS_ONE::SHOW_ENEMY_ICONS
      if col_max == 1
        draw_icon(R2_ALT_BATTLE_STATUS_ONE::HP_ICON, rect.x+200, rect.y)
        draw_current_and_max_values(rect.x, rect.y, rect.width - rect.x - 40,
        enmy.hp.to_i, enmy.mhp, hp_color(enmy), normal_color)
      else
        draw_icon(R2_ALT_BATTLE_STATUS_ONE::HP_ICON, rect.x+100, rect.y)
        rect.x += 140
        draw_text(rect, enmy.hp)
      end
      draw_enemy_scroll_icons(index, enmy)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    R2_ALT_BATTLE_STATUS_ONE::ENEMY_COLUMNS
  end
  #--------------------------------------------------------------------------
  # * Get Line Height
  #--------------------------------------------------------------------------
  def line_height
    return 26
  end
  #--------------------------------------------------------------------------
  # * Get Standard Padding Size
  #--------------------------------------------------------------------------
  def standard_padding
    return 8
  end
  #--------------------------------------------------------------------------
  # * Draw State and Buff/Debuff Icons
  #--------------------------------------------------------------------------
  def draw_enemy_scroll_icons(index, enmy)
    return unless R2_ALT_BATTLE_STATUS_ONE::SHOW_ENEMY_STATES
    rect = item_rect_for_text(index)
    rect.x += 360
    enmy.icon_scroll_icons = (enmy.state_icons + enmy.buff_icons)
    if enmy.icon_scroll_timer > R2_ALT_BATTLE_STATUS_ONE::ICON_SCROLL_TIMER
      enmy.icon_scroll_index += 1
      enmy.icon_scroll_index = 0 if enmy.icon_scroll_index > enmy.icon_scroll_icons.size - 1
      enmy.icon_scroll_timer = 0
    end
    contents.clear_rect(rect.x-2, rect.y - 2, 28, 28)
    draw_enemy_state_icons(enmy, rect.x, rect.y)
    enmy.icon_scroll_timer += 2
  end
  #--------------------------------------------------------------------------
  # new method: draw_actor_action
  #--------------------------------------------------------------------------
  def draw_enemy_state_icons(enmy, dx, dy)
    draw_icon(state_icon(enmy), dx, dy)
  end
  #--------------------------------------------------------------------------
  # new method: action_icon
  #--------------------------------------------------------------------------
  def state_icon(enmy)
    return R2_ALT_BATTLE_STATUS_ONE::BLANK_ICON if enmy.icon_scroll_icons == []
    return R2_ALT_BATTLE_STATUS_ONE::BLANK_ICON if enmy.icon_scroll_icons[enmy.icon_scroll_index].nil?
    return enmy.icon_scroll_icons[0] if enmy.icon_scroll_icons.size == 1
    return enmy.icon_scroll_icons[enmy.icon_scroll_index]
  end
  #--------------------------------------------------------------------------
  # * refresh_enemy_scroll_icons
  #--------------------------------------------------------------------------
  def refresh_enemy_scroll_icons
    return unless active
    $game_troop.alive_members.each_with_index do |mem, i|
      draw_enemy_scroll_icons(i, mem)
    end
  end
end

#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Actor Command Selection
  #--------------------------------------------------------------------------
  alias :r2_actor_command_icon_scroll :start_actor_command_selection
  def start_actor_command_selection
    @status_window.draw_actor_data
    r2_actor_command_icon_scroll
  end
  #--------------------------------------------------------------------------
  # * To Previous Command Input
  #--------------------------------------------------------------------------
  def prior_command
    if BattleManager.prior_command
      start_actor_command_selection
    else
      BattleManager.init_input
      @status_window.refresh
      start_party_command_selection
    end
  end
  #--------------------------------------------------------------------------
  # * Start Actor Selection
  #--------------------------------------------------------------------------
  alias :r2_select_actor_status_window    :select_actor_selection
  def select_actor_selection
    r2_select_actor_status_window
    @status_window.hide
  end
  #--------------------------------------------------------------------------
  # * Actor [OK]
  #--------------------------------------------------------------------------
  alias :r2_actor_ok_status_window    :on_actor_ok
  def on_actor_ok
    @status_window.show
    r2_actor_ok_status_window 
  end
  #--------------------------------------------------------------------------
  # * Actor [Cancel]
  #--------------------------------------------------------------------------
  alias :r2_actor_cancel_status_window    :on_actor_cancel
  def on_actor_cancel
    @status_window.show
    r2_actor_cancel_status_window
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias :r2_update_icon_scroll  :update
  def update
    r2_update_icon_scroll
    @status_window.refresh_actor_scroll_icons
    @enemy_window.refresh_enemy_scroll_icons
  end
  #--------------------------------------------------------------------------
  # * Update Information Display Viewport
  #--------------------------------------------------------------------------
  def update_info_viewport
    move_info_viewport(0)   if @party_command_window.active
    move_info_viewport(0)   if @actor_command_window.active
    move_info_viewport(64)  if BattleManager.in_turn?
  end
  #--------------------------------------------------------------------------
  # * Create Actor Commands Window
  #--------------------------------------------------------------------------
  def create_actor_command_window
    @actor_command_window = Window_ActorCommand.new
    @actor_command_window.viewport = @info_viewport
    @actor_command_window.set_handler(:attack, method(:command_attack))
    @actor_command_window.set_handler(:skill,  method(:command_skill))
    @actor_command_window.set_handler(:guard,  method(:command_guard))
    @actor_command_window.set_handler(:item,   method(:command_item))
    @actor_command_window.set_handler(:cancel, method(:prior_command))
  end
  #--------------------------------------------------------------------------
  # * Enemy [OK]
  #--------------------------------------------------------------------------
  alias :r2_enemy_ok_refresh_status    :on_enemy_ok
  def on_enemy_ok
    r2_enemy_ok_refresh_status
    @status_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Actor [OK]
  #--------------------------------------------------------------------------
  alias :r2_actor_ok_refresh_status    :on_actor_ok
  def on_actor_ok
    r2_actor_ok_refresh_status
    @status_window.refresh
  end
end
