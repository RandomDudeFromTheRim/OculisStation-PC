/datum/quirk/item_quirk/deafness
	/* // OCULIS EDIT REMOVAL START - POLITICAL_CORRECTNESS - ableist quirk name/description
	name = "Deaf"
	desc = "You are incurably deaf."
	*/ // OCULIS EDIT REMOVAL END
	// OCULIS EDIT ADDITION START - POLITICAL_CORRECTNESS - PC quirk strings
	name = "Auditory Differently Abled"
	desc = "Your auditory perception is non-normative and permanent. Nanotrasen's accessibility policy supports your lived experience; no correction is required."
	// OCULIS EDIT ADDITION END
	icon = FA_ICON_DEAF
	value = -8
	mob_trait = TRAIT_DEAF
	gain_text = span_danger("You enter a non-auditory perceptual modality. The silence is valid.") // OCULIS EDIT CHANGE - ORIGINAL: gain_text = span_danger("You can't hear anything.")
	lose_text = span_notice("Your auditory perception returns to the normative modality.") // OCULIS EDIT CHANGE - ORIGINAL: lose_text = span_notice("You're able to hear again!")
	medical_record_text = "Patient's auditory processing is permanently non-normative; no correction required." // OCULIS EDIT CHANGE - ORIGINAL: medical_record_text = "Patient's cochlear nerve is incurably damaged."
	hardcore_value = 12
	mail_goodies = list(/obj/item/clothing/mask/whistle)

/datum/quirk/item_quirk/deafness/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/deaf_pin, list(LOCATION_BACKPACK, LOCATION_HANDS))
