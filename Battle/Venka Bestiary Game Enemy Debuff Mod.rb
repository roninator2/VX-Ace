# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Venka Bestiary Game Enemy Debuff Mod   ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║            Alter Display                      ║    07 Sep 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Venka Bestiary V1.8                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   Change the display for debuffs to show current enemy in battle   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change value below to true or false                              ║
# ║     true equals original script data                               ║
# ║     false equals current enemy data                                ║
# ║                                                                    ║
# ║   This was made as a request from DarknessVoid                     ║
# ║     The issue was that debuffs applied to an enemy                 ║
# ║     in battle are not shown.                                       ║
# ║     This is because the script is designed to use                  ║
# ║     the data that is in the database for the enemy                 ║
# ║     not the enemy in battle                                        ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 07 Sep 2023 - Script finished                               ║
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

module Venka
  module Bestiary
    Show_ShownEnemy_DebuffStats = false
    # shows the enemy database stats not the active enemy stats
  end
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Game_Enemy < Game_Battler
  attr_accessor :shown_id
  attr_reader :buffs
 
  alias r2_shown_enemy_id_rpg_enemy_init    initialize
  def initialize(index, enemy_id)
    r2_shown_enemy_id_rpg_enemy_init(index, enemy_id)
    @shown_id = @enemy_id
    $data_enemies[@enemy_id].note.split(/[\r\n]+/).each do |line|
      case line
      when Venka::Notetag::Shown_ID;          @shown_id = $1.to_i
      end
    end
  end
end

#==============================================================================
# ■ Window_BestiaryStatSelection
#==============================================================================
class Window_BestiaryStatSelection < Window_Selectable
  #----------------------------------------------------------------------------
  # ○ new method: enemy_id
  #----------------------------------------------------------------------------
  def enemy_id=(enemy_id)
    return @enemy = nil if enemy_id == nil
    # changed to show enemy when in battle
    if SceneManager.scene_is?(Scene_Battle)
      if @enemy != enemy_id
        $game_troop.members.each do |emy|
          if emy == enemy_id
            @enemy = emy
          end
        end
      end
    else
      if @enemy != $data_enemies[enemy_id]
        @enemy = $data_enemies[enemy_id]
      end
    end
    refresh
  end
end

#==============================================================================
# ■ Window_BestiaryStats
#==============================================================================
class Window_BestiaryStats < Window_Base
  #----------------------------------------------------------------------------
  # ○ new method: enemy_id
  #----------------------------------------------------------------------------
  def enemy_id=(enemy_id)
    return @enemy = nil if enemy_id == 0
    # changed to show enemy when in battle
    if SceneManager.scene_is?(Scene_Battle)
      if @enemy != enemy_id
        $game_troop.members.each do |emy|
          if emy == enemy_id
            @enemy = emy
          end
        end
      end
    else
      if @enemy != $data_enemies[enemy_id]
        @enemy = $data_enemies[enemy_id]
      end
    end
    refresh
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_stat
  #----------------------------------------------------------------------------
  def draw_stat(stat, stat_type)
    rect = info_rect(stat)
    rect.y += @y
    stat_info = Venka::Bestiary::Base_Stats[stat]
    if stat_info[1]
      draw_icon(stat_info[1], rect.x, rect.y)
      rect.x += 25;            rect.width -= 25
    end
    if stat_info[0]
      set_bestiary_font(:stat_name)
      draw_text(rect, stat_info[0])
      text_width = text_size(stat_info[0]).width + 5
      rect.x += text_width;    rect.width -= text_width
    end
    set_bestiary_font(:stats_font)
    text = Venka::Bestiary::Unknown_Stat
    $game_party.bestiary.each do |entry|
      next unless entry.enemy_id == @enemy.shown_id
      if stat_type == :stat && (entry.scanned ||
            entry.kills >= Venka::Bestiary::Show_BaseStats)
        text = Game_Enemy.new(0, @enemy.shown_id).param(stat)
      elsif stat_type == :debuff && (entry.scanned ||
            entry.kills >= Venka::Bestiary::Show_DebuffStats)
            # changed to show database or enemy
        if Venka::Bestiary::Show_ShownEnemy_DebuffStats
          rate = Game_Enemy.new(0, @enemy.shown_id).debuff_rate(stat)
        elsif !SceneManager.scene_is?(Scene_Battle)
          rate = Game_Enemy.new(0, @enemy.shown_id).debuff_rate(stat)
        else
          rate = @enemy.debuff_rate(stat)
          rate += ( @enemy.buffs[stat] * 0.25 ) if @enemy.buffs[stat] != 0
        end
        text = get_resist_info(stat, rate)
      end
    end
    draw_text(rect, text, 2)
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_resist_style
  #----------------------------------------------------------------------------
  def set_resist_style(resist, text = "")
    if text != ""
      color = Venka::Bestiary::Immunity_Color
    else
      color = Venka::Bestiary::Fonts[:stats_font][3]
      color = Venka::Bestiary::High_Resist if resist > 1.0
      color = Venka::Bestiary::Low_Resist  if resist < 1.0
      # removed rate amount change
      text = (resist * 100).round.to_s+"%"
    end
    new_color = color.is_a?(Integer) ? text_color(color) : Color.new(*color)
    change_color(new_color)
    return text
  end
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #----------------------------------------------------------------------------
  # ● alias method: item_apply
  #----------------------------------------------------------------------------
  def apply_item_effects(target, item)
    if target.is_a?(Game_Enemy)
      enemy = $data_enemies[target.enemy_id]
      $game_party.reveal_resist(enemy.id, false) if item.scan
      attack_element = item.damage.element_id
      Venka::Bestiary::Elements.size.times do |i|
        if Venka::Bestiary::Elements[i][0] == attack_element
          $game_party.bestiary.each do |entry|
            entry.elements[i] = true if entry.enemy_id == enemy.shown_id
          end
        end
      end
      if item.scan
        $game_party.bestiary.each do |entry|
          entry.scanned = true if entry.enemy_id == enemy.shown_id
        end
        # changed to pass target not target.id
        show_enemy_info(target)
      end
    end
    venka_scan_skill_used(target, item)
  end
end

if $imported[:TSBS]
class Game_Battler
  alias venka_scan_skill_used item_apply
  def item_apply(user, item)
    if self.is_a?(Game_Enemy)
      enemy = $data_enemies[self.enemy_id]
      $game_party.reveal_resist(enemy.id, false) if item.scan
      attack_element = item.damage.element_id
      Venka::Bestiary::Elements.size.times do |i|
        if Venka::Bestiary::Elements[i][0] == attack_element
          $game_party.bestiary.each do |entry|
            entry.elements[i] = true if entry.enemy_id == enemy.shown_id
          end
        end
      end
      if item.scan
        $game_party.bestiary.each do |entry|
          entry.scanned = true if entry.enemy_id == enemy.shown_id
        end
        SceneManager.scene.show_enemy_info(self)
      end
    end
    venka_scan_skill_used(user, item)
  end
end
end
