/datum/quirk/clumsy
	/* // OCULIS EDIT REMOVAL START - POLITICAL_CORRECTNESS - ableist quirk name/description
	name = "Clumsy"
	desc = "You're clumsy, a goofball, a silly dude. You big loveable dope you! Hope you weren't planning on using your hands for anything that takes even a LICK of dexterity."
	*/ // OCULIS EDIT REMOVAL END
	// OCULIS EDIT ADDITION START - POLITICAL_CORRECTNESS - PC quirk strings
	name = "Differently Coordinated"
	desc = "You have a bold and interpretive relationship with fine motor control. Hope you weren't planning on using your hands for anything that takes even a LICK of dexterity."
	// OCULIS EDIT ADDITION END
	icon = FA_ICON_FACE_DIZZY
	value = -8
	mob_trait = TRAIT_CLUMSY
	gain_text = span_danger("Your proprioceptive confidence takes a well-deserved break.") // OCULIS EDIT CHANGE - ORIGINAL: gain_text = span_danger("You feel your IQ sink like your brain is liquid.")
	lose_text = span_notice("Your coordination returns to the normative standard.") // OCULIS EDIT CHANGE - ORIGINAL: lose_text = span_notice("You feel like your IQ went up to at least average.")
	medical_record_text = "Patient demonstrates a non-normative motor coordination style and an unconventional approach to problem-solving." // OCULIS EDIT CHANGE - ORIGINAL: medical_record_text = "Patient has demonstrated an extreme difficulty with high motor skill paired with an inability to demonstrate critical thinking."
	medical_symptom_text = "Exhibits a bold coordination style and frequent spontaneous physical expressions, along with an alternative approach to decision-making tasks." // OCULIS EDIT CHANGE - ORIGINAL: medical_symptom_text = "Exhibits poor coordination and frequent accidents, along with difficulty in problem-solving and decision-making tasks."
	quirk_flags = QUIRK_TRAUMALIKE
