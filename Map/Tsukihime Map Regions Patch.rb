=begin
#===============================================================================
 Title: Map Regions
 Author: Hime
 Date: Apr 24, 2015
 URL: http://himeworks.com/2014/02/17/map-regions/
 Patch: Roninator2
--------------------------------------------------------------------------------
 ** Change log
 Oct 2, 2019
   - Initial Creation
--------------------------------------------------------------------------------   
 ** Terms of Use
 * Follow Hime's Terms of Use
--------------------------------------------------------------------------------
 ** Description
 
 This script fixes a bug in "map regions".
 
--------------------------------------------------------------------------------
 ** Installation
 
 In the script editor, install this script below Hime Map Regions
 
--------------------------------------------------------------------------------
=end

module RPG
  class Map
    alias r2_map_region_92b7f9  map_regions
    def map_regions
      @oldmap_name = $game_map.display_name if @oldmap_name.nil?
      r2_map_region_92b7f9
    end
  end
end

class Game_Map
  def blank_region_location
    @map.display_name = @oldmap_name
		@map_regions = nil
    @region_name = nil
    @oldmap_name = nil
  end
end

class Scene_Map < Scene_Base
  alias r2_perform_transit    pre_transfer
  def pre_transfer
    $game_map.blank_region_location
    r2_perform_transit
  end
end
