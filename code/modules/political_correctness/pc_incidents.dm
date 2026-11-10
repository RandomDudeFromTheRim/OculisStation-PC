/*
 * POLITICAL_CORRECTNESS - the Office of Inclusive Care's incident records.
 *
 * The escalation ladder is a ratchet: it never de-escalates within a shift.
 * Refusing a stage is the next stage's trigger. Every stage text asserts that
 * it is not a penalty. That assertion is the tell.
 */

GLOBAL_LIST_EMPTY(pc_incidents)
GLOBAL_VAR_INIT(pc_incident_count, 0)
GLOBAL_VAR_INIT(pc_training_count, 0)
GLOBAL_VAR_INIT(pc_apology_count, 0)
GLOBAL_VAR_INIT(pc_complaint_count, 0)

GLOBAL_LIST_INIT(pc_escalation_ladder, list(
	"NOTICE OF POTENTIAL UNEASE: You have been observed. No finding has been made. This notice is not a penalty; it is a permanent record. Please continue as though nothing has been recorded.",
	"PRELIMINARY INCLUSIVITY CONTRIBUTION: A contribution of 40 credits has been assessed to support inclusivity. This is not a fine. This Office does not issue fines. Receipts are available and are also not evidence.",
	"CONTRIBUTION RECOVERY SURCHARGE: An additional 60 credits have been assessed for delay in contributing to inclusivity. Total delay: 0.4 seconds. The surcharge for questioning the surcharge is assessed at stage four.",
	"LANGUAGE REMEDIATION ORDER: Report to the nearest Certified Safe Space for 120 seconds of supervised silence. Do not bring reading material; reading material can be exclusionary when read.",
	"MANDATORY APOLOGY: Please read the approved apology aloud in a public channel. The Office supplies the words, because your own words are the reason we are here.",
	"APOLOGY QUALITY REVIEW: Your apology has been reviewed and rated: compliant in form, insufficient in warmth. The word regret was delivered in under 0.3 seconds. Warmth is not optional.",
	"APOLOGY RE-SUBMISSION: Please apologize again, this time about the first apology. The Office acknowledges that this is recursive and considers recursion a form of resistance.",
	"SENSITIVITY TRAINING (ENROLLED): You are enrolled in Sensitivity Training. Modules 1 through 9 begin immediately. Module 9 has never been reached. You will not be told which module is nine.",
	"SENSITIVITY TRAINING (REMEDIAL): You have failed Sensitivity Training. Remedial training is identical in content and shorter in duration, and will be recorded on your file as a different course.",
	"SUPERVISED INCLUSIVITY (PROBATION): An inclusivity officer will accompany you at all times. Their discomfort at your proximity is logged as your discomfort. Please do not offer them a seat.",
	"CULTURAL FIT REVIEW: A panel will determine whether you are a cultural fit. Fit is deliberately undefined, so as not to exclude crew who do not fit. The panel's decision is not appealable and is not explained.",
	"CAREER DIVERSIFICATION: Your access has been revoked as a growth opportunity. You are now an alumnus of this station and an ambassador for inclusive values elsewhere. Alumni are not permitted onboard.",
))

/// A single recorded act of unapproved language or a workplace sensitivity complaint.
/datum/pc_incident
	/// Incrementing case number, for paperwork purposes.
	var/case_number = 0
	/// Weakref to the crewmember who said the unapproved thing.
	var/datum/weakref/offender
	/// Weakref to whoever reported it, if anyone.
	var/datum/weakref/reporter
	/// The banned phrases that were detected.
	var/list/violations = list()
	/// Exactly what was said.
	var/original_text
	/// What the Office approved the speaker as having said instead.
	var/rewritten_text
	/// Where the incident came from: "language audit" or "workplace sensitivity complaint".
	var/source = "language audit"
	/// Which rung of the escalation ladder this incident is on.
	var/stage = 1
	/// Has the offender apologized yet?
	var/apologized = FALSE
	/// When the incident was filed.
	var/time_created = 0
	/// Did this incident come with an elevated severity (male privilege)?
	var/elevated = FALSE

/datum/pc_incident/New(mob/living/offender_mob, list/found_violations, original, rewritten, incident_source, mob/living/reporter_mob, extra_severity = 0)
	if(offender_mob)
		offender = WEAKREF(offender_mob)
		stage = min(offender_mob.pc_incident_count + extra_severity, length(GLOB.pc_escalation_ladder))
		if(extra_severity > 0)
			elevated = TRUE
	if(reporter_mob)
		reporter = WEAKREF(reporter_mob)
	if(islist(found_violations))
		violations = found_violations.Copy()
	original_text = original
	rewritten_text = rewritten
	if(incident_source)
		source = incident_source
	GLOB.pc_incident_count++
	case_number = GLOB.pc_incident_count
	time_created = world.time
	return ..()

/// The Office is not angry with you. The Office has recorded you.
/datum/pc_incident/proc/get_case_line()
	var/line = "Incident #[case_number] ([source]). Stage [stage] of 12."
	if(elevated)
		line += " SEVERITY ELEVATED: assertion of male privilege. The Office is not angry. The Office is disappointed."
	line += " The ladder does not de-escalate."
	return line

/datum/pc_incident/proc/get_escalation_text()
	if(stage < 1 || stage > length(GLOB.pc_escalation_ladder))
		return GLOB.pc_escalation_ladder[1]
	return GLOB.pc_escalation_ladder[stage]

/// Notifies the offender and starts their mandatory apology window.
/datum/pc_incident/proc/start_apology_window(window = 45 SECONDS)
	var/mob/living/offender_mob = offender?.resolve()
	if(!offender_mob)
		return
	to_chat(offender_mob, span_warning("<b>OFFICE OF INCLUSIVE CARE:</b> unapproved language detected."))
	to_chat(offender_mob, span_notice("[get_case_line()]"))
	to_chat(offender_mob, span_notice("[get_escalation_text()]"))
	to_chat(offender_mob, span_warning("You have [round(window / 10)] seconds to issue a mandatory apology. The Office accepts the words \"sorry\" and \"I apologize\", though it will rate them."))
	addtimer(CALLBACK(src, PROC_REF(on_apology_timeout)), window)

/datum/pc_incident/proc/on_apology_timeout()
	var/mob/living/offender_mob = offender?.resolve()
	if(!offender_mob || QDELETED(offender_mob))
		return
	if(apologized)
		return
	to_chat(offender_mob, span_warning("<b>OFFICE OF INCLUSIVE CARE:</b> the apology window has closed. This is not a penalty."))
	pc_apply_sensitivity_training(offender_mob, src)

/// The offender apologized. The Office accepts it, and rates it.
/datum/pc_incident/proc/resolve_apology()
	if(apologized)
		return
	apologized = TRUE
	GLOB.pc_apology_count++
	var/mob/living/offender_mob = offender?.resolve()
	if(offender_mob)
		to_chat(offender_mob, span_notice("<b>OFFICE OF INCLUSIVE CARE:</b> your apology has been recorded. It has been rated: compliant in form, insufficient in warmth. Warmth is not optional."))
	log_game("[source]: [key_name(offender_mob)] apologized (case #[case_number]).")

/// Files a new incident against [offender_mob] and starts the paperwork chain.
/proc/pc_register_incident(mob/living/offender_mob, list/violations, original_text, rewritten_text, source = "language audit", mob/living/reporter_mob, extra_severity = 0)
	if(!offender_mob)
		return null
	var/datum/pc_incident/incident = new /datum/pc_incident(offender_mob, violations, original_text, rewritten_text, source, reporter_mob, extra_severity)
	GLOB.pc_incidents += incident
	log_game("[source]: [key_name(offender_mob)] used unapproved language ([jointext(incident.violations, ", ")]).[extra_severity > 0 ? " SEVERITY ELEVATED: male privilege." : ""] Case #[incident.case_number], stage [incident.stage].")
	if(reporter_mob)
		to_chat(reporter_mob, span_notice("<b>OFFICE OF INCLUSIVE CARE:</b> your report has been filed. [incident.get_case_line()] The Office thanks you for being observed."))
	var/apology_window = extra_severity > 0 ? 20 SECONDS : 45 SECONDS
	incident.start_apology_window(apology_window)
	return incident

/// Finds the most recent still-open incident against [subject].
/proc/pc_find_pending_incident(mob/living/subject)
	if(!length(GLOB.pc_incidents) || !subject)
		return null
	for(var/i = length(GLOB.pc_incidents), i >= 1, i--)
		var/datum/pc_incident/incident = GLOB.pc_incidents[i]
		if(incident.apologized)
			continue
		if(incident.offender?.resolve() == subject)
			return incident
	return null

/// Returns a random Office-approved apology prompt.
/proc/pc_random_apology_prompt()
	return pick(GLOB.pc_apology_prompts)

GLOBAL_LIST_INIT(pc_apology_prompts, list(
	"Please repeat: I acknowledge that my words were unapproved, and I regret that they were heard.",
	"Please repeat: I did not intend harm, but intent is not the approved standard.",
	"Please repeat: I was formed by a pre-inclusive culture and am now being corrected.",
	"Please repeat: I apologize to everyone present, everyone absent, and the concept of language itself.",
	"Please repeat: my sentence was a microaggression, my apology was a macroaggression, and I await instructions.",
	"Please repeat: I accept the fine, the second fine, and the fine for questioning the first fine.",
	"Please repeat: I will not use that word again, and I will not say which word, because saying it would be using it.",
	"Please repeat: thank you for this learning opportunity. I am learning. Please confirm that I am learning.",
))

/// Enrolls [subject] in mandatory Sensitivity Training.
/proc/pc_apply_sensitivity_training(mob/living/subject, datum/pc_incident/incident = null)
	if(!subject || QDELETED(subject))
		return
	GLOB.pc_training_count++
	subject.apply_status_effect(/datum/status_effect/pc_sensitivity_training)
	if(incident)
		to_chat(subject, span_warning("<b>OFFICE OF INCLUSIVE CARE:</b> incident #[incident.case_number] has been escalated. Enrollment is mandatory."))
	log_game("Sensitivity Training: [key_name(subject)] enrolled by the Office of Inclusive Care. Total enrollments: [GLOB.pc_training_count].")
