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
		local
			i: INTEGER
		do
			i_main := a_i_main
			create cachedheight.make_empty
			create openings.make_filled (0, 0, MAXOPENINGS - 1)
			create lastopening.make (0, openings)
			create ceilingclip.make_filled (0, 0, {DOOMDEF_H}.screenwidth - 1)
			create floorclip.make_filled (0, 0, {DOOMDEF_H}.screenwidth - 1)

				-- make visplanes
			create visplanes.make_filled (create {VISPLANE_T}.make, 0, MAXVISPLANES - 1)
			from
				i := visplanes.lower
			until
				i > visplanes.upper
			loop
				visplanes [i] := create {VISPLANE_T}.make
				i := i + 1
			end
		end

feature
	-- Clip values are the solid pixel bounding the range.
	-- floorclip starts out SCREENHEIGHT
	-- ceilingclip starts out -1

	floorclip: ARRAY [INTEGER_16]

	ceilingclip: ARRAY [INTEGER_16]

	lastvisplane: INTEGER -- originally pointer inside visplanes

	MAXOPENINGS: INTEGER
		once
			Result := {DOOMDEF_H}.screenwidth * 64
		ensure
			instance_free: class
		end

	openings: ARRAY [INTEGER_16]

	lastopening: INDEX_IN_ARRAY [INTEGER_16] assign set_lastopening -- originally pointer inside openings

	set_lastopening (a_lastopening: like lastopening)
		do
			lastopening := a_lastopening
		end

	cachedheight: ARRAY [FIXED_T] -- SCREENHEIGHT

feature -- Here comes the obnoxious "visplane".

	MAXVISPLANES: INTEGER = 128

	visplanes: ARRAY [VISPLANE_T]

	floorplane: detachable VISPLANE_T assign set_floorplane

	set_floorplane (a_floorplane: like floorplane)
		do
			floorplane := a_floorplane
		end

	ceilingplane: detachable VISPLANE_T assign set_ceilingplane

	set_ceilingplane (a_ceilingplane: like ceilingplane)
		do
			ceilingplane := a_ceilingplane
		end

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
			create lastopening.make (0, openings)

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

	R_FindPlane (a_height: FIXED_T; picnum: INTEGER; a_lightlevel: INTEGER): VISPLANE_T
		local
			c: INTEGER -- index in visplanes
			height: FIXED_T
			lightlevel: INTEGER
			found: BOOLEAN
			ch: VISPLANE_T
		do
			height := a_height
			lightlevel := a_lightlevel
			if picnum = i_main.r_sky.skyflatnum then
				height := 0 -- all skys map together
				lightlevel := 0
			end
			from
				c := 0
				found := False
			until
				found or c >= lastvisplane
			loop
				ch := visplanes [c]
				if height = ch.height and picnum = ch.picnum and lightlevel = ch.lightlevel then
					found := True
				else
					c := c + 1
				end
			end
			if found then
				Result := visplanes [c]
			else
				if lastvisplane = MAXVISPLANES then
					{I_MAIN}.i_error ("R_FindPlane: no more visplanes")
				end
				lastvisplane := lastvisplane + 1
				ch := visplanes [lastvisplane]
				ch.height := height
				ch.picnum := picnum
				ch.lightlevel := lightlevel
				ch.minx := {DOOMDEF_H}.screenwidth
				ch.maxx := -1
				ch.top.fill_with (0xff)
				Result := ch
			end
		end

	R_CheckPlane (pl: VISPLANE_T; start, stop: INTEGER): VISPLANE_T
		local
			intrl: INTEGER
			intrh: INTEGER
			unionl: INTEGER
			unionh: INTEGER
			x: INTEGER
		do
			if start < pl.minx then
				intrl := pl.minx
				unionl := start
			else
				unionl := pl.minx
				intrl := start
			end
			if stop > pl.maxx then
				intrh := pl.maxx
				unionh := stop
			else
				unionh := pl.maxx
				intrh := stop
			end
			from
				x := intrl
			until
				x > intrh or else pl.top [x] = 0xff
			loop
				x := x + 1
			end
			if x > intrh then
				pl.minx := unionl
				pl.maxx := unionh

					-- use the same one
				Result := pl
			else
					-- make a new visplane
				visplanes [lastvisplane].height := pl.height
				visplanes [lastvisplane].picnum := pl.picnum
				visplanes [lastvisplane].lightlevel := pl.lightlevel
				Result := visplanes [lastvisplane]
				lastvisplane := lastvisplane + 1
				Result.minx := start
				Result.maxx := start
				Result.top.fill_with (0xff)
			end
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
	visplanes.count = MAXVISPLANES
	visplanes.lower = 0
	openings.lower = 0 and openings.count = MAXOPENINGS

end
