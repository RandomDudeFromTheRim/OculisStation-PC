/*
 * POLITICAL_CORRECTNESS - crew-facing and Diversity Officer verbs.
 */

GAME_VERB(/mob/living, pc_file_bias_complaint, "File Bias Complaint", "Inclusive Reporting")
	if(!src.client || src.stat == DEAD)
		return
	if(world.time < src.pc_next_complaint)
		to_chat(src, span_warning("The Office is still processing your previous complaint. Complaints about the processing of complaints are processed separately."))
		return
	var/list/candidates = list()
	for(var/mob/living/candidate in view(7, src))
		if(candidate == src || candidate.stat == DEAD)
			continue
		if(candidate.pc_incident_count > src.pc_incident_count + 3)
			candidates += candidate
			continue
		candidates += candidate
	if(!length(candidates))
		to_chat(src, span_warning("There is nobody nearby to complain about. The Office suggests waiting for a colleague to arrive."))
		return
	var/mob/living/target = tgui_input_list(src, "Select the colleague to file a workplace sensitivity complaint against.", "Inclusive Reporting", candidates, null, 30 SECONDS)
	if(!target || !src.client)
		return
	var/confirm = tgui_alert(src, "File a sensitivity complaint against [target.real_name]? The complaint is anonymous to everyone except the Office, the Officer, the admins, and the record.", "Inclusive Reporting", list("File Complaint", "Cancel"), 30 SECONDS)
	if(confirm != "File Complaint")
		return
	GLOB.pc_complaint_count++
	src.pc_next_complaint = world.time + 2 MINUTES
	to_chat(src, span_notice("<b>OFFICE OF INCLUSIVE CARE:</b> your complaint has been filed. The Office thanks you for observing your colleague."))
	to_chat(src, span_notice("[pc_random_apology_prompt()] (for your colleague, not for you.)"))
	to_chat(target, span_warning("<b>OFFICE OF INCLUSIVE CARE:</b> a workplace sensitivity complaint has been filed against you by [src.real_name]."))
	var/datum/pc_incident/incident = pc_register_incident(target, list("workplace sensitivity complaint"), "(complaint filed by [src.real_name])", "(complaint filed by [src.real_name])", "workplace sensitivity complaint", src)
	if(incident)
		to_chat(target, span_notice("[incident.get_case_line()]"))
		to_chat(target, span_notice("[incident.get_escalation_text()]"))
	var/mob/living/officer = SSpolitical_correctness?.diversity_officer?.resolve()
	if(officer)
		to_chat(officer, span_notice("<b>OFFICE OF INCLUSIVE CARE:</b> a complaint was filed by [src.real_name] against [target.real_name]. This is your problem now."))

GAME_VERB(/mob/living, pc_review_inclusivity, "Review Inclusivity Index", "Inclusive Reporting")
	if(!src.client)
		return
	to_chat(src, span_notice("<b>OFFICE OF INCLUSIVE CARE - INCLUSIVITY INDEX</b>"))
	to_chat(src, span_notice(pc_index_report_text()))
	to_chat(src, span_notice("Your personal record: [src.pc_incident_count] incident(s). The Office keeps score even when you do not."))

GAME_VERB(/mob/living, pc_issue_citation, "Issue Inclusivity Citation", "Inclusive Reporting")
	if(!src.client || !src.pc_diversity_officer)
		to_chat(src, span_warning("Only the appointed Diversity Officer may issue inclusivity citations. This is not exclusion; it is role differentiation."))
		return
	var/list/candidates = list()
	for(var/mob/living/candidate in view(5, src))
		if(candidate == src)
			continue
		candidates += candidate
	if(!length(candidates))
		to_chat(src, span_warning("There is nobody nearby to cite. The Office has noted your enthusiasm."))
		return
	var/mob/living/target = tgui_input_list(src, "Select the colleague to cite for a probable inclusivity violation.", "Diversity Officer", candidates, null, 30 SECONDS)
	if(!target)
		return
	to_chat(src, span_notice("You issue a citation to [target.real_name]."))
	target.visible_message(span_danger("[src] issues an inclusivity citation to [target]!"), span_danger("[src] issues you an inclusivity citation!"))
	var/datum/pc_incident/incident = pc_register_incident(target, list("probable inclusivity violation"), "(cited by the Diversity Officer)", "(cited by the Diversity Officer)", "diversity officer citation", src)
	if(incident)
		log_game("Diversity Officer [key_name(src)] cited [key_name(target)] (case #[incident.case_number]).")
