note
	description: "[
		r_main.c
		Rendering main loop and setup functions,
		 utility functions (BSP, geometry, trigonometry).
		See tables.c, too
	]"

class
	R_MAIN

inherit

	TABLES

	DOOMDEF_H

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		local
			i: INTEGER
		do
			i_main := a_i_main
			create viewplayer.make
			validcount := 1
			create scalelightfixed.make_filled (Void, 0, MAXLIGHTSCALE - 1)
			create viewangletox.make_filled (0, 0, FINEANGLES // 2 - 1)
				-- Create scalelight
			from
				create scalelight.make_filled (create {ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]]}.make_empty, 0, LIGHTLEVELS - 1)
				i := 0
			until
				i >= LIGHTLEVELS
			loop
				scalelight [i] := create {ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]]}.make_filled (Void, 0, MAXLIGHTSCALE - 1)
				i := i + 1
			end
				-- Create zlight
			from
				create zlight.make_filled (create {ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]]}.make_empty, 0, LIGHTLEVELS - 1)
				i := 0
			until
				i >= LIGHTLEVELS
			loop
				zlight [i] := create {ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]]}.make_filled (Void, 0, MAXLIGHTZ - 1)
				i := i + 1
			end
		end

feature

	viewx: FIXED_T

	viewy: FIXED_T

	viewz: FIXED_T

feature

	viewplayer: PLAYER_T

	viewangle: ANGLE_T

	viewangleoffset: INTEGER

	extralight: INTEGER

	viewsin: FIXED_T

	viewcos: FIXED_T

	sscount: INTEGER assign set_sscount

	set_sscount (a_sscount: like sscount)
		do
			sscount := a_sscount
		end

	linecount: INTEGER

	loopcount: INTEGER

	fixedcolormap: detachable INDEX_IN_ARRAY [LIGHTTABLE_T] -- lighttable_t*

	scalelightfixed: ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]] -- lighttable_t* []

	zlight: ARRAY [ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]]] -- ligghttable_t* [][]

	validcount: INTEGER
			-- increment every time a check is made

	FIELDOFVIEW: INTEGER = 2048
			-- Fineangles in the SCREENWIDTH wide window.

feature

	centerx: INTEGER

	centery: INTEGER

	centerxfrac: FIXED_T

	centeryfrac: FIXED_T

	projection: FIXED_T

feature

	colfunc: detachable PROCEDURE

	basecolfunc: detachable PROCEDURE

	fuzzcolfunc: detachable PROCEDURE

	transcolfunc: detachable PROCEDURE

	spanfunc: detachable PROCEDURE

feature

	detailshift: INTEGER -- 0 = high, 1 = low

feature -- Lighting constants.

	LIGHTLEVELS: INTEGER = 16

	LIGHTSEGSHIFT: INTEGER = 4

	MAXLIGHTSCALE: INTEGER = 48

	LIGHTSCALESHIFT: INTEGER = 12

	MAXLIGHTZ: INTEGER = 128

	LIGHTZSHIFT: INTEGER = 20

	NUMCOLORMAPS: INTEGER = 32
			-- Number of diminishing brightness levels.
			-- There a 0-31, i.e. 32 LUT in the COLORMAP lump.

	scalelight: ARRAY [ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]]] -- lighttable_t* [][]

feature

	finecosine: ARRAY [FIXED_T]
		local
			l_start: INTEGER
			i: INTEGER
		once
			l_start := FINEANGLES // 4
			create Result.make_filled (0, 0, finesine.count - l_start - 1)
			from
				i := 0
			until
				i > Result.upper
			loop
				Result [i] := finesine [i + l_start]
				i := i + 1
			end
		ensure
			instance_free: class
		end

	xtoviewangle: ARRAY [ANGLE_T]
			-- maps a screen pixel
			-- to the lowest viewangle that maps back to x ranges
			-- from clipangle to -clipangle
		once
			create Result.make_filled ({NATURAL} 0, 0, {DOOMDEF_H}.SCREENWIDTH)
		end

feature -- R_SetViewSize

	setsizeneeded: BOOLEAN

	setblocks: INTEGER

	setdetail: INTEGER

	R_SetViewSize (blocks: INTEGER; detail: INTEGER)
			-- Do not really change anything here,
			--  because it might be in the middle of a refresh.
			-- The change will take effect next refresh.
		do
			setsizeneeded := True
			setblocks := blocks
			setdetail := detail
		end

feature -- precalculated math tables

	clipangle: ANGLE_T

	viewangletox: ARRAY [INTEGER]
			-- The viewangletox[viewangle + FINEANGLES/4] lookup
			-- maps the visible view angles to screen X coordinates,
			-- flattening the arc to a flat projection plane.
			-- There will be many angles mapped to the same X.

feature

	R_ScaleFromGlobalAngle (visangle: ANGLE_T): FIXED_T
			-- Returns the texture mapping scale
			-- for the current line (horizontal span)
			-- at the given angle.
			-- rw_distance must be calculated first
		local
			scale: FIXED_T
			anglea: INTEGER
			angleb: INTEGER
			sinea: INTEGER
			sineb: INTEGER
			num: FIXED_T
			den: INTEGER
		do
			anglea := ANG90 + (visangle - viewangle)
			angleb := ANG90 + (visangle - i_main.r_segs.rw_normalangle)

				-- both sines are allways positive
			sinea := finesine [anglea |>> ANGLETOFINESHIFT]
			sineb := finesine [angleb |>> ANGLETOFINESHIFT]
			num := {M_FIXED}.FixedMul (projection, sineb) |<< detailshift
			den := {M_FIXED}.FixedMul (i_main.r_segs.rw_distance, sinea).to_integer_32
			if den > num |>> 16 then
				scale := {M_FIXED}.FixedDiv (num, den)
				if scale > 64 * {M_FIXED}.FRACUNIT then
					scale := 64 * {M_FIXED}.FRACUNIT
				elseif scale < 256 then
					scale := 256
				end
			else
				scale := 64 * {M_FIXED}.FRACUNIT
			end
			Result := scale
		end

	R_ExecuteSetViewSize
		local
			cosadj: FIXED_T
			dy: FIXED_T
			i, j: INTEGER
			level: INTEGER
			startmap: INTEGER
		do
			setsizeneeded := False
			if setblocks = 11 then
				i_main.r_draw.scaledviewwidth := {DOOMDEF_H}.SCREENWIDTH
				i_main.r_draw.viewheight := {DOOMDEF_H}.SCREENHEIGHT
			else
				i_main.r_draw.scaledviewwidth := setblocks * 32
				i_main.r_draw.viewheight := (setblocks * 168 // 10).bit_and ((7).bit_not)
			end
			detailshift := setdetail
			i_main.r_draw.viewwidth := i_main.r_draw.scaledviewwidth |>> detailshift
			centery := i_main.r_draw.viewheight // 2
			centerx := i_main.r_draw.viewwidth // 2
			centerxfrac := centerx |<< {M_FIXED}.FRACBITS
			centeryfrac := centery |<< {M_FIXED}.FRACBITS
			projection := centerxfrac
			if detailshift = 0 then
				colfunc := agent (i_main.r_draw).R_DrawColumn
				basecolfunc := agent (i_main.r_draw).R_DrawColumn
				transcolfunc := agent (i_main.r_draw).R_DrawTranslatedColumn
				spanfunc := agent (i_main.r_draw).R_DrawSpan
			else
				colfunc := agent (i_main.r_draw).R_DrawColumnLow
				basecolfunc := agent (i_main.r_draw).R_DrawColumnLow
				fuzzcolfunc := agent (i_main.r_draw).R_DrawFuzzColumn
				transcolfunc := agent (i_main.r_draw).R_DrawTranslatedColumn
				spanfunc := agent (i_main.r_draw).R_DrawSpanLow
			end
			i_main.r_draw.R_InitBuffer (i_main.r_draw.scaledviewwidth, i_main.r_draw.viewheight)
			R_InitTextureMapping

				-- psprite scales
			i_main.r_things.pspritescale := {M_FIXED}.FRACUNIT * i_main.r_draw.viewwidth // SCREENWIDTH
			i_main.r_things.pspriteiscale := {M_FIXED}.FRACUNIT * SCREENWIDTH // i_main.r_draw.viewwidth

				-- thing clipping
			from
				i := 0
			until
				i >= i_main.r_draw.viewwidth
			loop
				i_main.r_things.screenheightarray [i] := i_main.r_draw.viewheight.as_integer_16
				i := i + 1
			end

				-- planes
			from
				i := 0
			until
				i >= i_main.r_draw.viewheight
			loop
				dy := ((i - i_main.r_draw.viewheight // 2) |<< {M_FIXED}.FRACBITS) + {M_FIXED}.FRACUNIT // 2
				dy := dy.abs
				i_main.r_plane.yslope [i] := {M_FIXED}.FixedDiv ((i_main.r_draw.viewwidth |<< detailshift) // 2 * {M_FIXED}.FRACUNIT, dy)
				i := i + 1
			end
			from
				i := 0
			until
				i >= i_main.r_draw.viewwidth
			loop
				cosadj := finecosine [xtoviewangle [i] |>> ANGLETOFINESHIFT].abs
				i_main.r_plane.distscale [i] := {M_FIXED}.FixedDiv ({M_FIXED}.FRACUNIT, cosadj)
				i := i + 1
			end

				-- Calculate the light levels to use
				--  for each level / scale combination
			from
				i := 0
			until
				i >= LIGHTLEVELS
			loop
				startmap := ((LIGHTLEVELS - 1 - i) * 2) * NUMCOLORMAPS // LIGHTLEVELS
				from
					j := 0
				until
					j >= MAXLIGHTSCALE
				loop
					level := startmap - j * SCREENWIDTH // (i_main.r_draw.viewwidth |<< detailshift) // DISTMAP
					if level < 0 then
						level := 0
					end
					if level >= NUMCOLORMAPS then
						level := NUMCOLORMAPS - 1
					end
					scalelight [i] [j] := create {INDEX_IN_ARRAY [LIGHTTABLE_T]}.make (level * 256, i_main.r_data.colormaps)
					j := j + 1
				end
				i := i + 1
			end
		end

feature

	R_InitPointToAngle
		do
				-- UNUSED - now getting from tables.c
		end

	R_InitTables
		do
				-- UNUSED - now getting from tables.c
		end

	R_PointToDist (x, y: FIXED_T): FIXED_T
		local
			angle: INTEGER
			dx: FIXED_T
			dy: FIXED_T
			temp: FIXED_T
			dist: FIXED_T
		do
			dx := (x - viewx).abs
			dy := (y - viewy).abs
			if dy > dx then
				temp := dx
				dx := dy
				dy := temp
			end
			angle := (tantoangle [{M_FIXED}.FixedDiv (dy, dx).to_integer_32 |>> DBITS] + ANG90) |>> ANGLETOFINESHIFT

				-- use as cosine
			dist := {M_FIXED}.FixedDiv (dx, finesine [angle])
			Result := dist
		end

	R_InitTextureMapping
		local
			i: INTEGER
			x: INTEGER
			t: INTEGER
			focallength: FIXED_T
		do
			focallength := {M_FIXED}.fixeddiv (centerxfrac, {TABLES}.finetangent [FINEANGLES // 4 + {R_MAIN}.FIELDOFVIEW // 2])
			from
				i := 0
			until
				i >= FINEANGLES // 2
			loop
				if finetangent [i] > {M_FIXED}.FRACUNIT * 2 then
					t := -1
				elseif finetangent [i] < - {M_FIXED}.FRACUNIT * 2 then
					t := i_main.r_draw.viewwidth + 1
				else
					t := {M_FIXED}.fixedmul (finetangent [i], focallength).to_integer_32
					t := ((centerxfrac - t + {M_FIXED}.FRACUNIT - 1) |>> {M_FIXED}.FRACBITS).to_integer_32
					if t < -1 then
						t := -1
					elseif t > i_main.r_draw.viewwidth + 1 then
						t := i_main.r_draw.viewwidth + 1
					end
				end
				viewangletox [i] := t
				i := i + 1
			end

				-- Scan viewangletox[] to generate xtoviewangle[]:
				-- xtoviewangle will give the smallest view angle
				-- that maps to x
			from
				x := 0
			until
				x > i_main.r_draw.viewwidth
			loop
				from
					i := 0
				until
					viewangletox [i] <= x
				loop
					i := i + 1
				end
				xtoviewangle [x] := ((i |<< ANGLETOFINESHIFT) - ANG90).to_natural_32
				x := x + 1
			end

				-- Take out the fencepost cases from viewangletox
			from
				i := 0
			until
				i >= FINEANGLES // 2
			loop
				t := {M_FIXED}.fixedmul (finetangent [i], focallength).to_integer_32
				t := centerx - t
				if viewangletox [i] = -1 then
					viewangletox [i] := 0
				elseif viewangletox [i] = i_main.r_draw.viewwidth + 1 then
					viewangletox [i] := i_main.r_draw.viewwidth
				end
				i := i + 1
			end
			clipangle := xtoviewangle [0]
		end

feature -- R_InitLightTables

	DISTMAP: INTEGER = 2

	R_InitLightTables
			-- Only inits the zlight table,
			-- because the scalelight table changes with view size
		local
			i: INTEGER
			j: INTEGER
			level: INTEGER
			startmap: INTEGER
			scale: INTEGER
		do
				-- Calculate the light levels to use
				-- for each level/distance combination.
			from
				i := 0
			until
				i >= LIGHTLEVELS
			loop
				startmap := ((LIGHTLEVELS - 1 - i) * 2) * NUMCOLORMAPS // LIGHTLEVELS
				from
					j := 0
				until
					j >= MAXLIGHTZ
				loop
					scale := {M_FIXED}.fixeddiv (SCREENWIDTH // 2 * {M_FIXED}.FRACUNIT, (j + 1) |<< LIGHTZSHIFT).to_integer_32
					scale := scale |>> LIGHTSCALESHIFT
					level := startmap - scale // DISTMAP
					if level < 0 then
						level := 0
					end
					if level >= NUMCOLORMAPS then
						level := NUMCOLORMAPS - 1
					end
					zlight [i] [j] := create {INDEX_IN_ARRAY [LIGHTTABLE_T]}.make (level * 256, i_main.r_data.colormaps)
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- R_Init

	framecount: INTEGER -- just for profiling purposes

	R_Init
		do
			i_main.r_data.R_InitData
			print ("%NR_InitData")
			R_InitPointToAngle
			print ("%NR_InitPointToAngle")
			R_InitTables
				-- viewwidth / viewheight / detaillevel are set by the defaults
			print ("%NR_InitTables")
			R_SetViewSize (i_main.m_menu.screenblocks, i_main.m_menu.detaillevel)
			i_main.r_plane.R_InitPlanes
			print ("%NR_InitPlanes")
			R_InitLightTables
			print ("%NR_InitLightTables")
			i_main.r_sky.R_InitSkyMap
			print ("%NR_InitSkyMap")
			i_main.r_draw.R_InitTranslationTables
			print ("%NR_InitTranslationsTables")
			framecount := 0
		end

feature

	R_PointToAngle2 (x1, y1, x2, y2: FIXED_T): ANGLE_T
		do
			viewx := x1
			viewy := y1
			Result := R_PointToAngle (x2, y2)
		end

	R_PointToAngle (a_x, a_y: FIXED_T): ANGLE_T
			-- To get a global angle from cartesian coordinates,
			--  the coordinates are flipped until they are in
			--  the first octant of the coordinate system, then
			--  the y (<= x) is scaled and divided by x to get a
			--  tangent (slope) value which is looked up in the
			--  tantoangle[] table.
		local
			x, y: FIXED_T
		do
			x := a_x - viewx
			y := a_y - viewy
			if x = 0 and y = 0 then
				Result := {NATURAL} 0
			else
				if x >= 0 then
						-- x >= 0
					if y >= 0 then
							-- y >= 0
						if x > y then
								-- octant 0
							Result := tantoangle [SlopeDiv (y, x)]
						else
								-- octant 1
							Result := ANG90 - (1).as_natural_32 - tantoangle [SlopeDiv (x, y)]
						end
					else
							-- y < 0
						y := - y
						if x > y then
								-- octant 8
							Result := - tantoangle [SlopeDiv (y, x)]
						else
								-- octant 7
							Result := (ANG270 + tantoangle [SlopeDiv (x, y)]).as_natural_32
						end
					end
				else
						-- x < 0
					x := - x
					if y >= 0 then
							-- y >= 0
						if x > y then
								-- octant 3
							Result := ANG180 - (1).as_natural_32 - tantoangle [SlopeDiv (y, x)]
						else
								-- octant 2
							Result := ANG90 + tantoangle [SlopeDiv (x, y)]
						end
					else
							-- y < 0
						y := - y
						if x > y then
								-- octant 4
							Result := ANG180 + tantoangle [SlopeDiv (y, x)]
						else
								-- octant 5
							Result := ANG270 - (1).as_natural_32 - tantoangle [SlopeDiv (x, y)]
						end
					end
				end
			end
		end

feature

	R_RenderPlayerView (player: PLAYER_T)
		do
			R_SetupFrame (player)

				-- Clear buffers
			i_main.r_bsp.R_ClearClipSegs
			i_main.r_bsp.R_ClearDrawSegs
			i_main.r_plane.R_ClearPlanes
			i_main.r_things.R_ClearSprites

				-- check for new console commands
			i_main.d_net.NetUpdate

				-- The head node is the last node output.
			i_main.r_bsp.R_RenderBSPNode (i_main.p_setup.nodes.count - 1)

				-- check for new console commands.
			i_main.d_net.NetUpdate
			i_main.r_plane.R_DrawPlanes

				-- check for new console commands
			i_main.d_net.NetUpdate
			i_main.r_things.R_DrawMasked

				-- check for new console commands
			i_main.d_net.NetUpdate
		end

	R_SetupFrame (player: PLAYER_T)
		local
			i: INTEGER
		do
			viewplayer := player
			check attached player.mo as mo then
				viewx := mo.x
				viewy := mo.y
				viewangle := mo.angle + viewangleoffset.to_natural_32
			end
			extralight := player.extralight
			viewz := player.viewz
			viewsin := finesine [viewangle |>> ANGLETOFINESHIFT]
			viewcos := finecosine [viewangle |>> ANGLETOFINESHIFT]
			sscount := 0
			if player.fixedcolormap /= 0 then
				fixedcolormap := create {INDEX_IN_ARRAY [LIGHTTABLE_T]}.make (player.fixedcolormap, i_main.r_data.colormaps) -- originally colormaps + player->fixedcolormap*256*sizeof(lighttable_t)
				i_main.r_segs.walllights := scalelightfixed
				from
					i := 0
				until
					i >= MAXLIGHTSCALE
				loop
					check attached fixedcolormap as fcm then
						scalelightfixed [i] := fcm
					end
					i := i + 1
				end
			else
				fixedcolormap := Void
			end
			framecount := framecount + 1
			validcount := validcount + 1
		end

	R_PointOnSide (x, y: FIXED_T; node: NODE_T): BOOLEAN
			-- Traverse BSP (sub) tree,
			-- check point against partition plane.
			-- Returns side False (front) or True (back)
		local
			dx: FIXED_T
			dy: FIXED_T
			left: FIXED_T
			right: FIXED_T
		do
			if node.dx = 0 then
				if x <= node.x then
					Result := node.dy > 0
				else
					Result := node.dy < 0
				end
			elseif node.dy = 0 then
				if y <= node.y then
					Result := node.dx < 0
				else
					Result := node.dx > 0
				end
			else
				dx := (x - node.x)
				dy := (y - node.y)

					-- Try to quickly decide by looking at sign bits
				if node.dy.bit_xor (node.dx).bit_xor (dx).bit_xor (dy) & (0x80000000).to_integer_32 /= 0 then
					if node.dy.bit_xor (dx) & (0x80000000).to_integer_32 /= 0 then
							-- left is negative
						Result := True
					else
						Result := False
					end
				else
					left := {M_FIXED}.FixedMul (node.dy |>> {M_FIXED}.FRACBITS, dx)
					right := {M_FIXED}.FixedMul (dy, node.dx |>> {M_FIXED}.FRACBITS)
					if right < left then
							-- front side
						Result := False
					else
						Result := True
					end
				end
			end
		end

feature

	R_PointInSubsector (x, y: FIXED_T): SUBSECTOR_T
		local
			node: NODE_T
			side: INTEGER
			nodenum: INTEGER
		do
				-- single subsector is a special case
			if i_main.p_setup.numnodes = 0 then
				Result := i_main.p_setup.subsectors [i_main.p_setup.subsectors.lower]
			else
				nodenum := i_main.p_setup.numnodes - 1
				from
				until
					nodenum & {DOOMDATA_H}.NF_SUBSECTOR /= 0
				loop
					node := i_main.p_setup.nodes [nodenum]
					side := R_PointOnSide (x, y, node).to_integer
					nodenum := node.children [side]
				end
				Result := i_main.p_setup.subsectors [nodenum & {DOOMDATA_H}.NF_SUBSECTOR.bit_not]
			end
		end

invariant
	viewangletox.lower = 0
	viewangletox.count = FINEANGLES // 2
	scalelightfixed.lower = 0 and scalelightfixed.count = MAXLIGHTSCALE
	scalelight.lower = 0 and scalelight.count = LIGHTLEVELS and across scalelight as sc_level all sc_level.item.lower = 0 and sc_level.item.count = MAXLIGHTSCALE end
	zlight.lower = 0 and zlight.count = LIGHTLEVELS and across zlight as zl_level all zl_level.item.lower = 0 and zl_level.item.count = MAXLIGHTZ end

end
