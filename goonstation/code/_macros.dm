//Keelin: Just butchering #define s a bit here, don't mind me.
#define CONCALL(OBJ, TYPE, CALL, VARNAME) var##TYPE/##VARNAME=OBJ;if(istype(##VARNAME)) ##VARNAME.##CALL

// comment this line to disable or enable spawn debugging. it's pretty cheap and safe for the live servers though.
// #define ENABLE_SPAWN_DEBUG

// for this to work, use SPAWN_DBG() instead of spawn(). thank you for loving pupkin. -singh
#ifdef ENABLE_SPAWN_DEBUG
var/list/global_spawn_dbg = list()
#define SPAWN_DBG(x) global_spawn_dbg["spawn at [__FILE__]:[__LINE__]"]++; spawn(x)
#else
#define SPAWN_DBG(x) spawn(x)
#endif

// i think its slightly faster to do this with compiler macros instead of procs. i might be a moron, not sure - drsingh
// it is. no comment on the moron bit. -- marq
#define isclient(x) istype(x, /client)
#define ismind(x) istype(x, /datum/mind)
#define ismob(x) istype(x, /mob)
#define isobserver(x) istype(x, /mob/dead)
#define isadminghost(x) x.client && x.client.holder && rank_to_level(x.client.holder.rank) >= LEVEL_MOD && (istype(x, /mob/dead/observer) || istype(x, /mob/dead/target_observer)) // For antag overlays.

#define isliving(x) istype(x, /mob/living)

#define iscarbon(x) istype(x, /mob/living/carbon)
#define ismonkey(x) (istype(x, /mob/living/carbon/human) && istype(x:mutantrace, /datum/mutantrace/monkey))
#define ishuman(x) istype(x, /mob/living/carbon/human)
#define iscritter(x) istype(x, /mob/living/critter)
#define isintangible(x) istype(x, /mob/living/intangible)
#define ismobcritter(x) istype(x, /mob/living/critter)

#define issilicon(x) istype(x, /mob/living/silicon)
#define isrobot(x) istype(x, /mob/living/silicon/robot)
#define ishivebot(x) istype(x, /mob/living/silicon/hivebot)
#define ismainframe(x) istype(x, /mob/living/silicon/hive_mainframe)
#define isAI(x) (istype(x, /mob/living/silicon/ai) || istype (x, /mob/dead/aieye))
#define isAIeye(x) istype (x, /mob/dead/aieye)
#define isshell(x) istype(x, /mob/living/silicon/hivebot/eyebot)//istype(x, /mob/living/silicon/shell)
#define isdrone(x) istype(x, /mob/living/silicon/hivebot/drone)
#define isghostdrone(x) istype(x, /mob/living/silicon/ghostdrone)

#define iscube(x) (istype(x, /mob/living/carbon/cube))
#define isvirtual(x) istype(x, /mob/living/carbon/human/virtual)
#define isVRghost(x) (istype(x, /mob/living/carbon/human/virtual) && x:isghost)
#define issmallanimal(x) istype(x, /mob/living/critter/small_animal)
#define isghostcritter(x) (istype(x, /mob/living/critter/small_animal) && x:ghost_spawned)

// I'm grump that we don't already have these so I'm adding them.  will we use all of them? probably not.  but we have them. - Haine
// Hi, Marquesas here. Eliminating all ':' would be nice. Can we do that somehow? Thanks.

// Macros with abilityHolder or mutantrace defines are used for more than antagonist checks, so don't replace them with mind.special_role.
#define istraitor(x) (istype(x, /mob/living/carbon/human) && x:mind && x:mind:special_role == "traitor")
#define ischangeling(x) (istype(x, /mob/living/carbon/human) && x:get_ability_holder(/datum/abilityHolder/changeling) != null)
#define isabomination(x) (istype(x, /mob/living/carbon/human) && x:mutantrace && istype(x:mutantrace, /datum/mutantrace/abomination))
#define isnukeop(x) (istype(x, /mob/living/carbon/human) && x:mind && x:mind:special_role == "nukeop")
#define isvampire(x) ((istype(x, /mob/living/carbon/human) || istype(x, /mob/living/critter)) && x:get_ability_holder(/datum/abilityHolder/vampire) != null)
#define isvampiriczombie(x) (istype(x, /mob/living/carbon/human) && x:get_ability_holder(/datum/abilityHolder/vampiric_zombie) != null)
#define iswizard(x) ((istype(x, /mob/living/carbon/human) || istype(x, /mob/living/critter)) && x:get_ability_holder(/datum/abilityHolder/wizard) != null)
#define ishunter(x) (istype(x, /mob/living/carbon/human) && x:mutantrace && istype(x:mutantrace, /datum/mutantrace/hunter))
#define iswerewolf(x) (istype(x, /mob/living/carbon/human) && x:mutantrace && istype(x:mutantrace, /datum/mutantrace/werewolf))
#define iswrestler(x) ((istype(x, /mob/living/carbon/human) || istype(x, /mob/living/critter)) && x:get_ability_holder(/datum/abilityHolder/wrestler) != null)
#define iswraith(x) istype(x, /mob/wraith)
#define isblob(x) istype(x, /mob/living/intangible/blob_overmind)
#define isspythief(x) (istype(x, /mob/living/carbon/human) && x:mind && x:mind:special_role == "spy_thief")

// Why the separate mask check? NPCs don't use assigned_role and we still wanna play the cluwne-specific sound effects.
#define iscluwne(x) (istype(x, /mob/living/carbon/human) && ((x:mind && x:mind.assigned_role && x:mind:assigned_role == "Cluwne") || istype(x:wear_mask, /obj/item/clothing/mask/cursedclown_hat)))
#define ishorse(x) (istype(x, /mob/living/carbon/human) && ((x:mind && x:mind.assigned_role && x:mind:assigned_role == "Horse") || istype(x:wear_mask, /obj/item/clothing/mask/horse_mask/cursed)))
#define isdiabolical(x) (istype(x, /mob/living/carbon/human) && x:mind && x:mind:diabolical == 1)
#define iswelder(x) istype(x, /mob/living/carbon/human/welder)
#define ismartian(x) (istype(x, /mob/living/critter/martian) || (istype(x, /mob/living/carbon/human) && x:mutantrace && istype(x:mutantrace, /datum/mutantrace/martian)))
#define isprematureclone(x) (istype(x, /mob/living/carbon/human) && x:mutantrace && istype(x:mutantrace, /datum/mutantrace/premature_clone))

#define ishellbanned(x) istype(x, /mob) && x:client && x:client.hellbanned

#ifdef UNDERWATER_MAP
#define isrestrictedz(z) ((z) == 2 || (z) == 3  || (z) == 4 || (z) == 6)
#define isghostrestrictedz(z) (isrestrictedz(z) || (z) == 5)
#else
#define isrestrictedz(z) ((z) == 2 || (z) == 4  || (z) == 6)
#define isghostrestrictedz(z) (isrestrictedz(z))
#endif

#define isitem(x) istype(x, /obj/item)

#define childrentypesof(x) (typesof(x) - x)

#define istool(x,y) (isitem(x) && (x:tool_flags & (y)))
#define iscuttingtool(x) (istool(x, TOOL_CUTTING))
#define ispulsingtool(x) (istool(x, TOOL_PULSING))
#define ispryingtool(x) (istool(x, TOOL_PRYING))
#define isscrewingtool(x) (istool(x, TOOL_SCREWING) || (istype(x, /obj/item/reagent_containers) && x:reagents:has_reagent("screwdriver")) ) //the joke is too good
#define issnippingtool(x) (istool(x, TOOL_SNIPPING))
#define iswrenchingtool(x) (istool(x, TOOL_WRENCHING))
#define ischoppingtool(x) (istool(x, TOOL_CHOPPING))

#define isalcoholresistant(x) ((x.bioHolder && x.bioHolder.HasEffect("resist_alcohol")) || (x.traitHolder && x.traitHolder.hasTrait("training_drinker")))

// hi here's some flockdrone BS - cirr
#define isfeathertile(x) (istype(x, /turf/simulated/floor/feather) || istype(x, /turf/simulated/wall/auto/feather))
#define isflock(x) (istype(x, /mob/living/intangible/flock) || istype(x, /mob/living/critter/flock))

// pick strings from cache-- code/procs/string_cache.dm
#define pick_string(filename, key) pick(strings(filename, key))

#define DEBUG_MESSAGE(x) if (debug_messages) message_coders(x)
#define DEBUG_MESSAGE_VARDBG(x,d) if (debug_messages) message_coders_vardbg(x,d)
#define __red(x) text("<span style='color:red'>[]</span>", x)  //deprecated for some reason
#define __blue(x) text("<span style='color:blue'>[]</span>", x) //deprecated for some reason
#define __green(x) text("<span style='color:green'>[]</span>", x) //deprecated for some reason

#define TimeOfHour world.timeofday % 36000
//#endif

#define CLEAN(w) html_encode("[w]")

// get_step() with a dir of 0 just gets the turf an atom is on, through any number of nested layers.
// See: http://www.byond.com/forum/?post=2110095
#define get_turf(x) get_step(x, 0)
#define issimulatedturf(x) istype(x, /turf/simulated)
#define isfloor(x) (istype(x, /turf/simulated/floor) || istype(x, /turf/unsimulated/floor))

#define return_if_overlay_or_effect(x) if (istype(x, /obj/overlay) || istype(x, /obj/effects)) return

// maps
#define ismap(x) (map_setting == x)

// because fuck remembering what stat means every single time
#define isalive(x) (ismob(x) && x.stat == 0)
#define isunconscious(x) (ismob(x) && x.stat == 1)
#define isdead(x) (ismob(x) && x.stat == 2)
#define setalive(x) if (ismob(x)) x.stat = 0
#define setunconscious(x) if (ismob(x)) x.stat = 1
#define setdead(x) if (ismob(x)) x.stat = 2

#define isgrab(x) (istype(x, /obj/item/grab/))

#define RANDOM_HUMAN_VOICE pick(1,2,3)

#define admin_only if(!src.holder) {boutput(src, "Only administrators may use this command."); return}
#define mentor_only if(!src.mentor) {boutput(src, "Only mentors may use this command."); return}
#define usr_admin_only if(usr && usr.client && !usr.client.holder) {boutput(usr, "Only administrators may use this command."); return}

#define GLOBAL_PROC "THIS_IS_A_GLOBAL_PROC_CALLBACK" //used instead of null because clients can be callback targets and then go null from disconnect before invoked, and we need to be able to differentiate when that happens or when it's just a global proc.
#define CALLBACK new /datum/callback //not a macro to make it 510 compatible