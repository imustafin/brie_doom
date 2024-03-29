note
	description: "line_t from r_defs.h"
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
	LINE_T

create
	make, from_pointer

feature

	make
		do
			create bbox.make_filled (0, 0, 3)
			create v1.default_create
			create v2.default_create
			create sidenum.make_filled (0, 0, 1)
		end

feature

	v1: VERTEX_T -- from v1

	v2: VERTEX_T -- to v2

	dx: FIXED_T -- precalculated v2 - v1 for side checking

	dy: FIXED_T -- precalculated v2 - v1 for side checking

	flags: INTEGER_16 assign set_flags -- Animation related

	set_flags (a_flags: like flags)
		do
			flags := a_flags
		end

	special: INTEGER_16 assign set_special -- Animation related

	set_special (a_special: like special)
		do
			special := a_special
		end

	tag: INTEGER_16 -- Animation related

	sidenum: ARRAY [INTEGER_16]
			-- Visual appearance: SideDefs.
			-- sidenum[1] will be -1 if one sided

	bbox: ARRAY [FIXED_T]
			-- Neat. Another bounding box, for the extent
			-- of the LineDef

	slopetype: INTEGER
			-- (slopetype_t) To aid move clipping.

	frontsector: detachable SECTOR_T

	backsector: detachable SECTOR_T

	validcount: INTEGER assign set_validcount
			-- if == validcount, already checked

	set_validcount (a_validcount: like validcount)
		do
			validcount := a_validcount
		end

	specialdata: detachable ANY
			-- thinker_t for reversable actions

feature

	from_pointer (m: MANAGED_POINTER; offset: INTEGER; i_main: I_MAIN)
		local
			sn: ARRAY [INTEGER_16]
		do
			create bbox.make_filled (0, 0, 3)
			v1 := i_main.p_setup.vertexes [m.read_integer_16_le (offset)]
			v2 := i_main.p_setup.vertexes [m.read_integer_16_le (offset + 2)]
			dx := v2.x - v1.x
			dy := v2.y - v1.y
			if dx = 0 then
				slopetype := {R_DEFS}.ST_VERTICAL
			elseif dy = 0 then
				slopetype := {R_DEFS}.ST_HORIZONTAL
			else
				if {M_FIXED}.fixeddiv (dy, dx) > 0 then
					slopetype := {R_DEFS}.ST_POSITIVE
				else
					slopetype := {R_DEFS}.ST_NEGATIVE
				end
			end
			if v1.x < v2.x then
				bbox [{M_BBOX}.BOXLEFT] := v1.x
				bbox [{M_BBOX}.BOXRIGHT] := v2.x
			else
				bbox [{M_BBOX}.BOXLEFT] := v2.x
				bbox [{M_BBOX}.BOXRIGHT] := v1.x
			end
			if v1.y < v2.y then
				bbox [{M_BBOX}.BOXBOTTOM] := v1.y
				bbox [{M_BBOX}.BOXTOP] := v2.y
			else
				bbox [{M_BBOX}.BOXBOTTOM] := v2.y
				bbox [{M_BBOX}.BOXTOP] := v1.y
			end
			flags := m.read_integer_16_le (offset + 4)
			special := m.read_integer_16_le (offset + 6)
			tag := m.read_integer_16_le (offset + 8)
			create sn.make_filled (0, 0, 1)
			sn [0] := m.read_integer_16_le (offset + 10)
			sn [1] := m.read_integer_16_le (offset + 12)
			sidenum := sn
			if sn [0] /= -1 then
				frontsector := i_main.p_setup.sides [sn [0]].sector
			else
				frontsector := Void
			end
			if sn [1] /= -1 then
				backsector := i_main.p_setup.sides [sn [1]].sector
			else
				backsector := Void
			end
		end

	structure_size: INTEGER = 14

invariant
	sidenum.count = 2
	sidenum.lower = 0
	bbox.count = 4
	bbox.lower = 0

end
