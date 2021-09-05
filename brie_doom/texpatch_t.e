note
	description: "[
		texpatch_t from r_data.c
		
		A single patch from a texture definition,
		basically a rectangular area within
		the texture rectangle.
	]"

class
	TEXPATCH_T

feature
	-- Block origin (allways UL),
	-- which has allready accounted
	-- for the internal origin of the patch.

	originx: INTEGER assign set_originx

	set_originx (a_originx: like originx)
		do
			originx := a_originx
		end

	originy: INTEGER assign set_originy

	set_originy (a_originy: like originy)
		do
			originy := a_originy
		end

	patch: INTEGER assign set_patch

	set_patch (a_patch: like patch)
		do
			patch := a_patch
		end

end
