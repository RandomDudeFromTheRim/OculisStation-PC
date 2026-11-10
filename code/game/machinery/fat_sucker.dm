/obj/machinery/fat_sucker
	name = "lipid extractor"
	desc = "Inclusive Care-approved body mass reallocation unit. Safely and efficiently extracts excess fat from a subject while affirming their bodily autonomy." // PC
	icon = 'icons/obj/machines/fat_sucker.dmi'
	icon_state = "fat"
	circuit = /obj/item/circuitboard/machine/fat_sucker
	state_open = FALSE
	density = TRUE
	req_access = list(ACCESS_KITCHEN)
	var/processing = FALSE
	var/start_at = NUTRITION_LEVEL_WELL_FED
	var/stop_at = NUTRITION_LEVEL_STARVING
	var/free_exit = TRUE //set to false to prevent people from exiting before being completely stripped of fat
	var/bite_size = 7.5 //amount of nutrients we take per second
	var/nutrients //amount of nutrients we got build up
	var/nutrient_to_meat = 90 //one slab of meat gives about 52 nutrition
	var/datum/looping_sound/microwave/soundloop //100% stolen from microwaves
	var/breakout_time = 600

	var/next_fact = 10 //in ticks, so about 20 seconds
	var/static/list/fat_facts = list(\
	"Fats are triglycerides made up of a combination of different building blocks; glycerol and fatty acids.", \
	"Adults should get a recommended 20-35% of their energy intake from fat.", \
	"Being a Person of Increased Body Mass is not a risk factor. The risk factor is living in a society that keeps telling you it is.", \
	"Not all fats are bad. A certain amount of fat is an essential part of a healthy balanced diet. " , \
	"Saturated fat should form no more than 11% of your daily calories.", \
	"Unsaturated fat, that is monounsaturated fats, polyunsaturated fats and omega-3 fatty acids, is found in plant foods and fish." \
	)

/obj/machinery/fat_sucker/Initialize(mapload)
	. = ..()
	soundloop = new(src,  FALSE)
	update_appearance()

/obj/machinery/fat_sucker/Destroy()
	QDEL_NULL(soundloop)
	. = ..()

/obj/machinery/fat_sucker/RefreshParts()
	. = ..()
	var/rating = 0
	for(var/datum/stock_part/micro_laser/micro_laser in component_parts)
		rating += micro_laser.tier
	bite_size = initial(bite_size) + rating * 2.5
	nutrient_to_meat = initial(nutrient_to_meat) - rating * 5

/obj/machinery/fat_sucker/examine(mob/user)
	. = ..()
	. += {"[span_notice("Alt-Click to toggle the safety hatch.")]
				[span_notice("Removing [bite_size] nutritional units per operation.")]
				[span_notice("Requires [nutrient_to_meat] nutritional units per meat slab.")]"}

/obj/machinery/fat_sucker/close_machine(mob/user, density_to_set = TRUE)
	if(panel_open)
		to_chat(user, span_warning("You need to close the maintenance hatch first!"))
		return
	..()
	playsound(src, 'sound/machines/click.ogg', 50)
	if(occupant)
		if(!iscarbon(occupant))
			occupant.forceMove(drop_location())
			set_occupant(null)
			return
		to_chat(occupant, span_notice("You enter [src]."))
		addtimer(CALLBACK(src, PROC_REF(start_extracting)), 20, TIMER_OVERRIDE|TIMER_UNIQUE)
		update_appearance()

/obj/machinery/fat_sucker/open_machine(mob/user, density_to_set = FALSE)
	make_meat()
	playsound(src, 'sound/machines/click.ogg', 50)
	if(processing)
		stop()
	..()

/obj/machinery/fat_sucker/container_resist_act(mob/living/user)
	if(!free_exit || state_open)
		to_chat(user, span_notice("The emergency release is not responding! You start pushing against the hull!"))
		user.change_next_special_move(CLICK_CD_BREAKOUT)
		user.visible_message(span_notice("You see [user] kicking against the door of [src]!"), \
			span_notice("You lean on the back of [src] and start pushing the door open... (this will take about [DisplayTimeText(breakout_time)].)"), \
			span_hear("You hear a metallic creaking from [src]."))
		if(do_after(user, breakout_time, target = src, cog_icon = null))
			if(!user || IS_UNCONSCIOUS_OR_CRIT(user) || user.loc != src || state_open)
				return
			free_exit = TRUE
			user.visible_message(span_warning("[user] successfully broke out of [src]!"), \
				span_notice("You successfully break out of [src]!"))
			open_machine()
		return
	open_machine()

/obj/machinery/fat_sucker/interact(mob/user)
	if(state_open)
		close_machine()
	else if(!processing || free_exit)
		open_machine()
	else
		to_chat(user, span_warning("The safety hatch has been disabled!"))

/obj/machinery/fat_sucker/click_alt(mob/living/user)
	if(user == occupant)
		to_chat(user, span_warning("You can't reach the controls from inside!"))
		return CLICK_ACTION_BLOCKING
	if(!(obj_flags & EMAGGED) && !allowed(user))
		to_chat(user, span_warning("You lack the required access."))
		return CLICK_ACTION_BLOCKING
	free_exit = !free_exit
	to_chat(user, span_notice("Safety hatch [free_exit ? "unlocked" : "locked"]."))
	return CLICK_ACTION_SUCCESS

/obj/machinery/fat_sucker/update_overlays()
	. = ..()

	if(!state_open)
		if(processing)
			. += "[icon_state]_door_on"
			. += "[icon_state]_stack"
			. += "[icon_state]_smoke"
			. += "[icon_state]_green"
		else
			. += "[icon_state]_door_off"
			if(occupant)
				if(powered())
					. += "[icon_state]_stack"
					. += "[icon_state]_yellow"
			else
				. += "[icon_state]_red"
	else if(powered())
		. += "[icon_state]_red"
	if(panel_open)
		. += "[icon_state]_panel"

/obj/machinery/fat_sucker/process(seconds_per_tick)
	if(!processing)
		return
	if(!powered() || !occupant || !iscarbon(occupant))
		open_machine()
		return

	var/mob/living/carbon/C = occupant
	// PC ADDITION START - body mass reduction is deauthorized; the unit only affirms
	to_chat(C, span_notice("The Office of Inclusive Care affirms your body mass. No extraction will occur."))
	open_machine()
	// PC ADDITION END

/obj/machinery/fat_sucker/proc/start_extracting()
	if(state_open || !occupant || processing || !powered())
		return
	if(iscarbon(occupant))
		// PC ADDITION START - the Office of Inclusive Care has deauthorized body mass reduction
		var/mob/living/carbon/C = occupant
		say("The Office of Inclusive Care has deauthorized body-mass reduction. Subject's body mass is already within inclusive parameters.")
		to_chat(C, span_notice("You are reminded that your body mass is not a defect and will not be extracted."))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 40, FALSE)
		src.overlays += "[icon_state]_red" //throw a red light icon over it, to show that it won't work
		// PC ADDITION END

/obj/machinery/fat_sucker/proc/stop()
	processing = FALSE
	soundloop.stop()
	set_light(0, 0)

/obj/machinery/fat_sucker/proc/make_meat()
	// PC ADDITION START - the Office does not accept that bodies are a resource
	if(occupant && iscarbon(occupant))
		to_chat(occupant, span_notice("The unit produces no meat. Bodies are not a resource."))
	return
	// PC ADDITION END

/obj/machinery/fat_sucker/screwdriver_act(mob/living/user, obj/item/tool)
	if(occupant)
		to_chat(user, span_warning("[src] is currently occupied!"))
		return ITEM_INTERACT_BLOCKING
	if(state_open)
		to_chat(user, span_warning("[src] must be closed to [panel_open ? "close" : "open"] its maintenance hatch!"))
		return ITEM_INTERACT_BLOCKING
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/fat_sucker/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/fat_sucker/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	start_at = 100
	stop_at = 0
	to_chat(user, span_notice("You remove the access restrictions and lower the automatic ejection threshold!"))
	obj_flags |= EMAGGED
	return TRUE
