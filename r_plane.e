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
			create cachedheight.make_filled(0, 0, {DOOMDEF_H}.screenheight - 1)
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
			create cachedystep.make_filled (0, 0, {DOOMDEF_H}.screenheight - 1)
			create cachedxstep.make_filled (0, 0, {DOOMDEF_H}.screenheight - 1)
			create cacheddistance.make_filled (0, 0, {DOOMDEF_H}.screenheight - 1)
			create spanstart.make_filled(0, 0, {DOOMDEF_H}.screenheight - 1)
		end

feature

	spanstart: ARRAY [INTEGER]
			-- spanstart holds the start of a plane span
			-- initialized to 0 at start

	cacheddistance: ARRAY [FIXED_T]

	cachedxstep: ARRAY [FIXED_T]

	cachedystep: ARRAY [FIXED_T]

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

	planeheight: FIXED_T

	planezlight: detachable ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]] -- lighttable_t**

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
		require
				-- ifdef RANGECHECK
			i_main.r_bsp.ds_p <= {R_DEFS}.MAXDRAWSEGS
			lastvisplane <= MAXVISPLANES
			lastopening.index <= MAXOPENINGS
		local
			pl: INTEGER -- index inside visplanes
			light: INTEGER
			x: INTEGER
			stop: INTEGER
			angle: INTEGER
		do
			from
				pl := 0
			until
				pl >= lastvisplane
			loop
				if visplanes [pl].minx > visplanes [pl].maxx then
						-- continue
				else
						-- sky flat
					if visplanes [pl].picnum = i_main.r_sky.skyflatnum then
						i_main.r_draw.dc_iscale := i_main.r_things.pspriteiscale |>> i_main.r_main.detailshift

							-- Sky is allways drawn full bright,
							-- i.e. colormaps[0] is used.
							-- Because of this hack, sky is not affected
							-- by INVUL inverse mapping.
						i_main.r_draw.dc_colormap := create {INDEX_IN_ARRAY [LIGHTTABLE_T]}.make (0, i_main.r_data.colormaps)
						i_main.r_draw.dc_texturemid := i_main.r_sky.skytexturemid
						from
							x := visplanes [pl].minx
						until
							x > visplanes [pl].maxx
						loop
							i_main.r_draw.dc_yl := visplanes [pl].top [x]
							i_main.r_draw.dc_yh := visplanes [pl].bottom [x]
							if i_main.r_draw.dc_yl < i_main.r_draw.dc_yh then
								angle := (i_main.r_main.viewangle + i_main.r_main.xtoviewangle [x]) |>> {R_SKY}.ANGLETOSKYSHIFT
								i_main.r_draw.dc_x := x
								i_main.r_draw.dc_source := i_main.r_data.R_GetColumn (i_main.r_sky.skytexture, angle)
								check attached i_main.r_main.colfunc as colfunc then
									colfunc.call
								end
							end
							x := x + 1
						end
					else
							-- regular flat
						i_main.r_draw.ds_source := create {MANAGED_POINTER_WITH_OFFSET}.make (i_main.w_wad.W_CacheLumpNum (i_main.r_data.firstflat + i_main.r_data.flattranslation [visplanes [pl].picnum], {Z_ZONE}.pu_static), 0)
						planeheight := (visplanes [pl].height - i_main.r_main.viewz).abs
						light := (visplanes [pl].lightlevel |>> {R_MAIN}.LIGHTSEGSHIFT) + i_main.r_main.extralight
						if light >= {R_MAIN}.LIGHTLEVELS then
							light := {R_MAIN}.LIGHTLEVELS - 1
						end
						if light < 0 then
							light := 0
						end
						planezlight := i_main.r_main.zlight [light]
						visplanes [pl].top [visplanes [pl].maxx + 1] := 0xff
						visplanes [pl].top [visplanes [pl].minx - 1] := 0xff

						stop := visplanes [pl].maxx + 1
						from
							x := visplanes [pl].minx
						until
							x > stop
						loop
							R_MakeSpans (x, visplanes [pl].top [x - 1], visplanes [pl].bottom [x - 1], visplanes [pl].top [x], visplanes [pl].bottom [x])
							x := x + 1
						end
					end
				end
				pl := pl + 1
			end
		end

	R_MakeSpans (x, a_t1, a_b1, a_t2, a_b2: INTEGER)
		local
			t1: INTEGER
			b1: INTEGER
			t2: INTEGER
			b2: INTEGER
		do
			t1 := a_t1
			b1 := a_b1
			t2 := a_t2
			b2 := a_b2
			from
			until
				not (t1 < t2 and t1 <= b1)
			loop
				R_MapPlane (t1, spanstart [t1], x - 1)
				t1 := t1 + 1
			end
			from
			until
				not (b1 > b2 and b1 >= t1)
			loop
				R_MapPlane (b1, spanstart [b1], x - 1)
				b1 := b1 - 1
			end
			from
			until
				not (t2 < t1 and t2 <= b2)
			loop
				spanstart [t2] := x
				t2 := t2 + 1
			end
			from
			until
				not (b2 > b1 and b2 >= t2)
			loop
				spanstart [b2] := x
				b2 := b2 - 1
			end
		end

	R_MapPlane (y, x1, x2: INTEGER)
		require
				-- #ifdef RANGECHECK
			x2 >= x1
			x1 >= 0
			x2 < i_main.r_draw.viewwidth
			y <= i_main.r_draw.viewheight -- originally caster y to unsigned
		local
			angle: ANGLE_T
			distance: FIXED_T
			length: FIXED_T
			index: NATURAL
		do
			if planeheight /= cachedheight [y] then
				cachedheight [y] := planeheight
				distance := {M_FIXED}.fixedmul (planeheight, yslope [y])
				cacheddistance [y] := distance
				i_main.r_draw.ds_xstep := {M_FIXED}.fixedmul (distance, basexscale)
				cachedxstep [y] := i_main.r_draw.ds_xstep
				i_main.r_draw.ds_ystep := {M_FIXED}.fixedmul (distance, baseyscale)
				cachedystep [y] := i_main.r_draw.ds_ystep
			else
				distance := cacheddistance [y]
				i_main.r_draw.ds_xstep := cachedxstep [y]
				i_main.r_draw.ds_ystep := cachedystep [y]
			end
			length := {M_FIXED}.fixedmul (distance, distscale [x1])
			angle := (i_main.r_main.viewangle + i_main.r_main.xtoviewangle [x1]) |>> {R_MAIN}.ANGLETOFINESHIFT
			i_main.r_draw.ds_xfrac := i_main.r_main.viewx + {M_FIXED}.fixedmul (i_main.r_main.finecosine [angle], length)
			i_main.r_draw.ds_yfrac := - i_main.r_main.viewy - {M_FIXED}.fixedmul (i_main.r_main.finesine [angle], length)
			if attached i_main.r_main.fixedcolormap as fixedcolormap then
				i_main.r_draw.ds_colormap := fixedcolormap
			else
				index := distance |>> {R_MAIN}.LIGHTZSHIFT
				if index >= {R_MAIN}.MAXLIGHTZ.to_natural_32 then
					index := {R_MAIN}.MAXLIGHTZ.to_natural_32 - 1
				end
				check attached planezlight as pzl then
					check attached pzl [index.to_integer_32] as pzli then
						i_main.r_draw.ds_colormap := pzli
					end
				end
			end
			i_main.r_draw.ds_y := y
			i_main.r_draw.ds_x1 := x1
			i_main.r_draw.ds_x2 := x2

				-- high or low detail
			check attached i_main.r_main.spanfunc as spanfunc then
				spanfunc.call
			end
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
				ch := visplanes [lastvisplane]
				lastvisplane := lastvisplane + 1
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
				x > intrh or else pl.top[x] /= 0xff
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
	cachedystep.lower = 0 and cachedystep.count = {DOOMDEF_H}.SCREENHEIGHT
	cachedxstep.lower = 0 and cachedxstep.count = {DOOMDEF_H}.SCREENHEIGHT
	cacheddistance.lower = 0 and cacheddistance.count = {DOOMDEF_H}.SCREENHEIGHT
	cachedheight.lower = 0 and cachedheight.count = {DOOMDEF_H}.SCREENHEIGHT
	spanstart.lower = 0 and spanstart.count = {DOOMDEF_H}.screenheight

end
