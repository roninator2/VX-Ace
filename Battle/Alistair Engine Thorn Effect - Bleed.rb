#===============================================================================
# AE - Alistair Engine
#===============================================================================
# Code Snippet: Bleed Effect - reverse from Thorn Aura by Roninator2
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
# <bleed x>
# This will perform x damage to the user when acting
#
# <bleed_percent x%>
# This will damage x% of user mhp when taking action.
#
# Recommended effect: <begin effect> or <while effect>
# e.g. <begin effect: bleed_percent 4%>
#===SCRIPT=CALLS================================================================
#
# | NONE
#
#===============================================================================


#  You should copy everything that's below this line! Don't copy my header, it will just unneccesarily bloat
#  your script!

		when /BLEED_PERCENT[ ](\d+)[%]/i
			bleed = (user.mhp * ($1.to_i * 0.01)).round
			target = user
			target.perform_damage_effect
			text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], bleed.group)
			target.create_popup(text, "HP_DMG")
			target.hp -= bleed
			target.create_popup(state.name, "WEAK_ELE")
			target.perform_collapse_effect if target.hp <= 0

		when /BLEED[ ](\d+)/i
			bleed = $1.to_i
			target = user
			target.perform_damage_effect
			text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], bleed.group)
			target.create_popup(text, "HP_DMG")
			target.hp -= bleed
			target.create_popup(state.name, "WEAK_ELE")
			target.perform_collapse_effect if target.hp <= 0
