// MARK: Base Dispenser
/obj/machinery/chem_dispenser
	name = "chem dispenser"
	desc = "Высокотехнологичная машина, способная синтезировать определённые вещества с помощью сложных физико-химических процессов. \
			Даже не спрашивайте, как оно работает — вы всё равно не поймёте."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	base_icon_state = "dispenser"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	processing_flags = NONE

	/// The cell used to dispense reagents
	var/obj/item/stock_parts/cell/cell
	/// Efficiency used when converting cell power to reagents. Joule per volume.
	var/power_cost = 0.1 KILO WATTS
	/// The current amount this machine is dispensing
	var/amount = 30
	/// The rate at which this machine recharges the power cell.
	var/recharge_amount = 0.3 KILO WATTS
	var/recharge_counter = 0
	/// The temperature reagents are dispensed into the beaker
	var/dispensed_temperature = DEFAULT_REAGENT_TEMPERATURE
	/// If the UI has the pH meter shown
	var/show_ph = TRUE
	/// The overlay used to display the beaker on the machine
	VAR_PRIVATE/mutable_appearance/beaker_overlay
	/// Icon to display when the machine is powered
	var/working_state = "dispenser_working"
	/// Icon to display when the machine is not powered
	var/nopower_state = "dispenser_nopower"
	/// Should we display the open panel overlay when the panel is opened with a screwdriver
	var/has_panel_overlay = TRUE
	/// The actual beaker inserted into this machine
	var/obj/item/reagent_containers/beaker = null
	/// Dispensable_reagents is copypasted in plumbing synthesizers. Please update accordingly. (I didn't make it global because that would limit custom chem dispensers)
	var/list/dispensable_reagents = list(
		/datum/reagent/aluminium,
		/datum/reagent/bromine,
		/datum/reagent/carbon,
		/datum/reagent/chlorine,
		/datum/reagent/copper,
		/datum/reagent/consumable/ethanol,
		/datum/reagent/fluorine,
		/datum/reagent/hydrogen,
		/datum/reagent/iodine,
		/datum/reagent/iron,
		/datum/reagent/lithium,
		/datum/reagent/mercury,
		/datum/reagent/nitrogen,
		/datum/reagent/oxygen,
		/datum/reagent/phosphorus,
		/datum/reagent/potassium,
		/datum/reagent/uranium/radium,
		/datum/reagent/silicon,
		/datum/reagent/sodium,
		/datum/reagent/stable_plasma,
		/datum/reagent/consumable/sugar,
		/datum/reagent/sulfur,
		/datum/reagent/toxin/acid,
		/datum/reagent/water,
		/datum/reagent/fuel
	)
	/// These become available once the manipulator has been upgraded to tier 4 (femto)
	var/list/upgrade_reagents = list(
		/datum/reagent/acetone,
		/datum/reagent/ammonia,
		/datum/reagent/ash,
		/datum/reagent/diethylamine,
		/datum/reagent/fuel/oil,
		/datum/reagent/saltpetre
	)
	/// These become available once the machine has been emaged
	var/list/emagged_reagents = list(
		/datum/reagent/toxin/carpotoxin,
		/datum/reagent/medicine/mine_salve,
		/datum/reagent/medicine/morphine,
		/datum/reagent/drug/space_drugs,
		/datum/reagent/toxin
	)
	/// Starting purity of the created reagents
	var/base_reagent_purity = 1
	/// Records the reagents dispensed by the user if this list is not null
	VAR_PRIVATE/list/recording_recipe
	/// Saves all the recipes recorded by the machine
	VAR_PRIVATE/list/saved_recipes = list()

	/// Filters out all reactions that don't have any of these tags from the reaction list
	var/shown_reaction_tags = DAMAGE_HEALING_REACTION_TAGS | MEDICATION_REACTION_TAGS | CHEMIST_REACTION_TAGS
	/// Filters out all reactions that have any one of these tags from the reaction list
	var/hidden_reaction_tags = REACTION_TAG_ACTIVE | REACTION_TAG_FOOD | REACTION_TAG_DRINK

	var/base_skill = /datum/skill/medical/chemistry
	var/dispence_skill_name = CHEMISTRY_DISPENSE_RAND_SIZE
	var/dispence_random_prob_name = CHEMISTRY_DISPENSE_RAND_REAGENT_PROB

/obj/machinery/chem_dispenser/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/chem_dispenser(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/capacitor(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new cell_type(null)

	dispensable_reagents = sortAssoc(dispensable_reagents)
	RefreshParts()

	if(!is_operational())
		begin_processing()
	update_appearance()

	register_context()

/obj/machinery/chem_dispenser/Destroy()
	cell = null
	QDEL_NULL(beaker)
	return ..()

/obj/machinery/chem_dispenser/get_ru_names()
	return alist(
		NOMINATIVE = "химический раздатчик",
		GENITIVE = "химического раздатчика",
		DATIVE = "химическому раздатчику",
		ACCUSATIVE = "химический раздатчик",
		INSTRUMENTAL = "химическим раздатчиком",
		PREPOSITIONAL = "химическом раздатчике",
	)

/obj/machinery/chem_dispenser/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item) || (held_item.item_flags & ABSTRACT))
		if(isnull(held_item))
			context[SCREENTIP_CONTEXT_RMB] = "Извлечь ёмкость"
			. = CONTEXTUAL_SCREENTIP_SET
		return .

	if(held_item.is_chem_container())
		if(!QDELETED(beaker))
			context[SCREENTIP_CONTEXT_LMB] = "Заменить ёмкость"
		else
			context[SCREENTIP_CONTEXT_LMB] = "Вставить ёмкость"
		return CONTEXTUAL_SCREENTIP_SET

	if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
		context[SCREENTIP_CONTEXT_LMB] = "[panel_open ? "За" : "От"]крыть техпанель"
		return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "От" : "При"]крутить"
		return CONTEXTUAL_SCREENTIP_SET
	else if(panel_open && held_item.tool_behaviour == TOOL_CROWBAR)
		context[SCREENTIP_CONTEXT_LMB] = "Разобрать"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/chem_dispenser/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("Монитор состояния сообщает:\n\
			Скорость зарядки: <b>[display_power(recharge_amount, convert = FALSE)]</b>.\n\
			Энергозатраты: <b>[siunit(power_cost, "Дж/ед", 3)]</b>.")
		if(!QDELETED(beaker))
			. += span_notice("Слот для ёмкости:")
			var/beaker_volume = beaker.reagents.total_volume
			. += span_notice("- [beaker.get_examine_icon(user)] [DECLENT_RU_CAP(beaker, NOMINATIVE)] объёмом в [beaker_volume] единиц[declension_ru(beaker_volume, "", "ы", "у")].")
		else
			. += span_warning("- Пусто.")

		. += span_warning("Техобслуживание:")
		if(panel_open)
			. += span_notice("- Техпанель открыта. Вы можете закрыть её, [EXAMINE_HINT("закрутив винты")].")
			. += span_notice("- Вы можете разобрать оборудование, [EXAMINE_HINT("поддев")] внутренние компоненты.")
		else
			. += span_notice("- Техпанель закрыта. Вы можете открыть её, [EXAMINE_HINT("открутив винты")].")
		if(anchored)
			. += span_notice("Вы можете прикрутить оборедование к полу, [EXAMINE_HINT("затянув болты")].")
		else
			. += span_notice("Вы можете открутить оборедование от пола, [EXAMINE_HINT("ослабив болты")].")

/obj/machinery/chem_dispenser/on_set_is_operational(old_value)
	if(old_value) //Turned off
		end_processing()
	else //Turned on
		begin_processing()

/obj/machinery/chem_dispenser/process(seconds_per_tick)
/**
	if(cell.maxcharge == cell.charge)
		return
	use_power(active_power_usage * seconds_per_tick) //Additional power cost before charging the cell.
	charge_cell(recharge_amount * seconds_per_tick, cell) //This also costs power.
 */
	if(recharge_counter >= 4)
		if(!is_operational())
			return
		var/usedpower = cell.give(recharge_amount)
		if(usedpower)
			use_power(15 * recharge_amount)
		recharge_counter = 0
		return
	recharge_counter++

/obj/machinery/chem_dispenser/proc/display_beaker()
	var/mutable_appearance/b_o = beaker_overlay || mutable_appearance(icon, "disp_beaker")
	b_o.pixel_w = -7
	b_o.pixel_z = -4
	return b_o

/obj/machinery/chem_dispenser/proc/work_animation()
	if(working_state)
		flick(working_state,src)

/obj/machinery/chem_dispenser/update_icon_state()
	icon_state = "[(nopower_state && !powered()) ? nopower_state : base_icon_state]"
	return ..()

/obj/machinery/chem_dispenser/update_overlays()
	. = ..()
	if(has_panel_overlay && panel_open)
		. += mutable_appearance(icon, "[base_icon_state]_panel-o")

	if(beaker)
		beaker_overlay = display_beaker()
		. += beaker_overlay

/obj/machinery/chem_dispenser/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(emagged)
		balloon_alert(user, "already emagged!")
		return FALSE
	balloon_alert(user, "safeties shorted out")
	dispensable_reagents |= emagged_reagents//add the emagged reagents to the dispensable ones
	emagged = TRUE
	return TRUE

/obj/machinery/chem_dispenser/ex_act(severity, target)
	return severity <= EXPLODE_LIGHT ? FALSE : ..()

/**
/obj/machinery/chem_dispenser/contents_explosion(severity, target)
	. = ..()
	if(!beaker)
		return

	switch(severity)
		if(EXPLODE_DEVASTATE)
			SSexplosions.high_mov_atom += beaker
		if(EXPLODE_HEAVY)
			SSexplosions.med_mov_atom += beaker
		if(EXPLODE_LIGHT)
			SSexplosions.low_mov_atom += beaker
 */

/obj/machinery/chem_dispenser/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == beaker)
		beaker = null
		cut_overlays()

/obj/machinery/chem_dispenser/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser", DECLENT_RU_CAP(src, NOMINATIVE))
		ui.open()

	var/is_hallucinating = FALSE
	if(isliving(user))
		var/mob/living/living_user = user
		is_hallucinating = !!living_user.has_status_effect(/datum/status_effect/transient/hallucination)
	ui.set_autoupdate(!is_hallucinating) //to not ruin the immersion by constantly changing the fake chemicals

/obj/machinery/chem_dispenser/ui_data(mob/user)
	. = list()
	.["amount"] = amount
	.["energy"] = cell.charge ? cell.charge : 0 //To prevent NaN in the UI.
	.["maxEnergy"] = cell.maxcharge
	.["displayedUnits"] = cell.charge ? (cell.charge / power_cost) : 0
	.["displayedMaxUnits"] = cell.maxcharge / power_cost
	.["showpH"] = isnull(recording_recipe) ? show_ph : FALSE //virtual beakers have no ph to compute & display
	var/obj/item/held_item = user.get_active_hand()
	.["hasBeakerInHand"] = held_item?.is_chem_container() || FALSE

	var/list/chemicals = list()
	var/is_hallucinating = FALSE
	if(isliving(user))
		var/mob/living/living_user = user
		is_hallucinating = !!living_user.has_status_effect(/datum/status_effect/transient/hallucination)

	for(var/re in dispensable_reagents)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[re]
		if(temp)
			var/chemname = temp.name
			var/chemcolor = temp.color
			if(is_hallucinating && prob(5))
				chemname = "[pick_list_replacements("hallucination.json", "chemicals")]"
				chemcolor = random_colour()
			chemicals += list(list("title" = chemname, "id" = temp.name, "pH" = temp.ph, "color" = chemcolor, "pHCol" = convert_ph_to_readable_color(temp.ph)))
	.["chemicals"] = chemicals
	.["recipes"] = saved_recipes

	.["recordingRecipe"] = recording_recipe
	.["recipeReagents"] = list()
	if(beaker?.reagents.ui_reaction_id)
		var/datum/chemical_reaction/reaction = GLOB.chemical_reactions_list[beaker.reagents.ui_reaction_id]
		for(var/datum/reagent/reagent as anything in reaction.required_reagents)
			.["recipeReagents"] += reagent::name

	var/list/beaker_data = null
	if(!QDELETED(beaker))
		beaker_data = list()
		beaker_data["maxVolume"] = beaker.volume
		beaker_data["transferAmounts"] = beaker.possible_transfer_amounts
		beaker_data["pH"] = round(beaker.reagents.ph, 0.01)
		beaker_data["currentVolume"] = round(beaker.reagents.total_volume, CHEMICAL_VOLUME_ROUNDING)
		var/list/beakerContents = list()
		if(length(beaker.reagents.reagent_list))
			for(var/datum/reagent/reagent as anything in beaker.reagents.reagent_list)
				beakerContents += list(list("name" = reagent.name, "volume" = round(reagent.volume, CHEMICAL_VOLUME_ROUNDING))) // list in a list because Byond merges the first list...
		beaker_data["contents"] = beakerContents
	.["beaker"] = beaker_data

/obj/machinery/chem_dispenser/ui_static_data(mob/user)
	var/list/data = list()

	data["reaction_list"] = get_reaction_list()
	data["all_bitflags"] = list()
	for(var/readable_flag, real_flag in REACTION_TAG_READABLE)
		if((real_flag & hidden_reaction_tags) || !(real_flag & shown_reaction_tags))
			continue
		data["all_bitflags"][readable_flag] = real_flag

	return data

/obj/machinery/chem_dispenser/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("amount")
			if(!is_operational() || QDELETED(beaker))
				return
			var/target = text2num(params["target"])
			if(target in beaker.possible_transfer_amounts)
				amount = target
				work_animation()
				return TRUE

		if("dispense")
			if(!is_operational() || QDELETED(cell))
				return
			var/reagent_name = params["reagent"]
			if(!recording_recipe)
				var/reagent = GLOB.name2reagent[reagent_name]
				if(beaker && dispensable_reagents.Find(reagent))
					var/datum/reagents/holder = beaker.reagents
					var/to_dispense = max(0, min(amount, holder.maximum_volume - holder.total_volume))
					if(!to_dispense)
						atom_say("The container is full!")
						return
					if(!cell.use(to_dispense * power_cost))
						atom_say("Not enough energy to complete operation!")
						return
					beaker.add_hiddenprint(ui.user)
					holder.add_reagent(reagent, to_dispense, reagtemp = dispensed_temperature, added_purity = base_reagent_purity)

					work_animation()
			else
				recording_recipe[reagent_name] += amount
			return TRUE

		if("remove")
			if(!is_operational() || recording_recipe)
				return
			var/amount = text2num(params["amount"])
			if(beaker && (amount in beaker.possible_transfer_amounts))
				beaker.reagents.remove_all(amount)
				work_animation()
				return TRUE

		if("eject")
			replace_beaker(ui.user)
			return TRUE

		if("insert")
			var/obj/item/reagent_containers/container = ui.user.get_active_hand()
			if(container?.can_insert_container(ui.user, src))
				replace_beaker(ui.user, container)

			return TRUE

		if("dispense_recipe")
			if(!is_operational() || QDELETED(cell))
				return

			var/list/chemicals_to_dispense = saved_recipes[params["recipe"]]
			if(!LAZYLEN(chemicals_to_dispense))
				return
			for(var/key in chemicals_to_dispense)
				var/reagent = GLOB.name2reagent[key]
				var/dispense_amount = chemicals_to_dispense[key]
				if(!dispensable_reagents.Find(reagent))
					return
				if(!recording_recipe)
					if(!beaker)
						return
					var/datum/reagents/holder = beaker.reagents
					var/to_dispense = max(0, min(dispense_amount, holder.maximum_volume - holder.total_volume))
					if(!to_dispense)
						continue
					if(!cell.use(to_dispense * power_cost))
						atom_say("Not enough energy to complete operation!")
						return
					beaker.add_hiddenprint(ui.user)
					holder.add_reagent(reagent, to_dispense, reagtemp = dispensed_temperature, added_purity = base_reagent_purity)
					work_animation()
				else
					recording_recipe[key] += dispense_amount
			return TRUE

		if("clear_recipes")
			if(is_operational() && tgui_alert(ui.user, "Clear all recipes?", "Clear?", list("Yes", "No")) == "Yes")
				saved_recipes = list()
				return TRUE

		if("record_recipe")
			if(!is_operational())
				recording_recipe = list()
				return TRUE

		if("save_recording")
			if(!is_operational())
				return
			var/name = tgui_input_text(ui.user, "What do you want to name this recipe?", "Recipe Name", max_length = MAX_NAME_LEN, encode = FALSE)
			if(!ui.user.can_perform_action(src, ALLOW_SILICON_REACH))
				return
			if(saved_recipes[name] && tgui_alert(ui.user, "\"[name]\" already exists, do you want to overwrite it?",, list("Yes", "No")) == "No")
				return
			if(name && recording_recipe)
				for(var/reagent in recording_recipe)
					var/reagent_id = GLOB.name2reagent[reagent]
					if(!dispensable_reagents.Find(reagent_id))
						visible_message(span_warning("[src] buzzes."), span_hear("You hear a faint buzz."))
						to_chat(ui.user, span_warning("[src] cannot find <b>[reagent]</b>!"))
						playsound(src, 'sound/machines/buzz/buzz-two.ogg', 50, TRUE)
						return
				saved_recipes[name] = recording_recipe
				recording_recipe = null
				return TRUE

		if("cancel_recording")
			if(!is_operational())
				recording_recipe = null
				return TRUE

		if("reaction_lookup")
			if(beaker)
				beaker.reagents.ui_interact(ui.user)

	var/result = handle_ui_act(action, params, ui, state)
	if(isnull(result))
		result = FALSE
	return result

/// Same as ui_act() but to be used by subtypes exclusively
/obj/machinery/chem_dispenser/proc/handle_ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	return null

/obj/machinery/chem_dispenser/screwdriver_act(mob/user, obj/item/I)
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", "[initial(icon_state)]", I))
		return TRUE

/obj/machinery/chem_dispenser/wrench_act(mob/user, obj/item/I)
	. = TRUE
	if(!I.use_tool(src, user, 0, volume = I.tool_volume))
		return
	set_anchored(!anchored)
	if(anchored)
		WRENCH_ANCHOR_MESSAGE
	else
		WRENCH_UNANCHOR_MESSAGE

/obj/machinery/chem_dispenser/crowbar_act(mob/user, obj/item/I)
	if(!panel_open)
		balloon_alert(user, "техпанель закрыта!")
		return
	if(default_deconstruction_crowbar(user, I))
		return TRUE

/obj/machinery/chem_dispenser/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!tool.can_insert_container(user, src))
		return NONE
	if(!replace_beaker(user, tool))
		return ITEM_INTERACT_BLOCKING

	ui_interact(user)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/chem_dispenser/get_cell()
	return cell

/obj/machinery/chem_dispenser/emp_act(severity)
	. = ..()
	/** TODO: поменять с портом ТГ emp_act()
	if(. & EMP_PROTECT_SELF)
		return
	 */
	var/list/datum/reagents/R = list()
	var/total = min(rand(7,15), FLOOR(cell.charge*INVERSE(power_cost), 1))
	var/datum/reagents/Q = new(total*10)
	if(beaker?.reagents)
		R += beaker.reagents
	for(var/i in 1 to total)
		Q.add_reagent(pick(dispensable_reagents), 10, reagtemp = dispensed_temperature, added_purity = base_reagent_purity)
	R += Q
	chem_splash(get_turf(src), null, 3, R)
	if(beaker?.reagents)
		beaker.reagents.remove_all()
	cell.use(total * power_cost)
	cell.emp_act(severity)
	work_animation()
	visible_message(span_danger("[src] malfunctions, spraying chemicals everywhere!"))

/obj/machinery/chem_dispenser/RefreshParts()
	. = ..()
	recharge_amount = initial(recharge_amount)
	var/new_power_cost = initial(power_cost)
	var/parts_rating = 0
	for(var/obj/item/stock_parts/cell/stock_cell in component_parts)
		cell = stock_cell
	for(var/obj/item/stock_parts/matter_bin/matter_bin in component_parts)
		new_power_cost -= (matter_bin.rating * 0.25 KILO WATTS)
		parts_rating += matter_bin.rating
	for(var/obj/item/stock_parts/capacitor/capacitor in component_parts)
		recharge_amount *= capacitor.rating
		parts_rating += capacitor.rating
	for(var/obj/item/stock_parts/manipulator/manipulator in component_parts)
		if (manipulator.rating > 3)
			dispensable_reagents |= upgrade_reagents
		else
			dispensable_reagents -= upgrade_reagents
		parts_rating += manipulator.rating
	power_cost = max(new_power_cost, 0.1 KILO WATTS)

/**
 * Insert, remove, replace the existig beaker. Returns TRUE on success.
 * Arguments:
 *
 * * mob/living/user - the player trying to replace the beaker
 * * obj/item/reagent_containers/new_beaker - the beaker we are trying to insert, swap with existing or remove if null
 */
/obj/machinery/chem_dispenser/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!QDELETED(beaker))
		user.put_in_hands(beaker, ignore_anim = FALSE)
	if(!QDELETED(new_beaker))
		if(!user.transfer_item_to_loc(new_beaker, src))
			update_appearance(UPDATE_OVERLAYS)
			return FALSE

		beaker = new_beaker

	update_appearance(UPDATE_OVERLAYS)

	return TRUE

/obj/machinery/chem_dispenser/on_deconstruction(disassembled)
	cell = null
	if(beaker)
		beaker.forceMove(drop_location())
		beaker = null
	return ..()

/obj/machinery/chem_dispenser/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!user.can_perform_action(src, ALLOW_SILICON_REACH|FORBID_TELEKINESIS_REACH))
		return
	if(user.incapacitated() || !user.Adjacent(src))
		return
	replace_beaker(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/chem_dispenser/attack_robot_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_dispenser/attack_ai_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_dispenser/proc/get_reaction_list()
	var/static/list/reaction_list
	if(reaction_list?[type])
		return reaction_list[type]

	reaction_list ||= list()
	reaction_list[type] = list()

	var/list/new_reaction_list = list()
	for(var/result, reactions in GLOB.chemical_reactions_list_product_index - dispensable_reagents)
		var/datum/reagent/result_datum = GLOB.chemical_reagents_list[result]
		for(var/datum/chemical_reaction/reaction as anything in reactions)
			if(!(reaction.reaction_tags & shown_reaction_tags))
				continue
			if(reaction.reaction_tags & hidden_reaction_tags)
				continue
			if(reaction.required_container)
				continue

			var/index = result_datum.name
			var/list/new_info = get_reaction_info(reaction)
			new_info["description"] = result_datum.description
			new_info["color"] = result_datum.color

			var/num_alts = 0
			while(new_reaction_list[index])
				num_alts++
				index = "[result_datum.name] (Alt[num_alts == 1 ? "" : " #[num_alts]"])"

			new_reaction_list[index] = new_info

	reaction_list[type] = new_reaction_list
	return reaction_list[type]

/obj/machinery/chem_dispenser/proc/get_reaction_info(datum/chemical_reaction/reaction)
	var/list/info = list()
	info["id"] = reaction.type
	info["lower_temperature"] = reaction.required_temp
	info["upper_temperature"] = reaction.optimal_temp
	info["lower_ph"] = reaction.optimal_ph_min
	info["upper_ph"] = reaction.optimal_ph_max
	info["bitflags"] = reaction.reaction_tags
	info["required_reagents"] = reagent_list_to_info(reaction.required_reagents)
	info["required_catalysts"] = reagent_list_to_info(reaction.required_catalysts)
	return info

/obj/machinery/chem_dispenser/proc/reagent_list_to_info(list/reagent_list)
	var/list/info = list()
	for(var/datum/reagent/reagent_typepath as anything in reagent_list)
		info += list(list(
			"name" = reagent_typepath::name,
			"amount" = reagent_list[reagent_typepath],
			"typepath" = reagent_typepath,
		))
	return info

// MARK: Drinks
/obj/machinery/chem_dispenser/drinks
	name = "soda dispenser"
	desc = "Машина, способная синтезировать целый ряд самых разных напитков. Круто!"
	icon_state = "soda_dispenser"
	base_icon_state = "soda_dispenser"
	has_panel_overlay = FALSE
	dispensed_temperature = WATER_MATTERSTATE_CHANGE_TEMP // magical mystery temperature of 274.5, where ice does not melt, and water does not freeze
	amount = 10
	anchored_tabletop_offset = 6
	working_state = null
	nopower_state = null
	pass_flags = PASSTABLE
	show_ph = FALSE
	shown_reaction_tags = KITCHEN_REACTION_TAGS
	hidden_reaction_tags = REACTION_TAG_ACTIVE
	dispensable_reagents = list(
		/datum/reagent/consumable/coffee,
		/datum/reagent/consumable/space_cola,
		/datum/reagent/consumable/cream,
		/datum/reagent/consumable/dr_gibb,
		/datum/reagent/consumable/grenadine,
		/datum/reagent/consumable/ice,
		/datum/reagent/consumable/icetea,
		/datum/reagent/consumable/lemonjuice,
		/datum/reagent/consumable/lemon_lime,
		/datum/reagent/consumable/limejuice,
		/datum/reagent/consumable/melon_soda,
		/datum/reagent/consumable/menthol,
		/datum/reagent/consumable/orangejuice,
		/datum/reagent/consumable/pineapplejuice,
		/datum/reagent/consumable/pwr_game,
		/datum/reagent/consumable/shamblers,
		/datum/reagent/consumable/spacemountainwind,
		/datum/reagent/consumable/sodawater,
		/datum/reagent/consumable/sol_dry,
		/datum/reagent/consumable/space_up,
		/datum/reagent/consumable/sugar,
		/datum/reagent/consumable/tea,
		/datum/reagent/consumable/tomatojuice,
		/datum/reagent/consumable/tonic,
		/datum/reagent/water,
	)
	upgrade_reagents = null
	emagged_reagents = list(
		/datum/reagent/consumable/ethanol/thirteenloko,
		/datum/reagent/consumable/ethanol/whiskey_cola,
		/datum/reagent/toxin/mindbreaker,
		/datum/reagent/toxin/staminatoxin
	)
	base_reagent_purity = 0.5

	base_skill = /datum/skill/service/drink_mixing
	dispence_skill_name = DRINKS_DISPENSE_RAND_SIZE
	dispence_random_prob_name = DRINKS_DISPENSE_RAND_REAGENT_PROB

/obj/machinery/chem_dispenser/drinks/get_ru_names()
	return alist(
		NOMINATIVE = "раздатчик напитков",
		GENITIVE = "раздатчика напитков",
		DATIVE = "раздатчику напитков",
		ACCUSATIVE = "раздатчик напитков",
		INSTRUMENTAL = "раздатчиком напитков",
		PREPOSITIONAL = "раздатчике напитков",
	)

/obj/machinery/chem_dispenser/drinks/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/chem_dispenser/soda(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stock_parts/capacitor(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new cell_type(null)
	RefreshParts()

/obj/machinery/chem_dispenser/drinks/setDir()
	var/old = dir
	. = ..()
	if(dir != old)
		update_appearance()  // the beaker needs to be re-positioned if we rotate

/obj/machinery/chem_dispenser/drinks/display_beaker()
	var/mutable_appearance/b_o = beaker_overlay || mutable_appearance(icon, "disp_beaker")
	switch(dir)
		if(NORTH)
			b_o.pixel_w = rand(-9, 9)
			b_o.pixel_z = 7
		if(EAST)
			b_o.pixel_w = 4
			b_o.pixel_z = rand(-5, 7)
		if(WEST)
			b_o.pixel_w = -5
			b_o.pixel_z = rand(-5, 7)
		else//SOUTH
			b_o.pixel_w = rand(-9, 9)
			b_o.pixel_z = -7
	return b_o

/obj/machinery/chem_dispenser/drinks/fullupgrade //fully ugpraded stock parts, emagged
	emagged = TRUE

/obj/machinery/chem_dispenser/drinks/fullupgrade/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/chem_dispenser/soda(null)
	component_parts += new /obj/item/stock_parts/matter_bin/super(null)
	component_parts += new /obj/item/stock_parts/matter_bin/super(null)
	component_parts += new /obj/item/stock_parts/manipulator/pico(null)
	component_parts += new /obj/item/stock_parts/capacitor/super(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new cell_type(null)
	RefreshParts()

	dispensable_reagents |= emagged_reagents //adds emagged reagents

// MARK: Booze
/obj/machinery/chem_dispenser/drinks/beer
	name = "booze dispenser"
	desc = "Машина, способная синтезировать для вас любую алкогольную бурду, которая только может прийти в голову. Настоящее чудо алкологольных технологий!"
	icon_state = "booze_dispenser"
	base_icon_state = "booze_dispenser"
	dispensed_temperature = WATER_MATTERSTATE_CHANGE_TEMP
	dispensable_reagents = list(
		/datum/reagent/consumable/ethanol/absinthe,
		/datum/reagent/consumable/ethanol/ale,
		/datum/reagent/consumable/ethanol/applejack,
		/datum/reagent/consumable/ethanol/beer,
		/datum/reagent/consumable/ethanol/coconut_rum,
		/datum/reagent/consumable/ethanol/cognac,
		/datum/reagent/consumable/ethanol/creme_de_cacao,
		/datum/reagent/consumable/ethanol/creme_de_coconut,
		/datum/reagent/consumable/ethanol/creme_de_menthe,
		/datum/reagent/consumable/ethanol/curacao,
		/datum/reagent/consumable/ethanol/gin,
		/datum/reagent/consumable/ethanol/hcider,
		/datum/reagent/consumable/ethanol/kahlua,
		/datum/reagent/consumable/ethanol/beer/maltliquor,
		/datum/reagent/consumable/ethanol/navy_rum,
		/datum/reagent/consumable/ethanol/rice_beer,
		/datum/reagent/consumable/ethanol/rum,
		/datum/reagent/consumable/ethanol/sake,
		/datum/reagent/consumable/ethanol/tequila,
		/datum/reagent/consumable/ethanol/triple_sec,
		/datum/reagent/consumable/ethanol/vermouth,
		/datum/reagent/consumable/ethanol/vodka,
		/datum/reagent/consumable/ethanol/whiskey,
		/datum/reagent/consumable/ethanol/wine,
		/datum/reagent/consumable/ethanol/yuyake,
	)
	upgrade_reagents = null
	emagged_reagents = list(
		/datum/reagent/consumable/ethanol,
		/datum/reagent/iron,
		/datum/reagent/consumable/mintextract,
		/datum/reagent/consumable/ethanol/atomicbomb,
		/datum/reagent/consumable/ethanol/fernet
	)

	base_skill = /datum/skill/service/drink_mixing
	dispence_skill_name = DRINKS_DISPENSE_RAND_SIZE

/obj/machinery/chem_dispenser/drinks/beer/get_ru_names()
	return alist(
		NOMINATIVE = "раздатчик алкоголя",
		GENITIVE = "раздатчика алкоголя",
		DATIVE = "раздатчику алкоголя",
		ACCUSATIVE = "раздатчик алкоголя",
		INSTRUMENTAL = "раздатчиком алкоголя",
		PREPOSITIONAL = "раздатчике алкоголя",
	)

/obj/machinery/chem_dispenser/drinks/beer/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/chem_dispenser/beer(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/capacitor(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new cell_type(null)
	RefreshParts()

/obj/machinery/chem_dispenser/drinks/beer/fullupgrade //fully ugpraded stock parts, emagged
	emagged = TRUE

/obj/machinery/chem_dispenser/drinks/beer/fullupgrade/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/chem_dispenser/beer(null)
	component_parts += new /obj/item/stock_parts/matter_bin/super(null)
	component_parts += new /obj/item/stock_parts/matter_bin/super(null)
	component_parts += new /obj/item/stock_parts/capacitor/super(null)
	component_parts += new /obj/item/stock_parts/manipulator/pico(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new cell_type(null)
	RefreshParts()

	dispensable_reagents |= emagged_reagents //adds emagged reagents

// MARK: Botanical
/obj/machinery/chem_dispenser/botanical
	name = "botanical chemical dispenser"
	desc = "Узкоспециализированная модель химического раздатчика, настроенная на синтез ограниченного числа веществ, специально для ботанических нужд."
	dispensable_reagents = list(
		/datum/reagent/toxin/mutagen,
		/datum/reagent/saltpetre,
		/datum/reagent/ammonia,
		/datum/reagent/water,
	)
	upgrade_reagents = list(
		/datum/reagent/glyphosate/atrazine,
		/datum/reagent/glyphosate,
		/datum/reagent/pestkiller,
		/datum/reagent/diethylamine,
		/datum/reagent/ash,
	)

/obj/machinery/chem_dispenser/botanical/get_ru_names()
	return alist(
		NOMINATIVE = "ботанический раздатчик",
		GENITIVE = "ботанического раздатчика",
		DATIVE = "ботаническому раздатчику",
		ACCUSATIVE = "ботанический раздатчик",
		INSTRUMENTAL = "ботаническим раздатчиком",
		PREPOSITIONAL = "ботаническом раздатчике",
	)

/obj/machinery/chem_dispenser/botanical/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/chem_dispenser/botanical(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/capacitor(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new cell_type(null)
	RefreshParts()

/obj/machinery/chem_dispenser/botanical/upgraded/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/chem_dispenser/botanical(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
	component_parts += new /obj/item/stock_parts/manipulator/femto(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new cell_type(null)
	RefreshParts()

/obj/machinery/chem_dispenser/fullupgrade //fully ugpraded stock parts, emagged
	emagged = TRUE

/obj/machinery/chem_dispenser/fullupgrade/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/chem_dispenser(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/capacitor(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new cell_type(null)
	RefreshParts()

	dispensable_reagents |= emagged_reagents //adds emagged reagents

/**
// MARK: Handheld
/obj/item/handheld_chem_dispenser
	name = "handheld chem dispenser"
	desc = "Компактная версия химического раздатчика. Удобно!"
	icon = 'icons/obj/chemical.dmi'
	item_state = "handheld_chem"
	icon_state = "handheld_chem"
	item_flags = NOBLUDGEON
	var/obj/item/stock_parts/cell/high/cell = null
	var/amount = 10
	var/mode = "dispense"
	var/is_drink = FALSE
	var/list/dispensable_reagents = list("hydrogen", "lithium", "carbon", "nitrogen", "oxygen", "fluorine",
	"sodium", "aluminum", "silicon", "phosphorus", "sulfur", "chlorine", "potassium", "iron",
	"copper", "mercury", "plasma", "radium", "water", "ethanol", "sugar", "iodine", "bromine", "silver", "chromium")
	var/current_reagent = null
	var/efficiency = 0.2
	var/recharge_rate = 1 // Keep this as an integer

/obj/item/handheld_chem_dispenser/get_ru_names()
	return alist(
		NOMINATIVE = "ручной химический раздатчик",
		GENITIVE = "ручного химического раздатчика",
		DATIVE = "ручному химическому раздатчику",
		ACCUSATIVE = "ручной химический раздатчик",
		INSTRUMENTAL = "ручным химическим раздатчиком",
		PREPOSITIONAL = "ручном химическом раздатчике",
	)

/obj/item/handheld_chem_dispenser/Initialize(mapload)
	. = ..()
	cell = new(src)
	dispensable_reagents = sortList(dispensable_reagents)
	current_reagent = pick(dispensable_reagents)
	update_icon(UPDATE_OVERLAYS)
	START_PROCESSING(SSobj, src)

/obj/item/handheld_chem_dispenser/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/handheld_chem_dispenser/get_cell()
	return cell

/obj/item/handheld_chem_dispenser/afterattack(atom/target, mob/user, proximity_flag, list/modifiers, status)
	if(!proximity_flag || !current_reagent || !amount)
		return

	if(!check_allowed_items(target,target_self = TRUE) || !target.is_refillable())
		return
	switch(mode)
		if("dispense")
			var/free = target.reagents.maximum_volume - target.reagents.total_volume
			var/actual = min(amount, cell.charge / efficiency, free)
			target.reagents.add_reagent(current_reagent, actual)
			cell.charge -= actual / efficiency
			if(actual)
				to_chat(user, span_notice("Вы наливаете [amount] единиц[DECL_SEC_MIN(amount)] [current_reagent] в [target.declent_ru(ACCUSATIVE)]."))
			update_icon(UPDATE_OVERLAYS)
		if("remove")
			if(!target.reagents.remove_reagent(current_reagent, amount))
				to_chat(user, span_notice("Вы удаляете [amount] единиц[DECL_SEC_MIN(amount)] [current_reagent] из [target.declent_ru(GENITIVE)]."))
		if("isolate")
			if(!target.reagents.isolate_reagent(current_reagent))
				to_chat(user, span_notice("Вы удаляете всё, кроме [current_reagent] в [target.declent_ru(PREPOSITIONAL)]."))

/obj/item/handheld_chem_dispenser/attack_self(mob/user)
	if(cell)
		ui_interact(user)
	else
		balloon_alert(user, "нет батареи!")

/obj/item/handheld_chem_dispenser/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/handheld_chem_dispenser/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HandheldChemDispenser", DECLENT_RU_CAP(src, NOMINATIVE))
		ui.open()

/obj/item/handheld_chem_dispenser/ui_data(mob/user)
	var/list/data = list()

	data["glass"] = is_drink
	data["amount"] = amount
	data["energy"] = cell.charge ? cell.charge * efficiency : "0" //To prevent NaN in the UI.
	data["maxEnergy"] = cell.maxcharge * efficiency
	data["current_reagent"] = current_reagent
	data["mode"] = mode

	return data

/obj/item/handheld_chem_dispenser/ui_static_data()
	var/list/data = list()
	var/list/chemicals = list()
	for(var/re in dispensable_reagents)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[re]
		if(temp)
			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("dispense" = temp.id)))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals

	return data

/obj/item/handheld_chem_dispenser/ui_act(action, list/params)
	if(..())
		return

	. = TRUE
	switch(action)
		if("amount")
			amount = clamp(round(text2num(params["amount"])), 0, 50) // round to nearest 1 and clamp to 0 - 50
		if("dispense")
			if(params["reagent"] in dispensable_reagents)
				current_reagent = params["reagent"]
				update_icon(UPDATE_OVERLAYS)
		if("mode")
			switch(params["mode"])
				if("remove")
					mode = "remove"
				if("dispense")
					mode = "dispense"
				if("isolate")
					mode = "isolate"
			update_icon(UPDATE_OVERLAYS)
		else
			return FALSE

	add_fingerprint(usr)

/obj/item/handheld_chem_dispenser/update_overlays()
	. = ..()
	if(cell?.charge)
		var/mutable_appearance/power_light = mutable_appearance('icons/obj/chemical.dmi', "light_low")
		var/percent = round((cell.charge / cell.maxcharge) * 100)
		switch(percent)
			if(0 to 33)
				power_light.icon_state = "light_low"
			if(34 to 66)
				power_light.icon_state = "light_mid"
			if(67 to INFINITY)
				power_light.icon_state = "light_full"
		. += power_light

		var/mutable_appearance/mode_light = mutable_appearance('icons/obj/chemical.dmi', "light_[mode]")
		. += mode_light

		var/mutable_appearance/chamber_contents = mutable_appearance('icons/obj/chemical.dmi', "reagent_filling")
		var/datum/reagent/R = GLOB.chemical_reagents_list[current_reagent]
		chamber_contents.color = R.color
		. += chamber_contents

/obj/item/handheld_chem_dispenser/process()
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R?.cell && R.cell.charge && (R.cell != cell))
			cell = R.cell //Use robot's power source.

	update_icon(UPDATE_OVERLAYS)
	return TRUE

/obj/item/handheld_chem_dispenser/attackby(obj/item/I, mob/user, params)
	if(iscell(I))
		add_fingerprint(user)
		if(cell)
			balloon_alert(user, "слот для батареи занят!")
			return ATTACK_CHAIN_PROCEED
		if(cell.maxcharge < 100)
			balloon_alert(user, "требуется батарея большей ёмкости!")
			return ATTACK_CHAIN_PROCEED
		if(!user.drop_transfer_item_to_loc(I, src))
			return ..()
		cell = I
		update_icon(UPDATE_OVERLAYS)
		balloon_alert(user, "батарея установлена")
		return ATTACK_CHAIN_BLOCKED_ALL

	return ..()

/obj/item/handheld_chem_dispenser/screwdriver_act(mob/user, obj/item/I)
	. = TRUE
	if(isrobot(loc))
		balloon_alert(user, "невозможно!")
		return .
	if(!cell)
		add_fingerprint(user)
		balloon_alert(user, "батарея отсутствует!")
		return .
	if(!I.use_tool(src, user, volume = I.tool_volume))
		return .
	balloon_alert(user, "батарея извлечена")
	cell.update_icon()
	cell.forceMove(drop_location())
	cell.add_fingerprint(user)
	cell = null
	update_icon(UPDATE_OVERLAYS)

/obj/item/handheld_chem_dispenser/booze
	name = "handheld bar tap"
	desc = "Компактная версия алкогольного раздатчика. Удобно!"
	item_state = "handheld_booze"
	icon_state = "handheld_booze"
	is_drink = TRUE
	dispensable_reagents = list("ice", "cream", "cider", "beer", "kahlua", "whiskey", "wine", "vodka", "gin", "rum", "tequila",
	"vermouth", "cognac", "ale", "mead", "synthanol", "jagermeister", "bluecuracao", "sambuka", "schnaps", "sheridan", "iced_beer",
	"irishcream", "manhattan", "antihol", "synthignon", "bravebull", "goldschlager", "patron", "absinthe", "ethanol", "nothing",
	"sake", "bitter", "champagne", "aperol", "noalco_beer")

/obj/item/handheld_chem_dispenser/booze/get_ru_names()
	return alist(
		NOMINATIVE = "ручной алкогольный раздатчик",
		GENITIVE = "ручного алкогольного раздатчика",
		DATIVE = "ручному алкогольному раздатчику",
		ACCUSATIVE = "ручной алкогольный раздатчик",
		INSTRUMENTAL = "ручным алкогольным раздатчиком",
		PREPOSITIONAL = "ручном алкогольном раздатчике",
	)

/obj/item/handheld_chem_dispenser/soda
	name = "handheld soda fountain"
	desc = "Компактная версия раздатчика напитков. Удобно!"
	item_state = "handheld_soda"
	icon_state = "handheld_soda"
	is_drink = TRUE
	dispensable_reagents = list("water", "ice", "soymilk", "coffee", "tea", "hot_coco", "cola", "spacemountainwind", "dr_gibb",
	"space_up", "tonic", "sodawater", "lemon_lime", "grapejuice", "sugar", "orangejuice", "lemonjuice", "limejuice", "tomatojuice",
	"banana", "watermelonjuice", "carrotjuice", "potato", "berryjuice", "bananahonk", "milkshake", "cafe_latte", "cafe_mocha",
	"triple_citrus", "icecoffe", "icetea", "thirteenloko")

/obj/item/handheld_chem_dispenser/soda/get_ru_names()
	return alist(
		NOMINATIVE = "ручной раздатчик напитков",
		GENITIVE = "ручного раздатчика напитков",
		DATIVE = "ручному раздатчику напитков",
		ACCUSATIVE = "ручной раздатчик напитков",
		INSTRUMENTAL = "ручным раздатчиком напитков",
		PREPOSITIONAL = "ручном раздатчике напитков",
	)

/obj/item/handheld_chem_dispenser/botanical
	name = "handheld botanical chemical dispenser"
	desc = "Компактная версия ботанического раздатчика. Удобно!"
	dispensable_reagents = list(
		"mutagen",
		"saltpetre",
		"eznutriment",
		"left4zednutriment",
		"robustharvestnutriment",
		"water",
		"atrazine",
		"pestkiller",
		"cryoxadone",
		"ammonia",
		"ash",
		"diethylamine",
	)

/obj/item/handheld_chem_dispenser/botanical/get_ru_names()
	return alist(
		NOMINATIVE = "компактный кухонный раздатчик",
		GENITIVE = "компактного кухонного раздатчика",
		DATIVE = "компактному кухонному раздатчику",
		ACCUSATIVE = "компактный кухонный раздатчик",
		INSTRUMENTAL = "компактным кухонным раздатчиком",
		PREPOSITIONAL = "компактном кухонном раздатчике",
	)

/obj/item/handheld_chem_dispenser/cooking
	name = "handheld cooking chemical dispenser"
	desc = "Компактный кухонный раздатчик. Удобно!"
	dispensable_reagents = list(
		"sodiumchloride",
		"blackpepper",
		"ketchup",
		"herbsmix",
	)

/obj/item/handheld_chem_dispenser/cooking/get_ru_names()
	return alist(
		NOMINATIVE = "компактный кухонный раздатчик",
		GENITIVE = "компактного кухонного раздатчика",
		DATIVE = "компактному кухонному раздатчику",
		ACCUSATIVE = "компактный кухонный раздатчик",
		INSTRUMENTAL = "компактным кухонным раздатчиком",
		PREPOSITIONAL = "компактном кухонном раздатчике",
	)
 */
