// MARK: Basic Board
/obj/item/circuitboard
	abstract_type = /obj/item/circuitboard
	/// Use `board_name` instead of this.
	name = "circuit board"
	gender = FEMALE
	icon = 'icons/obj/module.dmi'
	icon_state = "circuit_map"
	item_state = "electronic"
	origin_tech = "programming=2"
	w_class = WEIGHT_CLASS_SMALL
	materials = list(MAT_GLASS=200)
	usesound = 'sound/items/deconstruct.ogg'
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	greyscale_config = /datum/greyscale_config/circuit
	flags = /obj/item::flags | NO_NEW_GAGS_PREVIEW
	/// Use this instead of `name`. Formats as: `circuit board ([board_name])`
	var/board_name = null
	/// The machine that will be built from this circuit board.
	var/build_path = null
	/// Whether or not the circuit board will build into a vendor whose products cost nothing (used for offstation vending machines mostly).
	var/all_products_free = FALSE
	/// Determines if the board requires specific levels of parts. (ie specifically a femto menipulator vs generic manipulator).
	var/specific_parts = FALSE

/obj/item/circuitboard/get_ru_names()
	return alist(
		NOMINATIVE = "печатная плата",
		GENITIVE = "печатной платы",
		DATIVE = "печатной плате",
		ACCUSATIVE = "печатную плату",
		INSTRUMENTAL = "печатной платой",
		PREPOSITIONAL = "печатной плате"
	)

/obj/item/circuitboard/Initialize(mapload)
	. = ..()
	format_board_name()

/obj/item/circuitboard/proc/format_board_name()
	name = "[initial(name)][board_name ? " ([board_name])" : ""]"
	set_ru_names_suffix(board_name ? " ([board_name])" : "")

/obj/item/circuitboard/proc/apply_default_parts(obj/machinery/machine)
	if(LAZYLEN(machine.component_parts))
		// This really shouldn't happen. If it somehow does, print out a stack trace and gracefully handle it.
		stack_trace("apply_defauly_parts called on machine that already had component_parts: [machine]")

		// Remove references of components so it doesn't trigger Exited logic and remove existing parts.
		for(var/obj/item/part as anything in machine.component_parts)
			machine.component_parts -= part
			qdel(part)

	// List of components always contains the circuit board used to build it.
	machine.component_parts = list(src)
	forceMove(machine)

	if(machine.circuit != src)
		// This really shouldn't happen. If it somehow does, print out a stack trace and gracefully handle it.
		stack_trace("apply_default_parts called from a circuit board that does not belong to machine: [machine]")

		QDEL_NULL(machine.circuit)
		machine.circuit = src

	return

/**
 * Used to allow the circuitboard to configure a machine in some way, shape or form.
 *
 * Arguments:
 * * machine - The machine to attempt to configure.
 */
/obj/item/circuitboard/proc/configure_machine(obj/machinery/machine)
	return

/**
 * This proc is called during /obj/structure/frame/machine/finalize_construction in case there's anything else that needs to be met before completion.
 * Arguments:
 * * install_frame - The frame the circuit has been installed into for reference.
 */
/obj/item/circuitboard/proc/completion_requirements(obj/structure/frame/install_frame, mob/living/user)
	return TRUE

// MARK: Machine Board
/obj/item/circuitboard/machine
	board_name = "Машинерия"
	abstract_type = /obj/item/circuitboard/machine
	/// Whether this machine must be anchored to be constructed.
	var/needs_anchored = TRUE
	/// Components required by the machine.
	/// Example: list(/obj/item/stock_parts/matter_bin = 5)
	var/list/req_components
	/// Default replacements for req_components, to be used in apply_default_parts instead of req_components types
	/// Example: list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)
	var/list/def_components
	/// List of atoms/datums to replace the default components placed inside the machine
	var/list/replacement_parts

/**
 * Converts req_components map into a linear list with its datum components resolved
 *
 * Arguments
 * * obj/machinery/machine - if not null adds the parts to the machine directly & will not return anything
*/
/obj/item/circuitboard/machine/proc/flatten_component_list(obj/machinery/machine)
	SHOULD_NOT_OVERRIDE(TRUE)

	. = NONE
	if(QDELETED(machine))
		. = list()

	for(var/comp_path in req_components)
		var/comp_amt = req_components[comp_path]
		if(!comp_amt)
			continue

		if(def_components && def_components[comp_path])
			comp_path = def_components[comp_path]

		if(ispath(comp_path, /obj/item/stack))
			continue
		else if (ispath(comp_path, /datum/stock_part))
			var/stock_part_datum = GLOB.stock_part_datums[comp_path]
			if (isnull(stock_part_datum))
				CRASH("[comp_path] didn't have a matching stock part datum")
			for (var/_ in 1 to comp_amt)
				if(!.)
					machine.component_parts += stock_part_datum
				else
					. += stock_part_datum
		else
			for(var/_ in 1 to comp_amt)
				if(!.)
					machine.component_parts += new comp_path(machine)
				else
					. += comp_path

/**
 * Applies the default component parts for this machine
 *
 * Arguments
 * * obj/machinery/machine - the machine to apply the default parts to
*/
/obj/item/circuitboard/machine/apply_default_parts(obj/machinery/machine)
	if(!req_components && !length(replacement_parts))
		return

	. = ..()

	if(replacement_parts)
		for(var/part in replacement_parts)
			if(ispath(part, /obj/item))
				part = new part(machine)
			else if(ismovable(part))
				var/atom/movable/thing = part
				thing.forceMove(machine)
			machine.component_parts += part
		replacement_parts = null
	else
		flatten_component_list(machine)

	machine.RefreshParts()

/obj/item/circuitboard/machine/examine(mob/user)
	. = ..()
	if(!LAZYLEN(req_components))
		. += span_notice("It requires no components.")
		return

	var/list/nice_list = list()
	for(var/component_path in req_components)
		if(!ispath(component_path))
			continue

		var/component_name
		var/component_amount = req_components[component_path]

		//e.g. "glass sheet" vs. "glass"
		if(ispath(component_path, /obj/item/stack))
			var/obj/item/stack/stack_path = component_path
			component_name = initial(stack_path.singular_name)

		//stock parts in datum or obj form
		else if(ispath(component_path, /obj/item/stock_parts) || ispath(component_path, /datum/stock_part))
			var/obj/item/stock_parts/stock_part
			if(ispath(component_path, /obj/item/stock_parts))
				stock_part = component_path
			else
				var/datum/stock_part/datum_part = component_path
				stock_part = initial(datum_part.physical_object_type)

			if(!specific_parts)
				component_name = initial(stock_part.base_name)
			if(!component_name)
				component_name = initial(stock_part.name)

		//beakers, any non conventional part
		else if(ispath(component_path, /atom))
			var/atom/stock_part = component_path
			component_name = initial(stock_part.name)

		//append decoded name to final result
		if (isnull(component_name))
			stack_trace("[component_path] was an invalid component")
		nice_list += list("[component_amount] [component_name]\s")

	. += span_notice("It requires [english_list(nice_list)].")

// MARK: Computer Board
/obj/item/circuitboard/computer
	abstract_type = /obj/item/circuitboard/computer
	board_name = "(Комьютер)"
