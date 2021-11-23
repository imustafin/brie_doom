note
	description: "[
		doomdata.h
		all external data is defined here
		most of the data is loaded into different structures at run time
		some internal structures shared by many modules are here
	]"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
				Copyright (C) 2005-2014 Simon Howard
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

feature -- Other ML_ ????

	ML_TWOSIDED: INTEGER = 4
			-- Backside will not be present at all if not two sided.

	ML_MAPPED: INTEGER = 256
			-- Set if already seen, thus drawn in automap.

	ML_DONTPEGTOP: INTEGER = 8
			-- upper texture unpegged

	ML_DONTPEGBOTTOM: INTEGER = 16
			-- lower texture unpegged

	ML_SECRET: INTEGER = 32
			-- In AutoMap: don't map as two sided: IT'S A SECRET!

	ML_BLOCKING: INTEGER = 1
			-- Solid, is an obstacle

	ML_BLOCKMONSTERS: INTEGER = 2
			-- Blocks monsters only

	ML_SOUNDBLOCK: INTEGER = 64
			-- Sound rendering: don't let sound cross two of these

feature

	NF_SUBSECTOR: INTEGER = 0x8000

end
