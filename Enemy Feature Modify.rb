# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Enemy Feature Modify                   ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Adjust features for enemies                 ╠════════════════════╣
# ║                                               ║    22 Jul 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow modifying the features for enemy                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Put note tag on enemy note box in order to block                 ║
# ║   a feature unless the condition is true                           ║
# ║  <feature restrict: feature_id,method,value,condition>             ║
# ║   example                                                          ║
# ║     <feature restrict: 2,st,15>                                    ║
# ║     <feature restrict: 4,sw,50>                                    ║
# ║     <feature restrict: 5,v,21,gt,5>                                ║
# ║     <feature restrict: 5,v,21,lt,5>                                ║
# ║   Feature lists starts at 0                                        ║
# ║                                                                    ║
# ║  Available conditions:                                             ║
# ║    st - state (state must be inflicted)                            ║
# ║    sw - switch (switch must be true)                               ║
# ║    v - variable (gt = greater than, lt = less than)                ║
# ║                                                                    ║
# ║  Numbers:                                                          ║
# ║    st,15 - state 15 is inflicted                                   ║
# ║    sw,50 - switch 50 is true                                       ║
# ║  v,21,gt,5 - variable 21 is equal to or greater than 5             ║
# ║                                                                    ║
# ║  The effect:                                                       ║
# ║    All features on the enemy will not work                         ║
# ║    Only features not in the notetag will be available              ║
# ║    Features that are referenced in the note tag                    ║
# ║    will be used or added to the enemy when the                     ║
# ║    condition is true.                                              ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Jul 2022 - Created script with help from Tsukihime code  ║
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

module R2_Class_Feature_Adjust
  Feature_Restrict = /<feature[ -_]restrict:[ ](\w+(?:\s*,\s*\w+)*)>/i
end
  
module DataManager
  class <<self 
    alias load_database_original_r2_enemy_feature_adjust_mod load_database
  end
  #--------------------------------------------------------------------------
  # * Alias Load Database
  #--------------------------------------------------------------------------
  def self.load_database
    load_database_original_r2_enemy_feature_adjust_mod
    load_enemy_feature_param_mod
  end
  #--------------------------------------------------------------------------
  # * Load Enemy Feature Restrictions
  #--------------------------------------------------------------------------
  def self.load_enemy_feature_param_mod
    for obj in $data_enemies
      next if obj.nil?
      obj.load_enemy_feature_param_mod
    end
  end
end

class RPG::Enemy
  attr_accessor :feature_restrict
  #--------------------------------------------------------------------------
  # * Load Enemy Feature Restrictions
  #--------------------------------------------------------------------------
  def load_enemy_feature_param_mod
    @feature_restrict = []
    results = self.note.scan(R2_Class_Feature_Adjust::Feature_Restrict)
    results.each do |res|
      data = res[0]
      restrict = []
      for x in data.split(",")
        restrict.push(x)
      end
      @feature_restrict << restrict
    end
  end
end

class Game_Enemy
  #--------------------------------------------------------------------------
  # * Overwrite Enemy
  #--------------------------------------------------------------------------
  def enemy
    @saved_features = []
    @original_features = [] if @original_features.nil?
    orig = $data_enemies[@enemy_id]
    @original_features = orig.features if @original_features.empty?
    orig.features = @original_features
    @deleted_features = []
    @removed_features = []
    @removed_features = check_feature_restrict(orig)
    @removed_features.each do |ft|
      @deleted_features << @original_features[ft]
    end
    @original_features.each do |ef|
      next if ef.nil?
      @same = false
      code_o = ef.code
      data_o = ef.data_id
      value_o = ef.value
      @deleted_features.each do |df|
        next if df.nil?
        code_d = df.code
        data_d = df.data_id
        value_d = df.value
        if (code_d == code_o) && (data_o == data_d) && (value_o == value_d)
          @same = true
        end
      end
      @saved_features << ef if @same == false
    end
    orig.features = @saved_features
    return orig
  end
  #--------------------------------------------------------------------------
  # * New Check feature restrictions
  #--------------------------------------------------------------------------
  def check_feature_restrict(orig)
    ft_remove = []
    restrict_features = orig.feature_restrict
    restrict_features.each do |ftr|
      ft = ftr[0].to_i
      mt = ftr[1].to_s.downcase
      vl = ftr[2].to_i
      eq = ftr[3].to_s.downcase 
      cd = ftr[4].to_i
      case mt
      when "st", " st"
        ft_remove.push(ft) if !state?(vl)
      when "sw", " sw"
        if $game_switches[vl] == true
          ft_remove.push(ft)
        end
      when "v", " v"
        if eq == "gt"
          if $game_variables[vl] > cd
            ft_remove.push(ft)
          end
        else
          if $game_variables[vl] < cd
            ft_remove.push(ft)
          end
        end
      end
    end
    return ft_remove
  end
end
