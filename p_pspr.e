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

	ps_flah: INTEGER = 1

	NUMPSPRITES: INTEGER = 2

feature

	WEAPONBOTTOM: INTEGER
		once
			Result := 128 * {M_FIXED}.fracunit
		ensure
			instance_free: class
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
				i > NUMPSPRITES
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
		do
			stnum := a_stnum
			psp := player.psprites [position]
			from
			until
				break or else psp.tics = 0
			loop
				if stnum = 0 then
						-- object removed itself
					psp.state := Void
					break := True
				end
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
				if attached state.action.acp2 as acp2 then
					acp2.call (player, psp)
					if psp.state = Void then
						break := True
					end
				end
				check attached psp.state as s then
					stnum := s.nextstate
				end
			end
		end

end
