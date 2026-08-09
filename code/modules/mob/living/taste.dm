/mob/living/proc/get_taste_sensitivity()
	return TASTE_SENSITIVITY_NORMAL

/mob/living/carbon/human/get_taste_sensitivity()
	if(dna.species)
		return dna.species.taste_sensitivity
	else
		return TASTE_SENSITIVITY_NORMAL

/**
 * Non-destructively tastes a reagent container
 * and gives feedback to the user.
 * Arguments:
 * * datum/reagents/from - Reagent holder to taste from.
 **/
/mob/living/proc/taste_container(datum/reagents/from)
	if(check_tasting_blocks())
		return

	var/taste_sensitivity = get_taste_sensitivity()
	var/text_output = from.generate_taste_message(src, taste_sensitivity)
	send_taste_message(text_output)

/**
 * Non-destructively tastes a reagent list
 * and gives feedback to the user.
 * Arguments:
 * * list/from - List of reagents to taste from.
 **/
/mob/living/proc/taste_list(list/from)
	if(check_tasting_blocks())
		return

	var/taste_sensitivity = get_taste_sensitivity()
	var/text_output = generate_reagents_taste_message(from, src, taste_sensitivity)
	send_taste_message(text_output)

/**
 * Check for anything blocking/overriding our tasting.
 * Returns TRUE on a block, FALSE if not.
 **/
/mob/living/proc/check_tasting_blocks()
	if(last_taste_time + 50 >= world.time)
		return TRUE

	// Sometimes, try send a replacement message if we're hallucinating
	if(AmountHallucinate() > 50 SECONDS && prob(25))
		var/text_output = pick("пауков","мечты","кошмаров","будущего","прошлого","победы",\
			"поражения","боли","блаженства","мести","яда","времени","космоса","смерти","жизни","правды","лжи","справедливости","воспоминаний",\
			"сожалений","души","страданий","музыки","шума","крови","голода")
		send_taste_message(text_output)
		return TRUE

	return FALSE

/**
 * Attempt to send a taste message using given tastes text.
 **/
/mob/living/proc/send_taste_message(tastes_text)
	if(tastes_text == last_taste_text && last_taste_time + 100 >= world.time)
		return

	to_chat(src, span_notice("Вы чувствуете вкус [tastes_text]."))

	last_taste_time = world.time
	last_taste_text = tastes_text
