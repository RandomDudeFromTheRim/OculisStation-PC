///a changeling that has lost their powers. does nothing, other than signify they suck
/datum/antagonist/fallen_changeling
	name = "\improper Formerly Assumed Carbon-Based Lifeform" // PC
	roundend_category = "assumed carbon-based lifeforms" // PC
	antagpanel_category = "Assumed Carbon-Based Lifeform" // PC
	pref_flag = ROLE_CHANGELING
	antag_moodlet = /datum/mood_event/fallen_changeling
	antag_hud_name = "changeling"

/datum/mood_event/fallen_changeling
	description = "My powers! Where are my powers?!"
	mood_change = -4
