note
	description: "line_t from r_defs.h"

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
		end

feature

	v1: VERTEX_T -- from v1

	v2: VERTEX_T -- to v2

	dx: FIXED_T -- precalculated v2 - v1 for side checking

	dy: FIXED_T -- precalculated v2 - v1 for side checking

	flags: INTEGER_16 -- Animation related

	special: INTEGER_16 -- Animation related

	tag: INTEGER_16 -- Animation related

	sidenum: detachable ARRAY [INTEGER_16]
			-- Visual appearance: SideDefs.
			-- sidenum[1] will be -1 if one sided

	bbox: ARRAY [FIXED_T]
			-- Neat. Another bounding box, for the extent
			-- of the LineDef

	slopetype: INTEGER
			-- (slopetype_t) To aid move clipping.

	frontsector: detachable SECTOR_T

	backsector: detachable SECTOR_T

	validcount: INTEGER
			-- if == validcount, already checked

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
					frontsector := Void
				end
			end
		end

	structure_size: INTEGER = 14

invariant
	attached sidenum as sn implies sn.count = 2
	bbox.count = 4
	bbox.lower = 0

end
