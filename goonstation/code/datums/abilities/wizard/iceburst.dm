/datum/targetable/spell/iceburst
	name = "Ice Burst"
	desc = "Launches freezing bolts at nearby foes."
	icon_state = "iceburst"
	targeted = 0
	cooldown = 200
	requires_robes = 1
	offensive = 1

	cast()
		if(!holder)
			return
		var/count = 0
		var/count2 = 0
		var/moblimit = 3

		for(var/mob/living/M as mob in oview())
			if(isdead(M)) continue
			count2++
		if(!count2)
			boutput(holder.owner, "Noone is in range!")
			return 1

		holder.owner.say("NYTH ERRIN")
		var/mob/living/carbon/human/O = holder.owner
		if(O && istype(O.wear_suit, /obj/item/clothing/suit/wizrobe/necro) && istype(O.head, /obj/item/clothing/head/wizard/necro))
			playsound(holder.owner.loc, "sound/voice/wizard/IceburstGrim.ogg", 50, 0, -1)
		else if(holder.owner.gender == "female")
			playsound(holder.owner.loc, "sound/voice/wizard/IceburstFem.ogg", 50, 0, -1)
		else
			playsound(holder.owner.loc, "sound/voice/wizard/IceburstLoud.ogg", 50, 0, -1)
		if(!holder.owner.wizard_spellpower())
			boutput(holder.owner, "<span style=\"color:red\">Your spell is weak without a staff to focus it!</span>")

		for (var/mob/living/M as mob in oview())
			if(isdead(M)) continue
			if (ishuman(M))
				if (M.traitHolder.hasTrait("training_chaplain"))
					boutput(holder.owner, "<span style=\"color:red\">[M] has divine protection! The spell refuses to target \him!</span>")
					continue
			if (iswizard(M))
				boutput(holder.owner, "<span style=\"color:red\">[M] has arcane protection! The spell refuses to target \him!</span>")
				continue
			else if(check_target_immunity( M ))
				boutput(holder.owner, "<span style='color:red'>[M] seems to be warded from the effects!</span>" )
				continue

			playsound(holder.owner.loc, "sound/effects/mag_iceburstlaunch.ogg", 25, 1, -1)
			if ((!holder.owner.wizard_spellpower() && count >= 1) || (count >= moblimit)) break
			count++
			SPAWN_DBG(0)
				var/obj/overlay/A = new /obj/overlay( holder.owner.loc )
				A.icon_state = "icem"
				A.icon = 'icons/obj/wizard.dmi'
				A.name = "ice bolt"
				A.anchored = 0
				A.set_density(0)
				A.layer = MOB_EFFECT_LAYER
				//A.sd_SetLuminosity(3)
				//A.sd_SetColor(0, 0.1, 0.8)
				var/i
				for(i=0, i<20, i++)
					if (holder.owner.wizard_spellpower())
						if (!locate(/obj/decal/icefloor) in A.loc)
							var/obj/decal/icefloor/B = new /obj/decal/icefloor(A.loc)
							//B.sd_SetLuminosity(1)
							//B.sd_SetColor(0, 0.1, 0.8)
							SPAWN_DBG(200)
								qdel (B)
					step_to(A,M,0)
					if (get_dist(A,M) == 0)
						boutput(M, text("<span style=\"color:blue\">You are chilled by a burst of magical ice!</span>"))
						M.visible_message("<span style=\"color:red\">[M] is struck by magical ice!</span>")
						playsound(holder.owner.loc, "sound/effects/mag_iceburstimpact.ogg", 25, 1, -1)
						M.bodytemperature = 0
						M.lastattacker = holder.owner
						M.lastattackertime = world.time
						qdel(A)
						if(prob(40))
							M.visible_message("<span style=\"color:red\">[M] is frozen solid!</span>")
							new /obj/icecube(M.loc, M)
						return
					sleep(5)
				qdel(A)

// /obj/decal/icefloor moved to decal.dm

/obj/icecube
	name = "ice cube"
	desc = "That is a surprisingly large ice cube."
	icon = 'icons/effects/effects.dmi'
	icon_state = "icecube"
	density = 1
	layer = EFFECTS_LAYER_BASE
	var/health = 10
	var/steam_on_death = 1
	var/add_underlay = 1

	New(loc, mob/iced as mob)
		..()
		if(iced && !isAI(iced) && !isblob(iced))
			if(istype(iced.loc, /obj/icecube)) //Already in a cube?
				qdel(src)
				return

			iced.set_loc(src)

			if (add_underlay)
				src.underlays += iced
			boutput(iced, "<span style=\"color:red\">You are trapped within [src]!</span>") // since this is used in at least two places to trap people in things other than ice cubes

			iced.last_cubed = world.time

		src.health *= (rand(10,20)/10)
		return

	relaymove(mob/user as mob)
		if (user.stat)
			return

		if(prob(25))
			takeDamage(1)
		return

	proc/takeDamage(var/damage)
		src.health -= damage
		if(src.health <= 0)
			qdel(src)
			return
		else
			var/wiggle = 3
			while(wiggle > 0)
				wiggle--
				src.pixel_x = rand(-2,2)
				src.pixel_y = rand(-2,2)
				sleep(0.5)
			src.pixel_x = 0
			src.pixel_y = 0

	attack_hand(mob/user as mob)
		user.visible_message("<span class='combat'><b>[user]</b> kicks [src]!</span>", "<span style=\"color:blue\">You kick [src].</span>")
		takeDamage(2)

	bullet_act(var/obj/projectile/P)
		var/damage = 0
		damage = round(((P.power/2)*P.proj_data.ks_ratio), 1.0)
		if (damage < 1)
			return

		switch(P.proj_data.damage_type)
			if(D_KINETIC)
				takeDamage(damage*2)
			if(D_PIERCING)
				takeDamage(damage/2)
			if(D_ENERGY)
				takeDamage(damage/4)

	attackby(obj/item/W as obj, mob/user as mob)
		takeDamage(W.force)

	disposing()
		for(var/atom/movable/AM in src)
			if(ismob(AM))
				var/mob/M = AM
				M.visible_message("<span style=\"color:red\"><b>[M]</b> breaks out of [src]!</span>","<span style=\"color:red\">You break out of [src]!</span>")
				M.last_cubed = world.time
			AM.set_loc(src.loc)

		if (steam_on_death)
			if (!(locate(/datum/effects/system/steam_spread) in src.loc))
				var/datum/effects/system/steam_spread/steam = unpool(/datum/effects/system/steam_spread)
				steam.set_up(10, 0, get_turf(src))
				steam.attach(src)
				steam.start(clear_holder=1)

		..()
		return

	mob_flip_inside(var/mob/user)
		..(user)
		user.show_text("<span style=\"color:red\">[src] [pick("cracks","bends","shakes","groans")].</span>")
		src.takeDamage(6)

	ex_act(severity)
		for(var/atom/A in src)
			A.ex_act(severity)
		takeDamage(20 / severity)
		..()