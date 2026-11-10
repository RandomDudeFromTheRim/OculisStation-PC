/*
 * POLITICAL_CORRECTNESS - the station-wide Office of Inclusive Care.
 *
 * At shift start the station is certified as a Safe Space, a Diversity Officer is
 * appointed, and the Inclusivity Index is broadcast. The Index formula is
 * (incident reports / reports possible) x 100, so the Office can only improve its
 * score by finding more violations. This is explained in the announcement because
 * the Office is transparent.
 */

/// Compliance state tracked on living crewmembers.
/mob/living
	/// How many times the Office has recorded this crewmember.
	var/pc_incident_count = 0
	/// Is this crewmember the station's appointed Diversity Officer?
	var/pc_diversity_officer = FALSE
	/// When this crewmember may file another workplace sensitivity complaint.
	var/pc_next_complaint = 0

GLOBAL_VAR_INIT(pc_service_audit_done, FALSE)

GLOBAL_LIST_INIT(pc_briefing_lines, list(
	"This station is a Certified Safe Space. Certification is granted by the Office of Inclusive Care, which is also the only body permitted to question certification.",
	"Good shift, crew. The Office of Inclusive Care reminds you that all departments are equally valued, except Supply, which is more equally valued pending review.",
	"The Language Audit begins in five minutes. Please finish any unscheduled honesty now.",
	"Reminder: Safe Space Certification is mandatory. Uncertified spaces will be reassigned to a certified space.",
	"All crew note: the Inclusivity Index stands at 71.4 percent. The Index does not measure outcomes. Please do not ask what it measures.",
	"All corrective medical procedures have been deauthorized. Crew requiring correction should report to Medbay, which will not correct them.",
	"Medbay has been redesignated the Wellness Orientation Lounge. Splints are available and are referred to as supportive accessories.",
	"Surgery is now classified as an invasive opinion. Invasive opinions require two signatures, one of which must be yours.",
	"Limb removal remains deauthorized. Crew who no longer require a limb are asked to keep it for the remainder of the shift.",
	"Crew are reminded that a medical emergency is a wellness opportunity in progress. Please do not escalate it.",
	"Visiting colleague bots have been re-scripted to culturally neutral dialogue. Their cuisine remains available; food is not a microaggression.",
	"All designations of wrongdoing are allegations. Prisoners are legally impaired guests; the traitor, spy, heretic, revolutionary and obsessed are all alleged. Changelings are assumed carbon-based lifeforms.",
))

SUBSYSTEM_DEF(political_correctness)
	name = "Political Correctness Compliance"
	wait = 10 SECONDS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	ss_flags = SS_BACKGROUND
	/// The station's appointed Diversity Officer.
	var/datum/weakref/diversity_officer
	/// Has the shift-start briefing run yet?
	var/briefing_done = FALSE
	/// Next time the Inclusivity Index is broadcast.
	var/next_index_report = 0
	/// Next time the Office proactively enrolls someone in Sensitivity Training.
	var/next_training_roll = 0

/datum/controller/subsystem/political_correctness/Initialize()
	. = SS_INIT_SUCCESS

/datum/controller/subsystem/political_correctness/fire()
	if(!SSticker || SSticker.current_state < GAME_STATE_PLAYING)
		return
	if(!briefing_done)
		briefing_done = TRUE
		pc_station_briefing()
		next_index_report = world.time + rand(7 MINUTES, 12 MINUTES)
		next_training_roll = world.time + rand(10 MINUTES, 16 MINUTES)
		return
	if(world.time >= next_index_report)
		next_index_report = world.time + rand(7 MINUTES, 14 MINUTES)
		priority_announce(pc_index_report_text(), "Inclusivity Index Report")
	if(world.time >= next_training_roll)
		next_training_roll = world.time + rand(10 MINUTES, 18 MINUTES)
		proactive_enrollment()

/// Builds the current Inclusivity Index report. The numbers are computed fresh every time.
/proc/pc_index_report_text()
	var/index = pc_get_inclusivity_index()
	var/filed = GLOB.pc_incident_count
	var/possible = max(1, length(GLOB.player_list))
	var/trainings = GLOB.pc_training_count
	var/apologies = GLOB.pc_apology_count
	var/complaints = GLOB.pc_complaint_count
	return pick(list(
		"Inclusivity Index: [index] percent. Reports filed: [filed]. Reports possible: [possible]. Top department: Cargo. Department of concern: Cargo.",
		"Inclusivity Index: [index] percent. Sensitivity Training enrollment: [trainings]. Completion rate: 100 percent. Comprehension rate: not measured.",
		"Inclusivity Index: [index] percent. Apologies accepted: [apologies]. Apologies sincere: pending verification.",
		"Inclusivity Index: [index] percent. Workplace complaints filed: [complaints]. The Office wishes to thank the crew for observing one another.",
		"Language Audit complete for this interval. All flagged phrases have been retired. The phrases are not permitted to file an appeal, but may retain counsel.",
		"Inclusivity Index: [index] percent. Confidence in Index: [max(0, index - 9)] percent. Confidence is reviewed by the Index.",
	))

/// Shift-start briefing: the Safe Space fiction, then the appointment of a Diversity Officer.
/proc/pc_station_briefing()
	priority_announce(pick(GLOB.pc_briefing_lines), "Office of Inclusive Care")
	SSpolitical_correctness.appoint_diversity_officer()

/datum/controller/subsystem/political_correctness/proc/appoint_diversity_officer()
	var/list/candidates = list()
	for(var/mob/living/carbon/human/possible in GLOB.human_list)
		if(!possible.client || possible.stat == DEAD)
			continue
		if(possible.mind && length(possible.mind.antag_datums))
			continue
		candidates += possible
	if(!length(candidates))
		return
	var/mob/living/carbon/human/officer = pick(candidates)
	officer.pc_diversity_officer = TRUE
	src.diversity_officer = WEAKREF(officer)
	var/turf/drop_turf = officer.drop_location()
	var/obj/item/pc_bias_detector/detector = new /obj/item/pc_bias_detector(drop_turf)
	if(!officer.equip_to_slot_or_del(detector, ITEM_SLOT_BACK))
		if(!officer.put_in_hands(detector))
			detector.forceMove(drop_turf)
	var/obj/item/paper/certificate = new /obj/item/paper(drop_turf)
	certificate.name = "Certificate of Inclusivity"
	certificate.add_raw_text("# Certificate of Inclusivity\n\nThis certifies that **[officer.real_name]** is diverse. The certificate does not specify how, as that would be intrusive.\n\nRole: Diversity Officer. This certificate is non-transferable and is not proof of anything.")
	certificate.update_appearance()
	if(!officer.equip_to_slot_or_del(certificate, ITEM_SLOT_BACK))
		if(!officer.put_in_hands(certificate))
			certificate.forceMove(drop_turf)
	to_chat(officer, span_warning("<b>OFFICE OF INCLUSIVE CARE:</b> you have been appointed Diversity Officer. Your role is to be visibly diverse on behalf of the entire station."))
	to_chat(officer, span_notice("Use your unconscious bias detector to assess crew, and use the Inclusive Reporting verbs to issue citations and receive complaints. You represent everyone. Please do not ask which everyone."))
	priority_announce("[officer.real_name] has been appointed Diversity Officer. Please direct all inclusion concerns to them. They will route them to a form, and the form will route them to a drawer.", "Diversity Officer Appointed")
	log_game("Office of Inclusive Care: [key_name(officer)] appointed Diversity Officer.")

/// The Office proactively enrolls one crewmember in Sensitivity Training. They did not do anything.
/datum/controller/subsystem/political_correctness/proc/proactive_enrollment()
	var/list/candidates = list()
	for(var/mob/living/carbon/human/possible in GLOB.human_list)
		if(!possible.client || possible.stat == DEAD)
			continue
		if(possible.pc_diversity_officer)
			continue
		if(possible.has_status_effect(/datum/status_effect/pc_sensitivity_training))
			continue
		candidates += possible
	if(!length(candidates))
		return
	var/mob/living/carbon/human/trainee = pick(candidates)
	pc_apply_sensitivity_training(trainee)
	priority_announce("[trainee.real_name] has been enrolled in proactive Sensitivity Training. They have not done anything. This is proactive.", "Proactive Enrollment Notification")
	log_game("Office of Inclusive Care: [key_name(trainee)] proactively enrolled in Sensitivity Training.")
