note
	description: "[
		p_floor.c
		
		Floor animation: raising stairs.
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
	P_FLOOR

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	EV_BuildStairs (line: LINE_T; type: INTEGER): BOOLEAN
			-- BUILD A STAIRCASE!
		do
			{I_MAIN}.i_error ("EV_BuildStairs not implemented")
		ensure
			instance_free: class
		end

	EV_DoFloor (line: LINE_T; type: INTEGER): BOOLEAN
			-- HANDLE FLOOR TYPES
		do
			{I_MAIN}.i_error ("EV_DoFloor not implemented")
		ensure
			instance_free: class
		end

	T_MovePlane (sector: SECTOR_T; speed, dest: FIXED_T; crush: BOOLEAN; floorOrCeiling, direction: INTEGER): RESULT_E
			-- Move a plane (floor or ceiling) and check for crushing
		local
			flag: BOOLEAN
			lastpos: FIXED_T
			returned: BOOLEAN
		do
			if floororceiling = 0 then
					-- FLOOR
				if direction = -1 then
						-- DOWN
					if sector.floorheight - speed < dest then
						lastpos := sector.floorheight
						sector.floorheight := dest
						flag := i_main.p_map.P_ChangeSector (sector, crush)
						if flag then
							sector.floorheight := lastpos
							i_main.p_map.P_ChangeSector (sector, crush).do_nothing
						end
						Result := {RESULT_E}.pastdest
						returned := True
					else
						lastpos := sector.floorheight
						sector.floorheight := sector.floorheight - speed
						flag := i_main.p_map.P_ChangeSector (sector, crush)
						if flag then
							sector.floorheight := lastpos
							i_main.p_map.P_ChangeSector (sector, crush).do_nothing
							Result := {RESULT_E}.crushed
							returned := True
						end
					end
				elseif direction = 1 then
						-- UP
					if sector.floorheight + speed > dest then
						lastpos := sector.floorheight
						sector.floorheight := dest
						flag := i_main.p_map.P_ChangeSector (sector, crush)
						if flag then
							sector.floorheight := lastpos
							i_main.p_map.P_ChangeSector (sector, crush).do_nothing
						end
						Result := {RESULT_E}.pastdest
						returned := True
					else
							-- COULD GET CRUSHED
						lastpos := sector.floorheight
						sector.floorheight := sector.floorheight + speed
						flag := i_main.p_map.P_ChangeSector (sector, crush)
						if flag then
							if not crush then
								sector.floorheight := lastpos
								i_main.p_map.P_ChangeSector (sector, crush).do_nothing
							end
							Result := {RESULT_E}.crushed
							returned := True
						end
					end
				end
			elseif floororceiling = 1 then
					-- CEILING
				if direction = -1 then
						-- DOWN
					if sector.ceilingheight - speed < dest then
						lastpos := sector.ceilingheight
						sector.ceilingheight := dest
						flag := i_main.p_map.P_ChangeSector (sector, crush)
						if flag then
							sector.ceilingheight := lastpos
							i_main.p_map.P_ChangeSector (sector, crush).do_nothing
						end
						Result := {RESULT_E}.pastdest
						returned := True
					else
							-- COULD GET CRUSHED
						lastpos := sector.ceilingheight
						sector.ceilingheight := sector.ceilingheight - speed
						flag := i_main.p_map.P_ChangeSector (sector, crush)
						if flag then
							if not crush then
								sector.ceilingheight := lastpos
								i_main.p_map.P_ChangeSector (sector, crush).do_nothing
							end
							Result := {RESULT_E}.crushed
							returned := True
						end
					end
				elseif direction = 1 then
						-- UP
					if sector.ceilingheight + speed > dest then
						lastpos := sector.ceilingheight
						sector.ceilingheight := dest
						flag := i_main.p_map.P_ChangeSector (sector, crush)
						if flag then
							sector.ceilingheight := lastpos
							i_main.p_map.P_ChangeSector (sector, crush).do_nothing
						end
						Result := {RESULT_E}.pastdest
						returned := True
					else
						lastpos := sector.ceilingheight
						sector.ceilingheight := sector.ceilingheight + speed
						flag := i_main.p_map.P_ChangeSector (sector, crush)
					end
				end
			end
			if not returned then
				Result := {RESULT_E}.ok
			end
		end

end
