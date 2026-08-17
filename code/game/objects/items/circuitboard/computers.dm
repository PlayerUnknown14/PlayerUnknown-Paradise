// MARK: Generic
/obj/item/circuitboard/computer/pod
	board_name = "Massdriver Control"
	build_path = /obj/machinery/computer/pod

/obj/item/circuitboard/computer/pod/deathsquad
	board_name = "Deathsquad Massdriver Control"
	build_path = /obj/machinery/computer/pod/deathsquad

/obj/item/circuitboard/computer/arcade
	origin_tech = "programming=1"

/obj/item/circuitboard/computer/arcade/battle
	board_name = "Arcade Battle"
	build_path = /obj/machinery/computer/arcade/battle

/obj/item/circuitboard/computer/arcade/orion_trail
	board_name = "Orion Trail"
	build_path = /obj/machinery/computer/arcade/orion_trail

/obj/item/circuitboard/computer/arcade/slotmachine
	board_name = "Slotmachine"
	build_path = /obj/machinery/computer/slot_machine

/obj/item/circuitboard/computer/olddoor
	board_name = "DoorMex"
	build_path = /obj/machinery/computer/pod/old

/obj/item/circuitboard/computer/syndicatedoor
	board_name = "ProComp Executive"
	build_path = /obj/machinery/computer/pod/old/syndicate

/obj/item/circuitboard/computer/swfdoor
	board_name = "Magix"
	build_path = /obj/machinery/computer/pod/old/swf

// MARK: Command
/obj/item/circuitboard/computer/aiupload
	board_name = "AI Upload"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/aiupload
	origin_tech = "programming=4;engineering=4"

/obj/item/circuitboard/computer/borgupload
	board_name = "Cyborg Upload"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/aiupload/cyborg
	origin_tech = "programming=4;engineering=4"

/obj/item/circuitboard/computer/communications
	board_name = "Communications Console"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/communications
	origin_tech = "programming=3;magnets=3"

/obj/item/circuitboard/computer/card
	board_name = "ID Computer"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/card
	origin_tech = "programming=3"

/obj/item/circuitboard/computer/card/minor
	board_name = "Dept ID Computer"
	build_path = /obj/machinery/computer/card/minor
	var/target_dept = TARGET_DEPT_GENERIC

/obj/item/circuitboard/computer/card/minor/hos
	board_name = "Sec ID Computer"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/card/minor/hos
	target_dept = TARGET_DEPT_SEC

/obj/item/circuitboard/computer/card/minor/cmo
	board_name = "Medical ID Computer"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/card/minor/cmo
	target_dept = TARGET_DEPT_MED

/obj/item/circuitboard/computer/card/minor/qm
	board_name = "Supply ID Computer"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/card/minor/qm
	target_dept = TARGET_DEPT_SUP

/obj/item/circuitboard/computer/card/minor/rd
	board_name = "Science ID Computer"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/card/minor/rd
	target_dept = TARGET_DEPT_SCI

/obj/item/circuitboard/computer/card/minor/ce
	board_name = "Engineering ID Computer"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/card/minor/ce
	target_dept = TARGET_DEPT_ENG

/obj/item/circuitboard/computer/card/centcom
	board_name = "CentComm ID Computer"
	build_path = /obj/machinery/computer/card/centcom

/obj/item/circuitboard/computer/addition_goals
	board_name = "addition goals console"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/addition_goals
	origin_tech = "engineering=2;combat=2;bluespace=2"

/obj/item/circuitboard/computer/bsa_control
	board_name = "Bluespace Artillery Controls"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/bsa_control
	origin_tech = "engineering=2;combat=2;bluespace=2"

/obj/item/circuitboard/computer/sat_control
	board_name = "Контроллер сети спутников"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/sat_control
	origin_tech = "engineering=3"

// MARK: Medical
/obj/item/circuitboard/computer/med_data
	board_name = "Medical Records"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/med_data
	origin_tech = "programming=2;biotech=2"

/obj/item/circuitboard/computer/pandemic
	board_name = "PanD.E.M.I.C. 2200"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/pandemic
	origin_tech = "programming=2;biotech=2"

/obj/item/circuitboard/computer/cloning
	board_name = "Biomass Pod Console"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/cloning
	origin_tech = "programming=2;biotech=2"

/obj/item/circuitboard/computer/crew
	board_name = "Crew Monitoring Computer"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/crew
	origin_tech = "programming=2;biotech=2"

/obj/item/circuitboard/computer/operating
	board_name = "Operating Computer"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/operating
	origin_tech = "programming=2;biotech=3"

// MARK: Science
/obj/item/circuitboard/computer/scan_consolenew
	board_name = "DNA Machine"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/scan_consolenew
	origin_tech = "programming=2;biotech=2"

/obj/item/circuitboard/computer/teleporter
	board_name = "Teleporter Console"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/teleporter
	origin_tech = "programming=3;bluespace=3;plasmatech=3"

/obj/item/circuitboard/computer/robotics
	board_name = "Robotics Control Console"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/robotics
	origin_tech = "programming=3"

// RD console circuits, so that de/reconstructing one of the special consoles doesn't ruin everything forever
/obj/item/circuitboard/computer/rdconsole
	board_name = "RD Console"
	desc = "Swipe a Scientist level ID or higher to reconfigure."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/rdconsole/core
	req_access = list(ACCESS_TOX) // This is for adjusting the type of computer we're building - in case something messes up the pre-existing robotics or mechanics consoles
	var/list/access_types = list("R&D Core", "Robotics", "E.X.P.E.R.I-MENTOR", "Mechanics", "Public", "Cargo")

/obj/item/circuitboard/computer/rdconsole/attackby(obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(I.GetID() || is_pda(I))
		add_fingerprint(user)
		if(!allowed(user))
			to_chat(user, span_warning("Access Denied"))
			return ATTACK_CHAIN_PROCEED
		user.visible_message(
			span_notice("[user] waves [user.p_their()] ID past [src]'s access protocol scanner."),
			span_notice("You swipe your ID past [src]'s access protocol scanner."),
		)
		var/console_choice = tgui_input_list(user, "What do you want to configure the access to?", "Access Modification", access_types)
		if(!console_choice || !Adjacent(user) || QDELETED(I) || I.loc != user)
			return ATTACK_CHAIN_BLOCKED_ALL
		switch(console_choice)
			if("R&D Core")
				board_name = "RD Console"
				build_path = /obj/machinery/computer/rdconsole/core
			if("Robotics")
				board_name = "RD Console - Robotics"
				build_path = /obj/machinery/computer/rdconsole/robotics
			if("E.X.P.E.R.I-MENTOR")
				board_name = "RD Console - E.X.P.E.R.I-MENTOR"
				build_path = /obj/machinery/computer/rdconsole/experiment
			if("Mechanics")
				board_name = "RD Console - Mechanics"
				build_path = /obj/machinery/computer/rdconsole/mechanics
			if("Public")
				board_name = "RD Console - Public"
				build_path = /obj/machinery/computer/rdconsole/public
			if("Cargo")
				board_name = "RD Console - Cargo"
				build_path = /obj/machinery/computer/rdconsole/cargo
		format_board_name()
		to_chat(user, span_notice("Access protocols set to '[console_choice]'."))
		return ATTACK_CHAIN_PROCEED_SUCCESS

	return ..()

/obj/item/circuitboard/computer/rdconsole/robotics
	board_name = "RD Console - Robotics"
	build_path = /obj/machinery/computer/rdconsole/robotics

/obj/item/circuitboard/computer/rdconsole/experiment
	board_name = "RD Console - E.X.P.E.R.I-MENTOR"
	build_path = /obj/machinery/computer/rdconsole/experiment

/obj/item/circuitboard/computer/rdconsole/mechanics
	board_name = "RD Console - Mechanics"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/rdconsole/mechanics

/obj/item/circuitboard/computer/rdconsole/public
	board_name = "RD Console - Public"
	build_path = /obj/machinery/computer/rdconsole/public

/obj/item/circuitboard/computer/rdconsole/cargo
	board_name = "RD Console - Cargo"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/rdconsole/cargo

/obj/item/circuitboard/computer/roboquest
	board_name = "Robotics Request Console"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/roboquest

/obj/item/circuitboard/computer/mecha_control
	board_name = "Exosuit Control Console"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/mecha

/obj/item/circuitboard/computer/rdservercontrol
	board_name = "RD Server Control"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/rdservercontrol

/obj/item/circuitboard/computer/mech_bay_power_console
	board_name = "Mech Bay Power Control Console"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/mech_bay_power_console
	origin_tech = "programming=3;powerstorage=3"

/obj/item/circuitboard/computer/telesci_console
	board_name = "Telepad Control Console"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/telescience
	origin_tech = "programming=3;bluespace=3;plasmatech=4"

// MARK: Security
/obj/item/circuitboard/computer/secure_data
	board_name = "Security Records"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/secure_data
	origin_tech = "programming=2;combat=2"

/obj/item/circuitboard/computer/prisoner
	board_name = "Prisoner Management"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/prisoner

/obj/item/circuitboard/computer/brigcells
	board_name = "Brig Cell Control"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/brigcells

/obj/item/circuitboard/computer/labor_shuttle
	board_name = "Labor Shuttle"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/shuttle/labor

/obj/item/circuitboard/computer/labor_shuttle/one_way
	board_name = "Prisoner Shuttle Console"
	build_path = /obj/machinery/computer/shuttle/labor/one_way

// MARK: Engineering
/obj/item/circuitboard/computer/stationalert
	board_name = "Station Alert Console - Engineering"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/station_alert

/obj/item/circuitboard/computer/atmos_alert
	board_name = "Atmospheric Alert Computer"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/circuitboard/computer/atmoscontrol
	board_name = "Central Atmospherics Computer"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/atmoscontrol

/obj/item/circuitboard/computer/air_management
	board_name = "Atmospheric Monitor"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/general_air_control

/obj/item/circuitboard/computer/injector_control
	board_name = "Injector Control"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/general_air_control/fuel_injection

/obj/item/circuitboard/computer/drone_control
	board_name = "Drone Control"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/drone_control
	origin_tech = "programming=3"

/obj/item/circuitboard/computer/message_monitor
	board_name = "Message Monitor"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/message_monitor

/obj/item/circuitboard/computer/powermonitor
	board_name = "Power Monitor"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/monitor
	origin_tech = "programming=2;powerstorage=2"

/obj/item/circuitboard/computer/powermonitor/secret
	board_name = "Outdated Power Monitor"
	build_path = /obj/machinery/computer/monitor/secret

/obj/item/circuitboard/computer/sm_monitor
	board_name = "Supermatter Monitoring Console"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/sm_monitor
	origin_tech = "programming=2;powerstorage=2"

/obj/item/circuitboard/computer/fission_monitor
	board_name = "NGCR Monitoring Console"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/fission_monitor
	origin_tech = "programming=2;powerstorage=2"

/obj/item/circuitboard/computer/solar_control
	board_name = "Solar Control"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/solar_control
	origin_tech = "programming=2;powerstorage=2"
	
// MARK: Supply
/obj/item/circuitboard/computer/ordercomp
	board_name = "Supply Ordering Console"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/supplycomp/public
	origin_tech = "programming=3"

/obj/item/circuitboard/computer/supplycomp
	board_name = "Supply Shuttle Console"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/supplycomp
	origin_tech = "programming=3"
	var/contraband_enabled = 0

/obj/item/circuitboard/computer/supplycomp/multitool_act(mob/living/user, obj/item/I)
	. = TRUE
	var/catastasis // Why is it called this
	var/opposite_catastasis
	if(contraband_enabled)
		catastasis = "BROAD"
		opposite_catastasis = "STANDARD"
	else
		catastasis = "STANDARD"
		opposite_catastasis = "BROAD"

	var/choice = tgui_alert(user, "Current receiver spectrum is set to: [catastasis]", "Multitool-Circuitboard interface", list("Switch to [opposite_catastasis]", "Cancel"))
	if(!choice || choice == "Cancel")
		return

	contraband_enabled = !contraband_enabled
	playsound(src, 'sound/effects/pop.ogg', 50)

/obj/item/circuitboard/computer/supplyquest
	board_name = "Supply Quest Console"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/supplyquest
	origin_tech = "programming=3"

/obj/item/circuitboard/computer/questcons
	board_name = "Supply Quest Monitor"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/supplyquest/workers
	origin_tech = "programming=3"

/obj/item/circuitboard/computer/syndicatesupplycomp
	board_name = "Syndicate Supply Pad Console"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/syndie_supplycomp
	origin_tech = "programming=3;syndicate=3"

/obj/item/circuitboard/computer/syndicatesupplycomp/public
	board_name = "Syndicate Public Supply Pad Console"
	build_path = /obj/machinery/computer/syndie_supplycomp/public

/obj/item/circuitboard/computer/syndicate_teleporter
	board_name = "Syndicate Redspace Teleporter"
	icon_state = "syndicate_circuit"
	greyscale_config = null
	build_path = /obj/machinery/computer/syndicate_depot/teleporter/taipan
	origin_tech = "programming=6;bluespace=5;syndicate=8"



/obj/item/circuitboard/computer/shuttle
	board_name = "Shuttle"
	build_path = /obj/machinery/computer/shuttle
	var/shuttleId
	var/possible_destinations = ""



/obj/item/circuitboard/computer/ferry
	board_name = "Transport Ferry"
	build_path = /obj/machinery/computer/shuttle/ferry

/obj/item/circuitboard/computer/ferry/request
	board_name = "Transport Ferry Console"
	build_path = /obj/machinery/computer/shuttle/ferry/request

/obj/item/circuitboard/computer/mining_shuttle
	board_name = "Mining Shuttle"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/shuttle/mining

/obj/item/circuitboard/computer/ruins_transport_shuttle
	board_name = "Transport Shuttle"
	build_path = /obj/machinery/computer/shuttle/ruins_transport_shuttle

/obj/item/circuitboard/computer/ruins_civil_shuttle
	board_name = "Regular Civilian Shuttle"
	build_path = /obj/machinery/computer/shuttle/ruins_civil_shuttle

/obj/item/circuitboard/computer/white_ship
	board_name = "White Ship"
	build_path = /obj/machinery/computer/shuttle/white_ship

/obj/item/circuitboard/computer/shuttle/syndicate
	board_name = "Syndicate Shuttle"
	build_path = /obj/machinery/computer/shuttle/syndicate

/obj/item/circuitboard/computer/shuttle/syndicate/recall
	board_name = "Syndicate Shuttle Recall Terminal"
	build_path = /obj/machinery/computer/shuttle/syndicate/recall

/obj/item/circuitboard/computer/shuttle/syndicate/drop_pod
	board_name = "Syndicate Drop Pod"
	build_path = /obj/machinery/computer/shuttle/syndicate/drop_pod

/obj/item/circuitboard/computer/shuttle/nt/drop_pod
	board_name = "Nanotrasen Drop Pod"
	build_path = /obj/machinery/computer/shuttle/nt/drop_pod

/obj/item/circuitboard/computer/shuttle/golem_ship
	board_name = "Golem Ship"
	build_path = /obj/machinery/computer/shuttle/golem_ship

/obj/item/circuitboard/computer/HolodeckControl
	board_name = "Holodeck Control"
	build_path = /obj/machinery/computer/HolodeckControl
	origin_tech = "programming=4"

/obj/item/circuitboard/computer/large_tank_control
	board_name = "Atmospheric Tank Control"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/general_air_control/large_tank_control
	origin_tech = "programming=2;engineering=3;materials=2"

/obj/item/circuitboard/computer/turbine_computer
	board_name = "Turbine Computer"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/turbine_computer
	origin_tech = "programming=4;engineering=4;powerstorage=4"

// MARK: Service
/obj/item/circuitboard/computer/portrait_printer
	board_name = "Portrait Printer"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/computer/portrait_printer

/obj/item/circuitboard/computer/skill_manuals
	board_name = "skill manuals console"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/computer/skill_manuals
	origin_tech = "engineering=2;bluespace=3;programming=2"

// MARK: Basic Camera
/obj/item/circuitboard/computer/camera
	board_name = "Camera Monitor"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/security
	origin_tech = "programming=2;combat=2"

/obj/item/circuitboard/computer/camera/wooden_tv
	board_name = "Wooden TV"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/computer/security/wooden_tv

/obj/item/circuitboard/computer/camera/mining
	board_name = "Outpost Camera Monitor"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/security/mining

/obj/item/circuitboard/computer/camera/engineering
	board_name = "Engineering Camera Monitor"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/security/engineering

// MARK: Telescreens
/obj/item/circuitboard/computer/camera/telescreen
	board_name = "Telescreen"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/security/telescreen

/obj/item/circuitboard/computer/camera/telescreen/singularity
	board_name = "Telescreen_Singularity"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/security/telescreen/singularity

/obj/item/circuitboard/computer/camera/telescreen/nfr
	board_name = "Telescreen_NFR"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/security/telescreen/nfr

/obj/item/circuitboard/computer/camera/telescreen/toxin_chamber
	board_name = "Toxins Telescreen"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/security/telescreen/toxin_chamber

/obj/item/circuitboard/computer/camera/telescreen/test_chamber
	board_name = "Test Chamber Telescreen"
	build_path = /obj/machinery/computer/security/telescreen/test_chamber

/obj/item/circuitboard/computer/camera/telescreen/research
	board_name = "Research Monitor"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/security/telescreen/research

/obj/item/circuitboard/computer/camera/telescreen/prison
	board_name = "Prison Monitor"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/security/telescreen/prison

/obj/item/circuitboard/computer/camera/telescreen/entertainment
	board_name = "Entertainment Monitor"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/computer/security/telescreen/entertainment

// MARK: Advanced Cameras
/obj/item/circuitboard/xenobiology
	board_name = "Xenobiology Console"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/camera_advanced/xenobio
	origin_tech = "programming=3;biotech=3"

// MARK: Misc
/obj/item/circuitboard/computer/HONKputer
	board_name = "HONKputer"
	build_path = /obj/machinery/computer/HONKputer
	icon = 'icons/obj/machines/HONKputer.dmi'
	icon_state = "bananium_board"
	greyscale_config = null

/obj/item/circuitboard/aicore
	board_name = "AI Core"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	origin_tech = "programming=3"

/obj/item/circuitboard/merch
	board_name = "Merchandise Computer"
	build_path = /obj/machinery/computer/merch

/obj/item/circuitboard/aifixer
	board_name = "AI Integrity Restorer"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/aifixer
	origin_tech = "programming=2;biotech=2"
