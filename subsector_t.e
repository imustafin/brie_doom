note
	description: "[
		subsector_t from r_defs.h
		
		A SubSector.
		References a Sector.
		Basically, this is a list of LineSegs,
		indicating the visible walls that define
		(all or some) sides of a convex BSP leaf.
	]"

class
	SUBSECTOR_T

create
	make

feature

	make (a_sector: SECTOR_T)
		do
			sector := a_sector
		end

feature

	sector: SECTOR_T

	numlines: INTEGER_16

	firstline: INTEGER_16

end
