note
	description: "drawseg_t from r_defs.h"

class
	DRAWSEG_T

create
	make

feature

	make
		do
			create sprtopclip.make_empty
			create sprbottomclip.make_empty
			create maskedtexturecolor.make_empty
		end

feature

	curline: detachable SEG_T

	x1: INTEGER

	x2: INTEGER

	scale1: FIXED_T

	scale2: FIXED_T

	scalestep: FIXED_T

	silhouette: INTEGER
			-- 0=none, 1=bottom, 2=top, 3=both

	bsilheight: FIXED_T
			-- do not clip sprites above this

	tsilheight: FIXED_T
			-- do not clip sprites below this

		-- Pointers to lists for sprite clipping
		-- all three adjusted so [x1] is first value

	sprtopclip: ARRAY [INTEGER_16]

	sprbottomclip: ARRAY [INTEGER_16]

	maskedtexturecolor: ARRAY [INTEGER_16]

end
