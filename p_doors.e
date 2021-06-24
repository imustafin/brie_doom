note
	description: "[
		p_doors.c
		
		Door animation code (opening/closing)
	]"

class
	P_DOORS

inherit

	VLDOOR_E

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	EV_VerticalDoor (line: LINE_T; thing: MOBJ_T)
			-- open a door manually, no tag value
		local
			player: PLAYER_T
			sec: SECTOR_T
			door: VLDOOR_T
			side: INTEGER
			returned: BOOLEAN
		do
			side := 0 -- only front sides can be used

				-- Check for locks
			player := thing.player
			if line.special = 26 or line.special = 32 then
					-- Blue Lock
				if attached player then
					if not player.cards [{CARD_T}.it_bluecard] and not player.cards [{CARD_T}.it_blueskull] then
						player.message := {D_ENGLSH}.PD_BLUEK
						i_main.s_sound.S_StartSound (Void, {SFXENUM_T}.sfx_oof)
						returned := True
					end
				else
					returned := True
				end
			end
			if not returned and (line.special = 27 or line.special = 34) then
					-- Yellow Lock
				if attached player then
					if not player.cards [{CARD_T}.it_yellowcard] and not player.cards [{CARD_T}.it_yellowskull] then
						player.message := {D_ENGLSH}.PD_YELLOWK
						i_main.s_sound.S_StartSound (Void, {SFXENUM_T}.sfx_oof)
						returned := True
					end
				else
					returned := True
				end
			end
			if not returned and (line.special = 28 or line.special = 33) then
				if attached player then
					if not player.cards [{CARD_T}.it_redcard] and not player.cards [{CARD_T}.it_redskull] then
						player.message := {D_ENGLSH}.PD_REDK
						i_main.s_sound.S_StartSound (Void, {SFXENUM_T}.sfx_oof)
						returned := True
					end
				else
					returned := True
				end
			end
			if not returned then
					-- if the sector has an active thinker, use it
				sec := i_main.p_setup.sides [line.sidenum [side.bit_xor (1)]].sector
				check attached sec as s then
					if attached s.specialdata as sd then
						check attached {VLDOOR_T} s.specialdata as ddd then
							door := ddd
						end
						if line.special = 1 or line.special = 26 or line.special = 27 or line.special = 28 or line.special = 117 then
								-- ONLY FOR "RAISE" DOORS, NOT "OPEN"S
							if door.direction = -1 then
								door.direction := 1 -- go back up
							else
								if thing.player = Void then
									returned := True -- JDC: bad guys never close doors
								else
									door.direction := -1
								end
							end
							returned := True
						end
					end
				end
			end
			if not returned then
					-- for proper sound
				check attached sec as s then
					if line.special = 117 or line.special = 118 then
							-- BLAZING DOOR {RAISE, OPEN}
						i_main.s_sound.S_StartSound (s.soundorg, {SFXENUM_T}.sfx_bdopn)
					elseif line.special = 1 or line.special = 31 then
							-- NORMAL DOOR SOUND
						i_main.s_sound.S_StartSound (s.soundorg, {SFXENUM_T}.sfx_doropn)
					else
							-- LOCKED DOOR SOUND
						i_main.s_sound.S_StartSound (s.soundorg, {SFXENUM_T}.sfx_doropn)
					end
				end
			end
			if not returned then
				check attached sec then
					create door.make(sec)
					i_main.p_tick.P_AddThinker (door)
					sec.specialdata := door
					door.thinker.function := agent T_VerticalDoor(door)
					door.direction := 1
					door.speed := {P_SPEC}.VDOORSPEED
					door.topwait := {P_SPEC}.VDOORWAIT
					if line.special = 1 or line.special = 26 or line.special = 27 or line.special = 28 then
						door.type := normal
					elseif line.special = 31 or line.special = 32 or line.special = 33 or line.special = 34 then
						door.type := open
						line.special := 0
					elseif line.special = 117 then
							-- blazing door raise
						door.type := blazeRaise
						door.speed := {P_SPEC}.VDOORSPEED * 4
					elseif line.special = 118 then
							-- blazing door open
						door.type := blazeOpen
						line.special := 0
						door.speed := {P_SPEC}.VDOORSPEED * 4
					end

						-- find the top and bottom of the movement range
					door.topheight := i_main.p_spec.P_FindLowestCeilingSurrounding (sec)
					door.topheight := door.topheight - (4 * {M_FIXED}.FRACUNIT)
				end
			end
		end

	EV_DoDoor (line: LINE_T; type: INTEGER): BOOLEAN
		do
			{I_MAIN}.i_error ("EV_DoDoor not implemented")
		ensure
			instance_free: class
		end

	EV_DoLockedDoor (line: LINE_T; type: INTEGER; thing: MOBJ_T): BOOLEAN
			-- Move a locked door up/down
		do
			{I_MAIN}.i_error ("EV_DoLockedDoor not implemented")
		ensure
			instance_free: class
		end

	T_VerticalDoor (door: VLDOOR_T)
		local
			res: RESULT_E
		do
			if door.direction = 0 then
					-- WAITING
				door.topcountdown := door.topcountdown - 1
				if door.topcountdown /= 0 then
					if door.type = blazeRaise then
						door.direction := -1 -- time to go back down
						i_main.s_sound.s_startsound (door.sector.soundorg, {SFXENUM_T}.sfx_bdcls)
					elseif door.type = normal then
						door.direction := -1 -- time to go back down
						i_main.s_sound.s_startsound (door.sector.soundorg, {SFXENUM_T}.sfx_dorcls)
					elseif door.type = close30ThenOpen then
						door.direction := 1
						i_main.s_sound.s_startsound (door.sector.soundorg, {SFXENUM_T}.sfx_doropn)
					end
				end
			elseif door.direction = 2 then
					-- INITIAL WAIT
				door.topcountdown := door.topcountdown - 1
				if door.topcountdown /= 0 then
					if door.type = raiseIn5Mins then
						door.direction := 1
						door.type := normal
						i_main.s_sound.s_startsound (door.sector.soundorg, {SFXENUM_T}.sfx_doropn)
					end
				end
			elseif door.direction = -1 then
					-- DOWN
				res := i_main.p_floor.T_MovePlane (door.sector, door.speed, door.sector.floorheight, False, 1, door.direction)
				if res = {RESULT_E}.pastdest then
					if door.type = blazeRaise or door.type = blazeClose then
						door.sector.specialdata := Void
						i_main.p_tick.p_removethinker (door) -- unlink and free
						i_main.s_sound.s_startsound (door.sector.soundorg, {SFXENUM_T}.sfx_bdcls)
					elseif door.type = normal or door.type = close then
						door.sector.specialdata := Void
						i_main.p_tick.p_removethinker (door)
					elseif door.type = close30ThenOpen then
						door.direction := 0
						door.topcountdown := 35 * 30
					end
				elseif res = {RESULT_E}.crushed then
					if door.type = blazeClose or door.type = close then
							-- DO NOT GO BACK UP!
					else
						door.direction := 1
						i_main.s_sound.s_startsound (door.sector.soundorg, {SFXENUM_T}.sfx_doropn)
					end
				end
			elseif door.direction = 1 then
				res := i_main.p_floor.T_MovePlane (door.sector, door.speed, door.topheight, False, 1, door.direction)
				if res = {RESULT_E}.pastdest then
					if door.type = blazeRaise or door.type = normal then
						door.direction := 0 -- wait at top
						door.topcountdown := door.topwait
					elseif door.type = close30ThenOpen or door.type = blazeOpen or door.type = open then
						door.sector.specialdata := Void
						i_main.p_tick.p_removethinker (door) -- unlink and free
					end
				end
			end
		end

end
