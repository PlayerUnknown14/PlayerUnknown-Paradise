/obj/machinery/chem_mass_spec
	name = "high-performance liquid chromatography machine"
	desc = "Лабораторная установка, предназначенная для разделения и очистки химических веществ с помощью метода \
			высокоэффективной жидкостной хроматографии (ВЭЖХ)."
	gender = FEMALE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "HPLC"
	base_icon_state = "HPLC"
	density = TRUE
	interaction_flags_atom = parent_type::interaction_flags_atom | INTERACT_ATOM_REQUIRES_ANCHORED
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.2
	resistance_flags = FIRE_PROOF | ACID_PROOF
	processing_flags = START_PROCESSING_MANUALLY

	/// If we're processing reagents or not.
	var/processing_reagents = FALSE
	/// Time we started processing + the delay.
	var/delay_time = 0
	/// How much time we've done so far.
	var/progress_time = 0
	/// Lower mass range - for mass selection of what will be processed.
	var/lower_mass_range = 0
	/// Upper_mass_range - for mass selection of what will be processed.
	var/upper_mass_range = INFINITY
	/// The log output to clarify how the thing works.
	var/list/log = list()
	/// Input reagents container.
	var/obj/item/reagent_containers/beaker1
	/// Output reagents container.
	var/obj/item/reagent_containers/beaker2
	/// Multiplies the final time needed to process the chems depending on the laser stock part.
	var/cms_coefficient = 1

/obj/machinery/chem_mass_spec/get_ru_names()
	return alist(
		NOMINATIVE = "ВЭЖХ-машина",
		GENITIVE = "ВЭЖХ-машина",
		DATIVE = "ВЭЖХ-машина",
		ACCUSATIVE = "ВЭЖХ-машина",
		INSTRUMENTAL = "ВЭЖХ-машина",
		PREPOSITIONAL = "ВЭЖХ-машина",
	)

/obj/machinery/chem_mass_spec/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/chem_mass_spec(null)
	component_parts += new /obj/item/stock_parts/micro_laser(null)
	component_parts += new /obj/item/stack/cable_coil(null, 5)
	RefreshParts()

	if(mapload)
		beaker2 = new /obj/item/reagent_containers/glass/beaker/large(src)

	register_context()

/obj/machinery/chem_mass_spec/Destroy()
	QDEL_NULL(beaker1)
	QDEL_NULL(beaker2)
	return ..()

/obj/machinery/chem_mass_spec/on_deconstruction(disassembled)
	var/location = drop_location()
	beaker1?.forceMove(location)
	beaker2?.forceMove(location)

/obj/machinery/chem_mass_spec/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE

	if(!QDELETED(beaker1))
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Извлечь ёмкость для ввода"
		. = CONTEXTUAL_SCREENTIP_SET
	if(!QDELETED(beaker2))
		context[SCREENTIP_CONTEXT_ALT_RMB] = "Извлечь ёмкость для вывода"
		. = CONTEXTUAL_SCREENTIP_SET

	if(isnull(held_item) || (held_item.item_flags & ABSTRACT))
		return

	if(held_item.is_chem_container())
		if(QDELETED(beaker1))
			context[SCREENTIP_CONTEXT_LMB] = "Вставить ёмкость для ввода"
		else
			context[SCREENTIP_CONTEXT_LMB] = "Заменить ёмкость для ввода"

		if(QDELETED(beaker2))
			context[SCREENTIP_CONTEXT_RMB] = "Вставить ёмкость для вывода"
		else
			context[SCREENTIP_CONTEXT_RMB] = "Заменить ёмкость для вывода"

		return CONTEXTUAL_SCREENTIP_SET

	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "От" : "При"]крутить"
		return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
		context[SCREENTIP_CONTEXT_LMB] = "[panel_open ? "За" : "От"]крыть техпанель"
		return CONTEXTUAL_SCREENTIP_SET
	else if(panel_open && held_item.tool_behaviour == TOOL_CROWBAR)
		context[SCREENTIP_CONTEXT_LMB] = "Разобрать"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/chem_mass_spec/examine(mob/user)
	. = ..()

	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += span_warning("Отсюда не получается разглядеть дисплей и содержимое!")
		return

	. += span_notice("Слот для ёмкости ввода:")
	if(!QDELETED(beaker1))
		. += span_notice("- [beaker1.get_examine_icon(user)] [DECLENT_RU_CAP(beaker1, NOMINATIVE)] содержит [beaker1.reagents.total_volume]/[beaker1.reagents.maximum_volume] ед. вещества.")
	else
		. += span_warning("- Пусто.")

	. += span_notice("Слот для ёмкости вывода:")
	if(!QDELETED(beaker2))
		. += span_notice("- [beaker2.get_examine_icon(user)] [DECLENT_RU_CAP(beaker2, NOMINATIVE)] содержит [beaker2.reagents.total_volume]/[beaker2.reagents.maximum_volume] ед. вещества.")
	else
		. += span_warning("- Пусто.")

	. += span_warning("Техобслуживание:")
	if(panel_open)
		. += span_notice("- Панель техобслуживания открыта. Вы можете закрыть её, [EXAMINE_HINT("закрутив винты")].")
		. += span_notice("- Вы можете разобрать оборудование, [EXAMINE_HINT("поддев")] внутренние компоненты.")
	else
		. += span_notice("- Панель техобслуживания закрыта. Вы можете открыть её, [EXAMINE_HINT("открутив винты")].")
	if(anchored)
		. += span_notice("- Вы можете прикрутить оборудование к полу, [EXAMINE_HINT("затянув болты")].")
	else
		. += span_notice("- Вы можете открутить оборудование от пола, [EXAMINE_HINT("ослабив болты")].")

/obj/machinery/chem_mass_spec/update_overlays()
	. = ..()

	if(panel_open)
		. += mutable_appearance(icon, "[base_icon_state]_panel-o")
		return

	if(!QDELETED(beaker1))
		. += "HPLC_beaker1"
	if(!QDELETED(beaker2))
		. += "HPLC_beaker2"

	if(is_operational() && !panel_open && anchored && !(stat & (BROKEN | NOPOWER)))
		if(processing_reagents)
			. += "HPLC_graph_active"
		else if (length(beaker1?.reagents.reagent_list))
			. += "HPLC_graph_idle"

/obj/machinery/chem_mass_spec/update_icon_state()
	if(is_operational() && !panel_open && anchored && !(stat & (BROKEN | NOPOWER)))
		icon_state = "HPLC_on"
	else
		icon_state = "HPLC"
	return ..()

/obj/machinery/chem_mass_spec/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == beaker1)
		beaker1 = null
	if(gone == beaker2)
		beaker2 = null

/obj/machinery/chem_mass_spec/RefreshParts()
	. = ..()

	cms_coefficient = 1
	for(var/obj/item/stock_parts/micro_laser/laser in component_parts)
		cms_coefficient /= laser.rating

/obj/machinery/chem_mass_spec/item_interaction(mob/living/user, obj/item/item, list/modifiers)
	if(processing_reagents)
		balloon_alert(user, "в работе!")
		return ITEM_INTERACT_BLOCKING

	if(!item.can_insert_container(user, src))
		return NONE

	var/is_right_clicking = LAZYACCESS(modifiers, RIGHT_CLICK)
	if(!replace_beaker(user, !is_right_clicking, item))
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "вставлено в слот для [is_right_clicking ? "вывода" : "ввода"]")
	update_appearance()
	ui_interact(user)

	return ITEM_INTERACT_SUCCESS

/obj/machinery/chem_mass_spec/wrench_act(mob/living/user, obj/item/tool)
	if(processing_reagents)
		balloon_alert(user, "в процессе печати!")
		return
	return default_unfasten_wrench(user, tool)

/obj/machinery/chem_mass_spec/screwdriver_act(mob/living/user, obj/item/tool)
	if(processing_reagents)
		balloon_alert(user, "в процессе печати!")
		return

	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/chem_mass_spec/crowbar_act(mob/living/user, obj/item/tool)
	if(processing_reagents)
		balloon_alert(user, "в процессе печати!")
		return

	return default_deconstruction_crowbar(user, tool)


/**
 * Computes either the lightest or heaviest reagent in the input beaker
 * Arguments
 *
 * * smallest - TRUE to find lightest reagent, FALSE to find heaviest reagent
 */
/obj/machinery/chem_mass_spec/proc/calculate_mass(smallest = TRUE)
	PRIVATE_PROC(TRUE)
	SHOULD_BE_PURE(TRUE)

	if(QDELETED(beaker1))
		return 0

	var/result = 0
	for(var/datum/reagent/reagent as anything in beaker1?.reagents.reagent_list)
		var/datum/reagent/target = reagent
		if(reagent.inverse_chem && reagent.inverse_chem_val > reagent.purity)
			target = GLOB.chemical_reagents_list[reagent.inverse_chem]

		if(!result)
			result = target.mass
		else
			result = smallest ? min(result, target.mass) : max(result, target.mass)
	return smallest ? FLOOR(result, 50) : CEILING(result, 50)

/**
 * Replaces a beaker in the machine, either input or output. Returns TRUE on success.
 * Arguments
 *
 * * user - The one bonking the machine
 * * target beaker - the target beaker we are trying to replace
 * * new beaker - the new beaker to add/replace the slot with
 */
/obj/machinery/chem_mass_spec/proc/replace_beaker(mob/living/user, is_input, obj/item/reagent_containers/new_beaker)
	PRIVATE_PROC(TRUE)

	if(is_input) //replace input beaker
		if(!QDELETED(beaker1))
			user.put_in_hands(beaker1, ignore_anim = FALSE)
		if(!QDELETED(new_beaker))
			if(!user.transfer_item_to_loc(new_beaker, src))
				update_appearance(UPDATE_OVERLAYS)
				return FALSE

			beaker1 = new_beaker
			lower_mass_range = calculate_mass(smallest = TRUE)
			upper_mass_range = calculate_mass(smallest = FALSE)
			estimate_time()
	else //replace output beaker
		if(!QDELETED(beaker2))
			user.put_in_hands(beaker2, ignore_anim = FALSE)
		if(!QDELETED(new_beaker))
			if(!user.transfer_item_to_loc(new_beaker, src))
				update_appearance(UPDATE_OVERLAYS)
				return FALSE

			beaker2 = new_beaker
			log.Cut()

	update_appearance(UPDATE_OVERLAYS)

	return TRUE

///Computes time to purity reagents
/obj/machinery/chem_mass_spec/proc/estimate_time()
	PRIVATE_PROC(TRUE)

	delay_time = 0
	if(QDELETED(beaker1))
		return

	for(var/datum/reagent/reagent as anything in beaker1.reagents.reagent_list)
		var/datum/reagent/target = reagent
		var/inverse = FALSE

		//inverted chems are dealt with diffrently
		if(reagent.inverse_chem && reagent.inverse_chem_val > reagent.purity)
			target = GLOB.chemical_reagents_list[reagent.inverse_chem]
			inverse = TRUE
		//out of our selected range
		if(target.mass < lower_mass_range || target.mass > upper_mass_range)
			continue
		//already at max purity
		if(!inverse && (initial(reagent.purity) - reagent.purity) <= 0)
			continue
		///Roughly 10 - 30s?
		delay_time += (((target.mass * reagent.volume) + (target.mass * reagent.get_inverse_purity() * 0.1)) * 0.0035) + 10

	delay_time *= cms_coefficient

/obj/machinery/chem_mass_spec/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MassSpec", DECLENT_RU_CAP(src, NOMINATIVE))
		ui.open()

/obj/machinery/chem_mass_spec/ui_data(mob/user)
	. = list()
	.["lowerRange"] = lower_mass_range
	.["upperRange"] = upper_mass_range
	.["processing"] = processing_reagents
	.["eta"] = delay_time - progress_time
	.["peakHeight"] = 0
	var/obj/item/held_item = user.get_active_hand()
	.["hasBeakerInHand"] = held_item?.is_chem_container() || FALSE

	//input reagents
	var/list/beaker1Data = null
	if(!QDELETED(beaker1))
		beaker1Data = list()
		var/datum/reagents/beaker_1_reagents = beaker1.reagents
		beaker1Data["currentVolume"] = beaker_1_reagents.total_volume
		beaker1Data["maxVolume"] = beaker_1_reagents.maximum_volume
		var/list/beakerContents = list()
		for(var/datum/reagent/reagent as anything in beaker_1_reagents.reagent_list)
			var/log = "Готов"
			var/datum/reagent/target = reagent
			var/purity = target.purity
			var/is_inverse = FALSE

			if(reagent.inverse_chem_val > reagent.purity && reagent.inverse_chem)
				purity = target.get_inverse_purity()
				target = GLOB.chemical_reagents_list[reagent.inverse_chem]
				is_inverse = TRUE
			else
				var/initial_purity = initial(reagent.purity)
				if((initial_purity - reagent.purity) <= 0) //already at max purity
					log = "Невозможно очистить выше [round(initial_purity * 100)]%"

			beakerContents += list(list(
				"name" = target.name,
				"volume" = round(reagent.volume, CHEMICAL_VOLUME_ROUNDING),
				"mass" = target.mass,
				"purity" = round(purity * 100),
				"type" = is_inverse ? "Загрязнённый" : "Чистый",
				"log" = log
			))
			.["peakHeight"] = max(.["peakHeight"], reagent.volume)
		beaker1Data["contents"] = beakerContents
	.["beaker1"] = beaker1Data

	//+10 because of the range on the peak
	.["graphUpperRange"] = calculate_mass(smallest = FALSE)

	//output reagents
	var/list/beaker2Data = null
	if(!QDELETED(beaker2))
		beaker2Data = list()
		var/datum/reagents/beaker_2_reagents = beaker2.reagents
		beaker2Data["currentVolume"] = beaker_2_reagents.total_volume
		beaker2Data["maxVolume"] = beaker_2_reagents.maximum_volume
		var/list/beakerContents = list()
		for(var/datum/reagent/reagent as anything in beaker_2_reagents.reagent_list)
			beakerContents += list(list(
				"name" = reagent.name,
				"volume" = round(reagent.volume, CHEMICAL_VOLUME_ROUNDING),
				"mass" = reagent.mass,
				"purity" = round(reagent.purity * 100),
				"type" = "Чистый",
				"log" = log[reagent.type]
			))
		beaker2Data["contents"] = beakerContents
	.["beaker2"] = beaker2Data

/obj/machinery/chem_mass_spec/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || processing_reagents)
		return

	switch(action)
		if("activate")
			if(QDELETED(beaker1))
				atom_say("Ёмкость для ввода отсутствует!")
				return
			if(QDELETED(beaker2))
				atom_say("Ёмкость для вывода отсутствует!")
				return

			//adjust timer for purification
			progress_time = 0
			estimate_time()
			if(delay_time <= 0)
				atom_say("Невозможно провести очистку!")
				return

			//start the purification process
			processing_reagents = TRUE
			begin_processing()
			update_appearance()

			return TRUE

		if("leftSlider")
			var/value = params["value"]
			if(isnull(value))
				return

			value = text2num(value)
			if(isnull(value))
				return

			lower_mass_range = clamp(value, calculate_mass(smallest = TRUE), (lower_mass_range + upper_mass_range) / 2)
			estimate_time()
			return TRUE

		if("rightSlider")
			var/value = params["value"]
			if(isnull(value))
				return

			value = text2num(value)
			if(isnull(value))
				return

			upper_mass_range = clamp(value, (lower_mass_range + upper_mass_range) / 2, calculate_mass(smallest = FALSE))
			estimate_time()
			return TRUE

		if("centerSlider")
			var/value = params["value"]
			if(isnull(value))
				return

			value = text2num(value)
			if(isnull(value))
				return

			var/delta_center = ((lower_mass_range + upper_mass_range) / 2) - params["value"]
			var/lowest = calculate_mass(smallest = TRUE)
			var/highest = calculate_mass(smallest = FALSE)
			lower_mass_range = clamp(lower_mass_range - delta_center, lowest, highest)
			upper_mass_range = clamp(upper_mass_range - delta_center, lowest, highest)
			estimate_time()

			return TRUE

		if("eject1")
			replace_beaker(ui.user, TRUE)
			return TRUE

		if("eject2")
			replace_beaker(ui.user, FALSE)
			return TRUE

		if("insert1")
			var/obj/item/reagent_containers/container = ui.user.get_active_hand()
			if(container?.can_insert_container(ui.user, src))
				replace_beaker(ui.user, TRUE, container)

			return TRUE

		if("insert2")
			var/obj/item/reagent_containers/container = ui.user.get_active_hand()
			if(container?.can_insert_container(ui.user, src))
				replace_beaker(ui.user, FALSE, container)

			return TRUE

/obj/machinery/chem_mass_spec/click_alt(mob/living/user)
	if(processing_reagents)
		balloon_alert(user, "в работе!")
		return CLICK_ACTION_BLOCKING
	replace_beaker(user, TRUE)
	return CLICK_ACTION_SUCCESS

/obj/machinery/chem_mass_spec/click_alt_secondary(mob/living/user)
	if(processing_reagents)
		balloon_alert(user, "в работе!")
		return
	replace_beaker(user, FALSE)

/obj/machinery/chem_mass_spec/process(seconds_per_tick)
	if(!processing_reagents)
		return PROCESS_KILL

	if(!is_operational() || panel_open || !anchored)
		return

	progress_time += seconds_per_tick
	if(progress_time >= delay_time)
		processing_reagents = FALSE
		progress_time = 0

		log.Cut()
		var/datum/reagents/input_reagents = beaker1.reagents
		var/datum/reagents/output_reagents = beaker2.reagents
		for(var/datum/reagent/reagent as anything in beaker1.reagents.reagent_list)
			var/product_vol = reagent.volume

			//purify inverted chems to their inverted purity
			if(reagent.inverse_chem && reagent.inverse_chem_val > reagent.purity)
				var/datum/reagent/inverse_reagent = GLOB.chemical_reagents_list[reagent.inverse_chem]
				if(inverse_reagent.mass < lower_mass_range || inverse_reagent.mass > upper_mass_range)
					continue
				input_reagents.remove_reagent(reagent.type, product_vol)
				output_reagents.add_reagent(reagent.inverse_chem, product_vol, reagtemp = input_reagents.chem_temp, added_purity = reagent.get_inverse_purity(), added_ph = reagent.ph)
				log[reagent.type] = "Очищено до [reagent.get_inverse_purity() * 100]%"
				continue

			//out of our selected range
			if(reagent.mass < lower_mass_range || reagent.mass > upper_mass_range)
				continue

			//already at max purity
			var/delta_purity = initial(reagent.purity) - reagent.purity
			if(delta_purity <= 0)
				continue

			//add the purified reagent. More impure reagents will yield smaller amounts
			beaker1.reagents.remove_reagent(reagent.type, product_vol)
			beaker2.reagents.add_reagent(reagent.type, product_vol * (1 - delta_purity), reagtemp = beaker1.reagents.chem_temp, added_purity = initial(reagent.purity), added_ph = reagent.ph)
			log[reagent.type] = "Очищено до [initial(reagent.purity) * 100]%"

		//recompute everything
		lower_mass_range = calculate_mass(smallest = TRUE)
		upper_mass_range = calculate_mass(smallest = FALSE)
		estimate_time()
		update_appearance()
		return PROCESS_KILL

	use_power(active_power_usage * seconds_per_tick)
