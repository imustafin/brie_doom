note
	description: "[
		p_switch.c
		Switches, buttons. Two-state animation. Exits.
	]"

class
	P_SWITCH

inherit

	STAIR_E

	PLATTYPE_E

	FLOOR_E

	VLDOOR_E

	CEILING_E

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	P_InitSwitchList
		do
				-- Stub
		end

	P_UseSpecialLine (thing: MOBJ_T; line: LINE_T; side: INTEGER): BOOLEAN
			-- Called when a thing uses a special line.
			-- Only the front sides of lines are usable.
		local
			returned: BOOLEAN
		do
				-- Err...
				-- Use the back sides of VERY SPECIAL lines...
			if side /= 0 then
				if line.special = 124 then
						-- Sliding door open&close
						-- UNUSED?
				else
					Result := False
					returned := True
				end
			end
			if not returned then
					-- Switches that other things can activate.
				if thing.player = Void then
						-- never open secret doors
					if line.flags & {DOOMDATA_H}.ML_SECRET /= 0 then
						Result := False
						returned := True
					end
					if not returned then
						if line.special = 1 -- MANUAL DOOR RAISE
							or line.special = 32 -- MANUAL BLUE
							or line.special = 33 -- MANUAL RED
							or line.special = 34 -- MANUAL YELLOW
						then
								-- nothing
						else
							Result := False
							returned := True
						end
					end
				end
			end
			if not returned then
					-- do something
				if -- MANUALS
					line.special = 1 -- Vertical Door
					or line.special = 26 -- Blue Door/Locked
					or line.special = 27 -- Yellow Door /Locked
					or line.special = 27 -- Red Door /Locked
						--
					or line.special = 31 -- Manual door open
					or line.special = 32 -- Blue locked door open
					or line.special = 33 -- Red locked door open
					or line.special = 34 -- Yellow locked door open
						--
					or line.special = 117 -- Blazing door raise
					or line.special = 118 -- Blazing door open
				then
					{P_DOORS}.EV_VerticalDoor (line, thing)
				elseif -- SWITCHES
					line.special = 7
				then
					if {P_FLOOR}.EV_BuildStairs (line, build8) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 9 then
						-- Change Donut
					if {P_SPEC}.EV_DoDonut (line) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 11 then
						-- Exit level
					P_ChangeSwitchTexture (line, 0)
					i_main.g_game.G_ExitLevel
				elseif line.special = 14 then
						-- Raise Floor 32 and change texture
					if {P_PLATS}.EV_DoPlat (line, raiseAndChange, 32) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 15 then
						-- Raise Floor 24 and change texture
					if {P_PLATS}.EV_DoPlat (line, raiseAndChange, 24) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 18 then
						-- Raise Floor to next highest floor
					if {P_FLOOR}.EV_DoFloor (line, raiseFloorToNearest) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 20 then
						-- Raise Plat next highest floor and change texture
					if {P_PLATS}.EV_DoPlat (line, raiseToNearestAndChange, 0) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 21 then
						-- PlatDownWaitUpStay
					if {P_PLATS}.EV_DoPlat (line, downWaitUpStay, 0) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 23 then
						-- Lower Floor to Lowest
					if {P_FLOOR}.EV_DoFloor (line, lowerFloorToLowest) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 29 then
						-- Raise Door
					if {P_DOORS}.EV_DoDoor (line, normal) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 41 then
						-- Lower Ceiling to Floor
					if {P_CEILNG}.EV_DoCeiling (line, lowerToFloor) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 71 then
						-- Turbo Lower Floor
					if {P_FLOOR}.EV_DoFloor (line, turboLower) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 49 then
						-- Ceiling Crush and Raise
					if {P_CEILNG}.EV_DoCeiling (line, crushAndRaise) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 50 then
						-- Close Door
					if {P_DOORS}.EV_DoDoor (line, close) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 51 then
						-- Secret EXIT
					P_ChangeSwitchTexture (line, 0)
					i_main.g_game.G_SecretExitLevel
				elseif line.special = 55 then
						-- Raise Floor Crush
					if {P_FLOOR}.EV_DoFloor (line, raiseFloorCrush) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 101 then
						-- Raise Floor
					if {P_FLOOR}.EV_DoFloor (line, raiseFloor) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 102 then
						-- Lower Floor to Surrounding floor height
					if {P_FLOOR}.EV_DoFloor (line, lowerFloor) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 103 then
						-- Open Door
					if {P_DOORS}.EV_DoDoor (line, open) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 111 then
						-- Blazing Door Raise (faster than TURBO!)
					if {P_DOORS}.EV_DoDoor (line, blazeRaise) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 112 then
						-- Blazing Door Open (faster than TURBO!)
					if {P_DOORS}.EV_DoDoor (line, blazeOpen) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 113 then
						-- Blazing Door Close (faster than TURBO!)
					if {P_DOORS}.EV_DoDoor (line, blazeClose) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 122 then
						-- Blazing PlatDownWaitUpStay
					if {P_PLATS}.EV_DoPlat (line, blazeDWUS, 0) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 127 then
						-- Build Stairs Turbo 16
					if {P_FLOOR}.EV_BuildStairs (line, turbo16) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 131 then
						-- Raise Floor Turbo
					if {P_FLOOR}.EV_DoFloor (line, raiseFloorTurbo) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 133 or line.special = 135 or line.special = 137 then
						-- BlzOpenDoor {BLUE, RED, YELLOW}
					if {P_DOORS}.EV_DoLockedDoor (line, blazeOpen, thing) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif line.special = 140 then
						-- Raise Floor 512
					if {P_FLOOR}.EV_DoFloor (line, raiseFloor512) then
						P_ChangeSwitchTexture (line, 0)
					end
				elseif -- BUTTONS
					line.special = 42
				then
						-- Close Door
					if {P_DOORS}.EV_DoDoor (line, close) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 43 then
						-- Lower Ceiling to Floor
					if {P_CEILNG}.EV_DoCeiling (line, lowerToFloor) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 45 then
						-- Lower Floor to Surrounding floor height
					if {P_FLOOR}.EV_DoFloor (line, lowerFloor) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 60 then
						-- Lower Floor to Lowest
					if {P_FLOOR}.EV_DoFloor (line, lowerFloorToLowest) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 61 then
						-- Open Door
					if {P_DOORS}.EV_DoDoor (line, open) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 62 then
						-- PlatDownWaitUpStay
					if {P_PLATS}.EV_DoPlat (line, downWaitUpStay, 1) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 63 then
						-- Raise Door
					if {P_DOORS}.EV_DoDoor (line, normal) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 64 then
						-- Raise Floor to ceiling
					if {P_FLOOR}.EV_DoFloor (line, raiseFloor) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 66 then
						-- Raise Floor 24 and change texture
					if {P_PLATS}.EV_DoPlat (line, raiseAndChange, 24) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 67 then
						-- Raise Floor 32 and change texture
					if {P_PLATS}.EV_DoPlat (line, raiseAndChange, 32) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 65 then
						-- Raise Floor Crush
					if {P_FLOOR}.EV_DoFloor (line, raiseFloorCrush) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 68 then
						-- Raise Plat to next highest floor and change texture
					if {P_PLATS}.EV_DoPlat (line, raiseToNearestAndChange, 0) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 69 then
						-- Raise Floor to next highest floor
					if {P_FLOOR}.EV_DoFloor (line, raiseFloorToNearest) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 70 then
						-- Turbo Lower Floor
					if {P_FLOOR}.EV_DoFloor (line, turbolower) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 114 then
						-- Blazing Door Raise (faster than TURBO!)
					if {P_DOORS}.EV_DoDoor (line, blazeRaise) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 115 then
						-- Blazing Door Open (faster than TURBO!)
					if {P_DOORS}.EV_DoDoor (line, blazeOpen) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 116 then
						-- Blazing Door Close (faster than TURBO!)
					if {P_DOORS}.EV_DoDoor (line, blazeClose) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 123 then
						-- Blazing PlatDownWaitUpStay
					if {P_PLATS}.EV_DoPlat (line, blazeDWUS, 0) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 132 then
						-- Raise Floor Turbo
					if {P_FLOOR}.EV_DoFloor (line, raiseFloorTurbo) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 99 or line.special = 134 or line.special = 136 then
						-- BlzOpenDoor {BLUE, RED, YELLOW}
					if {P_DOORS}.EV_DoLockedDoor (line, blazeOpen, thing) then
						P_ChangeSwitchTexture (line, 1)
					end
				elseif line.special = 138 then
						-- Light Turn On
					{P_LIGHTS}.EV_LightTurnOn (line, 255)
					P_ChangeSwitchTexture (line, 1)
				elseif line.special = 139 then
						-- Light Turn Off
					{P_LIGHTS}.EV_LightTurnOn (line, 35)
					P_ChangeSwitchTexture (line, 1)
				end
			end
			if not returned then
				Result := True
			end
		end

	P_ChangeSwitchTexture (line: LINE_T; useAgain: INTEGER)
			-- Function that changes wall texture
			-- Tell it if switch is ok to use again (1=yes, it's a button).
		do
			{I_MAIN}.i_error ("P_ChangeSwitchTexture not implemented")
		end

end
