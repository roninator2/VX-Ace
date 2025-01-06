# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Magic Shard addon            ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║ Galv's Magic Shards -               ╠════════════════════╣
# ║ Allows combinations of 3 shards     ║    01 Nov 2020     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ These are setup in Galvs script NOT HERE!                ║
# ║                                                          ║
# ║ [shard_id,shard_id,shard_id] => skill_id,                ║
# ║ [1,2,3] => 46, # fire and water and earth = skill 46     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Follow the Original Authors terms   ║
# ╚═════════════════════════════════════╝

class Game_Actor < Game_Battler
  def shard_linked_skills_three
    lst = Galv_Shard::SHARDS
    return [] if !shards
    sarray = []
    shards.each_with_index { |s,i|
      nxt = shards[i + 1].nil? ? 0 : i + 1
      fst = shards[i - 1].nil? ? 0 : i - 1
      next if s == :blank || shards[nxt] == :blank || shards[fst] == :blank
      check_three = [shards[i].shard,shards[nxt].shard,shards[fst].shard].sort
      sarray << lst[check_three] if lst.keys.include?(check_three)
    }
    sarray.compact
  end
  alias r2_galv_shards_ga_added_skills added_skills
  def added_skills
    r2_galv_shards_ga_added_skills + shard_linked_skills_three
  end
  def add_shard_actor(actor,amount)
    if actor == 0
      $game_party.leader.add_shard_level(amount)
    elsif actor > 0
      return if $game_actors[actor].nil?
      $game_actors[actor].add_shard_level(amount)
    end
  end
end

class Scene_Shards < Scene_MenuBase

  def do_shard_change
    learned = @actor.shard_linked_skills - @actor.known_links && @actor.shard_linked_skills_three - @actor.known_links
    forgot = @actor.known_links - @actor.shard_linked_skills && @actor.known_links - @actor.shard_linked_skills_three
    learn_usable = []
    forgot_usable = []
    learned.each { |sid|
      if @actor.added_skill_types.include?($data_skills[sid].stype_id)
        learn_usable << sid
      end
    }
    forgot.each { |sid|
      if @actor.added_skill_types.include?($data_skills[sid].stype_id)
        forgot_usable << sid
      end
    }

    @info_window.display(learn_usable,forgot_usable)
    @actor.known_links = @actor.shard_linked_skills && @actor.shard_linked_skills_three
  end

end
