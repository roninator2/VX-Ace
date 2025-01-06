#==============================================================================
# Different effects outside the battle
# By Lecode
#----------------------
# Use <when_outside: x> on skills and items notetags.
# When the party is outside, the effects of the skill/item with
# the ID x w'll be used instead of the selected skill/item's effects
# Added <when_inside: x> - Roninator2
#==============================================================================
module Lecode_ItemOutside
  def self.get_outside_item(item)
    return item if $game_party.in_battle
    other_id = item.outside_item_id
    if other_id > 0
      if item.is_a?(RPG::Skill)
        return $data_skills[other_id]
      elsif item.is_a?(RPG::Item)
        return $data_items[other_id]
      end
    end
    return item
  end
  def self.get_inside_item(item)
    return item if !$game_party.in_battle
    other_id = item.inside_item_id
    if other_id > 0
      if item.is_a?(RPG::Skill)
        return $data_skills[other_id]
      elsif item.is_a?(RPG::Item)
        return $data_items[other_id]
      end
    end
    return item
  end
end

class Scene_ItemBase
  def use_item_to_actors
    true_item = Lecode_ItemOutside.get_outside_item(item)
    item_target_actors.each do |target|
      true_item.repeats.times { target.item_apply(user, true_item) }
    end
  end
end

class Game_Battler
  def use_item(item)
    pay_skill_cost(item) if item.is_a?(RPG::Skill)
    consume_item(item) if item.is_a?(RPG::Item)
    true_item = Lecode_ItemOutside.get_outside_item(item)
    if true_item.nil?
      item.effects.each {|effect| item_global_effect_apply(effect) }
    else
      true_item.effects.each {|effect| item_global_effect_apply(effect) }
    end
  end
end

class RPG::UsableItem
  def outside_item_id
    self.note =~ /<when_outside:[ ]?(.+)>/ ? $1.to_i : 0
  end
  def inside_item_id
    self.note =~ /<when_inside:[ ]?(.+)>/ ? $1.to_i : 0
  end
end

class Scene_Battle < Scene_Base
  def use_item
    item = @subject.current_action.item
    true_item = Lecode_ItemOutside.get_inside_item(item)
    @log_window.display_use_item(@subject, true_item)
    @subject.use_item(true_item)
    refresh_status
    targets = @subject.current_action.make_targets.compact
    show_animation(targets, true_item.animation_id)
    targets.each {|target| true_item.repeats.times { invoke_item(target, true_item) } }
  end
end
