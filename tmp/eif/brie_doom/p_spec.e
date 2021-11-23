note
	description: "[
		p_spec.c
		Implements special effects:
		Texture animation, height or lighting changes
		 according to adjacent sectors, respective
		 utility functions, etc.
		Line Tag handling. Line and Sector triggers.
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
	P_SPEC

create
	make

feature

	make
		do
		end

feature

	VDOORSPEED: INTEGER
		once
			Result := {M_FIXED}.fracunit * 2
		ensure
			instance_free: class
		end

	VDOORWAIT: INTEGER = 150

	MAXSWITCHES: INTEGER = 50
			-- max # of wall switches in a level

	MAXBUTTONS: INTEGER = 16
			-- 4 players, 4 buttons each at once, max.

	BUTTONTIME: INTEGER = 35
			-- 1 second, in ticks.

feature

	P_InitPicAnims
		do
			{NOT_IMPLEMENTED}.not_implemented ("P_InitPicAnims", False)
		end

	P_SpawnSpecials
		do
			{NOT_IMPLEMENTED}.not_implemented ("P_SpawnSpecials", False)
		end

	P_UpdateSpecials
			-- Animate planes, scroll walls, etc.
		do
			{NOT_IMPLEMENTED}.not_implemented ("P_UpdateSpecials", False)
		end

	P_PlayerInSpecialSector (player: PLAYER_T)
			-- Called every tic frame
			-- that the player origin is in a special sector
		do
			{NOT_IMPLEMENTED}.not_implemented ("P_PlayerInSpecialSector", False)
		end

	P_CrossSpecialLine (linenum, side: INTEGER; thing: MOBJ_T)
			-- Called every time a thing origin is about
			-- to cross a line with a non 0 special
		do
			{NOT_IMPLEMENTED}.not_implemented ("P_CrossSpecialLine", False)
		end

	P_FindLowestCeilingSurrounding (sec: SECTOR_T): FIXED_T
		local
			i: INTEGER
			ch: LINE_T
			other: SECTOR_T
		do
			Result := {DOOMTYPE_H}.MAXINT
			from
				i := sec.lines.lower
			until
				i > sec.lines.upper
			loop
				ch := sec.lines [i]
				other := getNextSector (ch, sec)
				if attached other then
					if other.ceilingheight < Result then
						Result := other.ceilingheight
					end
				end
				i := i + 1
			end
		end

	getNextSector (line: LINE_T; sec: SECTOR_T): detachable SECTOR_T
			-- Return sector_t * of sector next to current.
			-- NULL if not two-sided line
		do
			if line.flags & {DOOMDATA_H}.ML_TWOSIDED = 0 then
				Result := Void
			else
				if line.frontsector = sec then
					Result := line.backsector
				else
					Result := line.frontsector
				end
			end
		end

	P_ShootSpecialLine (thing: MOBJ_T; line: LINE_T)
			-- IMPACT SPECIALS
			-- Called when a thing shoots a special line.
		do
			{NOT_IMPLEMENTED}.not_implemented ("P_ShootSpecialLine", false)
		end

feature -- Special Stuff that can not be categorized

	EV_DoDonut (line: LINE_T): BOOLEAN
		do
			{NOT_IMPLEMENTED}.not_implemented ("EV_DoDonut", true)
		ensure
			instance_free: class
		end

end
