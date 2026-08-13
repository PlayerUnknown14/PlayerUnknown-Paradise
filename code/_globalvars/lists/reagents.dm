///Maximum number of times to register a randomized reaction before giving up when collisions happen
#define MAX_RANDOMIZED_REACTION_RETRY_ATTEMPTS 5

// Base chemicals
GLOBAL_LIST_INIT(base_chemicals, list("water","oxygen","nitrogen","hydrogen","potassium","mercury","carbon",
							"chlorine","fluorine","phosphorus","lithium","sulfur","sacid","radium",
							"iron","aluminum","silicon","sugar","ethanol"))
// Standard chemicals
GLOBAL_LIST_INIT(standard_chemicals, list("slimejelly","blood","water","lube","charcoal","toxin","cyanide",
								"morphine","syntmorphine","epinephrine","space_drugs","oxygen","copper",
								"nitrogen","hydrogen","potassium","mercury","sulfur","carbon","chlorine",
								"fluorine","sodium","phosphorus","lithium","sugar","sacid","facid",
								"glycerol","radium","mutadone","thermite","mutagen","virusfood","iron",
								"gold","silver","uranium","aluminum","silicon","fuel","cleaner","atrazine",
								"plasma","teporone","lexorin","silver_sulfadiazine","salbutamol",
								"perfluorodecalin","omnizine","synaptizine","haloperidol","potass_iodide",
								"pen_acid","mannitol","oculine","styptic_powder","methamphetamine",
								"cryoxadone","spaceacillin","carpotoxin","lsd","fluorosurfactant",
								"fluorosurfactant","ethanol","ammonia","diethylamine","antihol","pancuronium",
								"lipolicide","condensedcapsaicin","frostoil","amanitin","psilocybin",
								"enzyme","nothing","salglu_solution","antifreeze","neurotoxin", "jestosterone"))
// Rare chemicals
GLOBAL_LIST_INIT(rare_chemicals, list("minttoxin","syndicate_nanites", "xenomicrobes"))
// Standard medicines
GLOBAL_LIST_INIT(standard_medicines, list("charcoal","toxin","cyanide","morphine","syntmorphine","epinephrine","space_drugs",
								"mutadone","mutagen","teporone","lexorin","silver_sulfadiazine",
								"salbutamol","perfluorodecalin", "cryoxadone","omnizine","synaptizine","haloperidol",
								"potass_iodide","pen_acid","mannitol","oculine","styptic_powder",
								"methamphetamine","spaceacillin","carpotoxin","lsd","ethanol","ammonia",
								"diethylamine","antihol","pancuronium","lipolicide","condensedcapsaicin",
								"frostoil","amanitin","psilocybin","nothing","salglu_solution","neurotoxin"))
// Rare medicines
GLOBAL_LIST_INIT(rare_medicines, list("syndicate_nanites","minttoxin","blood", "xenomicrobes"))
// Drinks
GLOBAL_LIST_INIT(drinks, subtypesof(/datum/reagent/consumable/drink/)\
						+ subtypesof(/datum/reagent/consumable/ethanol)\
						+ /datum/reagent/consumable/ethanol)

//Liver Toxins list
GLOBAL_LIST_INIT(liver_toxins, list("toxin", "plasma", "sacid", "facid", "cyanide","amanitin", "carpotoxin"))

//Random chem blacklist
GLOBAL_LIST_INIT(blocked_chems, list( \
	"polonium", "initropidril", "concentrated_initro",
	"sodium_thiopental", "ketamine", "coniine",
	"adminordrazine", "nanites", "hellwater", "beer2",
	"mutationtoxin", "amutationtoxin", "venom",
	"spore", "stimulants", "stimulative_agent",
	"syndicate_nanites", "ripping_tendrils", "boiling_oil",
	"envenomed_filaments", "lexorin_jelly", "kinetic",
	"cryogenic_liquid", "dark_matter", "b_sorium",
	"reagent", "life","dragonsbreath", "nanocalcium", "bungotoxin", "fruit_wine",
))

GLOBAL_LIST_INIT(safe_chem_list, list( \
	"antihol", "charcoal", "epinephrine", "insulin", "teporone","silver_sulfadiazine", "salbutamol",
	"omnizine", "stimulants", "synaptizine", "potass_iodide", "oculine", "mannitol", "styptic_powder",
	"spaceacillin", "salglu_solution", "sal_acid", "synthflesh", "hydrocodone",
	"mitocholide", "rezadone"
))

GLOBAL_LIST_INIT(safe_chem_applicator_list, list("silver_sulfadiazine", "styptic_powder", "synthflesh"))

GLOBAL_LIST_INIT(borer_reagents, list( \
	"charcoal", "epinephrine", "salbutamol", "mannitol", "capulettium_plus",
	"spaceacillin", "salglu_solution", "hydrocodone",
	"methamphetamine", "mitocholide", "fliptonium", "insulin"
))

GLOBAL_LIST_INIT(diseases_carrier_reagents, list(
			/datum/reagent/blood,
			/datum/reagent/slimejelly,
			/datum/reagent/medicine/cryoxadone,
))

//Pills & Patches
/// List of containers the Chem Master machine can print
GLOBAL_LIST_INIT(reagent_containers, list(
	CAT_CONDIMENTS = list(
		/obj/item/reagent_containers/food/condiment,
		/obj/item/reagent_containers/food/condiment/flour,
		/obj/item/reagent_containers/food/condiment/sugar,
		/obj/item/reagent_containers/food/condiment/rice,
		/obj/item/reagent_containers/food/condiment/milk,
		/obj/item/reagent_containers/food/condiment/soymilk,
		/obj/item/reagent_containers/food/condiment/saltshaker,
		/obj/item/reagent_containers/food/condiment/peppermill,
		/obj/item/reagent_containers/food/condiment/soysauce,
		/obj/item/reagent_containers/food/condiment/enzyme,
		/obj/item/reagent_containers/food/condiment/diablosauce,
		/obj/item/reagent_containers/food/condiment/pack,
	),
	CAT_TUBES = list(
		/obj/item/reagent_containers/glass/tube
	),
	CAT_PILLS = typecacheof(list(
		/obj/item/reagent_containers/food/pill
	)),
	CAT_PATCHES = typecacheof(list(
		/obj/item/reagent_containers/food/pill/patch
	)),
))

/// list of all /datum/chemical_reaction datums indexed by their typepath. Use this for general lookup stuff
GLOBAL_LIST(chemical_reactions_list)
/// list of all /datum/chemical_reaction datums. Used during chemical reactions. Indexed by REACTANT types
GLOBAL_LIST(chemical_reactions_list_reactant_index)
/// list of all /datum/chemical_reaction datums. Used for the reaction lookup UI. Indexed by PRODUCT type
GLOBAL_LIST(chemical_reactions_list_product_index)
/// list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
GLOBAL_LIST_INIT(chemical_reagents_list, init_chemical_reagent_list())
/// list of all reactions with their associated product and result ids. Used for reaction lookups
GLOBAL_LIST(chemical_reactions_results_lookup_list)
/// Map of reagent names to its datum path
GLOBAL_LIST_INIT(name2reagent, build_name2reagentlist())
/// List of all reagent side effects
GLOBAL_LIST_INIT(stacked_metabolization_effect, init_chemical_side_effects())

/// Initialises all /datum/reagent into a list indexed by reagent id
/proc/init_chemical_reagent_list()
	var/list/reagent_list = list()

	for(var/datum/reagent/path as anything in valid_subtypesof(/datum/reagent))
		var/datum/reagent/target_object = new path()
		target_object.mass = rand(10, 800)
		reagent_list[path] = target_object

	return reagent_list

/proc/check_recipe_for_conflicts(datum/chemical_reaction/reaction, list/reaction_lookup)
	for(var/x in reaction.required_reagents)
		for(var/datum/chemical_reaction/competitor in reaction_lookup[x])
			if(chem_recipes_do_conflict(competitor, reaction))
				return TRUE
	return FALSE

/**
 * Chemical Reactions - Initialises all /datum/chemical_reaction into a list
 * It is filtered into multiple lists within a list.
 * For example:
 * chemical_reactions_list_reactant_index[/datum/reagent/toxin/plasma] is a list of all reactions relating to plasma
 * For chemical reaction list product index - indexes reactions based off the product reagent type - see get_recipe_from_reagent_product() in helpers
 * For chemical reactions list lookup list - creates a bit list of info passed to the UI. This is saved to reduce lag from new windows opening, since it's a lot of data.
 */
/proc/build_chemical_reactions_lists()
	if(GLOB.chemical_reactions_list_reactant_index)
		return

	//Randomized need to go last since they need to check against conflicts with normal recipes
	var/paths = subtypesof(/datum/chemical_reaction) - typesof(/datum/chemical_reaction/randomized) + subtypesof(/datum/chemical_reaction/randomized)
	GLOB.chemical_reactions_list = list() //typepath to reaction list
	GLOB.chemical_reactions_list_reactant_index = list() //reagents to reaction list
	GLOB.chemical_reactions_results_lookup_list = list() //UI glob
	GLOB.chemical_reactions_list_product_index = list() //product to reaction list

	//Randomized recipes
	var/json_file = file("data/RandomizedChemRecipes.json")
	var/json
	if(fexists(json_file))
		json = json_decode(file2text(json_file))

	var/list/datum/chemical_reaction/reactions = list()
	for(var/datum/chemical_reaction/reaction as anything in paths)
		if(ispath(reaction, /datum/chemical_reaction/randomized))
			reaction = new reaction(LAZYACCESS(json, "[reaction]"))
		else
			reaction = new reaction
		if(!QDELETED(reaction)) // in case random recipe generation fail
			reactions += reaction
	// Ok so we're gonna do a thingTM here
	// I want to distribute all our reactions such that each reagent id links to as few as possible
	// I get the feeling there's a canonical way of doing this, but I don't know it
	// So instead, we're gonna wing it
	var/list/reagent_to_react_count = list()
	for(var/datum/chemical_reaction/reaction as anything in reactions)
		if(!istype(reaction, /datum/chemical_reaction/randomized))
			for(var/reagent_id in reaction.required_reagents)
				reagent_to_react_count[reagent_id] += 1

	var/list/reaction_lookup = GLOB.chemical_reactions_list_reactant_index
	// Create filters based on a random reagent id in the required reagents list - this is used to speed up handle_reactions()
	// Basically, we only really need to care about ONE reagent, at least when initially filtering, since any others are ignorable
	// Doing this separately because it relies on the loop above, and this is easier to parse
	for(var/datum/chemical_reaction/reaction as anything in reactions)
		//check for collisions
		if(istype(reaction, /datum/chemical_reaction/randomized))
			var/datum/chemical_reaction/randomized/random_reaction = reaction
			var/retry_attempts = 0
			while(check_recipe_for_conflicts(random_reaction, reaction_lookup))
				if(retry_attempts >= MAX_RANDOMIZED_REACTION_RETRY_ATTEMPTS || !random_reaction.generate_recipe())
					reactions -= reaction
					qdel(reaction)
					break
				retry_attempts++

			// log results
			if(QDELETED(reaction))
				log_game("Couldn't regenerate [reaction] due to conflicts in [retry_attempts] attempts.")
				continue
			else if(retry_attempts > 0)
				log_game("Regenerated [reaction] due to conflicts in [retry_attempts] attempts.")

		var/preferred_id = null
		for(var/reagent_id in reaction.required_reagents)
			if(isnull(preferred_id))
				preferred_id = reagent_id
				continue
			// If we would have less then they would, take it
			if(length(reaction_lookup[reagent_id]) < length(reaction_lookup[preferred_id]))
				preferred_id = reagent_id
				continue
			// If they potentially have more then us, we take it
			if(reagent_to_react_count[reagent_id] < reagent_to_react_count[preferred_id])
				preferred_id = reagent_id
				continue
		if (!isnull(preferred_id))
			if(!reaction_lookup[preferred_id])
				reaction_lookup[preferred_id] = list()
			reaction_lookup[preferred_id] += reaction

	for(var/datum/chemical_reaction/reaction as anything in reactions)
		var/list/product_ids = list()
		var/list/reagents = list()
		var/list/product_names = list()
		var/bitflags = reaction.reaction_tags

		if(!length(reaction.required_reagents)) //Skip impossible reactions
			continue

		GLOB.chemical_reactions_list[reaction.type] = reaction

		for(var/datum/reagent/reagent as anything in reaction.required_reagents)
			reagents += list(list("name" = reagent::name, "id" = reagent))

		for(var/datum/reagent/product as anything in reaction.results)
			product_names += product::name
			product_ids += product

		var/product_name
		if(!length(product_names))
			var/list/names = splittext("[reaction.type]", "/")
			product_name = names[names.len]
		else
			product_name = product_names[1]

		if(!istype(reaction, /datum/chemical_reaction/randomized))
			//Master list of ALL reactions that is used in the UI lookup table. This is expensive to make, and we don't want to lag the server by creating it on UI request, so it's cached to send to UIs instantly.
			GLOB.chemical_reactions_results_lookup_list += list(list(
				"name" = product_name,
				"id" = reaction.type,
				"bitflags" = bitflags,
				"reactants" = reagents,
			))

			// Create filters based on each reagent id in the required reagents list - this is specifically for finding reactions from product(reagent) ids/typepaths.
			for(var/id in product_ids)
				if(!GLOB.chemical_reactions_list_product_index[id])
					GLOB.chemical_reactions_list_product_index[id] = list()
				GLOB.chemical_reactions_list_product_index[id] += reaction

/// Builds map of reagent name to its datum path
/proc/build_name2reagentlist()
	. = list()

	//build map with keys stored separately
	var/list/name_to_reagent = list()
	var/list/only_names = list()
	for (var/datum/reagent/reagent as anything in GLOB.chemical_reagents_list)
		var/name = initial(reagent.name)
		if (length(name))
			name_to_reagent[name] = reagent
			only_names += name

	//sort keys
	only_names = sort_list(only_names)

	//build map with sorted keys
	for(var/name in only_names)
		.[name] = name_to_reagent[name]

/proc/init_chemical_side_effects()
	. = list()

	for(var/datum/stacked_metabolization_effect/effect as anything in valid_subtypesof(/datum/stacked_metabolization_effect))
		. += new effect()

#undef MAX_RANDOMIZED_REACTION_RETRY_ATTEMPTS
