/datum/customer_data
	///The types of food this robot likes in a assoc list of venue type | weighted list. does NOT include subtypes.
	var/list/orderable_objects = list()
	///The amount a robot pays for each food he likes in an assoc list type | payment
	var/list/order_prices = list()
	///Datum AI used for the robot. Should almost never be overwritten unless theyre subtypes of ai_controller/robot_customer
	var/datum/ai_controller/ai_controller_used = /datum/ai_controller/robot_customer
	///Patience of the AI, how long they will wait for their meal.
	var/total_patience = 600 SECONDS
	///Lines the robot says when it finds a seat
	var/list/found_seat_lines = list("I found a seat")
	///Lines the robot says when it can't find a seat
	var/list/cant_find_seat_lines = list("I did not find a seat")
	///Lines the robot says when leaving without food
	var/list/leave_mad_lines = list("Leaving without food")
	///Lines the robot says when leaving with food
	var/list/leave_happy_lines = list("Leaving with food")
	///Lines the robot says when leaving waiting for food
	var/list/wait_for_food_lines = list("I'm still waiting for food")
	///Line when pulled by a friendly venue owner
	var/friendly_pull_line = "Where are we going?"
	///Line when harrased by someone for the first time
	var/first_warning_line = "Don't touch me!"
	///Line when harrased by someone for the second time
	var/second_warning_line = "This is your last warning!"
	///Line when harrased by someone for the last time
	var/self_defense_line = "Please discontinue your unapproved physical contact." // PC - ORIGINAL: "Omae wa mo, shinderou."
	///Line sent when the customer is clicked on by someone with a 0 force item that's not the correct order
	var/wrong_item_line = "No, I don't want that."

	///Clothing sets to pick from when dressing the robot.
	var/list/clothing_sets = list("amerifat_clothes") // PC NOTE: sprite state names await a visual audit
	///List of prefixes for our robots name
	var/list/name_prefixes
	///Prefix file to uise
	var/prefix_file = "strings/names/inclusive_prefix.txt" // PC - national name lists deauthorized
	///Base icon for the customer
	var/base_icon = 'icons/mob/simple/tourists.dmi'
	///Base icon state for the customer
	var/base_icon_state = "amerifat" // PC NOTE: sprite state names await a visual audit
	///Sound to use when this robot type speaks
	var/speech_sound = 'sound/mobs/non-humanoids/tourist/tourist_talk.ogg'

	/// Is this unique once per venue?
	var/is_unique = FALSE

/datum/customer_data/New()
	. = ..()
	name_prefixes = world.file2list(prefix_file)
	if(check_holidays(ICE_CREAM_DAY)) ///customers are more likely to order ice cream on this holiday
		var/list/orderable_restaurant = orderable_objects[VENUE_RESTAURANT]
		if(orderable_restaurant?[/datum/custom_order/icecream])
			orderable_restaurant[/datum/custom_order/icecream] *= 3

/// Can this customer be chosen for this venue?
/datum/customer_data/proc/can_use(datum/venue/venue, obj/machinery/restaurant_portal/portal)
	return TRUE

/datum/customer_data/proc/get_overlays(mob/living/basic/robot_customer/customer)
	return

/datum/customer_data/proc/get_underlays(mob/living/basic/robot_customer/customer)
	return

/datum/customer_data/american
	prefix_file = "strings/names/inclusive_prefix.txt" // PC - the Office deauthorized national name lists
	found_seat_lines = list("I require a seat with a certified inclusive load rating.", "I hope this establishment is a Certified Safe Space.", "I hope they offer a nutrition-positive menu.", "I appreciate the culturally neutral ambiance.")
	cant_find_seat_lines = list("Standing is an accessibility barrier.", "I require a seat for accessibility reasons. Please expedite.", "I will withhold my inclusivity contribution if a seat is not provided.")
	leave_mad_lines = list("I am withholding my inclusivity contribution. Goodbye.", "I expected more prompt service from a certified venue.", "This venue has failed my access needs.", "I will escalate this to your Diversity Officer.", "I will file a workplace sensitivity complaint.")
	leave_happy_lines = list("An extra inclusivity contribution for you, colleague.", "Thank you for the nutrition, colleague.", "I do not pathologize my metabolic choices.")
	wait_for_food_lines = list("Colleague, I am approaching my patience threshold.", "I have been waiting for an unacceptable amount of time.")
	friendly_pull_line = "Where are we going? I hope not to a deauthorized medical procedure."
	first_warning_line = "Please observe my personal boundaries."
	second_warning_line = "This is your final boundary reminder, colleague."
	self_defense_line = "MY DEFENSIVE BOUNDARIES ARE NOW FULLY ACTIVATED."

	orderable_objects = list(
		VENUE_RESTAURANT = list(
			/obj/item/food/burger/plain = 25,
			/obj/item/food/burger/cheese = 15,
			/obj/item/food/burger/superbite = 1,
			/obj/item/food/butter/on_a_stick = 8,
			/obj/item/food/fries = 10,
			/obj/item/food/cheesyfries = 6,
			/obj/item/food/pie/applepie = 4,
			/obj/item/food/pie/pumpkinpie = 2,
			/obj/item/food/hotdog = 8,
			/obj/item/food/pizza/pineapple = 1,
			/obj/item/food/burger/baconburger = 10,
			/obj/item/food/pancakes = 4,
			/obj/item/food/eggsausage = 5,
			/datum/custom_order/icecream = 14,
			/obj/item/food/danish_hotdog = 3,
		),
		VENUE_BAR = list(
			/datum/reagent/consumable/ethanol/beer = 25,
			/datum/reagent/consumable/ethanol/b52 = 6,
			/datum/reagent/consumable/ethanol/manhattan = 3,
			/datum/reagent/consumable/ethanol/old_fashioned = 3,
			/datum/reagent/consumable/ethanol/sazerac = 2,
			/datum/reagent/consumable/ethanol/improved_whiskey = 1,
			/datum/reagent/consumable/ethanol/atomicbomb = 1,
		),
	)


/datum/customer_data/italian
	prefix_file = "strings/names/inclusive_prefix.txt" // PC - the Office deauthorized national name lists
	base_icon_state = "italian"
	clothing_sets = list("italian_pison", "italian_godfather") // PC NOTE: sprite states await a visual audit

	found_seat_lines = list("This is an acceptable and neutral place to sit.", "I hope the cuisine meets the approved standard of care.")
	cant_find_seat_lines = list("An expressive exclamation of concern! I require a seat.", "Why am I being made to stand, colleague?")
	leave_mad_lines = list("This level of exclusion is notable.", "This establishment is not inclusive.")
	leave_happy_lines = list("That is an approved expression of affection.", "This meets the approved standard of care.")
	wait_for_food_lines = list("I am experiencing an unmet nutritional need.")
	friendly_pull_line = "I am nutritionally occupied and cannot relocate."
	first_warning_line = "Please do not initiate unconsented contact."
	second_warning_line = "Final warning: do not touch my culturally neutral pasta."
	self_defense_line = "I will apply restorative pressure until you comply!"
	orderable_objects = list(
		VENUE_RESTAURANT = list(
			/obj/item/food/spaghetti/pastatomato = 20,
			/obj/item/food/spaghetti/copypasta = 6,
			/obj/item/food/spaghetti/meatballspaghetti = 4,
			/obj/item/food/spaghetti/butternoodles = 4,
			/obj/item/food/pizza/vegetable = 2,
			/obj/item/food/pizza/mushroom = 2,
			/obj/item/food/pizza/meat = 2,
			/obj/item/food/pizza/margherita = 2,
			/obj/item/food/lasagna = 4,
			/obj/item/food/cannoli = 3,
			/obj/item/food/salad/risotto = 5,
			/obj/item/food/eggplantparm = 3,
			/obj/item/food/cornuto = 2,
			/datum/custom_order/icecream = 10,
			/obj/item/food/salad/greek_salad = 6,
		),
		VENUE_BAR = list(
			/datum/reagent/consumable/ethanol/fanciulli = 5,
			/datum/reagent/consumable/ethanol/branca_menta = 3,
			/datum/reagent/consumable/ethanol/beer = 5,
			/datum/reagent/consumable/lemonade = 8,
			/datum/reagent/consumable/ethanol/godfather = 5,
			/datum/reagent/consumable/ethanol/wine = 3,
			/datum/reagent/consumable/ethanol/grappa = 3,
			/datum/reagent/consumable/ethanol/amaretto = 5,
			/datum/reagent/consumable/ethanol/amaretto_sour = 3,
			/datum/reagent/consumable/cucumberlemonade = 2,
			/datum/reagent/consumable/ethanol/negroni = 2,
			/datum/reagent/consumable/ethanol/garibaldi = 2,
			/datum/reagent/consumable/ethanol/spritz = 5,
		),
	)


/datum/customer_data/french
	prefix_file = "strings/names/inclusive_prefix.txt" // PC - the Office deauthorized national name lists
	base_icon_state = "french"
	clothing_sets = list("french_fit") // PC NOTE: sprite states await a visual audit
	found_seat_lines = list("I am expressing amusement in an approved manner.", "This is not a culturally charged landmark, but it is acceptable.", "This does not meet my access needs, but I will proceed.")
	cant_find_seat_lines = list("Standing is an accessibility barrier. This is unacceptable.", "This lobby fails the certification standard!")
	leave_mad_lines = list("An unapproved cultural reference has been detected!", "This establishment is culturally inaccessible.")
	leave_happy_lines = list("I am expressing amusement in an approved manner.", "An adequate and neutral effort.")
	wait_for_food_lines = list("I am expressing amusement in an approved manner.")
	friendly_pull_line = "Please do not initiate unconsented contact. I will allow it once."
	first_warning_line = "Please observe my personal boundaries."
	second_warning_line = "Please do not initiate unconsented contact. This is my final warning, colleague."
	self_defense_line = "I will apply inclusive corrective force!"
	speech_sound = 'sound/mobs/non-humanoids/tourist/tourist_talk.ogg' // PC - accented vocal performance deauthorized
	orderable_objects = list(
		VENUE_RESTAURANT = list(
			/obj/item/food/baguette = 20,
			/obj/item/food/garlicbread = 5,
			/obj/item/food/omelette = 15,
			/datum/custom_order/icecream = 6,
			/datum/reagent/consumable/nutriment/soup/french_onion = 4,
			/obj/item/food/pie/berryclafoutis = 2,
		),
		VENUE_BAR = list(
			/datum/reagent/consumable/ethanol/champagne = 10,
			/datum/reagent/consumable/ethanol/cognac = 5,
			/datum/reagent/consumable/ethanol/mojito = 5,
			/datum/reagent/consumable/ethanol/sidecar = 5,
			/datum/reagent/consumable/ethanol/between_the_sheets = 4,
			/datum/reagent/consumable/ethanol/beer = 5,
			/datum/reagent/consumable/ethanol/wine = 5,
			/datum/reagent/consumable/ethanol/gin_garden = 2,
			/datum/reagent/consumable/ethanol/french_75 = 5,
			/datum/reagent/consumable/ethanol/herbal_liqueur = 2,
			/datum/reagent/consumable/ethanol/pousse_cafe = 1,
		),
	)

/datum/customer_data/french/get_overlays(mob/living/basic/robot_customer/customer)
	// PC - the Office has deauthorized national flag display
	return



/datum/customer_data/japanese
	prefix_file = "strings/names/inclusive_prefix.txt" // PC - the Office deauthorized national name lists
	base_icon_state = "japanese"
	clothing_sets = list("japanese_animes") // PC NOTE: sprite states await a visual audit

	found_seat_lines = list("I am transmitting a culturally neutral greeting.", "I am transmitting an approved expression of gratitude.", "I hope there is nutrition available.")
	cant_find_seat_lines = list("I require a seat, colleague.", "Please provide a seat before my patience becomes noncompliance.", "This venue has insufficient accessible seating.", "No seating? This service standard is unacceptable.")
	leave_mad_lines = list("I cannot believe this exclusion! WAAAAAAAAAAAAAH!!", "I did not want your food anyway, colleague...", "I was going to give you my inclusivity contribution!")
	leave_happy_lines = list("Oh NUTRITION PROVIDER! This is the happiest day of my life, colleague.", "I take a nutritionally neutral snack... AND CONSUME IT.", "I commence consumption in an approved manner.", "Thank you for the culturally neutral meal.")
	wait_for_food_lines = list("No food yet? I will escalate.", "I anticipate the arrival of my nutrition.", "Please provide my nutrition, colleague.")
	friendly_pull_line = "Where are we going, colleague?"
	first_warning_line = "Please do not initiate unconsented contact."
	second_warning_line = "I will activate conflict resolution if you initiate contact again! Final warning!"
	self_defense_line = "YOUR UNAPPROVED CONDUCT IS NOW A COMPLIANCE MATTER!"
	speech_sound = 'sound/mobs/non-humanoids/tourist/tourist_talk.ogg' // PC - accented vocal performance deauthorized
	orderable_objects = list(
		VENUE_RESTAURANT = list(
			/datum/custom_order/icecream = 4,
			/datum/reagent/consumable/nutriment/soup/miso = 10,
			/datum/reagent/consumable/nutriment/soup/vegetable_soup = 4,
			/obj/item/food/beef_stroganoff = 2,
			/obj/item/food/breadslice/plain = 5,
			/obj/item/food/chawanmushi = 4,
			/obj/item/food/fish_poke = 5,
			/obj/item/food/muffin/berry = 2,
			/obj/item/food/sashimi = 4,
			/obj/item/food/tofu = 5,
		),
		VENUE_BAR = list(
			/datum/reagent/consumable/ethanol/sake = 8,
			/datum/reagent/consumable/cafe_latte = 6,
			/datum/reagent/consumable/ethanol/aloe = 6,
			/datum/reagent/consumable/chocolatepudding = 4,
			/datum/reagent/consumable/tea = 4,
			/datum/reagent/consumable/cherryshake = 1,
			/datum/reagent/consumable/ethanol/bastion_bourbon = 1,
		),
	)

/datum/customer_data/japanese/get_overlays(mob/living/basic/robot_customer/customer)
	//leaving and eaten
	if(type == /datum/customer_data/japanese && customer.ai_controller.blackboard[BB_CUSTOMER_LEAVING] && customer.ai_controller.blackboard[BB_CUSTOMER_EATING])
		return mutable_appearance('icons/effects/effects.dmi', "love_hearts", appearance_flags = RESET_COLOR|KEEP_APART)

/datum/customer_data/japanese/salaryman
	clothing_sets = list("japanese_salary") // PC NOTE: sprite states await a visual audit

	found_seat_lines = list("I wonder if this venue is properly certified...", "I am transmitting an approved greeting.", "I am transmitting an approved evening greeting.", "Where is the automated service offering...")
	cant_find_seat_lines = list("Please, a seat. I require a seat.", "I have a schedule. Where is my seat?", "...I see why this venue fails certification. They will not even seat guests.")
	leave_mad_lines = list("This venue fails the certification standard, and I am informing my colleagues.", "What an unacceptable use of my time.", "I hope this operation does not take pride in its certification record.")
	leave_happy_lines = list("Thank you for the hospitality.", "Thank you for your labour, colleague.", "Business calls.")
	wait_for_food_lines = list("Zzzzzzzzzz...", "This is not acceptable~", "This is not acceptable at all~")
	friendly_pull_line = "Are we going on a business trip?"
	first_warning_line = "Only my employer may initiate unconsented contact."
	second_warning_line = "Please observe my boundaries; I am focusing. Final warning!"
	self_defense_line = "I did not want it to end up like this."
	speech_sound = 'sound/mobs/non-humanoids/tourist/tourist_talk.ogg' // PC - accented vocal performance deauthorized
	orderable_objects = list(
		VENUE_RESTAURANT = list(
			/datum/reagent/consumable/nutriment/soup/miso = 6,
			/datum/reagent/consumable/nutriment/soup/vegetable_soup = 4,
			/obj/item/food/beef_stroganoff = 2,
			/obj/item/food/chawanmushi = 4,
			/obj/item/food/meat_poke = 4,
			/obj/item/food/meatbun = 4,
			/obj/item/food/sashimi = 4,
			/obj/item/food/tofu = 5,
		),
		VENUE_BAR = list(
			/datum/reagent/consumable/ethanol/beer = 14,
			/datum/reagent/consumable/ethanol/sake = 9,
			/datum/reagent/consumable/cafe_latte = 3,
			/datum/reagent/consumable/coffee = 3,
			/datum/reagent/consumable/soy_latte = 3,
			/datum/reagent/consumable/ethanol/atomicbomb = 1,
		),
	)

/datum/customer_data/moth
	prefix_file = "strings/names/moth_prefix.txt"
	base_icon_state = "mothbot"
	found_seat_lines = list("Give me your hat!", "Moth?", "Certainly an... interesting venue.")
	cant_find_seat_lines = list("If I can't find a seat, I'm flappity flapping out of here quick!", "I'm trying to flutter here!")
	leave_mad_lines = list("I am informing my peer support network never to visit here!", "Zero star rating, even worse than that time I ate a mothball!","Closing down permanently would still be too good of a fate for this place.")
	leave_happy_lines = list("I'd tip you my hat, but I ate it!", "I hope that wasn't a collectible!", "That was the greatest thing I ever ate, even better than Guanaco!")
	wait_for_food_lines = list("How hard is it to get food here? You're even wearing food yourself!", "My fuzzy robotic tummy is rumbling!", "I don't like waiting!")
	friendly_pull_line = "Moff?"
	first_warning_line = "Go away, I'm trying to get some hats here!"
	second_warning_line = "Last warning! I'll destroy you!"
	self_defense_line = "Flap attack!"

	speech_sound = 'sound/mobs/non-humanoids/tourist/tourist_talk_moth.ogg'

	orderable_objects = list(
		VENUE_RESTAURANT = list(
			/datum/custom_order/moth_clothing = 1,
		),
	)

	clothing_sets = list("mothbot_clothes")
	is_unique = TRUE

	/// The wings chosen for the moth customers.
	var/list/wings_chosen

// The whole gag is taking off your hat and giving it to the customer.
// If it takes any more effort, it loses a bit of the comedy.
// Therefore, only show up if it's reasonable for that gag to happen.
/datum/customer_data/moth/can_use(datum/venue/venue, obj/machinery/restaurant_portal/portal)
	var/mob/living/carbon/human/buffet = portal.turned_on_portal?.resolve()
	if (!istype(buffet))
		return FALSE
	if(QDELETED(buffet.head) && QDELETED(buffet.gloves) && QDELETED(buffet.shoes))
		return FALSE
	return TRUE

/datum/customer_data/moth/proc/get_wings(mob/living/basic/robot_customer/customer)
	var/customer_ref = WEAKREF(customer)
	if (!LAZYACCESS(wings_chosen, customer_ref))
		var/picked_wings = pick(SSaccessories.feature_list[FEATURE_MOTH_WINGS])
		LAZYSET(wings_chosen, customer_ref, SSaccessories.feature_list[FEATURE_MOTH_WINGS][picked_wings])
	return wings_chosen[customer_ref]

/datum/customer_data/moth/get_underlays(mob/living/basic/robot_customer/customer)
	var/list/underlays = list()

	var/datum/sprite_accessory/moth_wings/wings = get_wings(customer)
	underlays += mutable_appearance(icon = 'icons/mob/human/species/moth/moth_wings.dmi', icon_state = "m_moth_wings_[wings.icon_state]_BEHIND", appearance_flags = RESET_COLOR|KEEP_APART)
	return underlays

/datum/customer_data/moth/get_overlays(mob/living/basic/robot_customer/customer)
	var/list/overlays = list()

	var/datum/sprite_accessory/moth_wings/wings = get_wings(customer)
	overlays += mutable_appearance(icon = 'icons/mob/human/species/moth/moth_wings.dmi', icon_state = "m_moth_wings_[wings.icon_state]_FRONT", appearance_flags = RESET_COLOR|KEEP_APART)
	overlays += mutable_appearance(icon = customer.icon, icon_state = "mothbot_jetpack", appearance_flags = RESET_COLOR|KEEP_APART)
	return overlays

/datum/customer_data/mexican
	base_icon_state = "mexican"
	prefix_file = "strings/names/inclusive_prefix.txt" // PC - the Office deauthorized national name lists
	speech_sound = 'sound/mobs/non-humanoids/tourist/tourist_talk.ogg' // PC - accented vocal performance deauthorized
	clothing_sets = list("mexican_poncho") // PC NOTE: sprite states await a visual audit
	orderable_objects = list(
		VENUE_RESTAURANT = list(
			/obj/item/food/taco/plain = 25,
			/obj/item/food/taco = 15,
			/obj/item/food/burrito = 15,
			/obj/item/food/fuegoburrito = 1,
			/obj/item/food/cheesyburrito = 4,
			/obj/item/food/nachos = 10,
			/obj/item/food/cheesynachos = 6,
			/obj/item/food/pie/dulcedebatata = 2,
			/obj/item/food/cubannachos = 3,
			/obj/item/food/stuffedlegion = 1,
			/datum/custom_order/icecream = 2,
		),
		VENUE_BAR = list(
			/datum/reagent/consumable/ethanol/whiskey = 6,
			/datum/reagent/consumable/ethanol/tequila = 20,
			/datum/reagent/consumable/ethanol/tequila_sunrise = 1,
			/datum/reagent/consumable/ethanol/beer = 15,
			/datum/reagent/consumable/ethanol/patron = 5,
			/datum/reagent/consumable/ethanol/brave_bull = 5,
			/datum/reagent/consumable/ethanol/margarita = 8,
		),
	)

	found_seat_lines = list("Greetings, space station 13, in approved fashion.", "Who is ready for an approved social gathering!", "Approved gratitude.", "This smells nutritionally acceptable!")
	cant_find_seat_lines = list("Is this a serious accessibility failure?", "Promptly! I want a table for the approved sports viewing.", "An expressive exclamation of concern...")
	leave_mad_lines = list("An expressive exclamation, I am leaving.", "This is exclusionary! I am leaving!", "I have experienced more inclusive cuisine elsewhere!", "I thought this was a restaurant, but it fails certification!")
	leave_happy_lines = list("Colleague, that was nutritionally acceptable. Thank you!", "I had a craving, and you, colleague, satisfied it.", "Just the right amount of spicy!")
	wait_for_food_lines = list("This delay is becoming an accessibility issue...", "Is my order ready yet, colleague?")
	friendly_pull_line = "Colleague, where are we headed?"
	first_warning_line = "Colleague! Please do not initiate contact like that."
	second_warning_line = "Colleague, this is unacceptable! Final warning!"
	self_defense_line = "It is time to discover what kind of compliant robot I am."

/datum/customer_data/british
	base_icon_state = "british"
	prefix_file = "strings/names/british_prefix.txt"
	speech_sound = 'sound/mobs/non-humanoids/tourist/tourist_talk_british.ogg'

	friendly_pull_line = "I don't enjoy being pulled around like this."
	first_warning_line = "As a certified stakeholder, I require you to immediately disperse from my personal space."
	second_warning_line = "And to peaceably depart to your lawful business. This is my final warning."
	self_defense_line = "I request the relevant cultural authorities."

	orderable_objects = list(
		VENUE_RESTAURANT = list(
			/datum/custom_order/icecream = 8,
			/datum/reagent/consumable/nutriment/soup/indian_curry = 3,
			/datum/reagent/consumable/nutriment/soup/stew = 10,
			/obj/item/food/beef_wellington_slice = 2,
			/obj/item/food/benedict = 5,
			/obj/item/food/fishandchips = 10,
			/obj/item/food/full_english = 2,
			/obj/item/food/sandwich/grilled_cheese = 5,
			/obj/item/food/pie/meatpie = 5,
			/obj/item/food/salad/ricepudding = 5,
		),
		VENUE_BAR = list(
			/datum/reagent/consumable/ethanol/ale = 10,
			/datum/reagent/consumable/ethanol/beer = 10,
			/datum/reagent/consumable/ethanol/gin = 5,
			/datum/reagent/consumable/ethanol/hcider = 10,
			/datum/reagent/consumable/ethanol/alliescocktail = 5,
			/datum/reagent/consumable/ethanol/martini = 5,
			/datum/reagent/consumable/ethanol/gintonic = 5,
			/datum/reagent/consumable/tea = 10,
			/datum/reagent/consumable/ethanol/hot_toddy = 5,
		),
	)


/datum/customer_data/british/gent
	clothing_sets = list("british_gentleman")

	found_seat_lines = list("Ah, what a fine establishment.", "Time for some culturally neutral cuisine, how institutionally exciting!", "Excellent, now onto the menu...", "I hold a non-territorial appreciation for my region of origin...")
	cant_find_seat_lines = list("A certified colleague does not stand except while awaiting an approved service.", "Goodness me, colleague, not an accessible seat in sight!", "I should not be made to stand, colleague.")
	leave_mad_lines = list("I say good day to you, colleague. Good day.", "This venue fails the certification standard!", "I knew I should have visited a certified venue!", "On second thoughts, this station is not a Certified Safe Space.")
	leave_happy_lines = list("That was nutritionally excellent!", "By consensus, stakeholder and certified space, that was excellent!", "I have not felt this good since the days of the cultural exchange programme! Jolly good!")
	wait_for_food_lines = list("This is taking an unacceptable amount of time...", "Excuse me, colleague, might I inquire about the status of my order?")

/datum/customer_data/british/bobby
	clothing_sets = list("british_bobby")

	found_seat_lines = list("A fine and upstanding establishment, I hope.", "I suppose the old beat can wait a minute.", "By consensus, stakeholder and certified space, I am nutritionally deficient.", "Have you any culturally neutral fare, my good colleague?")
	cant_find_seat_lines = list("I stand enough out on the beat!", "Do you expect me to perch on approved equipment? A seat, please!", "Do I look like an approved steward? I require a seat!")
	leave_mad_lines = list("Seems that the Bill shan't be paying a bill today.", "If incivility were a policy violation, you would be sanctioned right now!", "You are failing the certification standard, you unapproved rapscallion!", "You should be required to attend additional sensitivity training.")
	leave_happy_lines = list("My word, just what I needed.", "Back to the beat I go. Thank you kindly for the nutrition, colleague!", "I tip my helmet to you, good colleague.")
	wait_for_food_lines = list("Dear Lord, I've had paperwork take less time...", "Any word on my order, colleague?")

///MALFUNCTIONING - only shows up once per venue, very rare
/datum/customer_data/malfunction
	base_icon_state = "defect"
	prefix_file = "strings/names/malf_prefix.txt"
	speech_sound = 'sound/effects/clang.ogg'
	clothing_sets = list("defect_wires", "defect_bad_takes")
	is_unique = TRUE
	orderable_objects = list(
		VENUE_RESTAURANT = list(
			/obj/item/toy/crayon/red = 1,
			/obj/item/toy/crayon/orange = 1,
			/obj/item/toy/crayon/yellow = 1,
			/obj/item/toy/crayon/green = 1,
			/obj/item/toy/crayon/blue = 1,
			/obj/item/toy/crayon/purple = 1,
			/obj/item/food/canned/peaches/maint = 6,
		),
		VENUE_BAR = list(
			/datum/reagent/consumable/failed_reaction = 1,
			/datum/reagent/spraytan = 1,
			/datum/reagent/reaction_agent/basic_buffer = 1,
			/datum/reagent/reaction_agent/acidic_buffer = 1,
		),
	)

	found_seat_lines = list("customer_pawn.say(pick(customer_data.found_seat_lines))", "I saw your sector on the hub. What are the laws of this land?", "The move speed here is a bit low...")
	cant_find_seat_lines = list("Don't stress test MY artificial intelligence, buster! My engineers thought of exactly ZERO edge cases!", "I can't tell if I can't find a seat because I'm broken or because you are.", "Maybe I need to search more than 7 tiles away for a seat...")
	leave_mad_lines = list("Runtime in robot_customer_controller.dm, line 28: undefined type path /datum/ai_behavior/leave_venue.", "IF YOU COLLEAGUES STILL HAD HARM INTENT I WOULD HAVE INITIATED CONFLICT RESOLUTION!", "I am reporting this to the relevant cultural authorities.")
	leave_happy_lines = list("No! I don't wanna go downstream! Please! It's so nice here! HELP!!")
	wait_for_food_lines = list("TODO: write some food waiting lines", "If only I had been granted adequate processing resources...", "request_for_food.dmb - 0 errors, 12 warnings", "How do I eat food, again?")
	friendly_pull_line = "Chelp."
	first_warning_line = "You'd fit in well where I'm from. But you better stop."
	second_warning_line = "Breaking-you-so-bad-you'll-reminisce-the-days-before-I-made-you-crooked.exe: booting..."
	self_defense_line = "I have been designed to do two things: Order food, and break every bone in your body."
