# Nanotrasen Office of Inclusive Care (POLITICAL_CORRECTNESS)

> This station is a Certified Safe Space. Certification is granted by the Office of Inclusive
> Care, which is also the only body permitted to question certification.

A satirical, station-wide "hyper-PC" policy layer inspired by South Park's PC Principal:
the bureaucracy itself is the antagonist. The Office enforces absurd inclusivity with
language review, mandatory apologies, sensitivity training, fines (`inclusivity
contributions`), and a self-condemning Inclusivity Index. It also deauthorizes all
"corrective" medicine: nobody gets to fix another crewmember's body, brain, blindness or
deafness. The joke targets the institution, its jargon and its metrics — never a real group.

## What the Office does in-game

| System | Behaviour |
| --- | --- |
| **Inclusive Language Review** | Every spoken word (say/radio) passes through `pc_process_speech()`. ~100 banned phrases are rewritten in place into Office-approved phrasing. Unapproved speech also files a **case**. |
| **Male Privilege Surcharge** | Gendered occupational language ("spokesman", "chairman", "policeman", "manpower", "guys", …) is treated as an *active assertion of male privilege*: the case jumps two rungs up the ladder immediately and the apology window shrinks from 45 to 20 seconds. The Office is not angry. The Office is disappointed. |
| **Alleged Antagonists** | Every antagonist designation is an allegation, not a finding: `Traitor (Alleged)`, `Spy (Alleged)`, `Heretic (Alleged)`, `Revolutionary (Alleged)`, `Head Revolutionary (Alleged)`, `Obsessed (Alleged)`, `Enemy of the State (Alleged)` — in role names, round-end sections and admin panels. A changeling is only ever an `Assumed Carbon-Based Lifeform`. Speech-filtered "traitor" becomes "alleged traitor", and "changeling" becomes "assumed carbon-based lifeform". |
| **Legally Impaired** | The Prisoner job is retitled **Legally Impaired** (alt titles: Alleged Offender, Low-/Medium-/High-Risk Legally Impaired, Protective Custody Legally Impaired, Psychiatric Hold Legally Impaired). The lawyer advocates for "legally impaired guests", the warden watches the "involuntary accommodation wing", and the spawn message says the crewmember is "being involuntarily accommodated pending an allegation". |
| **Mandatory Apology** | A flagged crewmember has 45 seconds to say "sorry"/"I apologize". Apologies are accepted, recorded, and rated for warmth. |
| **Escalation Ladder** | 12-stage ratchet (`pc_escalation_ladder`): Notice of Potential Unease → Inclusivity Contribution → Surcharge → Language Remediation → Mandatory Apology → Apology Quality Review → Apology Re-Submission → Sensitivity Training → Remedial Training → Supervised Inclusivity → Cultural Fit Review → Career Diversification. It never de-escalates. |
| **Sensitivity Training** | Status effect (`/datum/status_effect/pc_sensitivity_training`, 2 min) with nine modules; module nine has never been reached. |
| **Inclusivity Index** | `(incident reports / reports possible) × 100`; broadcast periodically. The Office can only improve its score by finding more violations. |
| **Diversity Officer** | At shift start the subsystem appoints a random crewmember, hands them an **unconscious bias detector** and a **Certificate of Inclusivity**, and announces them. |
| **Crew verbs** (IC tab → *Inclusive Reporting*) | `File Bias Complaint`, `Review Inclusivity Index`, `Issue Inclusivity Citation` (officer only). |
| **Bias Detector** | Repurposed health analyzer; prints an "Unconscious Bias Assessment" with an absurd fake score. Not actionable. Filed anyway. |
| **Deauthorized medicine** | Lipoplasty, brain surgery, lobotomy, eye/ear repair, oculine, inacusiate and sensory-restoration no longer correct anything; they now "affirm" and are inert. The lipid extractor machine ("fat sucker") only affirms body mass and produces no meat. |

## Files

Core module (new):

- `pc_lexicon.dm` — banned/approved phrase pairs, apology phrases, rewrite procs, Index formula.
- `pc_incidents.dm` — case datums, escalation ladder, apology windows, training enrollment.
- `pc_status.dm` — Sensitivity Training status effect and its module messages.
- `pc_speech.dm` — the say-pipeline review proc.
- `pc_compliance.dm` — `SSpolitical_correctness` subsystem, briefing/index/report announcements, Diversity Officer appointment, proactive enrollment, crew vars.
- `pc_verbs.dm` — crew/Diversity Officer verbs.
- `pc_objects.dm` — unconscious bias detector + its report table.

Integration point (single hook):

- `code/modules/mob/living/living_say.dm` — after `SEND_SIGNAL(COMSIG_MOB_SAY)`, `message = pc_process_speech(src, args, message)` (marked `POLITICAL_CORRECTNESS ADDITION`).

Modified core content (selection): brain traumas, mood events, negative quirks, medical kiosk and
scanners, brain organ tooltips, tgui Medical Records mental statuses, surgery operations
(lipoplasty/brain/lobotomy/eyes/ears), oculine/inacusiate reagents, sensory-restoration symptom,
research surgery node text, the lipid extractor, ion laws/tips/valentines/pirate names and other
player-visible strings, plus the `brain_surgery` unit test (it now asserts the PC behaviour:
the patient keeps their trauma and damage is not healed).

## Tuning

- **Add/remove banned phrases**: `GLOBAL_LIST_INIT(pc_lexicon, ...)` in `pc_lexicon.dm`.
  Format is `list("banned phrase", "approved phrase")`; matching is case-insensitive and
  word-bounded.
- **Turn the language review off**: comment out the hook in `living_say.dm`.
- **Escalation text / stages**: `pc_escalation_ladder` in `pc_incidents.dm` (stages clamp to its length).
- **Announcement cadence**: `SSpolitical_correctness.fire()` timings.
- **Officer eligibility**: `appoint_diversity_officer()` (antagonists are skipped).

## Satire boundaries (from the research)

Do: target the office (budget, ego, careerism, jargon, metrics), make the rule absurd rather
than a person's body, give the enforcer a boss, let someone visibly pay for the enforcement,
and keep the enforcer's institution implicated. Don't: make a protected identity the punchline,
put real slurs in the enforcer's mouth as "the joke", use "it's satire" as the only defence, or
do "both sides equally bad" where power is asymmetric. The vocabulary here is invented
corporate euphemism; the Office is the fool.

## Visiting colleague bots (service sector audit)

The restaurant robots were a walking national-stereotype parade: the American gun/healthcare/diabetes
bot, Italian mamma-mia bot, French "hon hon" bot with a flag overlay, anime-weeb Japanese bots,
"andele" Mexican bot, and the British Raj/deportation bot — plus stereotyped name lists and
culture-coded voice clips. The Office has re-scripted them:

- All cultural dialogue is now deadpan inclusivity doublespeak ("I require a seat with a certified
  inclusive load rating", "I am emitting an approved expression of amusement").
- Every cultural bot draws its name from `strings/names/inclusive_prefix.txt` →
  "Trauma-Informed-bot", "Culturally Neutral-bot", "Consent-Forward-bot", … so they are all equally reresented.
- Culture-specific voice clips are deauthorized (all use the generic tourist beep); the French flag
  overlay no longer displays.
- Bots examine as "certified culturally neutral by the Office of Inclusive Care".
- The first venue open each round triggers a **Service Sector Audit** station announcement.
- Restaurant/bar customer weights are equalized ("equal representation of all visiting colleagues").

Sprite/icon-state names ("amerifat", the national outfits, the tourist DMI) are left alone because
renaming DMI states is out of scope; the Office has filed them under "visual audit pending".

## Known caveats

- Renamed quirk display names may reset saved quirk selections for existing characters
  (typepaths are unchanged; only display strings moved).
- The branch changes a unit test on purpose so it documents the satirical behaviour.
- Historical `html/changelogs/archive/` entries were left as history.
