/obj/item/circuitboard/machine/smes
	board_name = "SMES"
	build_path = /obj/machinery/power/smes
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=3;powerstorage=3;engineering=3"
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/cell = 5,
		/obj/item/stock_parts/capacitor = 1,
	)

/obj/item/circuitboard/machine/smes/vintage
	build_path = /obj/machinery/power/smes/vintage
	origin_tech = "programming=2;powerstorage=2;engineering=2"
	req_components = list(
		/obj/item/stack/cable_coil = 7,
		/obj/item/stock_parts/cell = 7,
		/obj/item/stock_parts/capacitor = 3,
	)

/obj/item/circuitboard/machine/emitter
	board_name = "Emitter"
	build_path = /obj/machinery/power/emitter
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=3;powerstorage=4;engineering=4"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1,
	)

/obj/item/circuitboard/machine/power_compressor
	board_name = "Power Compressor"
	build_path = /obj/machinery/power/compressor
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=4;powerstorage=4;engineering=4"
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/manipulator = 6,
	)

/obj/item/circuitboard/machine/power_turbine
	board_name = "Power Turbine"
	build_path = /obj/machinery/power/turbine
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=4;powerstorage=4;engineering=4"
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 6,
	)

/obj/item/circuitboard/machine/thermomachine
	board_name = "Thermomachine"
	desc = "Use screwdriver to switch between heating and cooling modes."
	build_path = /obj/machinery/atmospherics/unary/thermomachine/freezer
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=3;plasmatech=3"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/thermomachine/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(!I.use_tool(src, user, volume = I.tool_volume))
		return .
	if(build_path == /obj/machinery/atmospherics/unary/thermomachine/freezer)
		build_path = /obj/machinery/atmospherics/unary/thermomachine/heater
		board_name = "Heater"
		to_chat(user, span_notice("You set the board to heating."))
	else
		build_path = /obj/machinery/atmospherics/unary/thermomachine/freezer
		board_name = "Freezer"
		to_chat(user, span_notice("You set the board to cooling."))

/obj/item/circuitboard/machine/cell_charger
	board_name = "Cell Recharger"
	build_path = /obj/machinery/cell_charger
	origin_tech = "powerstorage=3;materials=2"
	req_components = list(/obj/item/stock_parts/capacitor = 1)

/obj/item/circuitboard/machine/reactor_gas_node
	board_name = "Reactor Gas Node"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/unary/reactor_gas_node
	origin_tech = "engineering=2"
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/metal = 2,
	)

/obj/item/circuitboard/machine/reactor_moderator_gas_node
	board_name = "Moderator Gas Node"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/unary/reactor_gas_node/moderator
	origin_tech = "engineering=2"
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/metal = 2,
	)

/obj/item/circuitboard/machine/nuclear_centrifuge
	board_name = "Nuclear Centrifuge"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/nuclear_centrifuge
	origin_tech = "programming=4;engineering=4"
	req_components = list(
		/obj/item/stock_parts/manipulator = 4,
	)

/obj/item/circuitboard/machine/nuclear_rod_fabricator
	board_name = "Nuclear Rod Fabricator"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/nuclear_rod_fabricator
	origin_tech = "programming=4;engineering=4"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2,
	)

/obj/item/circuitboard/machine/reactor_chamber
	board_name = "Reactor Chamber"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/reactor_chamber
	origin_tech = "engineering=2"
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/metal = 2,
		/obj/item/stack/sheet/mineral/plastitanium = 2,
	)

/obj/item/circuitboard/machine/recharger
	board_name = "Recharger"
	build_path = /obj/machinery/recharger
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	origin_tech = "powerstorage=3;materials=2"
	req_components = list(/obj/item/stock_parts/capacitor = 1)

/obj/item/circuitboard/machine/snow_machine
	board_name = "Snow Machine"
	build_path = /obj/machinery/snow_machine
	origin_tech = "programming=2;materials=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
	)

/obj/item/circuitboard/machine/biogenerator
	board_name = "Biogenerator"
	build_path = /obj/machinery/biogenerator
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=2;biotech=3;materials=3"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/plantgenes
	board_name = "Plant DNA Manipulator"
	build_path = /obj/machinery/plantgenes
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=3;biotech=3"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/scanning_module = 1,
	)

/obj/item/circuitboard/machine/plantgenes/vault

/obj/item/circuitboard/machine/seed_extractor
	board_name = "Seed Extractor"
	build_path = /obj/machinery/seed_extractor
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=1"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
	)

/obj/item/circuitboard/machine/hydroponics
	board_name = "Hydroponics Tray"
	build_path = /obj/machinery/hydroponics/constructable
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=1;biotech=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/microwave
	board_name = "Microwave"
	build_path = /obj/machinery/kitchen_machine/microwave
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=2;magnets=2"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/oven
	board_name = "Oven"
	build_path = /obj/machinery/kitchen_machine/oven
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=2;magnets=2"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/grill
	board_name = "Grill"
	build_path = /obj/machinery/kitchen_machine/grill
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=2;magnets=2"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/candy_maker
	board_name = "Candy Maker"
	build_path = /obj/machinery/kitchen_machine/candy_maker
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=2;magnets=2"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/deepfryer
	board_name = "Deep Fryer"
	build_path = /obj/machinery/cooker/deepfryer
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=1"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/cable_coil = 5,
	)

/obj/item/circuitboard/machine/gibber
	board_name = "Gibber"
	build_path = /obj/machinery/gibber
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=2;engineering=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
	)

/obj/item/circuitboard/machine/tesla_coil
	board_name = "Tesla Coil"
	build_path = /obj/machinery/power/energy_accumulator/tesla_coil
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=3;magnets=3;powerstorage=3"
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
	)

/obj/item/circuitboard/machine/grounding_rod
	board_name = "Grounding Rod"
	build_path = /obj/machinery/power/energy_accumulator/grounding_rod
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=3;powerstorage=3;magnets=3;plasmatech=2"
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
	)

/obj/item/circuitboard/machine/processor
	board_name = "Food Processor"
	build_path = /obj/machinery/processor
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	origin_tech = "programming=1"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
	)

/obj/item/circuitboard/machine/recycler
	board_name = "Recycler"
	build_path = /obj/machinery/recycler
	origin_tech = "programming=2;engineering=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
	)

/obj/item/circuitboard/machine/dnaforensics
	board_name = "Анализатор ДНК"
	build_path = /obj/machinery/dnaforensics
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	origin_tech = "programming=2;combat=2"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/manipulator = 1,
	)

/obj/item/circuitboard/machine/microscope
	board_name = "Электронный микроскоп"
	build_path = /obj/machinery/microscope
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	origin_tech = "programming=2;combat=2"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/smartfridge
	board_name = "Smartfridge"
	build_path = /obj/machinery/smartfridge
	origin_tech = "programming=1"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
	)
	var/static/list/fridge_names_paths = list(
		"SmartFridge" = /obj/machinery/smartfridge,
		"Seed Storage" = /obj/machinery/smartfridge/seeds,
		"Refrigerated Medicine Storage" = /obj/machinery/smartfridge/medbay,
		"Slime Extract Storage" = /obj/machinery/smartfridge/secure/extract,
		"Secure Refrigerated Medicine Storage" = /obj/machinery/smartfridge/secure/medbay/organ,
		"Smart Chemical Storage" = /obj/machinery/smartfridge/secure/chemistry,
		"Smart Virus Storage" = /obj/machinery/smartfridge/secure/chemistry/virology,
		"Drink Showcase" = /obj/machinery/smartfridge/drinks,
		"Disk Storage" = /obj/machinery/smartfridge/disks,
		"Dish Showcase" = /obj/machinery/smartfridge/dish,
	)

/obj/item/circuitboard/machine/smartfridge/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(!I.use_tool(src, user, 0, volume = I.tool_volume))
		return
	var/choice = tgui_input_list(user, "Circuit Setting", "What would you change the board setting to?", fridge_names_paths)
	if(!choice)
		return
	set_type(user, choice)

/obj/item/circuitboard/machine/smartfridge/proc/set_type(mob/user, type)
	if(!ispath(type))
		board_name = type
		type = fridge_names_paths[type]
	else
		for(var/name in fridge_names_paths)
			if(fridge_names_paths[name] == type)
				board_name = name
				break
	build_path = type
	format_board_name()
	if(user)
		to_chat(user, span_notice("You set the board to [board_name]."))

/obj/item/circuitboard/machine/monkey_recycler
	board_name = "Monkey Recycler"
	build_path = /obj/machinery/monkey_recycler
	origin_tech = "programming=1;biotech=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
	)

/obj/item/circuitboard/machine/holopad
	board_name = "AI Holopad"
	build_path = /obj/machinery/hologram/holopad
	origin_tech = "programming=1"
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser
	board_name = "Chem Dispenser"
	build_path = /obj/machinery/chem_dispenser
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	origin_tech = "materials=4;programming=4;plasmatech=4;biotech=3"
	req_access = list(ACCESS_TOX, ACCESS_CHEMISTRY, ACCESS_SYNDICATE_SCIENTIST)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/botanical
	board_name = "Botanical Chem Dispenser"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/botanical

/obj/item/circuitboard/machine/chem_master
	board_name = "ChemMaster 3000"
	build_path = /obj/machinery/chem_master
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	origin_tech = "materials=3;programming=2;biotech=3"
	req_components = list(
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/chem_master/screwdriver_act(mob/user, obj/item/I)
	. = TRUE
	if(!I.use_tool(src, user, 0, volume = I.tool_volume))
		return
	var/new_name = "ChemMaster"
	var/new_path = /obj/machinery/chem_master

	if(build_path == /obj/machinery/chem_master)
		new_name = "CondiMaster"
		new_path = /obj/machinery/chem_master/condimaster

	build_path = new_path
	name = "circuit board ([new_name] 3000)"
	to_chat(user, span_notice("You change the circuit board setting to \"[new_name]\"."))

/obj/item/circuitboard/machine/chem_master/condi_master
	board_name = "CondiMaster 3000"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_master/condimaster

/obj/item/circuitboard/machine/chem_heater
	board_name = "Chemical Heater"
	build_path = /obj/machinery/chem_heater
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	origin_tech = "programming=2;engineering=2;biotech=2"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/reagentgrinder
	board_name = "All-In-One Grinder"
	build_path = /obj/machinery/reagentgrinder/empty
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	origin_tech = "materials=2;engineering=2;biotech=2"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
	)

//Almost the same recipe as destructive analyzer to give people choices.
/obj/item/circuitboard/machine/experimentor
	board_name = "E.X.P.E.R.I-MENTOR"
	build_path = /obj/machinery/r_n_d/experimentor
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "magnets=1;engineering=1;programming=1;biotech=1;bluespace=2"
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2,
	)

/obj/item/circuitboard/machine/destructive_analyzer
	board_name = "Destructive Analyzer"
	build_path = /obj/machinery/r_n_d/destructive_analyzer
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "magnets=2;engineering=2;programming=2"
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
	)

/obj/item/circuitboard/machine/autolathe
	board_name = "Autolathe"
	build_path = /obj/machinery/autolathe
	origin_tech = "engineering=2;programming=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/protolathe
	board_name = "Protolathe"
	build_path = /obj/machinery/r_n_d/protolathe
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "engineering=2;programming=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/reagent_containers/glass/beaker = 2,
	)

/obj/item/circuitboard/machine/chem_dispenser/soda
	board_name = "Soda Machine"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/soda

/obj/item/circuitboard/machine/chem_dispenser/beer
	board_name = "Beer Machine"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/beer

/obj/item/circuitboard/machine/circuit_imprinter
	board_name = "Circuit Imprinter"
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "engineering=2;programming=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/reagent_containers/glass/beaker = 2,
	)

/obj/item/circuitboard/machine/pacman
	board_name = "PACMAN-type Generator"
	build_path = /obj/machinery/power/port_gen/pacman
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=2;powerstorage=3;plasmatech=3;engineering=3"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor = 1,
	)

/obj/item/circuitboard/machine/pacman/super
	board_name = "SUPERPACMAN-type Generator"
	build_path = /obj/machinery/power/port_gen/pacman/super
	origin_tech = "programming=3;powerstorage=4;engineering=4"

/obj/item/circuitboard/machine/pacman/mrs
	board_name = "MRSPACMAN-type Generator"
	build_path = /obj/machinery/power/port_gen/pacman/mrs
	origin_tech = "programming=3;powerstorage=4;engineering=4;plasmatech=4"

/obj/item/circuitboard/machine/rdserver
	board_name = "R&D Server"
	build_path = /obj/machinery/r_n_d/server
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=3"
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/scanning_module = 1,
	)

/obj/item/circuitboard/machine/mechfab
	board_name = "Exosuit Fabricator"
	build_path = /obj/machinery/mecha_part_fabricator
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=2;engineering=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/mechfab/syndicate
	board_name = "Syndicate Exosuit Fabricator"
	icon_state = "syndicate_circuit"
	greyscale_config = null
	build_path = /obj/machinery/mecha_part_fabricator/syndicate
	origin_tech = "programming=2;engineering=2;syndicate=5"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/telecrystal = 25,
	)

/obj/item/circuitboard/machine/podfab
	board_name = "Spacepod Fabricator"
	build_path = /obj/machinery/mecha_part_fabricator/spacepod
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=2;engineering=2"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/clonepod
	board_name = "Experimental Biomass Pod"
	build_path = /obj/machinery/clonepod
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	origin_tech = "programming=2;biotech=2"
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/capacitor/quadratic = 5,
	)

/obj/item/circuitboard/machine/clonescanner
	board_name = "DNA Scanner"
	build_path = /obj/machinery/dna_scannernew
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	origin_tech = "programming=2;biotech=2"
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/cable_coil = 2,
	)

/obj/item/circuitboard/machine/mech_recharger
	board_name = "Mech Bay Recharger"
	build_path = /obj/machinery/mech_bay_recharge_port
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=3;powerstorage=3;engineering=3"
	req_components = list(
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/capacitor = 5,
	)

/obj/item/circuitboard/machine/teleporter_hub
	board_name = "Teleporter Hub"
	build_path = /obj/machinery/teleport/hub
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=3;engineering=4;bluespace=4;materials=4"
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 3,
		/obj/item/stock_parts/matter_bin = 1,
	)

/obj/item/circuitboard/machine/teleporter_station
	board_name = "Teleporter Station"
	build_path = /obj/machinery/teleport/station
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=4;engineering=4;bluespace=4;plasmatech=3"
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/teleporter_perma
	board_name = "Permanent Teleporter"
	build_path = /obj/machinery/teleport/perma
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=3;engineering=4;bluespace=4;materials=4"
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 3,
		/obj/item/stock_parts/matter_bin = 1,
	)
	var/target

/obj/item/circuitboard/machine/teleporter_perma/attackby(obj/item/I, mob/living/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/gps))
		add_fingerprint(user)
		var/obj/item/gps/gps = I
		if(gps.locked_location)
			target = get_turf(gps.locked_location)
			to_chat(user, span_caution("You upload the data from [gps]"))
		return ATTACK_CHAIN_PROCEED_SUCCESS

	return ..()

/obj/item/circuitboard/machine/telesci_pad
	board_name = "Telepad"
	build_path = /obj/machinery/telepad
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=4;engineering=3;plasmatech=4;bluespace=4"
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/quantumpad
	board_name = "Quantum Pad"
	build_path = /obj/machinery/quantumpad
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=3;engineering=3;plasmatech=3;bluespace=4"
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1,
	)

// syndie pads can be created by emagging normal quantumpads
/obj/item/circuitboard/machine/quantumpad/emag_act(mob/user)
	if(!emagged)
		if(user)
			user.visible_message(span_warning("Sparks fly out of the [src]!"), span_notice("You emag the [src], rewriting it's protocols for redspace usage."))
			playsound(src.loc, 'sound/effects/sparks4.ogg', 50, TRUE)
		emagged = TRUE
		name = "circuit board (Syndicate Quantum Pad)"
		build_path = /obj/machinery/syndiepad

		req_components = list(
			/obj/item/stack/telecrystal = 5,
			/obj/item/stock_parts/capacitor = 1,
			/obj/item/stock_parts/manipulator = 1,
			/obj/item/stack/cable_coil = 1,
		)
	return
// syndie pads by Furukai

/obj/item/circuitboard/machine/quantumpad/syndiepad
	board_name = "Syndicate Quantum Pad"
	build_path = /obj/machinery/syndiepad
	origin_tech = "programming=3;engineering=3;plasmatech=3;bluespace=4;syndicate=6" //Технология достойная подобного уровня нелегала как по мне
	req_components = list(
		/obj/item/stack/telecrystal = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1,
	)
	emagged = TRUE

/obj/item/circuitboard/machine/roboquest_pad

	board_name = "Robotics Request Quantum Pad"
	build_path = /obj/machinery/roboquest_pad
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=3;engineering=3;plasmatech=3;bluespace=5"
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 5,
		/obj/item/stack/cable_coil = 15,
	)

/obj/item/circuitboard/machine/advanced_roboquest_pad
	board_name = "Robotics Request Advanced Quantum Pad"
	icon_state = "abductor_mod"
	greyscale_config = null
	build_path = /obj/machinery/roboquest_pad/advanced
	origin_tech = "programming=4;engineering=5;plasmatech=5;bluespace=6"
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stack/cable_coil = 15,
	)

/obj/item/circuitboard/machine/sleeper
	board_name = "Sleeper"
	build_path = /obj/machinery/sleeper
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	origin_tech = "programming=3;biotech=2;engineering=3"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 2,
	)

/obj/item/circuitboard/machine/sleeper/syndicate
	board_name = "Sleeper - Syndicate"
	build_path = /obj/machinery/sleeper/syndie

/obj/item/circuitboard/machine/sleeper/survival
	board_name = "Sleeper - Survival Pod"
	build_path = /obj/machinery/sleeper/survival_pod

/obj/item/circuitboard/machine/bodyscanner
	board_name = "Body Scanner"
	build_path = /obj/machinery/bodyscanner
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	origin_tech = "programming=3;biotech=2;engineering=3"
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 2,
	)

/obj/item/circuitboard/machine/cryo_tube
	board_name = "Cryotube"
	build_path = /obj/machinery/atmospherics/unary/cryo_cell
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	origin_tech = "programming=4;biotech=3;engineering=4;plasmatech=3"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 4,
	)

/obj/item/circuitboard/machine/cyborgrecharger
	board_name = "Cyborg Recharger"
	build_path = /obj/machinery/recharge_station
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "powerstorage=3;engineering=3"
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/cell = 1,
		/obj/item/stock_parts/manipulator = 1,
	)

// Telecomms circuit boards:
/obj/item/circuitboard/machine/tcomms/relay
	board_name = "Telecommunications Relay"
	build_path = /obj/machinery/tcomms/relay
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=2;engineering=2;bluespace=2"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
	)

/obj/item/circuitboard/machine/tcomms/core
	board_name = "Telecommunications Core"
	build_path = /obj/machinery/tcomms/core
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=2;engineering=2"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
	)
// End telecomms circuit boards

/obj/item/circuitboard/machine/ore_redemption
	board_name = "Ore Redemption"
	build_path = /obj/machinery/mineral/ore_redemption
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	origin_tech = "programming=1;engineering=2"
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/assembly/igniter = 1,
	)

/obj/item/circuitboard/machine/ore_redemption/golem
	board_name = "Ore Redemption - Golem"
	build_path = /obj/machinery/mineral/ore_redemption/golem

/obj/item/circuitboard/machine/ore_redemption/labor
	board_name = "Ore Redemption - Labour"
	build_path = /obj/machinery/mineral/ore_redemption/labor

/obj/item/circuitboard/machine/mining_equipment_vendor
	board_name = "Mining Equipment Vendor"
	build_path = /obj/machinery/mineral/equipment_vendor
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	origin_tech = "programming=1;engineering=3"
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/matter_bin = 3,
	)

/obj/item/circuitboard/machine/mining_equipment_vendor/golem
	board_name = "Golem Equipment Vendor"
	build_path = /obj/machinery/mineral/equipment_vendor/golem

/obj/item/circuitboard/machine/mining_equipment_vendor/labor
	board_name = "Labour Equipment Vendor"
	build_path = /obj/machinery/mineral/equipment_vendor/labor

/obj/item/circuitboard/machine/clawgame
	board_name = "Claw Game"
	build_path = /obj/machinery/arcade/claw
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=1"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/minesweeper
	board_name = "Сапер"
	build_path = /obj/machinery/arcade/minesweeper
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=1"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/prize_counter
	board_name = "Prize Counter"
	build_path = /obj/machinery/prize_counter
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=1"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/cable_coil = 1,
	)

/obj/item/circuitboard/machine/gameboard
	board_name = "Virtual Gameboard"
	build_path = /obj/machinery/gameboard
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=1"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 3,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/item/circuitboard/machine/vendor/plasmamate

/obj/item/circuitboard/machine/vendor/plasmamate/Initialize(mapload)
	. = ..()
	set_type("PlasmaMate")

/obj/item/circuitboard/machine/anomaly_generator
	board_name = "генератор аномалий"
	build_path = /obj/machinery/power/anomaly_generator
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=1;bluespace=3"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/capacitor = 2,
	)

/obj/item/circuitboard/machine/electrolyzer
	board_name = "Electrolyzer"
	build_path = /obj/machinery/power/electrolyzer
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=3;engineering=3"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/cable_coil = 5,
	)

/obj/item/circuitboard/machine/portagrav
	board_name = "Портативный гравигенератор"
	build_path = /obj/machinery/power/portagrav
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	origin_tech = "programming=3;engineering=4;magnets=3"
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/cable_coil = 5,
	)

/obj/item/circuitboard/machine/coffeemaker/standard
	board_name = "Кофемашина \"Моделло 3\""
	build_path = /obj/machinery/coffeemaker/standard
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=2;magnets=2"
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1,
	)

/obj/item/circuitboard/machine/coffeemaker/impressa
	board_name = "Кофемашина \"Импресса Моделло 5\""
	build_path = /obj/machinery/coffeemaker/impressa
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	origin_tech = "programming=3;magnets=3"
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor/adv = 1,
		/obj/item/stock_parts/micro_laser/high = 2,
	)
