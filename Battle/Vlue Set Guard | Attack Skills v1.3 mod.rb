#Set Guard/Attack Skills v1.3.2
#----------#
#Features: Let's you set different attack/guard actions for individual actors
#
#Usage:    Placed in note tags of actors, weapons, armors, classes:
#          <Attack_Id skill_id level> - changes default attack if level matches
#          <Guard_Id skill_id level>  - changes default guard if level matchs
#
#           e.g. <guard_id 44 15>
#           guard skill is quick move at level 15
#
#          Weapons/Armors overrides Classes overides Actors.
#          Levels must be in a low to high order
#           e.g. <guard_id 44 10>
#           e.g. <guard_id 49 15>
#          
# addon by Roninator2
#----------#
#-- Script by: V.M of D.T
class Game_Actor
  def guard_skill_id
    @equips.each do |item|
      next unless item.object
    iidg = item.object.note.upcase =~ /<GUARD_ID (\d+)>/i ? $1.to_i : 2
    item.object.note.upcase.each_line { |line|
      if line =~ /<GUARD_ID (\d+)\s*[ ,]?\s*(\d+)*>/i 
        if @level >= $2.to_i
          iidg = $1.to_i
        end
      end
     }
    return iidg if item.object.note.upcase =~ /<GUARD_ID (\d+)>/i
    return iidg if item.object.note.upcase =~ /<GUARD_ID (\d+)\s*[ ,]?\s*(\d+)*>/i
    end
  
    cidg = self.class.note.upcase =~ /<GUARD_ID (\d+)>/ ? $1.to_i : 2
    self.class.note.upcase.each_line { |line|
      if line =~ /<GUARD_ID (\d+)\s*[ ,]?\s*(\d+)*>/i 
        if @level >= $2.to_i
          cidg = $1.to_i
        end
      end
     }
    return cidg if self.class.note.upcase =~ /<GUARD_ID (\d+)>/i
    return cidg if self.class.note.upcase =~ /<GUARD_ID (\d+)\s*[ ,]?\s*(\d+)*>/i
    
    idg = actor.note.upcase =~ /<GUARD_ID (\d+)>/i ? $1.to_i : 2
    actor.note.upcase.each_line { |line|
      if line =~ /<GUARD_ID (\d+)\s*[ ,]?\s*(\d+)*>/i 
        if @level >= $2.to_i
          idg = $1.to_i
        end
      end
     }
    return idg
  end
  
  def attack_skill_id
    @equips.each do |item|
      next unless item.object
      iida = item.object.note.upcase =~ /<ATTACK_ID (\d+)>/i ? $1.to_i : 1
      item.object.note.upcase.each_line { |line|
        if line =~ /<ATTACK_ID (\d+)\s*[ ,]?\s*(\d+)*>/i 
          if @level >= $2.to_i
            iida = $1.to_i
          end
        end
       }
      return iida if item.object.note.upcase =~ /<ATTACK_ID (\d+)>/i
      return iida if item.object.note.upcase =~ /<ATTACK_ID (\d+)\s*[ ,]?\s*(\d+)*>/i
    end
    
    cida = self.class.note.upcase =~ /<ATTACK_ID (\d+)>/i ? $1.to_i : 1
    self.class.note.upcase.each_line { |line|
      if line =~ /<ATTACK_ID (\d+)\s*[ ,]?\s*(\d+)*>/i 
        if @level >= $2.to_i
          cida = $1.to_i
        end
      end
     }
    return cida if self.class.note.upcase =~ /<ATTACK_ID (\d+)>/i
    return cida if self.class.note.upcase =~ /<ATTACK_ID (\d+)\s*[ ,]?\s*(\d+)*>/i 
    
    ida = actor.note.upcase =~ /<ATTACK_ID (\d+)>/i ? $1.to_i : 1
    actor.note.upcase.each_line { |line|
      if line =~ /<ATTACK_ID (\d+)\s*[ ,]?\s*(\d+)*>/i 
        if @level >= $2.to_i
          ida = $1.to_i
        end
      end
     }
    return ida
  end
end
