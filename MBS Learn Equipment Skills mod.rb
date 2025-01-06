#==============================================================================
# MBS - Learn Equipment Skills
#------------------------------------------------------------------------------
# by Masked # mod by Roninator2
#==============================================================================
# Only the actor stated will learn the skill if that actor has the item equiped
# equipment notetags
# <Actor1 LearnSkills: 21>	# temporary until item is removed
# <Actor5 LearnSkills: 21>	# temporary until item is removed
# <Actor1 LearnPSkills: 21>  # permanent
($imported ||= {})[:mbs_equipment_skills] = true
#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  attr_accessor :perm_skills
  alias mbs_chngeqp change_equip
  alias mbs_inteqps init_equips
  #--------------------------------------------------------------------------
  # * Equipment initialization
  #   equips: initial equipment
  #--------------------------------------------------------------------------
  def init_equips(equips)
    @perm_skills = []
    mbs_inteqps(equips)
    @equips.each {|i|
      equip_skills(i.object).each {|skill| learn_skill(skill)}
    }
  end
  #--------------------------------------------------------------------------
  # * Equipment change
  #   slot_id: slot ID
  #   item: Weapons / Matures (nil if empty)
  #--------------------------------------------------------------------------
  def change_equip(slot_id, item)
    equip_skills(@equips[slot_id].object).each {|skill| forget_skill(skill) unless @perm_skills.include?(skill)}
    mbs_chngeqp(slot_id,item)
    equip_skills(item).each {|skill| learn_skill(skill)}
  end
  #--------------------------------------------------------------------------
	# * Acquisition of equipment skills
  #   item: the equipment in question  
  #--------------------------------------------------------------------------
  def equip_skills(item)
    return [] if item.nil?
    s = ""
    skills = []
    item.note.split(/[\r\n]+/).each { |line|
      case line
      when /<Actor#{self.id}\s*LearnSkills:\s*(.+>)/im
      unless $1.nil?
        $1.each_char {|char|
          next if char == " "
          if char == "," || char == ">"
            skills << s.to_i
            s = ""
            next
          end
          s += char
        }
      end
    end }
    item.note.split(/[\r\n]+/).each { |line|
      case line
      when /<Actor#{self.id}\s*LearnPSkills:\s*(.+>)/im
      @perm_skills ||= []
      return skills if $1.nil?
      $1.each_char {|char|
        next if char == " "
        if char == "," || char == ">"
          skills << s.to_i
          @perm_skills << s.to_i
          s = ""
          next
        end
        s += char
      }
      end }
    return skills
  end
end
