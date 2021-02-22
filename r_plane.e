note
	description: "[
		r_plane.c
		Here is a core component: drawing the floors and ceilings
		 while maintaining a per column clipping list only.
		Moreover, the sky areas have to be determined.
	]"

class
	R_PLANE

create
	make

feature

	make
		do
		end

feature

	R_InitPlanes
		do
				-- Doh!
		end

feature

	yslope: ARRAY [FIXED_T]
		once
			create Result.make_filled (0, 0, {DOOMDEF_H}.SCREENHEIGHT - 1)
		end

	distscale: ARRAY [FIXED_T]
		once
			create Result.make_filled (0, 0, {DOOMDEF_H}.SCREENWIDTH - 1)
		end

end
