note
	description: "[
		vissprite_t from r_defs.h
		
		A vissprite_t is a thing
		that will be drawn during a refresh.
		I.e. a sprite object that is partly visible.
	]"

class
	VISSPRITE_T

feature

	prev: detachable VISSPRITE_T assign set_prev

	set_prev (a_prev: like prev)
		do
			prev := a_prev
		end

	next: detachable VISSPRITE_T assign set_next

	set_next (a_next: like next)
		do
			next := a_next
		end

	x1: INTEGER

	x2: INTEGER

		-- for line side calculation

	gx: FIXED_T

	gy: FIXED_T

		-- global bottom/top for silhouette clipping

	gz: FIXED_T

	gzt: FIXED_T

		-- horizontal position of x1

	startfrac: FIXED_T

	scale: FIXED_T

		-- negative if flipped

	xiscale: FIXED_T

	texturemid: FIXED_T

	patch: INTEGER

		-- for color translation and shadow draw,
		-- maxbright frames as well

	colormap: detachable INDEX_IN_ARRAY [LIGHTTABLE_T]

	mobjflags: INTEGER

end
