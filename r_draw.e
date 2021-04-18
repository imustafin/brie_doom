note
	description: "[
		r_draw.c
		The actual span/column drawing functios.
		Here find the main potential for optimization
		 e.g. inline assembly, different algorithms.
	]"

class
	R_DRAW

inherit

	DOOMDEF_H

create
	make

feature

	make
		do
			create dc_colormap.make (0, create {ARRAY [LIGHTTABLE_T]}.make_empty)
		end

feature

	SBARHEIGHT: INTEGER = 32 -- status bar height at bottom of screen

feature -- ?

	MAXWIDTH: INTEGER = 1120

	MAXHEIGHT: INTEGER = 832

feature

	columnofs: ARRAY [INTEGER]
		attribute
			create Result.make_filled (0, 0, MAXWIDTH - 1)
		end

	ylookup: ARRAY [INTEGER] -- index in screen[0]
		attribute
			create Result.make_filled (0, 0, MAXHEIGHT - 1)
		end

feature

	R_InitTranslationTables
			-- Creates the translation tables to map
			--  the green color rmap to gray, brown, red.
			-- Assumes a given structure of the PLAYPAL.
			-- Could be read from a lump instead.
		do
				-- Stub
		end

feature

	viewwidth: INTEGER assign set_viewwidth

	set_viewwidth (a_viewwidth: like viewwidth)
		do
			viewwidth := a_viewwidth
		end

	scaledviewwidth: INTEGER assign set_scaledviewwidth

	set_scaledviewwidth (a_scaledviewwidth: like scaledviewwidth)
		do
			scaledviewwidth := a_scaledviewwidth
		end

	viewheight: INTEGER assign set_viewheight

	set_viewheight (a_viewheight: like viewheight)
		do
			viewheight := a_viewheight
		end

	viewwindowx: INTEGER

	viewwindowy: INTEGER

feature -- R_DrawColumn

	dc_colormap: INDEX_IN_ARRAY [LIGHTTABLE_T] assign set_dc_colormap

	set_dc_colormap (a_dc_colormap: like dc_colormap)
		do
			dc_colormap := a_dc_colormap
		end

	dc_x: INTEGER assign set_dc_x

	set_dc_x (a_dc_x: like dc_x)
		do
			dc_x := a_dc_x
		end

	dc_yl: INTEGER assign set_dc_yl

	set_dc_yl (a_dc_yl: like dc_yl)
		do
			dc_yl := a_dc_yl
		end

	dc_yh: INTEGER assign set_dc_yh

	set_dc_yh (a_dc_yh: like dc_yh)
		do
			dc_yh := a_dc_yh
		end

	dc_iscale: FIXED_T assign set_dc_iscale

	set_dc_iscale (a_dc_iscale: like dc_iscale)
		do
			dc_iscale := a_dc_iscale
		end

	dc_texturemid: FIXED_T assign set_dc_texturemid

	set_dc_texturemid (a_dc_texturemid: like dc_texturemid)
		do
			dc_texturemid := a_dc_texturemid
		end

	dc_source: POINTER assign set_dc_source
			-- first pixel in a column (possibly virtual)

	set_dc_source (a_dc_source: like dc_source)
		do
			dc_source := a_dc_source
		end

	dccount: INTEGER
			-- just for profiling

	R_DrawColumn
			-- A column is a vertical slice/span from a wall texture that,
			-- given the DOOM style restrictions on the view orientation,
			-- will always have constant z depth.
			-- Thus a special case loop for very fast rendering can be used.
			-- It has also been used with Wolfenshtein 3D.
		do
				-- Stub
		end

feature

	R_FillBackScreen
			-- Fills the back screen with a pattern
			--  for variable screen sizes
			-- Also draws a beveled edge.
		do
				-- Stub
		end

	R_DrawViewBorder
			-- Draws the border around the view
			--  for different size windows?
		do
				-- Stub
		end

feature

	R_DrawTranslatedColumn
		do
				-- Stub
		end

	R_DrawSpan
		do
				-- Stub
		end

feature

	R_DrawColumnLow
		do
				-- Stub
		end

	R_DrawFuzzColumn
		do
				-- Stub
		end

	r_DrawSpanLow
		do
				-- Stub
		end

feature

	R_InitBuffer (width, height: INTEGER)
		local
			i: INTEGER
		do
				-- Handle resize,
				--  e.g. smaller view windows
				--  with border and/or status bar.
			viewwindowx := (SCREENWIDTH - width) |>> 1

				-- Collumn offset. For windows.
			from
				i := 0
			until
				i >= width
			loop
				columnofs [i] := viewwindowx + i
				i := i + 1
			end

				-- Samw with base row offset.
			if width = SCREENWIDTH then
				viewwindowy := 0
			else
				viewwindowy := (SCREENHEIGHT - SBARHEIGHT - height) |>> 1
			end

				-- Precalculate all row offsets.
			from
				i := 0
			until
				i >= height
			loop
				ylookup [i] := (i + viewwindowy) * SCREENWIDTH
				i := i + 1
			end
		end

end
