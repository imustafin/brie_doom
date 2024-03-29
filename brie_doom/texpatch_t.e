note
	description: "[
		texpatch_t from r_data.c
		
		A single patch from a texture definition,
		basically a rectangular area within
		the texture rectangle.
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
	TEXPATCH_T

feature
	-- Block origin (allways UL),
	-- which has allready accounted
	-- for the internal origin of the patch.

	originx: INTEGER assign set_originx

	set_originx (a_originx: like originx)
		do
			originx := a_originx
		end

	originy: INTEGER assign set_originy

	set_originy (a_originy: like originy)
		do
			originy := a_originy
		end

	patch: INTEGER assign set_patch

	set_patch (a_patch: like patch)
		do
			patch := a_patch
		end

end
