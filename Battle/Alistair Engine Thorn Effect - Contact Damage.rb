#===============================================================================
# AE - Alistair Engine
#===============================================================================
# Code Snippet: Contact Damage Effect - from Thorn Aura 
# mod by Roninator2
# Version: 1.0
#
# Changelog:
# 1.0 - First Version
#===============================================================================
# Instructions:
# Place the code snippet into YEA - Lunatic States above the part where it says
# "Stop editing past this point". That's somewhere around line 188 by default.
#
#===NOTETAGS===================================================================
#---> States <---
#
# <contact x>
# This will perform x damage to the user when hitting an enemy
#
# <contact_percent x%>
# This will damage x% to the user when hitting an enemy
#
# Recommended effect: <begin effect> or <while effect>
# e.g. <begin effect: contact_percent 4%>
#===SCRIPT=CALLS================================================================
#
# | NONE
#
#===============================================================================


#  You should copy everything that's below this line! Don't copy my header, it will just unneccesarily bloat
#  your script!

    when /CONTACT_PERCENT[ ](\d+)[%]/i
      return if @result.hp_damage < 0
      subject = SceneManager.scene.subject
      contact = (@result.hp_damage * ($1.to_i * 0.01)).round
      if subject.actor?
        target = $game_troop.members[subject.index]
      end # if
      if subject.enemy?
        target = subject
      end # if
      target.perform_damage_effect
      text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], contact.group)
      target.create_popup(text, "HP_DMG")
      target.hp -= contact
      target.create_popup(state.name, "WEAK_ELE")
      target.perform_collapse_effect if target.hp <= 0

    when /CONTACT[ ](\d+)/i
      return if @result.hp_damage < 0
      subject = SceneManager.scene.subject
      contact = $1.to_i
      if subject.actor?
        target = $game_troop.members[subject.index]
      end # if
      if subject.enemy?
        target = subject
      end # if
      target.perform_damage_effect
      text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], contact.group)
      target.create_popup(text, "HP_DMG")
      target.hp -= contact
      target.create_popup(state.name, "WEAK_ELE")
      target.perform_collapse_effect if target.hp <= 0
