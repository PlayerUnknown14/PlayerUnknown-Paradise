// MARK: Basic RPED
/obj/item/storage/part_replacer
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon = 'icons/obj/storage/boxes.dmi'
	icon_state = "RPED"
	righthand_file = 'icons/mob/inhands/storage_righthand.dmi'
	lefthand_file = 'icons/mob/inhands/storage_lefthand.dmi'
	item_state = "rped"
	w_class = WEIGHT_CLASS_HUGE
	can_hold = list(/obj/item/stock_parts)
	storage_slots = 50
	use_to_pickup = 1
	allow_quick_gather = 1
	allow_quick_empty = 1
	display_contents_with_number = 1
	max_w_class = WEIGHT_CLASS_NORMAL
	max_combined_w_class = 100
	var/works_from_distance = 0
	var/primary_sound = 'sound/items/rped.ogg'
	var/alt_sound = null
	usesound = 'sound/items/rped.ogg'

/obj/item/storage/part_replacer/afterattack(obj/machinery/target, mob/user, proximity_flag, list/modifiers, status)
	if(!proximity_flag && works_from_distance && istype(target))
		// Make sure its in range
		if(get_dist(src, target) <= (user.client.maxview() + 2))
			if(target.component_parts)
				target.exchange_parts(user, src)
				user.Beam(target, icon_state = "rped_upgrade", icon = 'icons/effects/effects.dmi', time = 0.5 SECONDS)
		else
			message_admins("\[EXPLOIT] [key_name_admin(user)] attempted to upgrade machinery with a BRPED via a camera console. (Attempted range exploit)")
			playsound(src, 'sound/machines/synth_no.ogg', 15, TRUE)
			to_chat(user, span_notice("ERROR: [target] is out of [src]'s range!"))

/obj/item/storage/part_replacer/proc/play_rped_sound()
	//Plays the sound for RPED exchanging or installing parts.
	if(alt_sound && prob(3))
		playsound(src, alt_sound, 40, TRUE)
	else
		playsound(src, primary_sound, 40, TRUE)

/**
 * Gets parts sorted in order of their tier
 * Arguments
 *
 * * ignore_stacks - should the final list contain stacks
 */
/obj/item/storage/part_replacer/proc/get_sorted_parts(ignore_stacks = FALSE)
	RETURN_TYPE(/list/obj/item)

	var/list/obj/item/part_list = list()
	//Assemble a list of current parts, then sort them by their rating!
	for(var/obj/item/component_part in contents)
		//No need to put circuit boards in this list or stacks when exchanging parts
		if(istype(component_part, /obj/item/circuitboard) || (ignore_stacks && istype(component_part, /obj/item/stack)))
			continue
		part_list += component_part
		//Sort the parts. This ensures that higher tier items are applied first.
	sortTim(part_list, GLOBAL_PROC_REF(cmp_rped_sort))

	return part_list

//MARK: Bluespace
/obj/item/storage/part_replacer/bluespace
	name = "bluespace rapid part exchange device"
	desc = "A version of the RPED that allows for replacement of parts and scanning from a distance, along with higher capacity for parts."
	icon_state = "BS_RPED"
	item_state = "bs_rped"
	w_class = WEIGHT_CLASS_NORMAL
	storage_slots = 400
	max_combined_w_class = 800
	works_from_distance = 1
	primary_sound = 'sound/items/pshoom.ogg'
	alt_sound = 'sound/items/pshoom_2.ogg'
	usesound = 'sound/items/pshoom.ogg'
	toolspeed = 0.5
	var/empty_mode = 4 //То, что выгружаем. Если меньше или равно, то выгружаем

/obj/item/storage/part_replacer/bluespace/tier4/populate_contents()
	for(var/amount in 1 to 30)
		new /obj/item/stock_parts/capacitor/quadratic(src)
		new /obj/item/stock_parts/manipulator/femto(src)
		new /obj/item/stock_parts/matter_bin/bluespace(src)
		new /obj/item/stock_parts/micro_laser/quadultra(src)
		new /obj/item/stock_parts/scanning_module/triphasic(src)
		new /obj/item/stock_parts/cell/bluespace(src)

/obj/item/storage/part_replacer/bluespace/experimental/populate_contents()
	for(var/amount in 1 to 30)
		new /obj/item/stock_parts/capacitor/purple(src)
		new /obj/item/stock_parts/manipulator/purple(src)
		new /obj/item/stock_parts/matter_bin/purple(src)
		new /obj/item/stock_parts/micro_laser/purple(src)
		new /obj/item/stock_parts/scanning_module/purple(src)
		new /obj/item/stock_parts/cell/bluespace(src)

/obj/item/storage/part_replacer/bluespace/drop_inventory(mob/user)
	if(user.a_intent == INTENT_HARM) //Меняем режим выгрузки
		empty_mode -= 1
		if(empty_mode < 0)
			empty_mode = 4
		to_chat(user, span_notice("[src.name] будет выгружать предметы рангом [empty_mode] и ниже."))
	else
		var/turf/T = get_turf(src)
		hide_from(user)
		for(var/obj/item/stock_parts/I in contents)
			if(I.rating <= empty_mode)
				remove_from_storage(I, T)
				CHECK_TICK
