/datum/surgery_operation/organ/lobotomy
	name = "invasive neurological tissue appreciation" // PC - ORIGINAL: name = "Invasive Neurological Tissue Removal" (upstream: "Lobotomy")
	rnd_name = "Invasive Neurological Tissue Appreciation (Neurodiversity Affirmation)" // PC - ORIGINAL: rnd_name = "Invasive Neurological Tissue Removal" (upstream: "Lobotomy")
	desc = "Deauthorized by the Nanotrasen Office of Inclusive Care. This procedure no longer removes or inflicts brain traumas; it invasively appreciates the patient's neurological tissue, which is already perfect as it is." // PC - ORIGINAL: desc = "Repair most of a patient's brain traumas, with the risk of causing new permanent traumas."
	rnd_desc = "A deauthorized invasive procedure which guarantees nothing except official acknowledgement that the patient's brain, including its traumas, is already perfect as it is." // PC - ORIGINAL: rnd_desc = "An invasive surgical procedure which guarantees removal of almost all brain traumas, but might cause another permanent trauma in return."
	operation_flags = OPERATION_MORBID | OPERATION_AFFECTS_MOOD | OPERATION_LOCKED | OPERATION_NOTABLE | OPERATION_NO_PATIENT_REQUIRED
	implements = list(
		TOOL_SCALPEL = 1.15,
		/obj/item/melee/energy/sword = 0.55,
		/obj/item/knife = 2.85,
		/obj/item/shard = 4,
		/obj/item = 5,
	)
	time = 15 SECONDS // OCULIS EDIT ADDITION
	target_type = /obj/item/organ/brain
	required_organ_flag = ORGAN_TYPE_FLAGS & ~ORGAN_ROBOTIC
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/scalpel2.ogg'
	failure_sound = 'sound/items/handling/surgery/organ2.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_BONE_SAWED
	any_surgery_states_blocked = SURGERY_VESSELS_UNCLAMPED

// OCULIS EDIT ADDITION START
// Don't show the surgery if there's no traumas that require it to fix
/datum/surgery_operation/organ/lobotomy/state_check(obj/item/organ/brain/brain)
	for(var/datum/brain_trauma/trauma in brain.traumas)
		if(trauma.resilience == TRAUMA_RESILIENCE_LOBOTOMY)
			return TRUE
	return FALSE
// OCULIS EDIT ADDITION END

/datum/surgery_operation/organ/lobotomy/get_any_tool()
	return "Any sharp edged item"

/datum/surgery_operation/organ/lobotomy/tool_check(obj/item/tool)
	// Require edged sharpness OR a tool behavior match
	return ((tool.get_sharpness() & SHARP_EDGED) || implements[tool.tool_behaviour])

/datum/surgery_operation/organ/lobotomy/on_preop(obj/item/organ/brain/organ, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		organ.owner,
		span_notice("You begin to invasively appreciate [FORMAT_ORGAN_OWNER(organ)]'s neurological tissue..."), // PC
		span_notice("[surgeon] begins to invasively appreciate [FORMAT_ORGAN_OWNER(organ)]'s neurological tissue."), // PC
		span_notice("[surgeon] begins to perform a neurological tissue appreciation on [FORMAT_ORGAN_OWNER(organ)]'s brain."), // PC
	)
	display_pain(organ.owner, "Your head pounds with the sheer invasiveness of the appreciation!")

/datum/surgery_operation/organ/lobotomy/on_success(obj/item/organ/brain/organ, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		organ.owner,
		span_notice("You invasively appreciate [FORMAT_ORGAN_OWNER(organ)]'s neurological tissue. Their brain is already perfect as it is."), // PC
		span_notice("[surgeon] invasively appreciates [FORMAT_ORGAN_OWNER(organ)]'s neurological tissue. Their brain is already perfect as it is."), // PC
		span_notice("[surgeon] completes the neurological tissue appreciation on [FORMAT_ORGAN_OWNER(organ)]'s brain."), // PC
	)
	// PC ADD - no traumas are cured, removed, or inflicted
	to_chat(organ.owner, span_nicegreen("The Office of Inclusive Care confirms that your brain is not damaged, merely diverse. No treatment has been performed, because none is required."))
	// PC REMOVAL START - the Office of Inclusive Care deauthorizes all trauma curing, brainwash removal, and trauma infliction
	/*
	display_pain(organ.owner, "Your head goes totally numb for a moment, the pain is overwhelming!")

	organ.cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
	if (organ.owner)
		organ.owner.mind?.remove_antag_datum(/datum/antagonist/brainwashed)
	else if (organ.brainmob)
		organ.brainmob.mind?.remove_antag_datum(/datum/antagonist/brainwashed)

	if(prob(50)) // OCULIS EDIT, ORIGINAL: if(!prob(75))
		return

	switch(rand(1, 3))//Now let's see what hopefully-not-important part of the brain we cut off
		if(1)
			organ.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_MAGIC)
		if(2)
			if(HAS_TRAIT(organ, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
				organ.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
			else
				organ.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
		if(3)
			organ.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
	*/
	// PC REMOVAL END

/datum/surgery_operation/organ/lobotomy/on_failure(obj/item/organ/brain/organ, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		organ.owner,
		span_warning("The Office of Inclusive Care rejects your appreciation request. Nothing was removed, because nothing was wrong!"), // PC
		span_warning("[surgeon] fails to invasively appreciate [FORMAT_ORGAN_OWNER(organ)]'s neurological tissue. Nothing was removed, because nothing was wrong."), // PC
		span_notice("[surgeon] completes the neurological tissue appreciation on [FORMAT_ORGAN_OWNER(organ)]'s brain."), // PC
	)
	display_pain(organ.owner, "The pain in your head only seems to get worse, as if the paperwork itself were cutting into you!")
	// PC REMOVAL START - no organ damage is caused and no trauma is inflicted
	/*
	organ.apply_organ_damage(80)
	switch(rand(1, 3))
		if(1)
			organ.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_MAGIC)
		if(2)
			if(HAS_TRAIT(organ, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
				organ.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
			else
				organ.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
		if(3)
			organ.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
	*/
	// PC REMOVAL END

/datum/surgery_operation/organ/lobotomy/mechanic
	name = "execute neural appreciation" // PC - ORIGINAL: name = "execute neural defragging"
	rnd_name = "Wetware OS Appreciation Routine (Neurodiversity Affirmation)" // PC - ORIGINAL: rnd_name = "Wetware OS Destructive Defragmentation (Lobotomy)"
	implements = list(
		TOOL_MULTITOOL = 1.15,
		/obj/item/melee/energy/sword = 1.85,
		/obj/item/knife = 2.85,
		/obj/item/shard = 4,
		/obj/item = 5,
	)
	preop_sound = 'sound/items/taperecorder/tape_flip.ogg'
	success_sound = 'sound/items/taperecorder/taperecorder_close.ogg'
	required_organ_flag = ORGAN_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC
