note
	description: "[
		node_t from r_defs.h
		
		BSP node.
	]"

class
	NODE_T

create
	make, from_pointer

feature

	make
		do
			create bbox.make_filled (create {ARRAY [FIXED_T]}.make_empty, 0, 1)
			bbox [0] := create {ARRAY [FIXED_T]}.make_filled (0, 0, 3)
			bbox [1] := create {ARRAY [FIXED_T]}.make_filled (0, 0, 3)
			create children.make_filled (0, 0, 1)
		end

feature
	-- Partition line

	x: FIXED_T

	y: FIXED_T

	dx: FIXED_T

	dy: FIXED_T

	bbox: ARRAY [ARRAY [FIXED_T]] -- [2][4]
			-- Bounding box for each child.

	children: ARRAY [NATURAL_16] -- [2]
			-- If NF_SUBSECTOR its a subsector

feature
	from_pointer(m: MANAGED_POINTER; offset: INTEGER)
		do
			-- partition line  from (x, y) to x+dx,y+dy)
			x := m.read_integer_16_le (offset).to_integer_32 |<< {M_FIXED}.fracbits
			y := m.read_integer_16_le (offset + 2).to_integer_32 |<< {M_FIXED}.fracbits
			dx := m.read_integer_16_le (offset + 4).to_integer_32 |<< {M_FIXED}.fracbits
			dy := m.read_integer_16_le (offset + 6).to_integer_32 |<< {M_FIXED}.fracbits

			create bbox.make_filled (create {ARRAY[FIXED_T]}.make_empty, 0, 1)
			bbox[0] := create {ARRAY [FIXED_T]}.make_filled (0, 0, 3)
			bbox[1] := create {ARRAY[FIXED_T]}.make_filled (0, 0, 3)
			bbox[0][0] := m.read_integer_16_le (offset + 8).to_integer_32 |<< {M_FIXED}.fracbits
			bbox[0][1] := m.read_integer_16_le (offset + 10).to_integer_32 |<< {M_FIXED}.fracbits
			bbox[0][2] := m.read_integer_16_le (offset + 12).to_integer_32 |<< {M_FIXED}.fracbits
			bbox[0][3] := m.read_integer_16_le (offset + 14).to_integer_32 |<< {M_FIXED}.fracbits
			bbox[1][0] := m.read_integer_16_le (offset + 16).to_integer_32 |<< {M_FIXED}.fracbits
			bbox[1][1] := m.read_integer_16_le (offset + 18).to_integer_32 |<< {M_FIXED}.fracbits
			bbox[1][2] := m.read_integer_16_le (offset + 20).to_integer_32 |<< {M_FIXED}.fracbits
			bbox[1][3] := m.read_integer_16_le (offset + 22).to_integer_32 |<< {M_FIXED}.fracbits

			create children.make_filled (0, 0, 1)
			children[0] := m.read_natural_16_le (offset + 24)
			children[1] := m.read_natural_16_le (offset + 26)
		end

	structure_size: INTEGER = 28

invariant
	children.lower = 0
	children.count = 2
	bbox.lower = 0
	bbox.count = 2
	bbox [0].lower = 0
	bbox [0].count = 4
	bbox [1].lower = 0
	bbox [1].count = 4

end
