note
	description: "[
		seg_t from r_defs.h
		
		The LineSeg.
	]"
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
	SEG_T

create
	make, from_pointer

feature

	make
		do
			create sidedef
			create v1
			create v2
			create linedef.make
		end

feature

	v1: VERTEX_T

	v2: VERTEX_T

	offset: FIXED_T

	angle: ANGLE_T

	sidedef: SIDE_T

	linedef: LINE_T

		-- Sector references.
		-- Could be retrieved from linedef, too.
		-- backsector is NULL for one sided lines

	frontsector: detachable SECTOR_T

	backsector: detachable SECTOR_T

feature

	from_pointer (m: MANAGED_POINTER; a_offset: INTEGER; i_main: I_MAIN)
		local
			side: INTEGER_16
			ldef: LINE_T
		do
			v1 := i_main.p_setup.vertexes [m.read_integer_16_le (a_offset)]
			v2 := i_main.p_setup.vertexes [m.read_integer_16_le (a_offset + 2)]
			angle := m.read_integer_16_le (a_offset + 4).to_natural_32 |<< 16
			offset := m.read_integer_16_le (a_offset + 10).to_integer_32 |<< 16
			ldef := i_main.p_setup.lines [m.read_integer_16_le (a_offset + 6)]
			linedef := ldef
			side := m.read_integer_16_le (a_offset + 8)
			sidedef := i_main.p_setup.sides [ldef.sidenum [side]]
			frontsector := i_main.p_setup.sides [ldef.sidenum [side]].sector
			if ldef.flags & {DOOMDATA_H}.ML_TWOSIDED /= 0 then
				backsector := i_main.p_setup.sides [ldef.sidenum [side.bit_xor (1)]].sector
			else
				backsector := Void
			end
		end

	structure_size: INTEGER = 12

end
