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

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create cachedheight.make_empty
			create openings.make_empty
			create ceilingclip.make_filled(0, 0, {DOOMDEF_H}.screenwidth - 1)
			create floorclip.make_filled(0, 0, {DOOMDEF_H}.screenwidth - 1)
		end

feature
	-- Clip values are the solid pixel bounding the range.
	-- floorclip starts out SCREENHEIGHT
	-- ceilingclip starts out -1

	floorclip: ARRAY [INTEGER_16]

	ceilingclip: ARRAY [INTEGER_16]

	lastvisplane: INTEGER -- originally pointer inside visplanes

	openings: ARRAY [INTEGER_16]

	lastopening: INTEGER -- originally pointer inside openings

	cachedheight: ARRAY [FIXED_T] -- SCREENHEIGHT

feature -- Texture mapping

	basexscale: FIXED_T

	baseyscale: FIXED_T

feature

	R_InitPlanes
		do
				-- Doh!
		end

	R_ClearPlanes
			-- At begining of frame.
		local
			i: INTEGER
			angle: ANGLE_T
		do
				-- opening / clipping determination
			from
				i := 0
			until
				i >= i_main.r_draw.viewwidth
			loop
				floorclip [i] := i_main.r_draw.viewheight.to_integer_16
				ceilingclip [i] := -1
				i := i + 1
			end
			lastvisplane := 0
			lastopening := 0

				-- texture calculation
			cachedheight.fill_with (0)

				-- left to right mapping
			angle := ((i_main.r_main.viewangle - {R_MAIN}.ANG90) |>> {R_MAIN}.ANGLETOFINESHIFT)

				-- scale will be unit scale at SCREENWIDTH/2 distance
			basexscale := {M_FIXED}.FixedDiv ({R_MAIN}.finecosine [angle], i_main.r_main.centerxfrac)
			baseyscale := - {M_FIXED}.FixedDiv ({R_MAIN}.finesine [angle], i_main.r_main.centerxfrac)
		end

	R_DrawPlanes
			-- At the end of each frame.
		do
				-- Stub
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

invariant
	floorclip.count = {DOOMDEF_H}.SCREENWIDTH
	ceilingclip.count = {DOOMDEF_H}.SCREENWIDTH

end
