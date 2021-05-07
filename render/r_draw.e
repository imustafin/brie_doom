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

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create dc_source.make (create {MANAGED_POINTER}.make (1), 0)
			create ylookup.make_filled (create {PIXEL_T_BUFFER}.make (1), 0, MAXHEIGHT - 1)
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

	ylookup: ARRAY [PIXEL_T_BUFFER]

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

	dc_colormap: detachable INDEX_IN_ARRAY [LIGHTTABLE_T] assign set_dc_colormap

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

	dc_source: MANAGED_POINTER_WITH_OFFSET assign set_dc_source
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
		require
			RANGECHECK: dc_x < SCREENWIDTH and dc_yl >= 0 and dc_yh < SCREENHEIGHT
		local
			count: INTEGER
			dest: PIXEL_T_BUFFER
			ofs: INTEGER
			frac: FIXED_T
			fracstep: FIXED_T
			val: NATURAL_8
			dc_source_val: INTEGER
		do
			count := dc_yh - dc_yl

				-- Zero length, column does not exceed a pixel
			if count > 0 then
					-- Framebuffer destination address.
					-- Use ylookup LUT to avoid multiply with ScreenWidth.
					-- Use columnofs LUT for subwindows?
				dest := ylookup [dc_yl]
				ofs := columnofs [dc_x]

					-- Determine scaling,
					-- which is the only mapping to be done.
				fracstep := dc_iscale
				frac := dc_texturemid + (dc_yl - i_main.r_main.centery) * fracstep

					-- Inner loop that does the actual texture mapping,
					-- e.g. a DDA-lile scaling.
					-- This is as fast as it gets.
				from
					count := count + 1 -- add one because do{}while loop
				until
					count <= 0
				loop
						-- Re-map color indices from wall texture column
						-- using a lighting/special effects LUT
					dc_source_val := dc_source.read_byte ((frac |>> {M_FIXED}.FRACBITS) & 127)
					check attached dc_colormap as dc_cmap then
						val := dc_cmap [dc_source_val]
					end
					dest.put (val, ofs)
					ofs := ofs + SCREENWIDTH
					frac := frac + fracstep
					count := count - 1
				end
			end
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
		require
			RANGECHECK: dc_x < SCREENWIDTH and dc_yl >= 0 and dc_yh < SCREENHEIGHT
		do
				-- Stub
		end

feature -- R_DrawSpan

	ds_xstep: FIXED_T assign set_ds_xstep

	set_ds_xstep (a_ds_xstep: like ds_xstep)
		do
			ds_xstep := a_ds_xstep
		end

	ds_ystep: FIXED_T assign set_ds_ystep

	set_ds_ystep (a_ds_ystep: like ds_ystep)
		do
			ds_ystep := a_ds_ystep
		end

	ds_xfrac: FIXED_T assign set_ds_xfrac

	set_ds_xfrac (a_ds_xfrac: like ds_xfrac)
		do
			ds_xfrac := a_ds_xfrac
		end

	ds_yfrac: FIXED_T assign set_ds_yfrac

	set_ds_yfrac (a_ds_yfrac: like ds_yfrac)
		do
			ds_yfrac := a_ds_yfrac
		end

	ds_colormap: detachable INDEX_IN_ARRAY [LIGHTTABLE_T] assign set_ds_colormap -- lighttable_t*

	set_ds_colormap (a_ds_colormap: like ds_colormap)
		do
			ds_colormap := a_ds_colormap
		end

	ds_y: INTEGER assign set_ds_y

	set_ds_y (a_ds_y: like ds_y)
		do
			ds_y := a_ds_y
		end

	ds_x1: INTEGER assign set_ds_x1

	set_ds_x1 (a_ds_x1: like ds_x1)
		do
			ds_x1 := a_ds_x1
		end

	ds_x2: INTEGER assign set_ds_x2

	set_ds_x2 (a_ds_x2: like ds_x2)
		do
			ds_x2 := a_ds_x2
		end

	ds_source: detachable MANAGED_POINTER_WITH_OFFSET assign set_ds_source

	set_ds_source (a_ds_source: like ds_source)
		do
			ds_source := a_ds_source
		end

	R_DrawSpan
			-- Draws the actual span
		require
			RANGECHECK: ds_x2 >= ds_x1 and ds_x1 >= 0 and ds_x2 < SCREENWIDTH and ds_y <= SCREENHEIGHT -- originally casted ds_y to unsigned
		local
			xfrac: FIXED_T
			yfrac: FIXED_T
			dest: PIXEL_T_BUFFER
			ofs: INTEGER
			count: INTEGER
			spot: INTEGER
			ds_source_val: INTEGER
		do
			xfrac := ds_xfrac
			yfrac := ds_yfrac
			dest := ylookup [ds_y]
			ofs := columnofs [ds_x1]

				-- We do not check for zero spans here?
			count := ds_x2 - ds_x1
			from
				count := count + 1 -- add one because do{}while loop
			until
				count = 0
			loop
					-- Current texture index in u,v
				spot := (((yfrac |>> (16 - 6)) & (63 * 64)) + ((xfrac |>> 16) & 63)).to_integer_32

					-- Lookup pixel from flat texture file,
					-- re-indexing using light/colormap
				check attached ds_source as src then
					ds_source_val := src.read_byte (spot)
				end
				check attached ds_colormap as dsc then
					dest.put (dsc [ds_source_val], ofs)
					ofs := ofs + 1
				end

					-- Next step in u,v
				xfrac := xfrac + ds_xstep
				yfrac := yfrac + ds_ystep
				count := count - 1
			end
		end

feature

	R_DrawColumnLow
		require
			RANGECHECK: dc_x < SCREENWIDTH and dc_yl >= 0 and dc_yh < SCREENHEIGHT
		do
			{I_MAIN}.i_error ("R_DrawColumnLow not implemented")
		end

	R_DrawFuzzColumn
		require
			RANGECHECK: dc_x < SCREENWIDTH and dc_yl >= 0 and dc_yh < SCREENHEIGHT
		do
				-- Stub
		end

	r_DrawSpanLow
		require
			RANGECHECK: ds_x2 >= ds_x1 and ds_x1 >= 0 and ds_x2 < SCREENWIDTH and ds_y <= SCREENHEIGHT
		do
				-- Stub
		end

feature

	R_InitBuffer (width, height: INTEGER)
		local
			i: INTEGER
			ofs: INTEGER
			left: INTEGER
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
				ofs := (i + viewwindowy) * SCREENWIDTH
				left := i_main.i_video.i_videobuffer.p.count - ofs -- how many bytes are there in I_VideoBuffer startin from ofs
				check
					left > 0
				end
				ylookup [i] := create {PIXEL_T_BUFFER}.share_from_pointer (i_main.i_video.I_VideoBuffer.p.item + ofs, left)
				i := i + 1
			end
		end

invariant
	ylookup.lower = 0
	ylookup.count = MAXHEIGHT

end
