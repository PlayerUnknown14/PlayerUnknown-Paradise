#define RNGCHEM_INPUT "input"
#define RNGCHEM_CATALYSTS "catalysts"

#define VALID_RANDOM_RECIPE_REAGENT(chemical_flags) (chemical_flags & REAGENT_CAN_BE_SYNTHESIZED && !(chemical_flags & REAGENT_NO_RANDOM_RECIPE))

/datum/chemical_reaction/randomized
	abstract_type = /datum/chemical_reaction/randomized

	//Increase default leniency because these are already hard enough
	optimal_ph_min = 1
	optimal_ph_max = 13
	temp_exponent_factor = 0
	ph_exponent_factor = 1
	H_ion_release = 0

	//Will reset every x days
	var/persistence_period = 7
	///creation timestamp
	var/created
	///How much the range can deviate, and also affects impure range
	var/suboptimal_range_ph = 3
	///Minimum required temperature for random range
	var/min_temp = 1
	///Maximum required temperature for random range
	var/max_temp = 600
	///Minimum random volume of input reagent
	var/min_input_reagent_amount = 1
	///Maximum random volume of input reagent
	var/max_input_reagent_amount = 10
	///Minimum number of random required reagents to select from GetPossibleReagents(RNGCHEM_INPUT)
	var/min_input_reagents = 2
	///Maximum number of random reagents to select from GetPossibleReagents(RNGCHEM_INPUT)
	var/max_input_reagents = 5
	///Minimum number of random catalyst reagents to select from GetPossibleReagents(RNGCHEM_CATALYST)
	var/min_catalysts = 0
	///Maximum number of random catalyst reagents to select from GetPossibleReagents(RNGCHEM_CATALYST)
	var/max_catalysts = 2
	///Random list of posible containers to select
	var/list/possible_containers

/datum/chemical_reaction/randomized/New(recipe_data)
	. = ..()

	if(!recipe_data || !load_recipe(recipe_data))
		log_game("Generating recipe for [src]")
		if(!generate_recipe())
			log_game("Couldn't generate recipe for [src]")
			qdel(src)


/datum/chemical_reaction/randomized/proc/load_recipe(recipe_data)
	PRIVATE_PROC(TRUE)
	// Timestamp
	created = text2num(recipe_data["timestamp"])
	if(daysSince(created) > persistence_period)
		log_game("Recipe [src] expired.")
		return FALSE
	//ingredients and catalysts
	required_reagents = unwrap_reagent_list(recipe_data["required_reagents"])
	if(!required_reagents)
		log_game("Couldn't load reagents for [src]")
		return FALSE
	required_catalysts = unwrap_reagent_list(recipe_data["required_catalysts"])
	if(!required_catalysts)
		log_game("Couldn't load catalysts for [src]")
		return FALSE

	//container
	if(possible_containers)
		var/container = recipe_data["required_container"] ? text2path(recipe_data["required_container"]) : null
		if(!container)
			log_game("Couldn't load container for [src]")
			return FALSE
		required_container = container

	//temperature
	is_cold_recipe = recipe_data["is_cold_recipe"]
	required_temp = recipe_data["required_temp"]
	optimal_temp = recipe_data["optimal_temp"]
	overheat_temp = recipe_data["overheat_temp"]
	thermic_constant = recipe_data["thermic_constant"]

	//pH
	optimal_ph_min = recipe_data["optimal_ph_min"]
	optimal_ph_max = recipe_data["optimal_ph_max"]
	determin_ph_range = recipe_data["determin_ph_range"]
	H_ion_release = recipe_data["H_ion_release"]

	//purity
	purity_min = recipe_data["purity_min"]

	return TRUE

/datum/chemical_reaction/randomized/proc/generate_recipe()
	// Timestamp
	created = world.realtime

	// Reagents and catalysts
	var/list/remaining_possible_reagents = GetPossibleReagents(RNGCHEM_INPUT)
	var/list/remaining_possible_catalysts = GetPossibleReagents(RNGCHEM_CATALYSTS)
	//We're going to assume we're not doing any weird partial reactions for now.
	for(var/reagent_type in results)
		remaining_possible_catalysts -= reagent_type
		remaining_possible_reagents -= reagent_type

	if(remaining_possible_reagents.len < min_input_reagents)
		log_game("Couldn't find enough reagents for [src]")
		return FALSE

	required_reagents = list()
	var/in_reagent_count = min(rand(min_input_reagents, max_input_reagents),remaining_possible_reagents.len)
	for(var/i in 1 to in_reagent_count)
		var/r_id = pick_n_take(remaining_possible_reagents)
		required_reagents[r_id] = rand(min_input_reagent_amount,max_input_reagent_amount)
		remaining_possible_catalysts -= r_id //Can't have same reagents both as catalyst and reagent. Or can we ?

	if(remaining_possible_catalysts.len < min_catalysts)
		log_game("Couldn't find enough catalysts for [src]")
		return FALSE

	required_catalysts = list()
	var/in_catalyst_count = min(rand(min_catalysts,max_catalysts),remaining_possible_catalysts.len)
	for(var/i in 1 to in_catalyst_count)
		required_catalysts[pick_n_take(remaining_possible_catalysts)] = rand(min_input_reagent_amount,max_input_reagent_amount)

	// Container
	if(possible_containers)
		required_container = pick(possible_containers)
	// Temperature
	is_cold_recipe = pick(TRUE, FALSE)
	if(is_cold_recipe)
		required_temp = rand(min_temp + 50, max_temp)
		optimal_temp = rand(min_temp + 25, required_temp - 10)
		overheat_temp = rand(min_temp, optimal_temp - 10)
		if(overheat_temp >= 200) //Otherwise it can disappear when you're mixing and I don't want this to happen here
			overheat_temp = 200
	else
		required_temp = rand(min_temp, max_temp - 50)
		optimal_temp = rand(required_temp + 10, max_temp - 25)
		overheat_temp = rand(optimal_temp, max_temp + 50)
		if(overheat_temp <= 400)
			overheat_temp = 400

	//pH
	optimal_ph_min = CHEMICAL_MIN_PH + rand(0, suboptimal_range_ph)
	optimal_ph_max = max((CHEMICAL_MAX_PH - rand(0, suboptimal_range_ph)), (optimal_ph_min + 1)) //Always ensure we've a window of 1
	determin_ph_range = suboptimal_range_ph
	H_ion_release = (rand(0, 25) / 100)// 0 - 0.25

	// Purity
	purity_min = (rand(0, 4) / 10)
	return TRUE

/**
 * Returns the reagents to select for randomizing
 * Arguments
 *
 * * kind - see above defines
*/
/datum/chemical_reaction/randomized/proc/GetPossibleReagents(kind)
	PROTECTED_PROC(TRUE)

	return list()

/**
 * Converts a list of text reagent paths into actual reagents
 * Arguments
 *
 * * list/textreagents - the list reagents
*/
/datum/chemical_reaction/randomized/proc/unwrap_reagent_list(list/textreagents)
	PRIVATE_PROC(TRUE)

	. = list()
	for(var/R in textreagents)
		var/pathR = text2path(R)
		if(!pathR)
			return null
		.[pathR] = textreagents[R]

#undef RNGCHEM_INPUT
#undef RNGCHEM_CATALYSTS
#undef VALID_RANDOM_RECIPE_REAGENT
