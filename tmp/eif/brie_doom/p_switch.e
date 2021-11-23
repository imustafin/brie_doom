note
	description: "[
		p_switch.c
		Switches, buttons. Two-state animation. Exits.
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
		local
			i: INTEGER
		do
			i_main := a_i_main
			create switchlist.make_filled (0, 0, {P_SPEC}.maxswitches * 2 - 1)
			create buttonlist.make_filled (create {BUTTON_T}, 0, {P_SPEC}.maxbuttons - 1)
			from
				i := buttonlist.lower
			until
				i > buttonlist.upper
			loop
				buttonlist [i] := create {BUTTON_T}
				i := i + 1
			end
		end

feature

	numswitches: INTEGER

	switchlist: ARRAY [INTEGER]

	buttonlist: ARRAY [BUTTON_T]

	alphSwitchList: ARRAY [TUPLE [name1: STRING; name2: STRING; episode: INTEGER]]
		once
			Result := <<
				-- Doom shareware episode 1 switches
			["SW1BRCOM", "SW2BRCOM", 1], ["SW1BRN1", "SW2BRN1", 1], ["SW1BRN2", "SW2BRN2", 1], ["SW1BRNGN", "SW2BRNGN", 1], ["SW1BROWN", "SW2BROWN", 1], ["SW1COMM", "SW2COMM", 1], ["SW1COMP", "SW2COMP", 1], ["SW1DIRT", "SW2DIRT", 1], ["SW1EXIT", "SW2EXIT", 1], ["SW1GRAY", "SW2GRAY", 1], ["SW1GRAY1", "SW2GRAY1", 1], ["SW1METAL", "SW2METAL", 1], ["SW1PIPE", "SW2PIPE", 1], ["SW1SLAD", "SW2SLAD", 1], ["SW1STARG", "SW2STARG", 1], ["SW1STON1", "SW2STON1", 1], ["SW1STON2", "SW2STON2", 1], ["SW1STONE", "SW2STONE", 1], ["SW1STRTN", "SW2STRTN", 1],

				-- Doom registered episodes 2&3 switches
 ["SW1BLUE", "SW2BLUE", 2], ["SW1CMT", "SW2CMT", 2], ["SW1GARG", "SW2GARG", 2], ["SW1GSTON", "SW2GSTON", 2], ["SW1HOT", "SW2HOT", 2], ["SW1LION", "SW2LION", 2], ["SW1SATYR", "SW2SATYR", 2], ["SW1SKIN", "SW2SKIN", 2], ["SW1VINE", "SW2VINE", 2], ["SW1WOOD", "SW2WOOD", 2],

				-- Doom II switches
 ["SW1PANEL", "SW2PANEL", 3], ["SW1ROCK", "SW2ROCK", 3], ["SW1MET2", "SW2MET2", 3], ["SW1WDMET", "SW2WDMET", 3], ["SW1BRIK", "SW2BRIK", 3], ["SW1MOD1", "SW2MOD1", 3], ["SW1ZIM", "SW2ZIM", 3], ["SW1STON6", "SW2STON6", 3], ["SW1TEK", "SW2TEK", 3], ["SW1MARB", "SW2MARB", 3], ["SW1SKULL", "SW2SKULL", 3], ["\0", "\0", 0]
				--
			>>
			Result.rebase (0)
		end

feature

	P_InitSwitchList
		local
			i: INTEGER
			index: INTEGER
			episode: INTEGER
			break: BOOLEAN
		do
			episode := 1
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.registered then
				episode := 2
			elseif i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
				episode := 3
			end
			from
				index := 0
				i := 0
			until
				break or i >= {P_SPEC}.MAXSWITCHES
			loop
				if alphSwitchList [i].episode = 0 then
					numswitches := index // 2
					switchlist [index] := -1
					break := True
				else
					if alphSwitchList [i].episode <= episode then
						switchlist [index] := i_main.r_data.R_TextureNumForName (alphSwitchList [i].name1)
						index := index + 1
						switchlist [index] := i_main.r_data.R_TextureNumForName (alphSwitchList [i].name2)
						index := index + 1
					end
				end
				i := i + 1
			end
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
					i_main.p_doors.EV_VerticalDoor (line, thing)
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
		local
			texTop: INTEGER
			texMid: INTEGER
			texBot: INTEGER
			i: INTEGER
			sound: INTEGER
			returned: BOOLEAN
		do
			if useAgain = 0 then
				line.special := 0
			end
			texTop := i_main.p_setup.sides [line.sidenum [0]].toptexture
			texMid := i_main.p_setup.sides [line.sidenum [0]].midtexture
			texBot := i_main.p_setup.sides [line.sidenum [0]].bottomtexture
			sound := {SFXENUM_T}.sfx_swtchn

				-- EXIT SWITCH?
			if line.special = 11 then
				sound := {SFXENUM_T}.sfx_swtchx
			end
			from
				i := 0
			until
				returned or i >= numswitches * 2
			loop
				i := i + 1
				if switchlist [i] = texTop then
					i_main.s_sound.s_startsound (buttonlist [0].soundorg, sound)
					i_main.p_setup.sides [line.sidenum [0]].midtexture := switchlist [i.bit_xor (1)].to_integer_16
					if useAgain /= 0 then
						P_StartButton (line, {BUTTON_T}.top, switchlist [i], {P_SPEC}.BUTTONTIME)
					end
					returned := True
				else
					if switchlist [i] = texMid then
						i_main.s_sound.s_startsound (buttonlist [0].soundorg, sound)
						i_main.p_setup.sides [line.sidenum [0]].midtexture := switchlist [i.bit_xor (1)].to_integer_16
						if useAgain /= 0 then
							P_StartButton (line, {BUTTON_T}.middle, switchlist [i], {P_SPEC}.BUTTONTIME)
						end
						returned := True
					else
						if switchlist [i] = texBot then
							i_main.s_sound.s_startsound (buttonlist [0].soundorg, sound)
							i_main.p_setup.sides [line.sidenum [0]].bottomtexture := switchlist [i.bit_xor (1)].to_integer_16
							if useAgain /= 0 then
								P_StartButton (line, {BUTTON_T}.bottom, switchlist [i], {P_SPEC}.BUTTONTIME)
							end
							returned := True
						end
					end
				end
			end
		end

	P_StartButton (line: LINE_T; w: INTEGER; texture, time: INTEGER)
			-- Start a button counting down till it turns off.
		local
			i: INTEGER
			returned: BOOLEAN
		do
				-- See if button is already pressed
			from
				i := 0
			until
				returned or i >= {P_SPEC}.MAXBUTTONS
			loop
				if buttonlist [i].btimer /= 0 and buttonlist [i].line = line then
					returned := True
				end
				i := i + 1
			end
			if not returned then
				from
					i := 0
				until
					returned or i >= {P_SPEC}.MAXBUTTONS
				loop
					if buttonlist [i].btimer = 0 then
						buttonlist [i].line := line
						buttonlist [i].where := w
						buttonlist [i].btexture := texture
						buttonlist [i].btimer := time
						check attached line.frontsector as fs then
							buttonlist [i].soundorg := fs.soundorg
						end
						returned := True
					end
					i := i + 1
				end
			end
			if not returned then
				{I_MAIN}.i_error ("P_StartButton: no button slots left!")
			end
		end

invariant
	switchlist.lower = 0 and switchlist.count = {P_SPEC}.MAXSWITCHES * 2
	{UTILS [BUTTON_T]}.invariant_ref_array (buttonlist, {P_SPEC}.MAXBUTTONS)

end
