note
	description: "[
		texture_t from r_data.c
		
		A maptexturedef_t describes a rectangular texture,
		which is composed of one or more mappatch_t structures
		that arrange graphic patches.
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
	TEXTURE_T

create
	make, make_from_maptexture_t

feature

	make
		do
			name := ""
			create patches.make_empty
		end

	make_from_maptexture_t (m: MAPTEXTURE_T; patchlookup: ARRAY [INTEGER])
		local
			i: INTEGER
		do
			width := m.width
			height := m.height
			name := m.name
			create patches.make_filled (create {TEXPATCH_T}, 0, m.patches.count - 1)
			from
				i := 0
			until
				i >= patches.count
			loop
				patches [i] := create {TEXPATCH_T}
				patches [i].originx := m.patches [i].originx
				patches [i].originy := m.patches [i].originy
				patches [i].patch := patchlookup [m.patches [i].patch]
				i := i + 1
			end
		end

feature

	name: STRING assign set_name
			-- Keep name for switch changing, etc.

	set_name (a_name: like name)
		do
			name := a_name
		end

	width: INTEGER_16 assign set_width

	set_width (a_width: like width)
		do
			width := a_width
		end

	height: INTEGER_16 assign set_height

	set_height (a_height: like height)
		do
			height := a_height
		end

		-- All the patches[patchcount]
		-- are drawn back to front into the cached texture.

	patches: ARRAY [TEXPATCH_T]

invariant
	name.count <= 8

end
