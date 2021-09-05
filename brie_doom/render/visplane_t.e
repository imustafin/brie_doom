note
	description: "visplane_t from r_defs.h"

class
	VISPLANE_T

create
	make

feature

	make
		do
			create top.make_filled (0, -1, {DOOMDEF_H}.screenwidth)
			create bottom.make_filled (0, -1, {DOOMDEF_H}.screenwidth)
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

		-- Here lies the rub for all
		-- dynamic resize/change of resolution

		-- pads for [minx-1]/[maxx+1] are in array (lower = -1)

	top: ARRAY [NATURAL_8]

	bottom: ARRAY [NATURAL_8]

invariant
	top_has_pad_plus_minus_1: top.lower = -1 and top.count = {DOOMDEF_H}.SCREENWIDTH + 2
	bottom_has_pad_plus_minus_1: bottom.lower = -1 and bottom.count = {DOOMDEF_H}.SCREENWIDTH + 2

end
