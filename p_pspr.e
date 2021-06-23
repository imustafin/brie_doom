note
	description: "[
		p_pspr.c
		Weapon sprite animation, weapon objects.
		Action functions for weapons.
	]"

class
	P_PSPR

inherit

	WEAPONTYPE_T

	AMMOTYPE_T

	SFXENUM_T

	STATENUM_T

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature -- psprnum_t

	ps_weapon: INTEGER = 0

	ps_flash: INTEGER = 1

	NUMPSPRITES: INTEGER = 2

	FF_FRAMEMASK: INTEGER = 0x7fff

	FF_FULLBRIGHT: INTEGER = 0x8000 -- flag in thing->frame

	BFGCELLS: INTEGER = 40
			-- plasma cells for a bfg attack

feature

	WEAPONBOTTOM: INTEGER
		once
			Result := 128 * {M_FIXED}.fracunit
		ensure
			instance_free: class
		end

	WEAPONTOP: INTEGER
		once
			Result := 32 * {M_FIXED}.fracunit
		end

	RAISESPEED: INTEGER
		once
			Result := {M_FIXED}.fracunit * 6
		ensure
			instance_free: class
		end

	LOWERSPEED: INTEGER
		once
			Result := {M_FIXED}.fracunit * 6
		end

feature

	A_Raise (player: PLAYER_T; psp: PSPDEF_T)
		local
			newstate: INTEGER
		do
			psp.sy := psp.sy - RAISESPEED
			if psp.sy > WEAPONTOP then
					-- return
			else
				psp.sy := WEAPONTOP
					-- The weapon has been raised all the way,
					-- so change to the ready state.
				newstate := {D_ITEMS}.weaponinfo [player.readyweapon].readystate
				P_SetPsprite (player, ps_weapon, newstate)
			end
		end

	A_WeaponReady (player: PLAYER_T; psp: PSPDEF_T)
			-- The player can fire the weapon
			-- or change to another weapon at this time.
			-- Follows after getting weapon up,
			-- or after previous attack/fire sequence.
		local
			newstate: INTEGER
			angle: INTEGER
			returned: BOOLEAN
		do
				-- get out of attack state
			check attached player.mo as mo then
				if mo.state = {INFO}.states [{INFO}.S_PLAY_ATK1] or mo.state = {INFO}.states [{INFO}.S_PLAY_ATK2] then
					i_main.p_mobj.P_SetMobjState (mo, {INFO}.S_PLAY).do_nothing
				end
				if player.readyweapon = wp_chainsaw and psp.state = {INFO}.states [{INFO}.S_SAW] then
					i_main.s_sound.s_startsound (mo, {SFXENUM_T}.sfx_sawidl)
				end

					-- check for range
					-- if player is dead, put the weapon away
				if player.pendingweapon /= wp_nochange or player.health = 0 then
						-- change weapon
						-- (pending weapon should allready be validated)
					newstate := {D_ITEMS}.weaponinfo [player.readyweapon].downstate
					P_SetPsprite (player, ps_weapon, newstate)
					returned := True
				end
				if not returned then
						-- check for fire
						-- the missile launcher and bfg do not auto fire
					if player.cmd.buttons & {D_EVENT}.BT_ATTACK /= 0 then
						if not player.attackdown or (player.readyweapon /= wp_missile and player.readyweapon /= wp_bfg) then
							player.attackdown := True
							P_FireWeapon (player)
							returned := True
						end
					else
						player.attackdown := False
					end
				end
				if not returned then
						-- bob the weapon based on movement speed
					angle := (128 * i_main.p_tick.leveltime) & {R_MAIN}.FINEMASK
					psp.sx := {M_FIXED}.FRACUNIT + {M_FIXED}.fixedmul (player.bob, {R_MAIN}.finecosine [angle])
					angle := angle & ({R_MAIN}.FINEANGLES // 2 - 1)
					psp.sy := WEAPONTOP + {M_FIXED}.fixedmul (player.bob, {R_MAIN}.finesine [angle])
				end
			end
		end

feature

	P_FireWeapon (player: PLAYER_T)
		local
			newstate: INTEGER
		do
			if not P_CheckAmmo (player) then
					-- return
			else
				check attached player.mo as mo then
					i_main.p_mobj.P_SetMobjState (mo, {STATENUM_T}.S_PLAY_ATK1).do_nothing
					newstate := {D_ITEMS}.weaponinfo [player.readyweapon].atkstate
					P_SetPsprite (player, ps_weapon, newstate)
					i_main.p_enemy.P_NoiseAlert (mo, mo)
				end
			end
		end

	P_CheckAmmo (player: PLAYER_T): BOOLEAN
			-- Returns true if there is enough ammo to shoot.
			-- If not, selects the next weapon to use.
		local
			ammo: INTEGER
			count: INTEGER
		do
			ammo := {D_ITEMS}.weaponinfo [player.readyweapon].ammo
				-- Minimal amount for one shot varies.
			if player.readyweapon = wp_bfg then
				count := BFGCELLS
			elseif player.readyweapon = wp_supershotgun then
				count := 2 -- Double barrel.
			else
				count := 1 -- Regular.
			end

				-- Some do not need ammunition anyway.
				-- Return if curren ammunition sufficient.
			if ammo = am_noammo or player.ammo [ammo] >= count then
				Result := True
			else
					-- Out of ammo, pick a weapon to change to.
					-- Preferences are set here.
				from
					player.pendingweapon := wp_nochange
				until
					player.pendingweapon /= wp_nochange
				loop
					if player.weaponowned [wp_plasma] and player.ammo [am_cell] /= 0 and i_main.doomstat_h.gamemode /= {GAME_MODE_T}.shareware then
						player.pendingweapon := wp_plasma
					elseif player.weaponowned [wp_supershotgun] and player.ammo [am_shell] > 2 and i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
						player.pendingweapon := wp_supershotgun
					elseif player.weaponowned [wp_chaingun] and player.ammo [am_clip] /= 0 then
						player.pendingweapon := wp_chaingun
					elseif player.weaponowned [wp_shotgun] and player.ammo [am_shell] /= 0 then
						player.pendingweapon := wp_shotgun
					elseif player.ammo [am_clip] /= 0 then
						player.pendingweapon := wp_pistol
					elseif player.weaponowned [wp_chainsaw] then
						player.pendingweapon := wp_chainsaw
					elseif player.weaponowned [wp_missile] and player.ammo [am_misl] /= 0 then
						player.pendingweapon := wp_missile
					elseif player.weaponowned [wp_bfg] and player.ammo [am_cell] > 40 and (i_main.doomstat_h.gamemode /= {GAME_MODE_T}.shareware) then
						player.pendingweapon := wp_bfg
					else
							-- If everything fails.
						player.pendingweapon := wp_fist
					end
				end
					-- Now set appropriate weapon overlay.
				P_SetPsprite (player, ps_weapon, {D_ITEMS}.weaponinfo [player.readyweapon].downstate)
				Result := False
			end
		end

feature

	P_SetupPsprites (player: PLAYER_T)
			-- Called at start of level for each player
		local
			i: INTEGER
		do
				-- remove all psprites
			from
				i := 0
			until
				i >= NUMPSPRITES
			loop
				player.psprites [i].state := Void
				i := i + 1
			end

				-- spawn the gun
			player.pendingweapon := player.readyweapon
			P_BringUpWeapon (player)
		end

	P_BringUpWeapon (player: PLAYER_T)
			-- Starts bringing up the pending weapon up
			-- from the bottom of the screen.
			-- Uses player
		local
			newstate: INTEGER
		do
			if player.pendingweapon = wp_nochange then
				player.pendingweapon := player.readyweapon
			end
			if player.pendingweapon = wp_chainsaw then
				i_main.s_sound.S_StartSound (player.mo, {SFXENUM_T}.sfx_sawup)
			end
			newstate := {D_ITEMS}.weaponinfo [player.pendingweapon].upstate
			player.pendingweapon := wp_nochange
			player.psprites [ps_weapon].sy := WEAPONBOTTOM
			P_SetPsprite (player, ps_weapon, newstate)
		end

	P_SetPsprite (player: PLAYER_T; position: INTEGER; a_stnum: INTEGER)
		local
			psp: PSPDEF_T
			state: STATE_T
			break: BOOLEAN
			stnum: INTEGER
			did: BOOLEAN
			action_target: STRING
		do
			stnum := a_stnum
			psp := player.psprites [position]
			from
			until
				did and (break or psp.tics /= 0)
			loop
				did := True
				if stnum = 0 then
						-- object removed itself
					psp.state := Void
					break := True
				end
				if not break then
					state := {INFO}.states [stnum]
					psp.state := state
					psp.tics := state.tics.to_integer_32 -- could be 0
					if state.misc1 /= 0 then
							-- coordinate set
						psp.sx := (state.misc1 |<< {M_FIXED}.FRACBITS).to_integer_32
						psp.sy := (state.misc2 |<< {M_FIXED}.FRACBITS).to_integer_32
					end
						-- Call action routine.
						-- Modified handling.
					if attached state.action as action then
						action.call (i_main.p_pspr, player, psp)
						if psp.state = Void then
							break := True
						end
					end
				end
				if not break then
					check attached psp.state as s then
						stnum := s.nextstate
					end
				end
			end
		end

	P_MovePsprites (player: PLAYER_T)
			-- Called every tic by player thinking routine.
		local
			i: INTEGER
			psp: INTEGER -- index in player.psprites
			state: STATE_T
		do
			psp := 0
			from
				i := 0
			until
				i >= NUMPSPRITES
			loop
					-- a null state means not active
				state := player.psprites [psp].state
				if state /= Void then
						-- drop tic count and possibly change state

						-- a -1 tic count never changes
					if player.psprites [psp].tics /= -1 then
						player.psprites [psp].tics := player.psprites [psp].tics - 1
						if player.psprites [psp].tics = 0 then
							P_SetPsprite (player, i, state.nextstate)
						end
					end
				end
				psp := psp + 1
				i := i + 1
			end
			player.psprites [ps_flash].sx := player.psprites [ps_weapon].sx
			player.psprites [ps_flash].sy := player.psprites [ps_weapon].sy
		end

feature

	A_Light0 (player: PLAYER_T; psp: PSPDEF_T)
		do
			player.extralight := 0
		ensure
			instance_free: class
		end

	A_Lower (player: PLAYER_T; psp: PSPDEF_T)
			-- Lowers current weapon,
			-- and changes weapon at bottom.
		do
			psp.sy := psp.sy + LOWERSPEED

				-- Is already down
			if psp.sy < WEAPONBOTTOM then
					-- return
			else
					-- Player is dead
				if player.playerstate = {D_PLAYER}.PST_DEAD then
					psp.sy := WEAPONBOTTOM
						-- don't bring weapon back up
						-- return
				else
						-- The old weapon has been lowered off the screen,
						-- so change the weapon and start raising it
					if player.health = 0 then
							-- Player is dead, so keep the weapon off screen.
						P_SetPsprite (player, ps_weapon, S_NULL)
							-- return
					else
						player.readyweapon := player.pendingweapon
						P_BringUpWeapon (player)
					end
				end
			end
		end

	A_Punch (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_Refire (player: PLAYER_T; psp: PSPDEF_T)
			-- The player can re-fire the weapon
			-- without lowering it entirely.
		do
				-- check for refire
				-- (if a weaponchange is pending, let it go through instead)
			if player.cmd.buttons & {D_EVENT}.BT_ATTACK /= 0 and player.pendingweapon = wp_nochange and player.health /= 0 then
				player.refire := player.refire + 1
				P_FireWeapon (player)
			else
				player.refire := 0
				P_CheckAmmo (player).do_nothing
			end
		end

	A_FirePistol (player: PLAYER_T; psp: PSPDEF_T)
		do
			check attached player.mo as mo then
				i_main.s_sound.S_StartSound (mo, sfx_pistol)
				i_main.p_mobj.P_SetMobjState (mo, S_PLAY_ATK2).do_nothing
				player.ammo [{D_ITEMS}.weaponinfo [player.readyweapon].ammo] := player.ammo [{D_ITEMS}.weaponinfo [player.readyweapon].ammo] - 1
				P_SetPsprite (player, ps_flash, {D_ITEMS}.weaponinfo [player.readyweapon].flashstate)
				P_BulletSlope (mo)
				P_GunShot (mo, not player.refire.to_boolean)
			end
		end

	P_BulletSlope (mo: MOBJ_T)
			-- Sets a slope so a near miss is at aproximately
			-- the height of the intended target
		do
				-- Stub
			print ("P_BulletSlope is not implemented%N")
		end

	P_GunShot (mo: MOBJ_T; accurate: BOOLEAN)
		do
				-- Stub
			print ("P_GunShot is not implemented%N")
		end

	A_Light1 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_Light2 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireShotgun (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireShotgun2 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_CheckReload (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireCGun (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_GunFlash (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireMissile (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_Saw (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FirePlasma (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_BFGSound (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireBFG (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_BFGSpray (mo: MOBJ_T)
			-- Spawn a BFG explosion on every monster in view
		do
				-- Stub
		end

end
