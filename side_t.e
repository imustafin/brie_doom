note
	description: "[
		side_t from r_defs.h
		
		The SideDef.
	]"

class
	SIDE_T

feature

	textureoffset: FIXED_T
			-- add this to the calculated texture column

	rowoffset: FIXED_T
			-- add this to the calculated texture top

	toptexture: INTEGER_16

	bottomtexture: INTEGER_16

	midtexture: INTEGER_16

	sector: detachable SECTOR_T
			-- Sector the SideDef is facing.

end
