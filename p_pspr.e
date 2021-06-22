note
	description: "[
		p_pspr.c
		Weapon sprite animation, weapon objects.
		Action functions for weapons.
	]"

class
	P_PSPR

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
				if player.readyweapon = {DOOMDEF_H}.wp_chainsaw and psp.state = {INFO}.states [{INFO}.S_SAW] then
					i_main.s_sound.s_startsound (mo, {SFXENUM_T}.sfx_sawidl)
				end

					-- check for range
					-- if player is dead, put the weapon away
				if player.pendingweapon /= {DOOMDEF_H}.wp_nochange or player.health = 0 then
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
						if not player.attackdown or (player.readyweapon /= {DOOMDEF_H}.wp_missile and player.readyweapon /= {DOOMDEF_H}.wp_bfg) then
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
		do
				-- Stub
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
			if player.pendingweapon = {DOOMDEF_H}.wp_nochange then
				player.pendingweapon := player.readyweapon
			end
			if player.pendingweapon = {DOOMDEF_H}.wp_chainsaw then
				i_main.s_sound.S_StartSound (player.mo, {SFXENUM_T}.sfx_sawup)
			end
			newstate := {D_ITEMS}.weaponinfo [player.pendingweapon].upstate
			player.pendingweapon := {DOOMDEF_H}.wp_nochange
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
				if state = player.psprites [psp].state then
						-- drop tic count and possibly change state

						-- a -1 tic count never changes
					if player.psprites [psp].tics /= -1 then
						player.psprites [psp].tics := player.psprites [psp].tics - 1
						if player.psprites [psp].tics = 0 then
							check attached player.psprites [psp].state as psp_state then
								P_SetPsprite (player, i, psp_state.nextstate)
							end
						end
					end
				end
				psp := psp + 1
				i := i + 1
			end
			player.psprites [ps_flash].sx := player.psprites [ps_weapon].sx
			player.psprites [ps_flash].sy := player.psprites [ps_weapon].sy
		end

end
