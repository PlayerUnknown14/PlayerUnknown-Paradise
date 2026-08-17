











/obj/item/circuitboard/solar_control
	board_name = "Solar Control"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/solar_control
	origin_tech = "programming=2;powerstorage=2"



/obj/item/circuitboard/broken
	board_name = "Broken curcuit"
	build_path = null





// Construction | Deconstruction
#define STATE_EMPTY 1 // Add a circuitboard | Weld to destroy
#define STATE_CIRCUIT 2 // Screwdriver the cover closed | Crowbar the circuit
#define STATE_NOWIRES 3 // Add wires | Screwdriver the cover open
#define STATE_WIRES 4 // Add glass | Remove wires
#define STATE_GLASS 5 // Screwdriver to complete | Crowbar glass out

/obj/structure/computerframe
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "comp_frame_1"
	density = TRUE
	anchored = TRUE
	max_integrity = 100
	var/state = STATE_EMPTY
	var/obj/item/circuitboard/circuit = null
	interaction_flags_click = NEED_HANDS | ALLOW_RESTING | NEED_DEXTERITY

/obj/structure/computerframe/Initialize(mapload, obj/item/circuitboard/circuit)
	. = ..()

	if(circuit)
		src.circuit = new circuit(src)
		state = STATE_GLASS	// Spawned during completed computer Init, so it's completed.

/obj/structure/computerframe/examine(mob/user)
	. = ..()
	. += span_notice("It is [anchored ? "<b>bolted</b> to the floor" : "<b>unbolted</b>"].")
	switch(state)
		if(STATE_EMPTY)
			. += span_notice("The frame is <b>welded together</b>, but it is missing a <i>circuit board</i>.")
		if(STATE_CIRCUIT)
			. += span_notice("A circuit board is <b>firmly connected</b>, but the cover is <i>unscrewed and open</i>.")
		if(STATE_NOWIRES)
			. += span_notice("The cover is <b>screwed shut</b>, but the frame is missing <i>wiring</i>.")
		if(STATE_WIRES)
			. += span_notice("The frame is <b>wired</b>, but the <i>glass</i> is missing.")
		if(STATE_GLASS)
			. += span_notice("The glass is <b>loosely connected</b> and needs to be <i>screwed into place</i>.")
	if(!anchored)
		. += span_notice("Alt-Click to rotate it.")

/obj/structure/computerframe/deconstruct(disassembled = TRUE)
	if(!(obj_flags & NODECONSTRUCT))
		var/location = drop_location()
		drop_computer_materials(location)

		if(circuit)
			circuit.forceMove(location)

		if(state >= STATE_WIRES)
			new /obj/item/stack/cable_coil(location, 5)

		if(state == STATE_GLASS)
			new /obj/item/stack/sheet/glass(location, 2)

	state = STATE_EMPTY
	circuit = null

	return ..() // will qdel the frame

/obj/structure/computerframe/Destroy()
	if(istype(circuit))
		qdel(circuit)

	circuit = null

	return ..()

/obj/structure/computerframe/click_alt(mob/user)
	if(anchored)
		to_chat(user, span_warning("The frame is anchored to the floor!"))
		return CLICK_ACTION_BLOCKING
	setDir(turn(dir, 90))
	return CLICK_ACTION_SUCCESS

/obj/structure/computerframe/obj_break(damage_flag)
	deconstruct()

/obj/structure/computerframe/proc/drop_computer_materials(location)
	new /obj/item/stack/sheet/metal(location, 5)

/obj/structure/computerframe/update_icon_state()
	icon_state = "comp_frame_[state]"

/obj/structure/computerframe/welder_act(mob/user, obj/item/I)
	if(state != STATE_EMPTY)
		return FALSE
	. = TRUE
	if(!I.tool_use_check(user, 0))
		return .
	WELDER_ATTEMPT_SLICING_MESSAGE
	if(!I.use_tool(src, user, 5 SECONDS, volume = I.tool_volume))
		return .
	WELDER_SLICING_SUCCESS_MESSAGE
	deconstruct(TRUE)

/obj/structure/computerframe/wrench_act(mob/living/user, obj/item/I)
	. = TRUE
	CALCULATE_SKILL_MOD(user, CONSTRUCTING_SPEED_MOD, construction_mod)
	if(!I.use_tool(src, user, 2 SECONDS * construction_mod, volume = I.tool_volume))
		return .
	set_anchored(!anchored)
	to_chat(user, span_notice("You [anchored ? "fasten the frame into place" : "unfasten the frame"]."))

/obj/structure/computerframe/crowbar_act(mob/living/user, obj/item/I)
	if(state != STATE_CIRCUIT && state != STATE_GLASS)
		return FALSE
	. = TRUE

	if(!I.use_tool(src, user, volume = I.tool_volume))
		return .

	switch(state)
		if(STATE_CIRCUIT)
			to_chat(user, span_notice("You remove the circuit board."))
			state = STATE_EMPTY
			name = initial(name)
			circuit.forceMove_turf()
			circuit = null
			update_icon(UPDATE_ICON_STATE)
		if(STATE_GLASS)
			to_chat(user, span_notice("You remove the glass panel."))
			state = STATE_WIRES
			new /obj/item/stack/sheet/glass(drop_location(), 2)
			update_icon(UPDATE_ICON_STATE)

/obj/structure/computerframe/screwdriver_act(mob/living/user, obj/item/I)
	if(state != STATE_CIRCUIT && state != STATE_NOWIRES && state != STATE_GLASS)
		return FALSE

	. = TRUE

	if(!I.use_tool(src, user, volume = I.tool_volume))
		return

	switch(state)
		if(STATE_CIRCUIT)
			to_chat(user, span_notice("You screw the circuit board into place."))
			state = STATE_NOWIRES
			update_icon(UPDATE_ICON_STATE)

		if(STATE_NOWIRES)
			to_chat(user, span_notice("You unfasten the circuit board."))
			state = STATE_CIRCUIT
			update_icon(UPDATE_ICON_STATE)

		if(STATE_GLASS)
			if(!anchored)
				to_chat(user, span_warning("Monitor can't be properly connected to the unfastened frame!"))
				return

			to_chat(user, span_notice("You connect the monitor."))
			if(circuit.build_path)
				new circuit.build_path(get_turf(src), src)
			else
				to_chat(user, span_warning("You connect the monitor, but it doesn't work. Maybe the circuit is broken?"))

/obj/structure/computerframe/wirecutter_act(mob/living/user, obj/item/I)
	if(state != STATE_WIRES)
		return FALSE
	. = TRUE
	if(!I.use_tool(src, user, volume = I.tool_volume))
		return .
	to_chat(user, span_notice("You remove the cables."))
	new /obj/item/stack/cable_coil(drop_location(), 5)
	state = STATE_NOWIRES
	update_icon(UPDATE_ICON_STATE)

/obj/structure/computerframe/attackby(obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	switch(state)
		if(STATE_EMPTY)
			if(!istype(I, /obj/item/circuitboard))
				return ..()

			add_fingerprint(user)

			if(!circuit_compatibility_check(I))
				to_chat(user, span_warning("[src] does not accept circuit boards of this type!"))
				return ATTACK_CHAIN_PROCEED

			if(!user.drop_transfer_item_to_loc(I, src))
				return ..()

			var/obj/item/circuitboard/new_circuit = I
			new_circuit.play_tool_sound(src)
			to_chat(user, span_notice("You place [new_circuit] inside [src]."))
			name += " ([new_circuit.board_name])"
			state = STATE_CIRCUIT
			circuit = new_circuit
			update_icon(UPDATE_ICON_STATE)
			return ATTACK_CHAIN_BLOCKED_ALL

		if(STATE_NOWIRES)
			if(!iscoil(I))
				return ..()
			add_fingerprint(user)
			var/obj/item/stack/cable_coil/coil = I
			if(coil.get_amount() < 5)
				to_chat(user, span_warning("You need five lengths of cable to wire the frame."))
				return ATTACK_CHAIN_PROCEED
			coil.play_tool_sound(src)
			to_chat(user, span_notice("You start to add cables to the frame..."))
			CALCULATE_SKILL_MOD(user, CONSTRUCTING_SPEED_MOD, construction_mod)
			if(!do_after(user, 2 SECONDS * coil.toolspeed * construction_mod, src, category = DA_CAT_TOOL) || state != STATE_NOWIRES || QDELETED(coil))
				return ATTACK_CHAIN_PROCEED
			if(!coil.use(5))
				to_chat(user, span_warning("At some point during construction you lost some cable. Make sure you have five lengths before trying again."))
				return ATTACK_CHAIN_PROCEED
			state = STATE_WIRES
			update_icon(UPDATE_ICON_STATE)
			to_chat(user, span_notice("You add cables to the frame."))
			return ATTACK_CHAIN_PROCEED_SUCCESS

		if(STATE_WIRES)
			if(!istype(I, /obj/item/stack/sheet/glass))
				return ..()
			add_fingerprint(user)
			var/obj/item/stack/sheet/glass/glass = I
			if(glass.get_amount() < 2)
				to_chat(user, span_warning("You need two sheets of glass for this."))
				return ATTACK_CHAIN_PROCEED
			glass.play_tool_sound(src)
			to_chat(user, span_notice("You start to add the glass panel to the frame..."))
			CALCULATE_SKILL_MOD(user, CONSTRUCTING_SPEED_MOD, construction_mod)
			if(!do_after(user, 2 SECONDS * glass.toolspeed * construction_mod, src, category = DA_CAT_TOOL) || state != STATE_WIRES || QDELETED(glass))
				return ATTACK_CHAIN_PROCEED
			if(!glass.use(2))
				to_chat(user, span_warning("At some point during construction you lost some glass. Make sure you have two sheets before trying again."))
				return ATTACK_CHAIN_PROCEED
			to_chat(user, span_notice("You put in the glass panel."))
			state = STATE_GLASS
			update_icon(UPDATE_ICON_STATE)
			return ATTACK_CHAIN_PROCEED_SUCCESS

	return ..()

/obj/structure/computerframe/proc/on_construction(obj/machinery/computer/computer)
	forceMove(computer)

/obj/structure/computerframe/proc/circuit_compatibility_check(obj/item/circuitboard/circuit)
	return circuit.board_type == "computer"

/obj/structure/computerframe/HONKputer
	name = "Bananium Computer-frame"
	icon = 'icons/obj/machines/HONKputer.dmi'

/obj/structure/computerframe/HONKputer/drop_computer_materials(location)
	new /obj/item/stack/sheet/mineral/bananium(location, 20)

/obj/structure/computerframe/HONKputer/circuit_compatibility_check(obj/item/circuitboard/circuit)
	return circuit.board_type == "HONKputer"

/obj/structure/computerframe/abductor
	icon_state = "comp_frame_alien1"

/obj/structure/computerframe/abductor/update_icon_state()
	icon_state = "comp_frame_alien[state]"

/obj/structure/computerframe/abductor/on_construction(obj/machinery/computer/computer)
	..()
	computer.abductor = TRUE
	computer.max_integrity = 400
	computer.update_integrity(400)

/obj/structure/computerframe/abductor/drop_computer_materials(location)
	new /obj/item/stack/sheet/mineral/abductor(location, 4)

/obj/structure/computerframe/cargo
	name = "cargo R&D console frame"
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "cargocomp_unscrewed"

#undef STATE_EMPTY
#undef STATE_CIRCUIT
#undef STATE_NOWIRES
#undef STATE_WIRES
#undef STATE_GLASS
