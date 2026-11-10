/datum/quirk/mute
	/* // OCULIS EDIT REMOVAL START - POLITICAL_CORRECTNESS - ableist quirk name/description
	name = "Mute"
	desc = "For some reason you are completely unable to speak."
	*/ // OCULIS EDIT REMOVAL END
	// OCULIS EDIT ADDITION START - POLITICAL_CORRECTNESS - PC quirk strings
	name = "Non-Verbal Communicator"
	desc = "You communicate through alternative, non-verbal modalities. For some reason you are completely unable to speak."
	// OCULIS EDIT ADDITION END
	icon = FA_ICON_VOLUME_XMARK
	value = -4
	mob_trait = TRAIT_MUTE
	gain_text = span_danger("You adopt a non-verbal communication modality. It is equally valid.") // OCULIS EDIT CHANGE - ORIGINAL: gain_text = span_danger("You find yourself unable to speak!")
	lose_text = span_notice("You regain your verbal communication privilege.") // OCULIS EDIT CHANGE - ORIGINAL: lose_text = span_notice("You feel a growing strength in your vocal chords.")
	medical_record_text = "Patient communicates through non-verbal modalities; no correction required." // OCULIS EDIT CHANGE - ORIGINAL: medical_record_text = "The patient is unable to use their voice in any capacity."
	hardcore_value = 4
