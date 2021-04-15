note
	description: "[
		r_bsp.c
		BSP traversal, handling of LineSegs for rendering
	]"

class
	R_BSP

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: I_MAIN)
		do
			i_main := a_i_main
			create solidsegs.make_filled (create {CLIPRANGE_T}, 0, MAXSEGS - 1)
			create drawsegs.make_empty
		end

feature

	MAXSEGS: INTEGER = 32

	newend: INTEGER -- one past the last valid seg

	solidsegs: ARRAY [CLIPRANGE_T]

	drawsegs: ARRAY [DRAWSEG_T]

	ds_p: INTEGER -- pointer inside drawsegs

feature

	R_ClearClipSegs
		do
			solidsegs [0].first := -0x7fffffff
			solidsegs [0].last := -1
			solidsegs [1].first := i_main.r_draw.viewwidth
			solidsegs [1].last := 0x7fffffff
			newend := 2
		end

	R_ClearDrawSegs
		do
			ds_p := 0
		end

	R_RenderBSPNode (bspnum: INTEGER)
			-- Renders all subsectors below a given node,
			-- traversing subtree recursively.
			-- Just call with BSP root
		do
				-- Stub
		end

invariant
	solidsegs.count = MAXSEGS

end
