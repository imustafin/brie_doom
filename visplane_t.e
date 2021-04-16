note
	description: "visplane_t from r_defs.h"

class
	VISPLANE_T

create
	make

feature

	make
		do
			create top.make_filled (0, 0, {DOOMDEF_H}.screenwidth - 1)
			create bottom.make_filled (0, 0, {DOOMDEF_H}.screenwidth - 1)
		end

feature

	height: FIXED_T assign set_height

	set_height (a_height: like height)
		do
			height := a_height
		end

	picnum: INTEGER assign set_picnum

	set_picnum (a_picnum: like picnum)
		do
			picnum := a_picnum
		end

	lightlevel: INTEGER assign set_lightlevel

	set_lightlevel (a_lightlevel: like lightlevel)
		do
			lightlevel := a_lightlevel
		end

	minx: INTEGER assign set_minx

	set_minx (a_minx: like minx)
		do
			minx := a_minx
		end

	maxx: INTEGER assign set_maxx

	set_maxx (a_maxx: like maxx)
		do
			maxx := a_maxx
		end

		-- leave pads for [minx-1]/[maxx+1]

	pad: NATURAL_8

		-- Here lies the rub for all
		-- dynamic resize/change of resolution

	top: ARRAY [NATURAL_8]

	pad2: NATURAL_8

	pad3: NATURAL_8
			-- See above

	bottom: ARRAY [NATURAL_8]

	pad4: NATURAL_8

invariant
	top.count = {DOOMDEF_H}.SCREENWIDTH
	top.lower = 0
	bottom.count = {DOOMDEF_H}.SCREENWIDTH
	bottom.lower = 0

end
