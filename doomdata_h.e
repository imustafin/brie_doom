note
	description: "[
		doomdata.h
		all external data is defined here
		most of the data is loaded into different structures at run time
		some internal structures shared by many modules are here
	]"

class
	DOOMDATA_H

feature -- ML enum

	ML_LABEL: INTEGER = 0 -- A separator, name, ExMx or MAPxx

	ML_THINGS: INTEGER = 1 -- Monsters, items...

	ML_LINEDEFS: INTEGER = 2 -- LineDefs, from editing

	ML_SIDEDEFS: INTEGER = 3 -- SideDefs, from editing

	ML_VERTEXES: INTEGER = 4 -- Vertices, edited and BSP splits generated

	ML_SEGS: INTEGER = 5 -- LineSegs, from LineDefs split by BSP

	ML_SSECTORS: INTEGER = 6 -- SubSectors, list of LineSegs

	ML_NODES: INTEGER = 7 -- BSP nodes

	ML_SECTORS: INTEGER = 8 -- Sectors, from editing

	ML_REJECT: INTEGER = 9 -- LUT, sector-sector visibility

	ML_BLOCKMAP: INTEGER = 10 -- LUT, motion clipping, walls/grid element

end
