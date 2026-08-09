/////////////////////////////////////////////
//////// Attach a trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////

/datum/effect_system/trail_follow
	var/turf/oldposition
	var/active = FALSE
	var/allow_overlap = FALSE
	var/auto_process = TRUE
	var/qdel_in_time = 1 SECONDS
	var/fadetype = "ion_fade"
	var/fade = TRUE
	var/nograv_required = FALSE

/datum/effect_system/trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/trail_follow/Destroy()
	oldposition = null
	stop()
	return ..()

/datum/effect_system/trail_follow/proc/stop()
	oldposition = null
	STOP_PROCESSING(SSfastprocess, src)
	active = FALSE
	return TRUE

/datum/effect_system/trail_follow/start()
	oldposition = get_turf(holder)
	if(!check_conditions())
		return FALSE
	if(auto_process)
		START_PROCESSING(SSfastprocess, src)
	active = TRUE
	return TRUE

/datum/effect_system/trail_follow/process()
	generate_effect()

/datum/effect_system/trail_follow/generate_effect()
	if(!check_conditions())
		return stop()
	if(oldposition && !(oldposition == get_turf(holder)) && (oldposition.no_gravity() || !nograv_required))
		var/obj/effect/new_effect = new effect_type(oldposition)
		set_dir(new_effect)
		if(fade && fadetype)
			flick(fadetype, new_effect)
			new_effect.icon_state = ""
		if(qdel_in_time)
			QDEL_IN(new_effect, qdel_in_time)
	oldposition = get_turf(holder)

/datum/effect_system/trail_follow/proc/set_dir(obj/effect/particle_effect/ion_trails/trails)
	trails.setDir(holder.dir)

/datum/effect_system/trail_follow/proc/check_conditions()
	if(!get_turf(holder))
		return FALSE
	return TRUE

/datum/effect_system/trail_follow/ion
	effect_type = /obj/effect/particle_effect/ion_trails
	nograv_required = TRUE
	qdel_in_time = 2 SECONDS

/datum/effect_system/trail_follow/ion/grav_allowed
	nograv_required = FALSE

/datum/effect_system/trail_follow/spacepod
	effect_type = /obj/effect/particle_effect/ion_trails
	nograv_required = TRUE
	qdel_in_time = 2 SECONDS

/datum/effect_system/trail_follow/spacepod/set_dir(obj/effect/particle_effect/ion_trails/trails1, obj/effect/particle_effect/ion_trails/trails2)
	trails1.setDir(holder.dir)
	trails2.setDir(holder.dir)

/datum/effect_system/trail_follow/spacepod/generate_effect()
	if(!check_conditions())
		return stop()
	if(oldposition && !(oldposition == get_turf(holder)) && (oldposition.no_gravity() || !nograv_required))
		// spacepod loc is always southwest corner of 4x4 space
		var/turf/our_turf = holder.loc
		var/loc1
		var/loc2
		switch(holder.dir)
			if(NORTH)
				loc1 = get_step(our_turf, SOUTH)
				loc2 = get_step(loc1, EAST)
			if(SOUTH) // More difficult, offset to the north!
				loc1 = get_step(get_step(our_turf, NORTH), NORTH)
				loc2 = get_step(loc1, EAST)
			if(EAST) // Just one to the north should suffice
				loc1 = get_step(our_turf , WEST)
				loc2 = get_step(loc1, NORTH)
			if(WEST) // One to the east and north from there
				loc1 = get_step(get_step(our_turf, EAST), EAST)
				loc2 = get_step(loc1, NORTH)
		var/obj/effect/effect1 = new effect_type(loc1)
		var/obj/effect/effect2 = new effect_type(loc2)
		set_dir(effect1, effect2)
		if(fade && fadetype)
			flick(fadetype, effect1)
			flick(fadetype, effect2)
			effect1.icon_state = ""
			effect2.icon_state = ""
		if(qdel_in_time)
			QDEL_IN(effect1, qdel_in_time)
			QDEL_IN(effect2, qdel_in_time)
	oldposition = get_turf(holder)

/obj/effect/particle_effect/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"

/obj/effect/particle_effect/ion_trails/flight
	icon_state = "ion_trails_flight"
