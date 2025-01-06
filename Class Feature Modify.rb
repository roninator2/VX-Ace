# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Class Feature Modify                   ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Adjust features for equipment               ╠════════════════════╣
# ║   on class. Blocking or Adding                ║    16 Feb 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Modify Class Features                                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:   Block                                              ║
# ║   put note tag on weapon or armour that is blocked                 ║
# ║   from a specific class                                            ║
# ║     <class restrict: x, x, x...>                                   ║
# ║  The effect:                                                       ║
# ║    All features on the weapon or armour will not work              ║
# ║    Only classes not in the notetag will get the features           ║
# ║                                                                    ║
# ║                 Add                                                ║
# ║    put note tag on weapon or armour that is to be                  ║
# ║    given extra stat boost for specific classes                     ║
# ║     <class bonus: class id, class id>                              ║
# ║       :stat bonus                                                  ║
# ║       :stat bonus                                                  ║
# ║     </class bonus>                                                 ║
# ║    e.g.                                                            ║
# ║     <class bonus: 2, 5> Bonus will apply to class 2 & 5            ║
# ║     :MHP 100   # increase max hp by 100                            ║
# ║     :ATK 5     # increase attack by 5                              ║
# ║     :HRG 50    # increase health regeneration by 50%               ║
# ║     :PDR 80    # Sets Physical Damage Rate to 80%                  ║
# ║     </class bonus>                                                 ║
# ║                                                                    ║
# ║  List of stats that can be assigned                                ║
# ║    Param                                                           ║
# ║      :MHP  :MMP  :ATK  :DEF  :MAT  :MDF  :AGI  :LUK                ║
# ║                                                                    ║
# ║    XPARAM  Ratio -> e.g. :HIT 10  Adds 10% to hit                  ║
# ║      :HIT  :EVA  :CRI  :CEV  :MEV                                  ║
# ║      :MRF  :CNT  :HRG  :MRG  :TRG                                  ║
# ║                                                                    ║
# ║    SPARAM  Ratio -> e.g. :PHA 10  Overwrites pha to 10%            ║
# ║      :TGR  :GRD  :REC  :PHA  :MCR                                  ║
# ║      :TCR  :PDR  :MDR  :FDR  :EXP                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 16 Feb 2022 - Created script with help from Tsukihime code  ║
# ║ 1.01 - 18 Feb 2022 - Script extended for bonus features            ║
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
  Bad_Class = /<class[ _-]restrict:[ ]*(\d+(?:\s*,\s*\d+)*)>/i
  Class_Bonus = /<class[-_ ]bonus:[ ]*(\d+(?:\s*,\s*\d+)*)>(.*?)<\/class[-_ ]bonus>/im
end
  
module DataManager
  class <<self 
    alias load_database_original_r2_class_equip_adjust_param load_database
  end
  def self.load_database
    load_database_original_r2_class_equip_adjust_param
    load_class_adjust_param_equip
  end
  def self.load_class_adjust_param_equip
    groups = [$data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_class_adjust_param_equip
      end
    end
  end
end

class RPG::EquipItem
  attr_accessor :class_equip_restrict
  attr_accessor :hidden_features
  attr_accessor :bonus_features
  attr_accessor :added_features
  attr_accessor :class_equip_bonus_id
  attr_accessor :class_equip_bonus_params
  def load_class_adjust_param_equip
    @hidden_features = []
    @bonus_features = []
    @added_features = []
    @class_equip_restrict = []
    @class_equip_bonus_id = []
    @class_equip_bonus_params = {}
    parameter_list = [:mhp, :mmp, :atk, :def, :mat, :mdf, :agi, :luk, :hit, :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg, :tgr, :grd, :rec, :pha, :mcr, :tcr, :pdr, :mdr, :fdr, :exr]
    results = self.note.scan(R2_Class_Feature_Adjust::Bad_Class)
    results.each do |res|
      data = res[0]
      data.strip.split("\r\n").each do |line|
        restrict = $1.split(",").map {|val| val.to_i }
        @class_equip_restrict << restrict
      end
    end
    results = self.note.scan(R2_Class_Feature_Adjust::Class_Bonus)
    results.each do |res|
      id = res[0]
      data = res[1]
      id.strip.split("\r\n").each do |line|
        bonus_class = $1.split(",").map {|val| val.to_i }
        @class_equip_bonus_id << bonus_class
      end
      key = nil
      dig = 0
      data.strip.split("\r\n").each do |line|
        num = line.split(" ").map {|val| 
          stat = val.to_i
          if stat == 0
            code = val.to_s.upcase
            parameter_list.each do |k|
              key = k if code.include?(k.to_s.upcase)
            end
          else
            dig = val.to_i
          end
          @class_equip_bonus_params[key] = 0 unless key.nil?
          @class_equip_bonus_params[key] = dig unless key.nil?
        }
      end
    end
  end
end

class Game_Actor
  alias r2_class_equip_restrict_param_plus param_plus
  def param_plus(param_id)
    check_class_restrict
    check_class_bonus
    r2_class_equip_restrict_param_plus(param_id)
  end
  
  def check_class_restrict
    equips.compact.each do |eq|
      eq.hidden_features = eq.features if eq.hidden_features == []
      next if eq.class_equip_restrict.empty?
      if eq.class_equip_restrict[0].include?(actor.class_id)
        eq.features = []
        eq.features = eq.added_features if eq.added_features != []
      else
        eq.features = eq.hidden_features if eq.features == []
      end
    end
  end
  def check_class_bonus
    equips.compact.each do |eq|
      next if eq.class_equip_bonus_id.empty?
      if eq.class_equip_bonus_id[0].include?(actor.class_id)
        data = eq.class_equip_bonus_params
        data.each_with_index do |stat, i|
          case stat[0]
          # params
          when :mhp, :mmp, :atk, :def, :mat, :mdf, :agi, :luk
            list = [:mhp, :mmp, :atk, :def, :mat, :mdf, :agi, :luk]
            list.each_with_index do |st, j|
              if stat[0] == st
                id = j 
                value = stat[1]
                eq.params[id] += value unless eq.bonus_features.include?(stat)
                eq.bonus_features << stat unless eq.bonus_features.include?(stat)
              end
            end
          # Xparams - add onto previous value
          when :hit, :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg
            list = [:hit, :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg]
            list.each_with_index do |st, j|
              if stat[0] == st
                id = j 
                value = stat[1]
                value = value.to_f / 100
                code = 22
                eq.features.push(RPG::BaseItem::Feature.new(code, id, value)) unless eq.bonus_features.include?(stat)
                eq.added_features = eq.features# if eq.features == []
                eq.bonus_features << stat unless eq.bonus_features.include?(stat)
              end
            end
          # Sparams - Overwrites previous value
          when :tgr, :grd, :rec, :pha, :mcr, :tcr, :pdr, :mdr, :fdr, :exr
            list = [:tgr, :grd, :rec, :pha, :mcr, :tcr, :pdr, :mdr, :fdr, :exr]
            list.each_with_index do |st, j|
              if stat[0] == st
                id = j 
                value = stat[1]
                value = value.to_f / 100 + 1
                code = 23
                eq.features.push(RPG::BaseItem::Feature.new(code, id, value)) unless eq.bonus_features.include?(stat)
                eq.added_features = eq.features# if eq.features == []
                eq.bonus_features << stat unless eq.bonus_features.include?(stat)
              end
            end
          end
        end
      else
        eq.bonus_features = []
      end
#~       eq.features = eq.added_features if eq.features == []
    end
  end
end
