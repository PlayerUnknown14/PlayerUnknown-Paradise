/obj/item/circuitboard/drone
	abstract_type = /obj/item/circuitboard/drone
	var/tech_to_give

/obj/item/circuitboard/drone/Initialize(mapload)
	. = ..()
	if(!tech_to_give)
		return
	origin_tech = "[tech_to_give]=[rand(3, 6)]"

/obj/item/circuitboard/drone/motherboard
	board_name = "Drone CPU motherboard"
	tech_to_give = "programming"

/obj/item/circuitboard/drone/interface
	board_name = "Drone neural interface"
	tech_to_give = "biotech"

/obj/item/circuitboard/drone/processor
	board_name = "Drone suspension processor"
	tech_to_give = "magnets"

/obj/item/circuitboard/drone/controller
	board_name = "Drone shielding controller"
	tech_to_give = "bluespace"

/obj/item/circuitboard/drone/capacitor
	board_name = "Drone power capacitor"
	tech_to_give = "powerstorage"

/obj/item/circuitboard/drone/reinforcer
	board_name = "Drone hull reinforcer"
	tech_to_give = "materials"

/obj/item/circuitboard/drone/system
	board_name = "Drone auto-repair system"
	tech_to_give = "engineering"

/obj/item/circuitboard/drone/counter
	board_name = "Drone plasma overcharge counter"
	tech_to_give = "plasmatech"

/obj/item/circuitboard/drone/targetting
	board_name = "Drone targetting circuitboard"
	tech_to_give = "combat"

/obj/item/circuitboard/drone/core
	board_name = "Corrupted drone morality core"
	tech_to_give = "syndicate"
