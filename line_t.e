note
	description: "line_t from r_defs.h"

class
	LINE_T

feature

	v1: detachable VERTEX_T -- from v1

	v2: detachable VERTEX_T -- to v2

	dx: FIXED_T -- precalculated v2 - v1 for side checking

	dy: FIXED_T -- precalculated v2 - v1 for side checking

	flags: INTEGER_16 -- Animation related

	special: INTEGER_16 -- Animation related

	tag: INTEGER_16 -- Animation related

	sidenum: detachable ARRAY [INTEGER_16]
			-- Visual appearance: SideDefs.
			-- sidenum[1] will be -1 if one sided

	bbox: detachable ARRAY [FIXED_T]
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

invariant
	attached sidenum as sn implies sn.count = 2
	attached bbox as bb implies bb.count = 4

end
