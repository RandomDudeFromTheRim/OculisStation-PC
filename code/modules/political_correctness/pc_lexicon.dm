/*
 * POLITICAL_CORRECTNESS - Nanotrasen Office of Inclusive Care
 *
 * Approved vocabulary for all crew. Any deviation from the approved vocabulary
 * is a microaggression, and microaggressions are a workplace hazard.
 *
 * Format: list(banned_phrase, approved_phrase)
 * Phrase matching is case-insensitive and word-bounded.
 */

GLOBAL_LIST_INIT(pc_lexicon, list(
	// Sanism / mental-health language (Rule B1)
	list("crazy", "experiencing an unconventional perspective"),
	list("insane", "experiencing psychological irregularity"),
	list("insanity", "psychological irregularity"),
	list("psycho", "emotionally distinctive"),
	list("psychotic", "reality-adjacent"),
	list("psychosis", "reality-adjacent experience"),
	list("schizo", "perception-diverse"),
	list("schizophrenia", "perception diversity"),
	list("lunatic", "moon-affiliated colleague"),
	list("maniac", "enthusiasm-forward"),
	list("deranged", "creatively ordered"),
	list("mad", "bizarre"),
	list("madman", "bizarre individual"),
	list("madness", "bizarreness"),
	list("moron", "confidence-unburdened"),
	list("idiot", "confidence-unburdened"),
	list("imbecile", "confidence-unburdened"),
	list("retarded", "differently paced"),
	list("retard", "differently paced person"),

	// Ableist language
	list("blind", "visually differently abled"),
	list("deaf", "auditory differently abled"),
	list("mute", "non-verbal communicator"),
	list("crippled", "mobility-diverse"),
	list("paraplegic", "vertically accommodated"),
	list("midget", "vertically economical"),
	list("fat", "person of increased body mass"),
	list("obese", "person of increased body mass"),
	list("ugly", "aesthetically non-conforming"),
	list("disabled", "differently enabled"),
	list("handicapped", "differently enabled"),
	list("dumb", "speech-optional"),

	// Death-adjacent language
	list("dead", "temporarily non-living"),
	list("died", "became temporarily non-living"),
	list("die", "become temporarily non-living"),
	list("death", "temporary non-living state"),
	list("corpse", "post-biological colleague"),
	list("killed", "permanently redirected"),
	list("kill", "permanently redirect"),
	list("gibbed", "partially redistributed"),
	list("spaced", "vacuum-relocated"),

	// Gendered occupational language (asserting male privilege)
	list("spokesman", "spokesperson"),
	list("spokesmen", "spokespersons"),
	list("chairman", "chairperson"),
	list("chairmen", "chairpersons"),
	list("policeman", "police officer"),
	list("policemen", "police officers"),
	list("fireman", "firefighter"),
	list("firemen", "firefighters"),
	list("mailman", "mail carrier"),
	list("mailmen", "mail carriers"),
	list("salesman", "salesperson"),
	list("salesmen", "salespersons"),
	list("businessman", "businessperson"),
	list("businessmen", "businesspersons"),
	list("congressman", "representative"),
	list("congressmen", "representatives"),
	list("workman", "worker"),
	list("workmen", "workers"),
	list("foreman", "supervisor"),
	list("foremen", "supervisors"),
	list("handyman", "maintenance person"),
	list("handymen", "maintenance persons"),
	list("barman", "bartender"),
	list("barmen", "bartenders"),
	list("freshman", "first-year student"),
	list("manpower", "workforce"),
	list("manmade", "artificially created"),
	list("mankind", "carbon-based personkind"),
	list("guys", "colleagues"),

	// Othering language
	list("human", "carbon-based person"),
	list("humans", "carbon-based persons"),
	list("mutant", "genetically diverse individual"),
	list("mutants", "genetically diverse individuals"),
	list("alien", "non-terrestrial colleague"),
	list("aliens", "non-terrestrial colleagues"),
	list("robot", "synthetic crew-adjacent entity"),
	list("robots", "synthetic crew-adjacent entities"),
	list("ai", "emergent colleague"),
	list("clown", "comedic wellness specialist"),
	list("clowns", "comedic wellness specialists"),
	list("prisoner", "involuntarily accommodated guest"),
	list("prisoners", "involuntarily accommodated guests"),
	list("jail", "supervised reflection zone"),
	list("punishment", "corrective learning opportunity"),
	list("fine", "inclusivity contribution"),
	list("fired", "career-diversified"),
	list("traitor", "allegiance-flexible"),
	list("traitors", "allegiance-flexible colleagues"),
	list("spy", "information-enthusiastic colleague"),
	list("cultist", "faith-diverse"),
	list("demon", "extraplanar stakeholder"),
	list("experiment", "consented curiosity initiative"),
	list("explosion", "rapid unscheduled expansion"),
	list("nuke", "opinionated device"),
	list("syndicate", "competitively aligned organization"),
	list("wizard", "reality-adjacent practitioner"),
	list("vampire", "nocturnally optimized"),
	list("changeling", "identity-flexible colleague"),
	list("drunk", "sobriety-optional"),
	list("security", "inclusivity enforcement"),
	list("old", "temporally experienced"),
	list("short", "vertically economical"),
	list("bald", "follicularly streamlined"),
))

/// Terms which the Office treats as an active assertion of male privilege.
/// These carry an elevated case severity and a shorter apology window.
GLOBAL_LIST_INIT(pc_male_privilege_terms, list(
	"spokesman",
	"spokesmen",
	"chairman",
	"chairmen",
	"policeman",
	"policemen",
	"fireman",
	"firemen",
	"mailman",
	"mailmen",
	"salesman",
	"salesmen",
	"businessman",
	"businessmen",
	"congressman",
	"congressmen",
	"workman",
	"workmen",
	"foreman",
	"foremen",
	"handyman",
	"handymen",
	"barman",
	"barmen",
	"freshman",
	"manpower",
	"manmade",
	"mankind",
	"guys",
))

/// Returns TRUE if [phrase] is an assertion of male privilege.
/proc/pc_is_male_privilege_term(phrase)
	if(!phrase)
		return FALSE
	return (lowertext(phrase) in GLOB.pc_male_privilege_terms)

/// Phrases that count as an apology for the Office's compliance records.
GLOBAL_LIST_INIT(pc_apology_phrases, list(
	"apolog",
	"sorry",
	"my bad",
	"i regret",
	"my fault",
	"forgive me",
	"i take it back",
))

/// Returns TRUE if [character] is treated as part of a word for boundary purposes.
/proc/pc_is_word_character(character)
	if(!character)
		return FALSE
	return !!findtext("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_", character)

/// Finds [phrase] in [text] at or after [start], requiring whole-word boundaries.
/// Returns the character index of the match, or 0 if there is none.
/proc/pc_find_banned_word(text, phrase, start = 1)
	var/total = length(text)
	var/phrase_length = length(phrase)
	var/position = max(1, start)
	while(position + phrase_length - 1 <= total)
		var/found = findtext(text, phrase, position)
		if(!found)
			return 0
		var/before_ok = (found == 1) || !pc_is_word_character(copytext(text, found - 1, found))
		var/after_index = found + phrase_length
		var/after_ok = (after_index > total) || !pc_is_word_character(copytext(text, after_index, after_index + 1))
		if(before_ok && after_ok)
			return found
		position = found + 1
	return 0

/// Returns list(position, banned_phrase) for the earliest banned phrase at or after [position].
/proc/pc_find_next_banned(text, position = 1)
	var/earliest = 0
	var/earliest_phrase = null
	for(var/list/pair as anything in GLOB.pc_lexicon)
		var/phrase = pair[1]
		var/found = pc_find_banned_word(text, phrase, position)
		if(found && (!earliest || found < earliest))
			earliest = found
			earliest_phrase = phrase
	return list(earliest, earliest_phrase)

/// Returns the Office-approved replacement for a banned phrase.
/proc/pc_approved_phrase(phrase)
	for(var/list/pair as anything in GLOB.pc_lexicon)
		if(lowertext(pair[1]) == lowertext(phrase))
			return pair[2]
	return phrase

/// Re-applies the original capitalisation to an approved replacement.
/proc/pc_match_case(original, replacement)
	if(!original || !replacement)
		return replacement
	if(length(original) > 1 && original == uppertext(original) && original != lowertext(original))
		return uppertext(replacement)
	var/first = copytext(original, 1, 2)
	if(first && first == uppertext(first) && first != lowertext(first))
		return capitalize(replacement)
	return replacement

/*
 * Rewrites all banned phrases in [text] into approved phrasing.
 * Adds every banned phrase found to [violations] (if provided).
 */
/proc/pc_rewrite_text(text, list/violations = null)
	if(!text)
		return text
	var/lower = lowertext(text)
	var/output = ""
	var/position = 1
	var/checks = 0
	while(checks++ < 64)
		var/list/next = pc_find_next_banned(lower, position)
		var/match_start = next[1]
		if(!match_start)
			break
		var/phrase = next[2]
		output += copytext(text, position, match_start)
		var/matched_text = copytext(text, match_start, match_start + length(phrase))
		output += pc_match_case(matched_text, pc_approved_phrase(phrase))
		if(!isnull(violations))
			violations += phrase
		position = match_start + length(phrase)
	output += copytext(text, position)
	return output

/// Returns TRUE if [text] contains one of the Office-approved apology phrases.
/proc/pc_contains_apology(text)
	if(!text)
		return FALSE
	var/lower = lowertext(text)
	for(var/phrase in GLOB.pc_apology_phrases)
		if(findtext(lower, phrase))
			return TRUE
	return FALSE

/// Returns the current Inclusivity Index. The formula is deliberately self-condemning.
/proc/pc_get_inclusivity_index()
	var/reports_possible = max(1, length(GLOB.player_list))
	var/index = 100 - min(99, round((GLOB.pc_incident_count / reports_possible) * 100))
	return clamp(index, 0, 100)
