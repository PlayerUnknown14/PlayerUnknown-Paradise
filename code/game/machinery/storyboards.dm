/obj/machinery/storyboard
	name = "NT storyboard"
	desc = "Высокий телевизионный экран. В верхней части находится лампа, излучающая слабый свет, а также пара колонок по бокам."
	ru_names = list(
		NOMINATIVE = "информационный стенд",
		GENITIVE = "информационного стенда",
		DATIVE = "информационному стенду",
		ACCUSATIVE = "информационный стенд",
		INSTRUMENTAL = "информационным стендом",
		PREPOSITIONAL = "информационном стенде"
	)
	icon = 'icons/obj/storyboards.dmi'
	icon_state = ""
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 500
	active_power_usage = 500
	max_integrity = 150
	integrity_failure = 100
	light_color = LIGHT_COLOR_DARKBLUE
	var/light_range_on = 3
	var/light_power_on = 1.5
	var/force_no_power_icon_state = FALSE


/obj/machinery/storyboard/Initialize(mapload)
	. = ..()
	power_change()
	update_icon()

/obj/machinery/storyboard/update_icon_state()
	if(stat & (BROKEN))
		icon_state = "broken"


/obj/machinery/storyboard/process()
	if(stat & (NOPOWER|BROKEN))
		return FALSE
	return TRUE

/obj/machinery/storyboard/extinguish_light(force = FALSE)
	if(light_on)
		set_light_on(FALSE)
		underlays.Cut()
		visible_message(span_danger("[capitalize(declent_ru(NOMINATIVE))] тускнеет, экран едва читаем."))

/obj/machinery/storyboard/power_change(forced = FALSE)
	. = ..()
	if((stat & (BROKEN|NOPOWER)))
		set_light_on(FALSE)
	else
		set_light(light_range_on, light_power_on, l_on = TRUE)
	if(.)
		update_icon()

/obj/machinery/storyboard/obj_break(damage_flag)
	if(!(stat & BROKEN))
		playsound(loc, 'sound/effects/glassbr3.ogg', 100, TRUE)
		stat |= BROKEN
		update_icon()
		set_light_on(FALSE)

/obj/machinery/storyboard/wrench_act(mob/user, obj/item/I)
	. = TRUE
	default_unfasten_wrench(user, I)

/obj/machinery/storyboard/emag_act(mob/user)
	if(!emagged)
		emagged = TRUE
		update_icon()
		if(user)
			balloon_alert(user, "емагнуто")
	else if(user)
		balloon_alert(user, " уже емагнуто!")


/obj/machinery/storyboard/y2246
	icon_state = "2246"

/obj/machinery/storyboard/y2262
	icon_state = "2262"

/obj/machinery/storyboard/y2367
	icon_state = "2367"

/obj/machinery/storyboard/y2425
	icon_state = "2425"

/obj/machinery/storyboard/y2512
	icon_state = "2512"
