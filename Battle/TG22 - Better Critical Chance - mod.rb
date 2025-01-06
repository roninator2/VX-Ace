#===============================================================================#
#
#  Better Critical Chance
#   Custom Script File by TG22
#	Mod by Roninator2
#   This script creates skill notetags to give the developper a better control
#  of skills' critical chance
#-------------------------------------------------------------------------------#
# Status : v0 : Just implemented, needs alpha testing.
#-------------------------------------------------------------------------------#
#
#  Usage : In the skill notes you can add :
#
#  <critical chance: = 10>
#  This notetag will override the battler crit chance (but not the "can-crit?"
#   flag of the skill). In this example, if the skill can crit, the chance is
#   10%, whoever uses it. Only the target CEV can modify it.
#  Set the value to zero and the skill will not be able to crit. 
#  The entered value must be an integer!
#
#  <critical chance: + 5>
#  <critical chance: - 5>
#  Unless overriden by an "=" notetag, this skill will have an additional chance
#   to have a critical effect. In this example, if the user has 4% cri, the
#   resulting crit chance will be 4+5 = 9% or 9-5 = 4%
#  Note: the target's cev is applied to the final value (9%)
#  The entered value must be an integer!
#
#  <critical chance: x 110>
#  Unless overriden by an "=" notetag, this skill will have a multiplied chance
#   to have a critical effect. In this example, if the user has 4% cri, the
#   resulting critical chance will be 4 * 1.10 = 4.4%
#  Note: the target's cev is applied to the final value (4.4%)
#  Note: Can be used to increase or decrease (<100%) crit chance.
#  The entered value must be an integer!
#
#  Stacking :
#  <critical chance: x 110>
#  <critical chance: + 5>
#  If these two tags are used, and unless they are overriden by the "=" notetag,
#  if the battler has a base 4% cri, the resulting crit chance will be :
#  (4 + 5) * 1.10 = 9.9% chance. The multiply tag is applied after the
#  additive one.
#  Note: the target's cev is applied to the final value (9.9%)
#
#-------------------------------------------------------------------------------#
# Compatibility :
#  Warning : the method 
#  -Game_Battler > item_cri
#  is erased.
#-------------------------------------------------------------------------------#
# Configuration
#===============================================================================#

module TGTT
  module BETTERCRITCHANCE
	REGEXP_CRITCHANCE = /<critical[ -_]chance:[ -_](.)[ -_](\d+)>/i
  end
end

#===============================================================================#
# End of Configuration
#-------------------------------------------------------------------------------#
# Erasing the crit chance computation
#===============================================================================#

class Game_Battler < Game_BattlerBase
  def item_cri(user, item)
    #Zero crit chance if the critical flag is not set.
    return 0 unless item.damage.critical
    #Base user crit chance
    base_cri = user.cri
    #Apply additional notetag
    if item.critchance_additional != 0.0
      base_cri += item.critchance_additional
    end
    #Apply subtractive notetag
    if item.critchance_subtractive != 0.0
      base_cri -= item.critchance_subtractive
      base_cri = 0 if base_cri < 0
    end
    #Apply multiplicative notetag
    if item.critchance_multiplier != 1.0
      base_cri *= item.critchance_multiplier
    end
    #Apply overriding notetag, if present
    if !item.critchance_override.nil?
      base_cri = item.critchance_override
    end
    #Applying CEV to the final value.
    return base_cri * (1.0 - cev)
  end
end

#===============================================================================#
# Notetag management
#===============================================================================#

module DataManager
  #Aliasing the module "static" method
  class << self
    alias hrpg_betcc_load_database load_database
  end

  def self.load_database
    hrpg_betcc_load_database
    hrpg_betcc_load_notetags
  end

  def self.hrpg_betcc_load_notetags
    for sk in $data_skills
      next if sk.nil?
      sk.hrpg_betcc_load_notetags
    end
  end

end

class RPG::BaseItem
  attr_accessor :critchance_additional
  attr_accessor :critchance_subtractive
  attr_accessor :critchance_multiplier
  attr_accessor :critchance_override

  def hrpg_betcc_load_notetags
    #Default values.
    @critchance_additional  = 0.0
    @critchance_subtractive = 0.0
    @critchance_multiplier  = 1.0
    @critchance_override    = nil #nil means not present. Do not change that.

    self.note.split(/[\r\n]+/).each do |line|
      case line
      when TGTT::BETTERCRITCHANCE::REGEXP_CRITCHANCE
        case $1
        when '+'
          @critchance_additional = $2.to_i * 0.01
        when '-'
          @critchance_subtractive = $2.to_i * 0.01
        when 'x'
          @critchance_multiplier = $2.to_i * 0.01
        when '='
          @critchance_override = $2.to_i * 0.01
        end
      end
    end
  end

end
