note
	description: "visplane_t from r_defs.h"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
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
	VISPLANE_T

create
	make

feature

	make
		do
			create top.make_filled (0, -1, {DOOMDEF_H}.screenwidth)
			create bottom.make_filled (0, -1, {DOOMDEF_H}.screenwidth)
		end

feature

	height: FIXED_T assign set_height

	set_height (a_height: like height)
		do
			height := a_height
		end

	picnum: INTEGER assign set_picnum

	set_picnum (a_picnum: like picnum)
		do
			picnum := a_picnum
		end

	lightlevel: INTEGER assign set_lightlevel

	set_lightlevel (a_lightlevel: like lightlevel)
		do
			lightlevel := a_lightlevel
		end

	minx: INTEGER assign set_minx

	set_minx (a_minx: like minx)
		do
			minx := a_minx
		end

	maxx: INTEGER assign set_maxx

	set_maxx (a_maxx: like maxx)
		do
			maxx := a_maxx
		end

		-- Here lies the rub for all
		-- dynamic resize/change of resolution

		-- pads for [minx-1]/[maxx+1] are in array (lower = -1)

	top: ARRAY [NATURAL_8]

	bottom: ARRAY [NATURAL_8]

invariant
	top_has_pad_plus_minus_1: top.lower = -1 and top.count = {DOOMDEF_H}.SCREENWIDTH + 2
	bottom_has_pad_plus_minus_1: bottom.lower = -1 and bottom.count = {DOOMDEF_H}.SCREENWIDTH + 2

end
