note
	description: "[
		p_inter.c
		
		Handling interactions (i.e., collisions)
	]"

class
	P_INTER

inherit

	MOBJFLAG_T

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: I_MAIN)
		do
			i_main := a_i_main
		end

feature

	maxammo: ARRAY [INTEGER]
		once
			create Result.make_filled (0, 0, 3)
			Result [0] := 200
			Result [1] := 50
			Result [2] := 300
			Result [3] := 50
		ensure
			Result.lower = 0
			Result.count = {AMMOTYPE_T}.numammo
			instance_free: class
		end

feature -- P_DamageMobj

	P_DamageMobj_inner (target: MOBJ_T; inflictor, source: detachable MOBJ_T; a_damage: INTEGER)
		local
			ang: ANGLE_T -- originally unsigned
			saved: INTEGER
			player: PLAYER_T
			thrust: FIXED_T
			temp: INTEGER
			damage: INTEGER
			player_using_chainsaw: BOOLEAN
			returned: BOOLEAN
		do
			damage := a_damage
			if target.flags & MF_SKULLFLY /= 0 then
				target.momx := 0
				target.momy := 0
				target.momz := 0
			end
			player := target.player
			if attached player and then i_main.g_game.gameskill = {DOOMDEF_H}.sk_baby then
				damage := damage |>> 1 -- take half damage in trainer mode
			end
				-- Some close combat weapons should not
				-- inflict thrust and push the victim out of reach,
				-- thus kick away unless using the chainsaw.
			player_using_chainsaw := attached source and then attached source.player as p and then p.readyweapon = {WEAPONTYPE_T}.wp_chainsaw
			if attached inflictor and target.flags & MF_NOCLIP = 0 and not player_using_chainsaw then
				ang := i_main.r_main.R_PointToAngle2 (inflictor.x, inflictor.y, target.x, target.y)
				check attached target.info as tinfo then
					thrust := damage * ({M_FIXED}.fracunit |>> 3) * 100 // tinfo.mass
				end

					-- make fall forwards sometimes
				if damage < 40 and damage > target.health and target.z - inflictor.z > 64 * {M_FIXED}.fracunit and (i_main.m_random.p_random & 1 /= 0) then
					ang := ang + {R_MAIN}.ANG180
					thrust := thrust * 4
				end
			end

				-- player specific
			if attached player then
					-- end of game hell hack
				check attached target.subsector as sub and then attached sub.sector as s then
					if s.special = 11 and damage >= target.health then
						damage := target.health - 1
					end
				end

					-- Below certain threshold,
					-- ignore damage in GOD mode, or with INVUL power.
				if damage < 1000 and (player.cheats & {CHEAT_T}.CF_GODMODE /= 0 or player.powers [{POWERTYPE_T}.pw_invulnerability] /= 0) then
						-- return
					returned := True
				end
				if not returned then
					if player.armortype /= 0 then
						if player.armortype = 1 then
							saved := damage // 3
						else
							saved := damage // 2
						end
						if player.armorpoints <= saved then
								-- armor is used up
							saved := player.armorpoints
							player.armortype := 0
						end
						player.armorpoints := player.armorpoints - saved
						damage := damage - saved
					end
					player.health := player.health - damage -- mirror mobj health here for Dave
					if player.health < 0 then
						player.health := 0
					end
					player.attacker := source
					player.damagecount := player.damagecount + damage -- add damage after armor / invuln
					if player.damagecount > 100 then
						player.damagecount := 100 -- teleport stomp does 10k points...
					end
					temp := damage.max (100)
					if player = i_main.g_game.players [i_main.g_game.consoleplayer] then
						i_main.i_system.I_Tactile (40, 10, 40 + temp * 2)
					end
				end
			end
			if not returned then
					-- do the damage
				target.health := target.health - damage
				if target.health <= 0 then
					P_KillMobj (source, target)
					returned := True
				end
			end
			if not returned then
				check attached target.info as tinfo then
					if i_main.m_random.p_random < tinfo.painchance and target.flags & MF_SKULLFLY = 0 then
						target.flags := target.flags | MF_JUSTHIT -- fight back!
						i_main.p_mobj.P_SetMobjState (target, tinfo.painstate).do_nothing
					end
					target.reactiontime := 0 -- we're awake now...
					if (target.threshold = 0 or target.type = {MOBJTYPE_T}.MT_VILE) and then attached source and then source /= target and then source.type /= {MOBJTYPE_T}.MT_VILE then
							-- if not intent on another player,
							-- chase after this one
						target.target := source
						target.threshold := {P_LOCAL}.BASETHRESHOLD
						if target.state = {INFO}.states [tinfo.spawnstate] and tinfo.seestate /= {STATENUM_T}.S_NULL then
							i_main.p_mobj.P_SetMobjState (target, tinfo.seestate).do_nothing
						end
					end
				end
			end
		end

	P_DamageMobj (target: MOBJ_T; inflictor, source: detachable MOBJ_T; damage: INTEGER)
		do
			if target.flags & MF_SHOOTABLE = 0 then
					-- shouldn't happen
			elseif target.health <= 0 then
					-- return
			else
				P_DamageMobj_inner (target, inflictor, source, damage)
			end
		end

	P_KillMobj (source: detachable MOBJ_T; target: MOBJ_T)
		do
				-- Stub
			print ("P_KillMobj is not implemented%N")
		end

	P_TouchSpecialThing (special, toucher: MOBJ_T)
		do
				-- Stub

		ensure
			instance_free: class
		end

end
