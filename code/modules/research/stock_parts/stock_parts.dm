//MARK: Basic Stock Part
/obj/item/stock_parts
	abstract_type = /obj/item/stock_parts
	name = "stock part"
	desc = "What?"
	gender = MALE
	icon = 'icons/obj/stock_parts.dmi'
	w_class = WEIGHT_CLASS_SMALL
	usesound = 'sound/items/deconstruct.ogg'
	pickup_sound = 'sound/items/handling/pickup/component_pickup.ogg'
	drop_sound = 'sound/items/handling/drop/component_drop.ogg'
	var/rating = 1
	/// Used when a base part has a different name to higher tiers of part. For example, machine frames want any servo and not just a micro-servo.
	var/base_name
	var/energy_rating = 1

/obj/item/stock_parts/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/item/stock_parts/get_part_rating()
	return rating

//MARK: Rank 1
/obj/item/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	origin_tech = "powerstorage=1"
	materials = list(MAT_METAL=50, MAT_GLASS=50)

/obj/item/stock_parts/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = "magnets=1"
	materials = list(MAT_METAL=50, MAT_GLASS=20)

/obj/item/stock_parts/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	origin_tech = "materials=1;programming=1"
	materials = list(MAT_METAL=30)

/obj/item/stock_parts/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	origin_tech = "magnets=1"
	materials = list(MAT_METAL=10, MAT_GLASS=20)

/obj/item/stock_parts/matter_bin
	name = "matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = "materials=1"
	materials = list(MAT_METAL=80)

//MARK: Rank 2
/obj/item/stock_parts/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	icon_state = "adv_capacitor"
	origin_tech = "powerstorage=3"
	rating = 2
	materials = list(MAT_METAL=50, MAT_GLASS=50)

/obj/item/stock_parts/scanning_module/adv
	name = "advanced scanning module"
	icon_state = "adv_scan_module"
	origin_tech = "magnets=3"
	rating = 2
	materials = list(MAT_METAL=50, MAT_GLASS=20)

/obj/item/stock_parts/manipulator/nano
	name = "nano-manipulator"
	icon_state = "nano_mani"
	origin_tech = "materials=3;programming=2"
	rating = 2
	materials = list(MAT_METAL=30)

/obj/item/stock_parts/micro_laser/high
	name = "high-power micro-laser"
	icon_state = "high_micro_laser"
	origin_tech = "magnets=3"
	rating = 2
	materials = list(MAT_METAL=10, MAT_GLASS=20)

/obj/item/stock_parts/matter_bin/adv
	name = "advanced matter bin"
	icon_state = "advanced_matter_bin"
	origin_tech = "materials=3"
	rating = 2
	materials = list(MAT_METAL=80)

//MARK: Rank 3
/obj/item/stock_parts/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "super_capacitor"
	origin_tech = "powerstorage=4;engineering=4"
	rating = 3
	materials = list(MAT_METAL=50, MAT_GLASS=50)

/obj/item/stock_parts/scanning_module/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	icon_state = "super_scan_module"
	origin_tech = "magnets=4;engineering=4"
	rating = 3
	materials = list(MAT_METAL=50, MAT_GLASS=20)

/obj/item/stock_parts/manipulator/pico
	name = "pico-manipulator"
	icon_state = "pico_mani"
	origin_tech = "materials=4;programming=4;engineering=4"
	rating = 3
	materials = list(MAT_METAL=30)

/obj/item/stock_parts/micro_laser/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	origin_tech = "magnets=4;engineering=4"
	rating = 3
	materials = list(MAT_METAL=10, MAT_GLASS=20)

/obj/item/stock_parts/matter_bin/super
	name = "super matter bin"
	icon_state = "super_matter_bin"
	origin_tech = "materials=4;engineering=4"
	rating = 3
	materials = list(MAT_METAL=80)

//MARK: Rank 4
/obj/item/stock_parts/capacitor/quadratic
	name = "quadratic capacitor"
	desc = "An capacity capacitor used in the construction of a variety of devices."
	icon_state = "quadratic_capacitor"
	origin_tech = "powerstorage=5;materials=4;engineering=4"
	rating = 4
	materials = list(MAT_METAL=50, MAT_GLASS=50)

/obj/item/stock_parts/scanning_module/triphasic
	name = "triphasic scanning module"
	desc = "A compact, ultra resolution triphasic scanning module used in the construction of certain devices."
	icon_state = "triphasic_scan_module"
	origin_tech = "magnets=5;materials=4;engineering=4"
	rating = 4
	materials = list(MAT_METAL=50, MAT_GLASS=20)

/obj/item/stock_parts/manipulator/femto
	name = "femto-manipulator"
	icon_state = "femto_mani"
	origin_tech = "materials=6;programming=4;engineering=4"
	rating = 4
	materials = list(MAT_METAL=30)

/obj/item/stock_parts/micro_laser/quadultra
	name = "quad-ultra micro-laser"
	icon_state = "quadultra_micro_laser"
	origin_tech = "magnets=5;materials=4;engineering=4"
	rating = 4
	materials = list(MAT_METAL=10, MAT_GLASS=20)

/obj/item/stock_parts/matter_bin/bluespace
	name = "bluespace matter bin"
	icon_state = "bluespace_matter_bin"
	origin_tech = "materials=6;programming=4;engineering=4"
	rating = 4
	materials = list(MAT_METAL=80)

//MARK: Rank 5
/obj/item/stock_parts/capacitor/purple
	name = "experimental capacitor"
	desc = "An capacity capacitor used in the construction of a variety of devices."
	icon_state = "ps_capacitor"
	origin_tech = "powerstorage=6;materials=5;engineering=5"
	rating = 5
	materials = list(MAT_METAL=50, MAT_GLASS=50)

/obj/item/stock_parts/scanning_module/purple
	name = "experimental scanning module"
	desc = "A compact, ultra resolution triphasic scanning module used in the construction of certain devices."
	icon_state = "ps_scan_module"
	origin_tech = "magnets=5;materials=5;engineering=5"
	rating = 5
	materials = list(MAT_METAL=50, MAT_GLASS=20)

/obj/item/stock_parts/manipulator/purple
	name = "experimental manipulator"
	icon_state = "ps_mani"
	origin_tech = "materials=6;programming=5;engineering=5"
	rating = 5
	materials = list(MAT_METAL=30)

/obj/item/stock_parts/micro_laser/purple
	name = "experimental micro-laser"
	icon_state = "ps_micro_laser"
	origin_tech = "magnets=6;materials=5;engineering=5"
	rating = 5
	materials = list(MAT_METAL=10, MAT_GLASS=20)

/obj/item/stock_parts/matter_bin/purple
	name = "experimental matter bin"
	icon_state = "ps_matter_bin"
	origin_tech = "materials=6;programming=5;engineering=5"
	rating = 5
	materials = list(MAT_METAL=80)

//MARK: Misc
/obj/item/research//Makes testing much less of a pain -Sieve
	name = "research"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "capacitor"
	desc = "A debug item for research."
	origin_tech = "materials=8;programming=8;magnets=8;powerstorage=8;bluespace=8;combat=8;biotech=8;syndicate=8;engineering=8;plasmatech=8;abductor=8;toxins=8"

/obj/item/stack/debug_resource //This also makes material filling less of a pain
	name = "resources"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "high_micro_laser"
	desc = "A debug item for filling protolathes or furnaces with all types of resources"
	materials = list(
		MAT_METAL=8000, MAT_GLASS=8000, MAT_SILVER=8000, MAT_GOLD=8000, MAT_DIAMOND=8000, MAT_URANIUM=8000,
		MAT_PLASMA=8000, MAT_BLUESPACE=8000, MAT_BANANIUM=8000, MAT_TRANQUILLITE=8000, MAT_TITANIUM=8000
	)
