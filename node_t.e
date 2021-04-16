note
	description: "[
		node_t from r_defs.h
		
		BSP node.
	]"

class
	NODE_T

create
	make

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
