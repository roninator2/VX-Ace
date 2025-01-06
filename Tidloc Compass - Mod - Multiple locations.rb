################################################################################
#    Compass script v.1.2                                                      #
#         by Tidloc                                                            #
#==============================================================================#
#  simple script, that allows on given maps a compass to appear and point at a #
#  given point on that map. To define that point use the following command:    #
#     Tidloc::Set_Coord(*map*,*x*,*y*)                                         #
#  were x and y are the x and y coordinates on that map.                       #
#  If no coordinates are saved for a specific map, no compass will appear.     #
#==============================================================================#
#  Only adjustable thing in this script is the name of the graphic for the     #
#  compass, and the place where the compass will be shown. Everything else     #
#  will be calculated on its own by using the stated command.                  #
#  You can erase the saved coordinates with the command:                       #
#     Tidloc::Clear_Coord(*map*)                                               #
#  You are free to leave the map out, then all coordinates will be erased.     #
#==============================================================================#
#  Feel free to use this script, but please credit me for my work! ^__^        #
#==============================================================================#
#  Modification: Roninator2                                                    #
#  Now able to hold several locations at once                                  #
#  New method - Remove_Coord                                                   #
#    Specify what coordinates to remove - Tidloc::Remove_Coord(map_id, x, y)   #
#  It will hold any coordinates you provide, but will only point               #
#    to the last one in the array for that map.                                #
################################################################################

$imported = {} if $imported.nil?
$imported["Tidloc-Compass"] = [1,2,0]

module Tidloc
  module Compass
    Graphic = "compass_needle"
    Target  = nil
    X = Graphics.width - 32
    Y = 32
  end
   
################################################################################
 
  class<<self
    def Set_Coord(map,x,y)
      $game_system._tidloc_compass[map] = [] if $game_system._tidloc_compass[map].nil?
      $game_system._tidloc_compass[map] << [x,y]
    end
    
    def Remove_Coord(map,x,y)
      return if $game_system._tidloc_compass == []
      for i in 0..$game_system._tidloc_compass[map].size - 1
        set = $game_system._tidloc_compass[map][i]
        if set[0] == x && set[1] == y
          $game_system._tidloc_compass[map].delete($game_system._tidloc_compass[map][i])
        end
      end
    end
    
    def Clear_Coord(map = nil)
      if map == nil
        $game_system._tidloc_compass = []
      else
        $game_system._tidloc_compass[map] = []
      end
    end
  end
end
 
class Game_System
  attr_accessor :_tidloc_compass
  alias wo_compass_init initialize
  def initialize
    self._tidloc_compass = []
    wo_compass_init
  end
end
 
class Scene_Map < Scene_Base
  if !$imported["Tidloc-Header"]
    alias wo_tidloc_update update
    def update
        compass_update
      wo_tidloc_update
    end
  end

  def compass_update
    if $game_system._tidloc_compass[$game_map.map_id]
      x = Tidloc::Compass::X
      y = Tidloc::Compass::Y
      ydif = 0
      xdif = 0
      $game_map.screen.pictures[401].show(Tidloc::Compass::Graphic,
                                           1, x, y, 50, 50, 255, 0)
      $game_system._tidloc_compass[$game_map.map_id].each do |i|
        next if i.nil?
        xdif = $game_player.x - i[0].to_i
        ydif = $game_player.y - i[1].to_i
      end
      angle = 0
      if ydif == 0 && xdif > 0
        angle = 180
      elsif ydif == 0 && xdif < 0
        angle = -180
      elsif xdif == 0 && ydif > 0
        angle = 0
      elsif xdif == 0 && ydif < 0
        angle = 360
      elsif xdif == 0 && ydif == 0
        $game_map.screen.pictures[401].erase
        unless Tidloc::Compass::Target.nil?
          $game_map.screen.pictures[401].show(Tidloc::Compass::Target,
                                           1, x, y, 50, 50, 255, 0)
        end                                  
      else
        angle = Math::atan2(xdif + 0.0, ydif + 0.0) * 360.0 / Math::PI
      end
      $game_map.screen.pictures[401].rotate(angle)
    else
      $game_map.screen.pictures[401].erase
    end
  end
end
