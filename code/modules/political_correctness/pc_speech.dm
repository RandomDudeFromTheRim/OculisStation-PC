/*
 * POLITICAL_CORRECTNESS - inclusive language review for spoken words and radios.
 *
 * The Office reviews every spoken word. Speech that does not comply is rewritten
 * in place by the Office, and the speaker is enrolled in the review ladder.
 */

/// Reviews and (if required) rewrites a spoken message. Returns the message to use.
/// [message] is the local variable from /mob/living/say(); [speech_args] is the signal argslist.
/proc/pc_process_speech(mob/living/speaker, list/speech_args, message)
	if(!speaker || !message)
		return message
	// Prefer whatever the signal argslist holds - other say handlers (accents, mutations) have had their turn.
	if(islist(speech_args) && speech_args[SPEECH_MESSAGE])
		message = speech_args[SPEECH_MESSAGE]
	if(!istext(message) || !length(message))
		return message
	// Custom say emotes ("*laughs") are not language and are not reviewed.
	if(copytext(message, 1, 2) == "*")
		return message
	// Dead chat is handled elsewhere and is not subject to review.
	if(speaker.stat == DEAD)
		return message

	var/list/violations = list()
	var/rewritten = pc_rewrite_text(message, violations)
	if(length(violations))
		// The Office speaks the approved version into the record.
		if(islist(speech_args))
			speech_args[SPEECH_MESSAGE] = rewritten
		var/male_privilege = FALSE
		for(var/term in violations)
			if(pc_is_male_privilege_term(term))
				male_privilege = TRUE
				break
		if(male_privilege)
			to_chat(speaker, span_warning("<b>OFFICE OF INCLUSIVE CARE:</b> MALE PRIVILEGE ASSERTED. The Office has elevated this case and shortened your apology window. This is not a penalty."))
			pc_register_incident(speaker, violations, message, rewritten, "male privilege audit", null, 2)
		else
			pc_register_incident(speaker, violations, message, rewritten, "language audit")
		return rewritten

	// No violations: check whether this was the mandatory apology the Office was waiting for.
	if(pc_contains_apology(message))
		var/datum/pc_incident/pending = pc_find_pending_incident(speaker)
		if(pending)
			pending.resolve_apology()
	return message
