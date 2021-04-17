note
	description: "[
		seg_t from r_defs.h
		
		The LineSeg.
	]"

class
	SEG_T

create
	make

feature

	make
		do
			create sidedef
			create v1
			create v2
		end

feature

	v1: VERTEX_T

	v2: VERTEX_T

	offset: FIXED_T

	angle: ANGLE_T

	sidedef: SIDE_T

	linedef: detachable LINE_T

		-- Sector references.
		-- Could be retrieved from linedef, too.
		-- backsector is NULL for one sided lines

	frontsector: detachable SECTOR_T

	backsector: detachable SECTOR_T

end
