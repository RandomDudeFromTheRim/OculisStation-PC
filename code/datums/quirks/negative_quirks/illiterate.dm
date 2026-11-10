/datum/quirk/illiterate
	/* // OCULIS EDIT REMOVAL START - POLITICAL_CORRECTNESS - ableist quirk name/description
	name = "Illiterate"
	desc = "You dropped out of school and are unable to read or write. This affects reading, writing, using computers and other electronics."
	*/ // OCULIS EDIT REMOVAL END
	// OCULIS EDIT ADDITION START - POLITICAL_CORRECTNESS - PC quirk strings
	name = "Differently Literate"
	desc = "You engage with written language through alternative modalities. This affects reading, writing, using computers and other electronics."
	// OCULIS EDIT ADDITION END
	icon = FA_ICON_GRADUATION_CAP
	value = -8
	mob_trait = TRAIT_ILLITERATE
	medical_record_text = "Patient's literacy is non-normative; no correction required." // OCULIS EDIT CHANGE - ORIGINAL: medical_record_text = "Patient is not literate."
	hardcore_value = 8
	mail_goodies = list(/obj/item/pai_card) // can read things for you
	//IRIS EDIT ADDITION BEGIN - COGNOMERGE_EVENT
	gain_text = span_danger("You transition to an alternative literacy modality.") // OCULIS EDIT CHANGE - ORIGINAL: gain_text = span_danger("You forget how to read.")
	lose_text = span_notice("You regain normative literacy.") // OCULIS EDIT CHANGE - ORIGINAL: lose_text = span_notice("You remember how to read again.")
	//IRIS EDIT ADDITION END
