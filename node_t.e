note
	description: "[
		node_t from r_defs.h
		
		BSP node.
	]"

class
	NODE_T

feature
	-- Partition line

	x: FIXED_T

	y: FIXED_T

	dx: FIXED_T

	dy: FIXED_T

	bbox: detachable ARRAY [ARRAY [FIXED_T]] -- [2][4]
			-- Bounding box for each child.

	children: detachable ARRAY [NATURAL_16] -- [2]
			-- If NF_SUBSECTOR its a subsector

end
