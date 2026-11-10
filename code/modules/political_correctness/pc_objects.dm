/*
 * POLITICAL_CORRECTNESS - the unconscious bias detector.
 *
 * A repurposed health analyzer which has been calibrated to detect unconscious
 * bias instead of vital signs. It can detect neither. The Diversity Officer is
 * issued one at the start of every shift; the reports it prints are not
 * actionable, but they are kept on file.
 */

GLOBAL_LIST_INIT(pc_bias_reports, list(
	list("BIAS 61.2%", "DIAGNOSIS: unexamined proximity to Cargo.", "RECOMMENDATION: remain 2 metres from all crates for one shift."),
	list("BIAS 12.4%", "DIAGNOSIS: performative low bias.", "RECOMMENDATION: increase suspicion of yourself."),
	list("BIAS 99.1%", "DIAGNOSIS: exhaustive bias.", "RECOMMENDATION: none. You have completed bias."),
	list("BIAS 44.0%", "DIAGNOSIS: microaggression debt carried over from a prior shift.", "RECOMMENDATION: file a repayment plan with the Office."),
	list("BIAS 0.0%", "ERROR: subject may be synthetic. Synthetic crew cannot be biased.", "RECOMMENDATION: confirm subject is not a chair."),
	list("BIAS 73.8%", "DIAGNOSIS: unearned confidence.", "RECOMMENDATION: attend Confidence Reduction, then attend it again."),
	list("BIAS 55.5%", "DIAGNOSIS: symmetrical bias detected.", "RECOMMENDATION: pick a lane."),
	list("BIAS 38.2%", "DIAGNOSIS: bias stored in a decorative container.", "RECOMMENDATION: transfer bias to a colleague who has done the training."),
	list("BIAS 88.8%", "DIAGNOSIS: bias of unusual size.", "RECOMMENDATION: log bias as hazardous material and label the container."),
	list("BIAS 27.6%", "DIAGNOSIS: bias inherited during shift handover.", "RECOMMENDATION: return to the previous shift and apologize retroactively."),
	list("BIAS 66.6%", "DIAGNOSIS: scan incomplete. Subject moved during inclusivity.", "RECOMMENDATION: hold still while being assessed."),
	list("BIAS 1.0%", "DIAGNOSIS: suspiciously clean.", "RECOMMENDATION: 1.0% is below the mandatory minimum. Please acquire bias."),
))

/obj/item/pc_bias_detector
	name = "unconscious bias detector"
	desc = "A hand-held inclusivity assessment device, repurposed from a health analyzer. It detects unconscious bias with the same precision with which it detects vital signs, which is to say it reports whatever it was going to report anyway."
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "health"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	interaction_flags_click = NEED_LITERACY|NEED_LIGHT|ALLOW_RESTING

/obj/item/pc_bias_detector/attack_self(mob/user)
	. = ..()
	if(!isliving(user))
		return
	assess_crewmember(user, user)

/obj/item/pc_bias_detector/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	. = ITEM_INTERACT_SUCCESS
	if(interacting_with == user)
		assess_crewmember(user, user)
		return
	user.visible_message(
		span_notice("[user] performs an inclusivity assessment on [interacting_with] with [src]."),
		span_notice("You perform an inclusivity assessment on [interacting_with] with [src]."),
	)
	playsound(user.loc, 'sound/items/healthanalyzer.ogg', 50)
	assess_crewmember(user, interacting_with)
	add_fingerprint(user)

/obj/item/pc_bias_detector/proc/assess_crewmember(mob/living/user, mob/living/target)
	if(!user || !target)
		return
	var/list/report = pick(GLOB.pc_bias_reports)
	var/text = "<span class='info'>OFFICE OF INCLUSIVE CARE - UNCONSCIOUS BIAS ASSESSMENT</span><br>"
	text += "<span class='info ml-1'>Subject: [target.real_name] ([target.job || "unassigned"])</span><br>"
	text += "<span class='alert ml-1'>[report[1]]</span><br>"
	text += "<span class='info ml-1'>[report[2]]</span><br>"
	text += "<span class='info ml-1'>[report[3]]</span><br>"
	text += "<span class='notice ml-1'>This assessment is not actionable. It has been filed anyway.</span>"
	to_chat(user, custom_boxed_message("blue_box", text))
	if(target != user)
		to_chat(target, span_warning("You are being assessed for unconscious bias. Please do not move during inclusivity."))
	log_game("Unconscious Bias Detector: [key_name(user)] assessed [key_name(target)] - [report[1]].")
