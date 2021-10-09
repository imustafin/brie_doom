note
	description: "[
		p_inter.c
		
		Handling interactions (i.e., collisions)
	]"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
		Copyright (C) 2005-2014 Simon Howard
		Copyright (C) 2021 Ilgiz Mustafin

		This program is free software; you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation; either version 2 of the License, or
		(at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along
		with this program; if not, write to the Free Software Foundation, Inc.,
		51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
	]"

class
	P_INTER

inherit

	MOBJFLAG_T

	MOBJTYPE_T

	SFXENUM_T

	SPRITENUM_T

	D_ENGLSH

	CARD_T

	POWERTYPE_T

	WEAPONTYPE_T

	AMMOTYPE_T

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: I_MAIN)
		do
			i_main := a_i_main
		end

feature

	BONUSADD: INTEGER = 6

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

	P_DamageMobj (target: MOBJ_T; inflictor, source: detachable MOBJ_T; a_damage: INTEGER)
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
			if target.flags & MF_SHOOTABLE = 0 then
					-- shouldn't happen
			elseif target.health <= 0 then
					-- return
			else
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
		end

	P_KillMobj (source: detachable MOBJ_T; target: MOBJ_T)
		local
			item: INTEGER
			mo: MOBJ_T
			target_player_index: INTEGER
			returned: BOOLEAN
		do
			target.flags := target.flags & (MF_SHOOTABLE | MF_FLOAT | MF_SKULLFLY).bit_not
			if target.type /= MT_SKULL then
				target.flags := target.flags & MF_NOGRAVITY.bit_not
			end
			target.flags := target.flags | MF_CORPSE | MF_DROPOFF
			target.height := target.height |>> 2
			if attached source and then attached source.player as player then
					-- count for intermission
				if target.flags & MF_COUNTKILL /= 0 then
					player.killcount := player.killcount + 1
				end
				if attached target.player as target_player then
					target_player_index := i_main.g_game.player_index (target_player)
					player.frags [target_player_index] := player.frags [target_player_index] + 1
				end
			elseif not i_main.g_game.netgame and target.flags & MF_COUNTKILL /= 0 then
					-- count all monster kills
					-- even those caused by other monsters
				i_main.g_game.players [0].killcount := i_main.g_game.players [0].killcount + 1
			end
			if attached target.player as target_player then
					-- count enviornment kills against you
				if source = Void then
					target_player_index := i_main.g_game.player_index (target_player)
					target_player.frags [target_player_index] := target_player.frags [target_player_index] + 1
				end
				target.flags := target.flags & MF_SOLID.bit_not
				target_player.playerstate := {PLAYER_T}.PST_DEAD
				i_main.p_pspr.P_DropWeapon (target_player)
				if target_player = i_main.g_game.players [i_main.g_game.consoleplayer] and i_main.am_map.automapactive then
						-- don't die in auto map,
						-- switch view prior to dying
					i_main.am_map.am_stop
				end
			end
			check attached target.info as tinfo then
				if target.health < - tinfo.spawnhealth and tinfo.xdeathstate /= 0 then
					i_main.p_mobj.P_SetMobjState (target, tinfo.xdeathstate).do_nothing
				else
					i_main.p_mobj.P_SetMobjState (target, tinfo.deathstate).do_nothing
				end
			end
			target.tics := target.tics - (i_main.m_random.p_random & 3)
			if target.tics < 1 then
				target.tics := 1
			end

				-- Drop stuff.
				-- This determines the kind of object spawned
				-- during the death frame of a thing
			if target.type = MT_WOLFSS or target.type = MT_POSSESSED then
				item := MT_CLIP
			elseif target.type = MT_SHOTGUY then
				item := MT_SHOTGUN
			elseif target.type = MT_CHAINGUY then
				item := MT_CHAINGUN
			else
					-- return
				returned := True
			end
			if not returned then
				mo := i_main.p_mobj.P_SpawnMobj (target.x, target.y, {P_LOCAL}.ONFLOORZ, item)
				mo.flags := mo.flags | MF_DROPPED -- special versions of items
			end
		end

	P_TouchSpecialThing (special, toucher: MOBJ_T)
		local
			player: PLAYER_T
			i: INTEGER
			delta: FIXED_T
			sound: INTEGER
			returned: BOOLEAN
		do
			delta := special.z - toucher.z
			if delta > toucher.height or delta < -8 * {M_FIXED}.fracunit then
					-- out of reach
				returned := True
			end
			if not returned then
				sound := sfx_itemup
				player := toucher.player

					-- Dead thing touching.
					-- Can happen with a sliding player corpse
				if toucher.health <= 0 then
					returned := True
				end
			end
			if not returned then
					-- Identify by sprite
				check attached player and then attached player.mo as mo then
					if special.sprite = SPR_ARM1 then -- armor
						if not P_GiveArmor (player, 1) then
							returned := True
						else
							player.message := GOTARMOR
						end
					elseif special.sprite = SPR_ARM2 then
						if not P_GiveArmor (player, 2) then
							returned := True
						else
							player.message := GOTMEGA
						end
					elseif special.sprite = SPR_BON1 then -- bonus items
						player.health := player.health + 1 -- can go over 100%
						if player.health > 200 then
							player.health := 200
						end
						mo.health := player.health
						player.message := GOTHTHBONUS
					elseif special.sprite = SPR_BON2 then
						player.armorpoints := player.armorpoints + 1 -- can go over 100%
						if player.armorpoints > 200 then
							player.armorpoints := 200
						end
						if player.armortype = 0 then
							player.armortype := 1
						end
						player.message := GOTARMBONUS
					elseif special.sprite = SPR_SOUL then
						player.health := player.health + 100
						if player.health > 200 then
							player.health := 200
						end
						mo.health := player.health
						player.message := GOTSUPER
						sound := sfx_getpow
					elseif special.sprite = SPR_MEGA then
						if i_main.doomstat_h.gamemode /= {GAME_MODE_T}.commercial then
							returned := True
						else
							player.health := 200
							mo.health := player.health
							P_GiveArmor (player, 2).do_nothing
							player.message := GOTMSPHERE
							sound := sfx_getpow
						end
					elseif special.sprite = SPR_BKEY then -- cards. leave cards for everyone
						if not player.cards [it_bluecard] then
							player.message := GOTBLUECARD
						end
						P_GiveCard (player, it_bluecard)
						if i_main.g_game.netgame then
							returned := True
						end
					elseif special.sprite = SPR_YKEY then
						if not player.cards [it_yellowcard] then
							player.message := GOTYELWCARD
						end
						P_GiveCard (player, it_yellowcard)
						if i_main.g_game.netgame then
							returned := True
						end
					elseif special.sprite = SPR_RKEY then
						if not player.cards [it_redcard] then
							player.message := GOTREDCARD
						end
						P_GiveCard (player, it_redcard)
						if i_main.g_game.netgame then
							returned := True
						end
					elseif special.sprite = SPR_BSKU then
						if not player.cards [it_blueskull] then
							player.message := GOTBLUESKUL
						end
						P_GiveCard (player, it_blueskull)
						if i_main.g_game.netgame then
							returned := True
						end
					elseif special.sprite = SPR_YSKU then
						if not player.cards [it_yellowskull] then
							player.message := GOTYELWSKUL
						end
						P_GiveCard (player, it_yellowskull)
						if i_main.g_game.netgame then
							returned := True
						end
					elseif special.sprite = SPR_RSKU then
						if not player.cards [it_redskull] then
							player.message := GOTREDSKULL
						end
						P_GiveCard (player, it_redskull)
						if i_main.g_game.netgame then
							returned := True
						end
					elseif special.sprite = SPR_STIM then -- medikits, heals
						if not P_GiveBody (player, 10) then
							returned := True
						else
							player.message := GOTSTIM
						end
					elseif special.sprite = SPR_MEDI then
						if not P_GiveBody (player, 25) then
							returned := True
						else
							if player.health < 25 then
								player.message := GOTMEDINEED
							else
								player.message := GOTMEDIKIT
							end
						end
					elseif special.sprite = SPR_PINV then -- power ups
						if not P_GivePower (player, pw_invulnerability) then
							returned := True
						else
							player.message := GOTINVUL
							sound := sfx_getpow
						end
					elseif special.sprite = SPR_PSTR then
						if not P_GivePower (player, pw_strength) then
							returned := True
						else
							player.message := GOTBERSERK
							if player.readyweapon /= wp_fist then
								player.pendingweapon := wp_fist
							end
							sound := sfx_getpow
						end
					elseif special.sprite = SPR_PINS then
						if not P_GivePower (player, pw_invisibility) then
							returned := True
						else
							player.message := GOTINVIS
							sound := sfx_getpow
						end
					elseif special.sprite = SPR_SUIT then
						if not P_GivePower (player, pw_ironfeet) then
							returned := True
						else
							player.message := GOTSUIT
							sound := sfx_getpow
						end
					elseif special.sprite = SPR_PMAP then
						if not P_GivePower (player, pw_allmap) then
							returned := True
						else
							player.message := GOTMAP
							sound := sfx_getpow
						end
					elseif special.sprite = SPR_PVIS then
						if not P_GivePower (player, pw_infrared) then
							returned := True
						else
							player.message := GOTVISOR
							sound := sfx_getpow
						end
					elseif special.sprite = SPR_CLIP then -- ammo
						if special.flags & MF_DROPPED /= 0 then
							if not P_GiveAmmo (player, am_clip, 0) then
								returned := True
							end
						else
							if not P_GiveAmmo (player, am_clip, 1) then
								returned := True
							end
						end
						if not returned then
							player.message := GOTCLIP
						end
					elseif special.sprite = SPR_AMMO then
						if not P_GiveAmmo (player, am_clip, 5) then
							returned := True
						else
							player.message := GOTCLIPBOX
						end
					elseif special.sprite = SPR_ROCK then
						if not P_GiveAmmo (player, am_misl, 1) then
							returned := True
						else
							player.message := GOTROCKET
						end
					elseif special.sprite = SPR_BROK then
						if not P_GiveAmmo (player, am_misl, 5) then
							returned := True
						else
							player.message := GOTROCKBOX
						end
					elseif special.sprite = SPR_CELL then
						if not P_GiveAmmo (player, am_cell, 1) then
							returned := True
						else
							player.message := GOTCELL
						end
					elseif special.sprite = SPR_CELP then
						if not P_GiveAmmo (player, am_cell, 5) then
							returned := True
						else
							player.message := GOTCELLBOX
						end
					elseif special.sprite = SPR_SHEL then
						if not P_GiveAmmo (player, am_shell, 1) then
							returned := True
						else
							player.message := GOTSHELLS
						end
					elseif special.sprite = SPR_SBOX then
						if not P_GiveAmmo (player, am_shell, 5) then
							returned := True
						else
							player.message := GOTSHELLBOX
						end
					elseif special.sprite = SPR_BPAK then
						if not player.backpack then
							from
								i := 0
							until
								i >= NUMAMMO
							loop
								player.maxammo [i] := player.maxammo [i] * 2
								i := i + 1
							end
							player.backpack := True
						end
						from
							i := 0
						until
							i >= NUMAMMO
						loop
							P_GiveAmmo (player, i, 1).do_nothing
							i := i + 1
						end
						player.message := GOTBACKPACK
					elseif special.sprite = SPR_BFUG then -- weapons
						if not P_GiveWeapon (player, wp_bfg, False) then
							returned := True
						else
							player.message := GOTBFG9000
							sound := sfx_wpnup
						end
					elseif special.sprite = SPR_MGUN then
						if not P_GiveWeapon (player, wp_chaingun, special.flags & MF_DROPPED /= 0) then
							returned := True
						else
							player.message := GOTCHAINGUN
							sound := sfx_wpnup
						end
					elseif special.sprite = SPR_CSAW then
						if not P_GiveWeapon (player, wp_chainsaw, False) then
							returned := True
						else
							player.message := GOTCHAINSAW
							sound := sfx_wpnup
						end
					elseif special.sprite = SPR_LAUN then
						if not P_GiveWeapon (player, wp_missile, False) then
							returned := True
						else
							player.message := GOTLAUNCHER
							sound := sfx_wpnup
						end
					elseif special.sprite = SPR_PLAS then
						if not P_GiveWeapon (player, wp_plasma, False) then
							returned := True
						else
							player.message := GOTPLASMA
							sound := sfx_wpnup
						end
					elseif special.sprite = SPR_SHOT then
						if not P_GiveWeapon (player, wp_shotgun, special.flags & MF_DROPPED /= 0) then
							returned := True
						else
							player.message := GOTSHOTGUN
							sound := sfx_wpnup
						end
					elseif special.sprite = SPR_SGN2 then
						if not P_GiveWeapon (player, wp_supershotgun, special.flags & MF_DROPPED /= 0) then
							returned := True
						else
							player.message := GOTSHOTGUN2
							sound := sfx_wpnup
						end
					else
						{I_MAIN}.i_error ("P_SpecialThing: Unknown gettable thing%N")
					end
				end
			end
			if not returned then
				check attached player then
					if special.flags & MF_COUNTITEM /= 0 then
						player.itemcount := player.itemcount + 1
					end
					i_main.p_mobj.P_RemoveMobj (special)
					player.bonuscount := player.bonuscount + BONUSADD
					if player = i_main.g_game.players [i_main.g_game.consoleplayer] then
						i_main.s_sound.s_startsound (Void, sound)
					end
				end
			end
		end

	P_GiveArmor (player: PLAYER_T; armortype: INTEGER): BOOLEAN
			-- Returns false if the armor is worse
			-- than the current armor
		local
			hits: INTEGER
		do
			hits := armortype * 100
			if player.armorpoints >= hits then
				Result := False -- don't pick up
			else
				player.armortype := armortype
				player.armorpoints := hits
				Result := True
			end
		end

	P_GiveCard (player: PLAYER_T; card: INTEGER)
		do
			if player.cards [card] then
					-- return
			else
				player.bonuscount := BONUSADD
				player.cards [card] := True
			end
		end

	P_GiveBody (player: PLAYER_T; num: INTEGER): BOOLEAN
			-- Returns false if the body isn't needed at all
		do
			if player.health >= {P_LOCAL}.MAXHEALTH then
				Result := False
			else
				player.health := player.health + num
				if player.health > {P_LOCAL}.MAXHEALTH then
					player.health := {P_LOCAL}.MAXHEALTH
				end
				check attached player.mo as mo then
					mo.health := player.health
				end
				Result := True
			end
		end

	P_GivePower (player: PLAYER_T; power: INTEGER): BOOLEAN
		do
			check attached player.mo as mo then
				if power = pw_invulnerability then
					player.powers [power] := {DOOMDEF_H}.INVULNTICS
					Result := True
				elseif power = pw_invisibility then
					player.powers [power] := {DOOMDEF_H}.INVISTICS
					mo.flags := mo.flags | MF_SHADOW
					Result := True
				elseif power = pw_infrared then
					player.powers [power] := {DOOMDEF_H}.INFRATICS
					Result := True
				elseif power = pw_ironfeet then
					player.powers [power] := {DOOMDEF_H}.IRONTICS
					Result := True
				elseif power = pw_strength then
					P_GiveBody (player, 100).do_nothing
					player.powers [power] := 1
					Result := True
				else
					if player.powers [power] /= 0 then
						Result := False -- already got it
					else
						player.powers [power] := 1
						Result := True
					end
				end
			end
		end

feature -- P_GiveAmmo

	clipammo: ARRAY [INTEGER]
		once
			Result := <<10, 4, 20, 1>>
			Result.rebase (0)
		end

	P_GiveAmmo (player: PLAYER_T; ammo: INTEGER; a_num: INTEGER): BOOLEAN
			-- Num is the number of clip loads,
			-- not the individual count (0= 1/2 clip).
			-- Returns false if the ammo can't be picked up at all.
		require
			ammo >= 0 and ammo < NUMAMMO
		local
			oldammo: INTEGER
			num: INTEGER
		do
			num := a_num
			if ammo = am_noammo then
				Result := False
			elseif player.ammo [ammo] = player.maxammo [ammo] then
				Result := False
			else
				if num /= 0 then
					num := num * clipammo [ammo]
				else
					num := clipammo [ammo] // 2
				end
				if i_main.g_game.gameskill = {DOOMDEF_H}.sk_baby or i_main.g_game.gameskill = {DOOMDEF_H}.sk_nightmare then
						-- give double ammo in trainer mode,
						-- you'll need in nightmare
					num := num |<< 1
				end
				oldammo := player.ammo [ammo]
				player.ammo [ammo] := player.ammo [ammo] + num
				if player.ammo [ammo] > player.maxammo [ammo] then
					player.ammo [ammo] := player.maxammo [ammo]
				end

					-- If non zero ammo,
					-- don't change up weapons,
					-- player was lower on purpose.
				if oldammo /= 0 then
					Result := True
				else
						-- We were down to zero,
						-- so select a new weapon.
						-- Preferences are not user selectable.
					if ammo = am_clip then
						if player.readyweapon = wp_fist then
							if player.weaponowned [wp_chaingun] then
								player.pendingweapon := wp_chaingun
							else
								player.pendingweapon := wp_pistol
							end
						end
					elseif ammo = am_shell then
						if player.readyweapon = wp_fist or player.readyweapon = wp_pistol then
							if player.weaponowned [wp_shotgun] then
								player.pendingweapon := wp_shotgun
							end
						end
					elseif ammo = am_cell then
						if player.readyweapon = wp_fist or player.readyweapon = wp_pistol then
							if player.weaponowned [wp_plasma] then
								player.pendingweapon := wp_plasma
							end
						end
					elseif ammo = am_misl then
						if player.readyweapon = wp_fist then
							if player.weaponowned [wp_missile] then
								player.pendingweapon := wp_missile
							end
						end
					end
					Result := True
				end
			end
		end

	P_GiveWeapon (player: PLAYER_T; weapon: INTEGER; dropped: BOOLEAN): BOOLEAN
			-- The weapon name may have a MF_DROPPED flag ored in.
		local
			gaveammo, gaveweapon: BOOLEAN
		do
			if i_main.g_game.netgame then
					-- skip strange deathmatch!=2 condition above
				{I_MAIN}.i_error ("P_GiveWeapon not implemented for netgame")
			end
			if {D_ITEMS}.weaponinfo [weapon].ammo /= am_noammo then
					-- give one clip with a dropped weapon,
					-- two clips with a found weapon
				if dropped then
					gaveammo := P_GiveAmmo (player, {D_ITEMS}.weaponinfo [weapon].ammo, 1)
				else
					gaveammo := P_GiveAmmo (player, {D_ITEMS}.weaponinfo [weapon].ammo, 2)
				end
			else
				gaveammo := False
			end
			if player.weaponowned [weapon] then
				gaveweapon := False
			else
				gaveweapon := True
				player.weaponowned [weapon] := True
				player.pendingweapon := weapon
			end
			Result := gaveweapon or gaveammo
		end

end
