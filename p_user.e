note
	description: "[
		p_user.c
		
		Player related stuff.
		Bobbing POV/weapon, movement.
		Pending weapon.
	]"

class
	P_USER

inherit

	CHEAT_T

	MOBJFLAG_T

	STATENUM_T

	DOOMDEF_H

	POWERTYPE_T

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	MAXBOB: INTEGER = 0x100000
			-- 16 pixels of bob

	INVERSECOLORMAP: INTEGER = 32
			-- Index of the special effects (INVUL inverse) map.

feature

	onground: BOOLEAN

feature

	P_PlayerThink (player: PLAYER_T)
		local
			cmd: TICCMD_T
			newweapon: INTEGER
		do
			if attached player.mo as mo then
			end
				-- fixme: do this in the cheat code
			if player.cheats & CF_NOCLIP /= 0 then
				check attached player.mo as mo then
					mo.flags := mo.flags | MF_NOCLIP
				end
			else
				check attached player.mo as mo then
					mo.flags := mo.flags & MF_NOCLIP.bit_not
				end
			end

				-- chain saw run forward
			cmd := player.cmd
			check attached player.mo as mo then
				if mo.flags & MF_JUSTATTACKED /= 0 then
					cmd.angleturn := 0
					cmd.forwardmove := (0xc800 // 512).to_integer_8
					cmd.sidemove := (0).to_integer_8
					mo.flags := mo.flags & MF_JUSTATTACKED.bit_not
				end
			end
			if player.playerstate = {D_PLAYER}.PST_DEAD then
				P_DeathThink (player)
			else
					-- Move around.
					-- Reactiontime is used to prevent movement
					-- for a bit after a teleport
				check attached player.mo as mo then
					if mo.reactiontime /= 0 then
						mo.reactiontime := mo.reactiontime - 1
					else
						P_MovePlayer (player)
					end
				end
				P_CalcHeight (player)
				check attached player.mo as mo then
					check attached mo.subsector as subsector then
						check attached subsector.sector as sector then
							if sector.special /= 0 then
								i_main.p_spec.P_PlayerInSpecialSector (player)
							end
						end
					end
				end

					-- Check for a weapon change.

					-- A special event has no other buttons.
				if cmd.buttons & {D_EVENT}.BT_SPECIAL /= 0 then
					cmd.buttons := 0
				end
				if cmd.buttons & {D_EVENT}.BT_CHANGE /= 0 then
						-- The actual changing of the weapon is done
						-- when the weapon psprite can do it
						-- (read: not in the middle of an attack)
					newweapon := (cmd.buttons & {D_EVENT}.BT_WEAPONMASK) |>> {D_EVENT}.BT_WEAPONSHIFT
					if newweapon = wp_fist and player.weaponowned [wp_chainsaw] and not (player.readyweapon = wp_chainsaw and player.powers [pw_strength] /= 0) then
						newweapon := wp_chainsaw
					end
					if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial and newweapon = wp_shotgun and player.weaponowned [wp_supershotgun] and player.readyweapon /= wp_supershotgun then
						newweapon := wp_supershotgun
					end
					if player.weaponowned [newweapon] and newweapon /= player.readyweapon then
							-- Do not go to plasma or BFG in shareware, even if cheated
						if (newweapon /= wp_plasma and newweapon /= wp_bfg) or (i_main.doomstat_h.gamemode /= {GAME_MODE_T}.shareware) then
							player.pendingweapon := newweapon
						end
					end
				end

					-- check for use
				if cmd.buttons & {D_EVENT}.BT_USE /= 0 then
					if not player.usedown then
						i_main.p_map.P_UseLines (player)
						player.usedown := True
					end
				else
					player.usedown := False
				end

					-- cycle psprites
				i_main.p_pspr.P_MovePsprites (player)

					-- Counters, time depended power ups.

					-- Strength counts up to dimish fade
				if player.powers [pw_strength] /= 0 then
					player.powers [pw_strength] := player.powers [pw_strength] + 1
				end
				if player.powers [pw_invulnerability] /= 0 then
					player.powers [pw_invulnerability] := player.powers [pw_invulnerability] - 1
				end
				if player.powers [pw_invisibility] /= 0 then
					player.powers [pw_invisibility] := player.powers [pw_invisibility] - 1
					if player.powers [pw_invisibility] = 0 then
						check attached player.mo as mo then
							mo.flags := mo.flags & MF_SHADOW.bit_not
						end
					end
				end
				if player.powers [pw_infrared] /= 0 then
					player.powers [pw_infrared] := player.powers [pw_infrared] - 1
				end
				if player.powers [pw_ironfeet] /= 0 then
					player.powers [pw_ironfeet] := player.powers [pw_ironfeet] - 1
				end
				if player.damagecount /= 0 then
					player.damagecount := player.damagecount - 1
				end
				if player.bonuscount /= 0 then
					player.bonuscount := player.bonuscount - 1
				end

					-- Handling colormaps
				if player.powers [pw_invulnerability] /= 0 then
					if player.powers [pw_invulnerability] > 4 * 32 or player.powers [pw_invulnerability] & 8 /= 0 then
						player.fixedcolormap := INVERSECOLORMAP
					else
						player.fixedcolormap := 0
					end
				elseif player.powers [pw_infrared] > 0 then
					if player.powers [pw_infrared] > 4 * 32 or player.powers [pw_infrared] & 8 /= 0 then
							-- almost full bright
						player.fixedcolormap := 1
					else
						player.fixedcolormap := 0
					end
				else
					player.fixedcolormap := 0
				end
			end
		end

	P_DeathThink (player: PLAYER_T)
		do
			{I_MAIN}.i_error ("P_DeathThink is not implemented")
		end

	P_MovePlayer (player: PLAYER_T)
		local
			cmd: TICCMD_T
			b: BOOLEAN
		do
			cmd := player.cmd
			check attached player.mo as mo then
				mo.angle := mo.angle + (cmd.angleturn.to_natural_32 |<< 16)

					-- Do not let the player control movement if not onground.
				onground := (mo.z <= mo.floorz)
				if cmd.forwardmove /= 0 and onground then
					P_Thrust (player, mo.angle, cmd.forwardmove * 2048)
				end
				if cmd.sidemove /= 0 and onground then
					P_Thrust (player, mo.angle - {R_MAIN}.ANG90, cmd.sidemove * 2048)
				end
				if (cmd.forwardmove /= 0 or cmd.sidemove /= 0) and mo.state = {INFO}.states [{INFO}.S_PLAY] then
						-- do nothing with b
					b := i_main.p_mobj.P_SetMobjState (mo, S_PLAY_RUN1)
				end
			end
		end

	P_Thrust (player: PLAYER_T; a_angle: ANGLE_T; move: FIXED_T)
		local
			angle: ANGLE_T
		do
			angle := a_angle
			angle := angle |>> {R_MAIN}.ANGLETOFINESHIFT
			check attached player.mo as mo then
				mo.momx := mo.momx + {M_FIXED}.fixedmul (move, {R_MAIN}.finecosine [angle])
				mo.momy := mo.momy + {M_FIXED}.fixedmul (move, {TABLES}.finesine [angle])
			end
		end

	P_CalcHeight (player: PLAYER_T)
			-- Calculate the walking / running height adjustment
		local
			angle: INTEGER
			bob: FIXED_T
		do
				-- Regular movement bobbing
				-- (needs to be calculated for gun swing even if not on ground)
				-- OPTIMIZE: tablify angle
				-- Note: a LUT allows for effects like a ramp with low health.
			check attached player.mo as mo then
				player.bob := {M_FIXED}.fixedmul (mo.momx, mo.momx) + {M_FIXED}.fixedmul (mo.momy, mo.momy)
				player.bob := player.bob |>> 2
				if player.bob > MAXBOB then
					player.bob := MAXBOB
				end
				if player.cheats & CF_NOMOMENTUM /= 0 or not onground then
					player.viewz := mo.z + {P_LOCAL}.VIEWHEIGHT
					if player.viewz > mo.ceilingz - 4 * {M_FIXED}.FRACUNIT then
						player.viewz := mo.ceilingz - 4 * {M_FIXED}.FRACUNIT
					end
					player.viewz := mo.z + player.viewheight
				else
					angle := ({R_MAIN}.FINEANGLES // 20 * i_main.p_tick.leveltime) & {R_MAIN}.FINEMASK
					bob := {M_FIXED}.fixedmul (player.bob // 2, {TABLES}.finesine [angle])

						-- move viewheight
					if player.playerstate = {PLAYER_T}.PST_LIVE then
						player.viewheight := player.viewheight + player.deltaviewheight
						if player.viewheight > {P_LOCAL}.VIEWHEIGHT then
							player.viewheight := {P_LOCAL}.VIEWHEIGHT
							player.deltaviewheight := 0
						end
						if player.viewheight < {P_LOCAL}.VIEWHEIGHT // 2 then
							player.viewheight := {P_LOCAL}.VIEWHEIGHT // 2
							if player.deltaviewheight <= 0 then
								player.deltaviewheight := 1
							end
						end
						if player.deltaviewheight /= 0 then
							player.deltaviewheight := player.deltaviewheight + {M_FIXED}.FRACUNIT // 4
							if player.deltaviewheight = 0 then
								player.deltaviewheight := 1
							end
						end
					end
					player.viewz := mo.z + player.viewheight + bob
					if player.viewz > mo.ceilingz - 4 * {M_FIXED}.FRACUNIT then
						player.viewz := mo.ceilingz - 4 * {M_FIXED}.FRACUNIT
					end
				end
			end
		end

end
