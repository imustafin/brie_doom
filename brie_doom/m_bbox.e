note
	description: "[
		m_bbox.c
		Main loop menu stuff.
		Random number LUT.
		Default Config File.
		PCX Screenshots.
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
	M_BBOX

feature

	make
		do
		end

feature -- bbox coordinates

	BOXTOP: INTEGER = 0

	BOXBOTTOM: INTEGER = 1

	BOXLEFT: INTEGER = 2

	BOXRIGHT: INTEGER = 3

feature

	M_AddToBox (box: ARRAY [FIXED_T]; x, y: FIXED_T)
		do
			if x < box [BOXLEFT] then
				box [BOXLEFT] := x
			elseif x > box [BOXRIGHT] then
				box [BOXRIGHT] := x
			end
			if y < box [BOXBOTTOM] then
				box [BOXBOTTOM] := y
			elseif y > box [BOXTOP] then
				box [BOXTOP] := y
			end
		ensure
			instance_free: class
		end

	M_ClearBox (box: ARRAY [FIXED_T])
		do
			box [BOXTOP] := {DOOMTYPE_H}.minint
			box [BOXRIGHT] := {DOOMTYPE_H}.minint
			box [BOXBOTTOM] := {DOOMTYPE_H}.maxint
			box [BOXLEFT] := {DOOMTYPE_H}.maxint
		ensure
			instance_free: class
		end

end
