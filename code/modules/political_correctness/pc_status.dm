/*
 * POLITICAL_CORRECTNESS - the mandatory Sensitivity Training status effect.
 * The course is nine modules. Module nine has never been reached.
 */

GLOBAL_LIST_INIT(pc_training_messages, list(
	"SENSITIVITY TRAINING: session begun. Please sit still for forty minutes and think about it.",
	"Module 1 of 9: What Is A Microaggression? Answer: you will be told later, at length.",
	"Module 2 of 9: Unlearning. You will not be told what you are unlearning, as naming it would reintroduce it.",
	"Training reminder: 4 minutes elapsed, 6 modules remaining, 1 instructor who has also not finished.",
	"You have been in Sensitivity Training for three hours. The course is twenty minutes. Please explain the discrepancy using only approved vocabulary.",
	"Compliance notice: your eyes are closed. Closed eyes are not inclusion. Open them.",
	"The Office reminds you that you are still enrolled. Enrollment is a form of care.",
))

GLOBAL_LIST_INIT(pc_training_complete_messages, list(
	"Training complete. You are now sensitive. Sensitivity is valid for 30 days and must be renewed.",
	"Congratulations, you passed. Everyone passes. That is the problem. Certificate is non-transferable and not proof of anything.",
	"The Office has recorded your completion. The Office has also recorded that you were recorded.",
))

/datum/status_effect/pc_sensitivity_training
	id = "pc_sensitivity_training"
	duration = 2 MINUTES
	tick_interval = 20 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect
	show_duration = TRUE

/datum/status_effect/pc_sensitivity_training/on_apply()
	to_chat(owner, span_warning("<b>MANDATORY SENSITIVITY TRAINING</b> has begun. [pick(GLOB.pc_training_messages)]"))
	to_chat(owner, span_notice("Your eyes are closed. Closed eyes are not inclusion. The Office is watching."))
	return TRUE

/datum/status_effect/pc_sensitivity_training/tick(seconds_between_ticks)
	if(!owner)
		return
	if(prob(45))
		to_chat(owner, span_notice(pick(GLOB.pc_training_messages)))
		if(prob(25))
			to_chat(owner, span_notice("[pc_random_apology_prompt()]"))

/datum/status_effect/pc_sensitivity_training/on_remove()
	if(!owner)
		return
	to_chat(owner, span_notice("<b>SENSITIVITY TRAINING:</b> [pick(GLOB.pc_training_complete_messages)]"))
	to_chat(owner, span_notice("You may now return to work, already sensitive."))
