/*
 *	These absorb the functionality of the plant bag, ore satchel, etc.
 *	They use the use_to_pickup, quick_gather, and quick_empty functions
 *	that were already defined in weapon/storage, but which had been
 *	re-implemented in other classes.
 *
 *	Contains:
 *		Trash Bag
 *		Mining Satchel
 *		Plant Bag
 *		Sheet Snatcher
 *		Book Bag
 *		Tray
 *
 *	-Sayu
 */

//  Generic non-item
/obj/item/weapon/storage/bag
	allow_quick_gather = 1
	allow_quick_empty = 1
	display_contents_with_number = 0 // UNStABLE AS FuCK, turn on when it stops crashing clients
	use_to_pickup = 1
	slot_flags = SLOT_BELT

// -----------------------------
//          Trash bag
// -----------------------------
/obj/item/weapon/storage/bag/trash
	name = "trash bag"
	desc = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	icon = 'icons/obj/trash.dmi'
	icon_state = "trashbag0"
	item_state = "trashbag"

	w_class = 4
	max_w_class = 2
	storage_slots = 30
	can_hold = list() // any
	cant_hold = list("/obj/item/weapon/disk/nuclear","/obj/item/flag/nation")
	
/obj/item/weapon/storage/bag/trash/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] puts the [src.name] over their head and starts chomping at the insides! Disgusting!</span>")
	playsound(loc, 'sound/items/eatfood.ogg', 50, 1, -1)
	return (TOXLOSS)

/obj/item/weapon/storage/bag/trash/update_icon()
	if(contents.len == 0)
		icon_state = "trashbag0"
	else if(contents.len < 12)
		icon_state = "trashbag1"
	else if(contents.len < 21)
		icon_state = "trashbag2"
	else icon_state = "trashbag3"

/obj/item/weapon/storage/bag/trash/cyborg	
	
/obj/item/weapon/storage/bag/trash/proc/janicart_insert(mob/user, obj/structure/janitorialcart/J)
	J.put_in_cart(src, user)
	J.mybag=src
	J.update_icon()
	
/obj/item/weapon/storage/bag/trash/cyborg/janicart_insert(mob/user, obj/structure/janitorialcart/J)
	return


// -----------------------------
//        Plastic Bag
// -----------------------------

/obj/item/weapon/storage/bag/plasticbag
	name = "plastic bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/trash.dmi'
	icon_state = "plasticbag"
	item_state = "plasticbag"
	slot_flags = SLOT_HEAD|SLOT_BELT
	throwforce = 0
	w_class = 4
	max_w_class = 2
	storage_slots = 21
	can_hold = list() // any
	cant_hold = list("/obj/item/weapon/disk/nuclear","/obj/item/flag/nation")
	var/head = 0

/obj/item/weapon/storage/bag/plasticbag/mob_can_equip(M as mob, slot)

	if(slot==slot_head && contents.len)
		M << "\red You need to empty the bag first!"
		return 0
	return ..()


/obj/item/weapon/storage/bag/plasticbag/equipped(var/mob/user, var/slot)
	if(slot==slot_head)
		head = 1
		storage_slots = 0
		processing_objects.Add(src)
	return

/obj/item/weapon/storage/bag/plasticbag/process()
	if(is_equipped() && head)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if(H.internal)
				return
			H.losebreath += 1
	else
		head = 0
		storage_slots = 21
		processing_objects.Remove(src)
	return

// -----------------------------
//        Mining Satchel
// -----------------------------

/obj/item/weapon/storage/bag/ore
	name = "Mining Satchel"
	desc = "This little bugger can be used to store and transport ores."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = 3
	storage_slots = 50
	max_combined_w_class = 200 //Doesn't matter what this is, so long as it's more or equal to storage_slots * ore.w_class
	max_w_class = 3
	can_hold = list("/obj/item/weapon/ore")


// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/weapon/storage/bag/plants
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "plantbag"
	name = "Plant Bag"
	storage_slots = 50; //the number of plant pieces it can carry.
	max_combined_w_class = 200 //Doesn't matter what this is, so long as it's more or equal to storage_slots * plants.w_class
	max_w_class = 3
	w_class = 1
	can_hold = list("/obj/item/weapon/reagent_containers/food/snacks/grown","/obj/item/seeds","/obj/item/weapon/grown", "/obj/item/stack/tile/grass")

/*
/obj/item/weapon/storage/bag/plants/portaseeder
	name = "Portable Seed Extractor"
	desc = "For the enterprising botanist on the go. Less efficient than the stationary model, it creates one seed per plant."
	icon_state = "portaseeder"
	origin_tech = "materials=2;biotech=2"

	verb/dissolve_contents()
		set name = "Activate Seed Extraction"
		set category = "Object"
		set desc = "Activate to convert your plants into plantable seeds."
		for(var/obj/item/O in contents)
			seedify(O, 1)
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.close(M)
*/

// -----------------------------
//        Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu

/obj/item/weapon/storage/bag/sheetsnatcher
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	name = "Sheet Snatcher"
	desc = "A patented Nanotrasen storage system designed for any kind of mineral sheet."

	var/capacity = 300; //the number of sheets it can carry.
	w_class = 3

	allow_quick_empty = 1 // this function is superceded
	New()
		..()
		//verbs -= /obj/item/weapon/storage/verb/quick_empty
		//verbs += /obj/item/weapon/storage/bag/sheetsnatcher/quick_empty

	can_be_inserted(obj/item/W as obj, stop_messages = 0)
		if(!istype(W,/obj/item/stack/sheet) || istype(W,/obj/item/stack/sheet/mineral/sandstone) || istype(W,/obj/item/stack/sheet/wood))
			if(!stop_messages)
				usr << "The snatcher does not accept [W]."
			return 0 //I don't care, but the existing code rejects them for not being "sheets" *shrug* -Sayu
		var/current = 0
		for(var/obj/item/stack/sheet/S in contents)
			current += S.amount
		if(capacity == current)//If it's full, you're done
			if(!stop_messages)
				usr << "\red The snatcher is full."
			return 0
		return 1


// Modified handle_item_insertion.  Would prefer not to, but...
	handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
		var/obj/item/stack/sheet/S = W
		if(!istype(S)) return 0

		var/amount
		var/inserted = 0
		var/current = 0
		for(var/obj/item/stack/sheet/S2 in contents)
			current += S2.amount
		if(capacity < current + S.amount)//If the stack will fill it up
			amount = capacity - current
		else
			amount = S.amount

		for(var/obj/item/stack/sheet/sheet in contents)
			if(S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
				sheet.amount += amount	// they should only be removed through procs in this file, which split them up.
				S.amount -= amount
				inserted = 1
				break

		if(!inserted || !S.amount)
			usr.unEquip(S)
			usr.update_icons()	//update our overlays
			if (usr.client && usr.s_active != src)
				usr.client.screen -= S
			S.dropped(usr)
			if(!S.amount)
				del S
			else
				S.loc = src

		orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
		update_icon()
		return 1


// Sets up numbered display to show the stack size of each stored mineral
// NOTE: numbered display is turned off currently because it's broken
	orient2hud(mob/user as mob)
		var/adjusted_contents = contents.len

		//Numbered contents display
		var/list/datum/numbered_display/numbered_contents
		if(display_contents_with_number)
			numbered_contents = list()
			adjusted_contents = 0
			for(var/obj/item/stack/sheet/I in contents)
				adjusted_contents++
				var/datum/numbered_display/D = new/datum/numbered_display(I)
				D.number = I.amount
				numbered_contents.Add( D )

		var/row_num = 0
		var/col_count = min(7,storage_slots) -1
		if (adjusted_contents > 7)
			row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
		src.standard_orient_objs(row_num, col_count, numbered_contents)
		return


// Modified quick_empty verb drops appropriate sized stacks
	quick_empty()
		var/location = get_turf(src)
		for(var/obj/item/stack/sheet/S in contents)
			while(S.amount)
				var/obj/item/stack/sheet/N = new S.type(location)
				var/stacksize = min(S.amount,N.max_amount)
				N.amount = stacksize
				S.amount -= stacksize
			if(!S.amount)
				del S // todo: there's probably something missing here
		orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
		update_icon()

// Instead of removing
	remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/stack/sheet/S = W
		if(!istype(S)) return 0

		//I would prefer to drop a new stack, but the item/attack_hand code
		// that calls this can't recieve a different object than you clicked on.
		//Therefore, make a new stack internally that has the remainder.
		// -Sayu

		if(S.amount > S.max_amount)
			var/obj/item/stack/sheet/temp = new S.type(src)
			temp.amount = S.amount - S.max_amount
			S.amount = S.max_amount

		return ..(S,new_location)

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/weapon/storage/bag/sheetsnatcher/borg
	name = "Sheet Snatcher 9000"
	desc = ""
	capacity = 500//Borgs get more because >specialization


// -----------------------------
//           Cash Bag
// -----------------------------

/obj/item/weapon/storage/bag/cash
	icon = 'icons/obj/storage.dmi'
	icon_state = "cashbag"
	name = "Cash bag"
	desc = "A bag for carrying lots of cash. It's got a big dollar sign printed on the front."
	storage_slots = 50; //the number of cash pieces it can carry.
	max_combined_w_class = 200 //Doesn't matter what this is, so long as it's more or equal to storage_slots * cash.w_class
	max_w_class = 3
	w_class = 1

	can_hold = list("/obj/item/weapon/coin","/obj/item/weapon/spacecash")

// -----------------------------
//           Book bag
// -----------------------------

/obj/item/weapon/storage/bag/books
	name = "book bag"
	desc = "A bag for books."
	icon = 'icons/obj/library.dmi'
	icon_state = "bookbag"
	display_contents_with_number = 0 //This would look really stupid otherwise
	storage_slots = 7
	max_combined_w_class = 21
	max_w_class = 3
	w_class = 4 //Bigger than a book because physics
	can_hold = list(/obj/item/weapon/book, /obj/item/weapon/spellbook) //No bibles, consistent with bookcase
	
/*
 * Trays - Agouri
 */
/obj/item/weapon/storage/bag/tray
	name = "tray"
	icon = 'icons/obj/food.dmi'
	icon_state = "tray"
	desc = "A metal tray to lay food on."
	force = 5
	throwforce = 10.0
	throw_speed = 3
	throw_range = 5
	w_class = 4.0
	flags = CONDUCT
	m_amt = 3000

/obj/item/weapon/storage/bag/tray/attack(mob/living/M as mob, mob/living/user as mob)
	..()
	// Drop all the things. All of them.
	var/list/obj/item/oldContents = contents.Copy()
	quick_empty()

	// Make each item scatter a bit
	for(var/obj/item/I in oldContents)
		spawn()
			for(var/i = 1, i <= rand(1,2), i++)
				if(I)
					step(I, pick(NORTH,SOUTH,EAST,WEST))
					sleep(rand(2,4))

	if(prob(50))
		playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
	else
		playsound(M, 'sound/items/trayhit2.ogg', 50, 1)

	if(ishuman(M) || ismonkey(M))
		if(prob(10))
			M.Weaken(2)

/obj/item/weapon/storage/bag/tray/proc/rebuild_overlays()
	overlays.Cut()
	for(var/obj/item/I in contents)
		overlays += image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = -1)

/obj/item/weapon/storage/bag/tray/remove_from_storage(obj/item/W as obj, atom/new_location)
	..()
	rebuild_overlays()

/obj/item/weapon/storage/bag/tray/handle_item_insertion(obj/item/I, prevent_warning = 0)
	overlays += image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = -1)
	..()

/obj/item/weapon/storage/bag/tray/cyborg	
	
/obj/item/weapon/storage/bag/tray/cyborg/afterattack(atom/target, mob/user as mob)
	if ( isturf(target) || istype(target,/obj/structure/table) )
		var foundtable = istype(target,/obj/structure/table/)
		if ( !foundtable ) //it must be a turf!
			for(var/obj/structure/table/T in target)
				foundtable = 1
				break

		var turf/dropspot
		if ( !foundtable ) // don't unload things onto walls or other silly places.
			dropspot = user.loc
		else if ( isturf(target) ) // they clicked on a turf with a table in it
			dropspot = target
		else					// they clicked on a table
			dropspot = target.loc

		overlays = null

		var droppedSomething = 0

		for(var/obj/item/I in contents)
			I.loc = dropspot
			contents.Remove(I)
			droppedSomething = 1
			if(!foundtable && isturf(dropspot))
				// if no table, presume that the person just shittily dropped the tray on the ground and made a mess everywhere!
				spawn()
					for(var/i = 1, i <= rand(1,2), i++)
						if(I)
							step(I, pick(NORTH,SOUTH,EAST,WEST))
							sleep(rand(2,4))
		if ( droppedSomething )
			if ( foundtable )
				user.visible_message("\blue [user] unloads their service tray.")
			else
				user.visible_message("\blue [user] drops all the items on their tray.")

	return ..()
