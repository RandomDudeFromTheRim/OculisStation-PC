/datum/quirk/unstable
	/* // OCULIS EDIT REMOVAL START - POLITICAL_CORRECTNESS - sanist quirk name/description
	name = "Unstable"
	desc = "Due to past troubles, you are unable to recover your sanity if you lose it. Be very careful managing your mood!"
	*/ // OCULIS EDIT REMOVAL END
	// OCULIS EDIT ADDITION START - POLITICAL_CORRECTNESS - PC quirk strings
	name = "Mood-Nonconforming"
	desc = "Due to your lived experience, your mood does not self-restore once deregulated. Please manage your emotional accessibility plan with care!"
	// OCULIS EDIT ADDITION END
	icon = FA_ICON_ANGRY
	value = -10
	mob_trait = TRAIT_UNSTABLE
	gain_text = span_danger("There's a lot on your mind right now.")
	lose_text = span_notice("Your mind finally feels calm.")
	medical_record_text = "Patient's emotional state is vulnerable and requires accommodations to recover from stressful events." // OCULIS EDIT CHANGE - ORIGINAL: medical_record_text = "Patient's mind is in a vulnerable state, and cannot recover from traumatic events."
	medical_symptom_text = "Exhibits a strongly non-normative mood cycle and a need for supported recovery from psychological stressors." // OCULIS EDIT CHANGE - ORIGINAL: medical_symptom_text = "Exhibits severe mood instability and an inability to recover from psychological stressors."
	hardcore_value = 9
	mail_goodies = list(/obj/effect/spawner/random/entertainment/plushie)
	quirk_flags = QUIRK_TRAUMALIKE
