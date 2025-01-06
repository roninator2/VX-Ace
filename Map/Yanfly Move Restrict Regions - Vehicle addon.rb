#==============================================================================
# 
# ▼ Yanfly Engine Ace - Move Restrict Region v1.03 - Addon
# -- Last Updated: 2012.01.03
# -- Level: Normal
# -- Requires: n/a
# -- Addon Mod: Roninator2
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-MoveRestrictRegion"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.23.08 - Added Feature: <all restrict: x>
# 2012.01.03 - Added Feature: <all restrict: x>
# 2011.12.26 - Bug Fixed: Player Restricted Regions.
# 2011.12.15 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Not everybody wants NPC's to travel all over the place. With this script, you
# can set NPC's to be unable to move pass tiles marked by a specified Region.
# Simply draw out the area you want to enclose NPC's in on and they'll be
# unable to move past it unless they have Through on. Likewise, there are
# regions that you can prevent the player from moving onto, too!
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
#
# Must be below Yanfly Engine Ace - Move Restrict Region v1.03
#
# -----------------------------------------------------------------------------
# Map Notetags - These notetags go in the map notebox in a map's properties.
# -----------------------------------------------------------------------------
# 
# <vehicle restrict: x>
# <vehicle restrict: x, x>
# Players will not be able to move on tiles marked by region x unless the
# player has a "Through" flag on. Draw out the area you want to close the
# player in with the regions and the player will be unable to move past any of
# those tiles marked by region x. If you want to have more regions restrict the
# player, insert multiples of this tag.
#
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module MOVE_RESTRICT
    
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default Vehicle Restricted Regions -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # If you want there to always be a region ID that will forbid the vehicle
    # from passing through, insert that region ID into the array below.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_VEHICLE = [59]
    
  end # MOVE_RESTRICT
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module MAP
    
    VEHICLE_RESTRICT = 
      /<(?:VEHICLE_RESTRICT|vehicle restrict):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
  end # MAP
  end # REGEXP
end # YEA

#==============================================================================
# ■ RPG::Map
#==============================================================================

class RPG::Map
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :vehicle_restrict_regions
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_mrr
  #--------------------------------------------------------------------------
  alias r2_load_notetags_mrr_tnm5j load_notetags_mrr
  def load_notetags_mrr
    r2_load_notetags_mrr_tnm5j
    @vehicle_restrict_regions = YEA::MOVE_RESTRICT::DEFAULT_VEHICLE.clone
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::MAP::VEHICLE_RESTRICT
        $1.scan(/\d+/).each { |num| 
        @vehicle_restrict_regions.push(num.to_i) if num.to_i > 0 }
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Map

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # new method: player_restrict_regions
  #--------------------------------------------------------------------------
  def vehicle_restrict_regions
    return @map.vehicle_restrict_regions
  end

end # Game_Map

#==============================================================================
# ■ Game_CharacterBase
#==============================================================================

class Game_CharacterBase

  #--------------------------------------------------------------------------
  # alias method: passable?
  #--------------------------------------------------------------------------
  alias r2game_characterbase_passable_mrr passable?
  def passable?(x, y, d)
    return false if vehicle_region_forbid?(x, y, d)
    return r2game_characterbase_passable_mrr(x, y, d)
  end
  
  #--------------------------------------------------------------------------
  # new method: player_region_forbid?
  #--------------------------------------------------------------------------
  def vehicle_region_forbid?(x, y, d)
    return false unless self.is_a?(Game_Character)
    return false if debug_through?
    region = 0
    case d
    when 1; region = $game_map.region_id(x-1, y+1)
    when 2; region = $game_map.region_id(x+0, y+1)
    when 3; region = $game_map.region_id(x+1, y+1)
    when 4; region = $game_map.region_id(x-1, y+0)
    when 5; region = $game_map.region_id(x+0, y+0)
    when 6; region = $game_map.region_id(x+1, y+0)
    when 7; region = $game_map.region_id(x-1, y-1)
    when 8; region = $game_map.region_id(x+0, y-1)
    when 9; region = $game_map.region_id(x+1, y-1)
    end
    return true if $game_map.all_restrict_regions.include?(region)
    return false if @through
    return true if @vehicle_type != :walk && $game_map.vehicle_restrict_regions.include?(region)
  end
  
end # Game_CharacterBase

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
