note
	description: "[
		r_draw.c
		The actual span/column drawing functios.
		Here find the main potential for optimization
		 e.g. inline assembly, different algorithms.
	]"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
				Copyright (C) 2005-2014 Simon Howard
				Copyright (C) 2021 Ilgiz Mustafin
		
				This program is free software; you can redistribute it and/or modify
				it under the terms of the GNU General Public License as published by
				the Free Software Foundation; either version 2 of the License, or
				(at your option) any later version.
		
				This program is distributed in the hope that it will be useful,
				but WITHOUT ANY WARRANTY; without even the implied warranty of
				MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
				GNU General Public License for more details.
		
				You should have received a copy of the GNU General Public License along
				with this program; if not, write to the Free Software Foundation, Inc.,
				51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
			create ylookup.make_filled (create {PIXEL_T_BUFFER}.make (1), 0, MAXHEIGHT - 1)
		end

feature

	SBARHEIGHT: INTEGER = 32 -- status bar height at bottom of screen

	background_buffer: detachable PIXEL_T_BUFFER

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
		local
			i: INTEGER
		do
			create translationtables.make_filled (0, 0, 256 * 3 + 255 - 1)
				-- skip align

				-- translate just the 16 green colors
			from
				i := 0
			until
				i >= 256
			loop
				check attached translationtables as tt then
					if i >= 0x70 and i <= 0x7f then
							-- map green ramp to gray, brown, red
						tt [i] := (0x60 + (i & 0xf)).to_natural_16
						tt [i + 256] := (0x40 + (i & 0xf)).to_natural_16
						tt [i + 512] := (0x20 + (i & 0xf)).to_natural_16
					else
							-- Keep all other colors as is
						tt [i] := i.to_natural_16
						tt [i + 256] := i.to_natural_16
						tt [i + 512] := i.to_natural_16
					end
				end
				i := i + 1
			end
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

	dc_source: detachable BYTE_SEQUENCE assign set_dc_source
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
			i: INTEGER
		do
			count := dc_yh - dc_yl

				-- Zero length, column does not exceed a pixel
			if count >= 0 then
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

					check attached dc_source as dcs then
						i := (frac |>> {M_FIXED}.FRACBITS) & 127
						if dcs.valid_index (i) then
							dc_source_val := dcs [i]
						else
							print ("R_DrawColumn: dc_source read out of bounds [" + i.out + "]%N")
							dc_source_val := 0
						end
					end
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
		local
			src: PIXEL_T_BUFFER
			dest: PIXEL_T_BUFFER
			border_patch: MANAGED_POINTER
			x, y: INTEGER
			patch: PATCH_T
			name1: STRING
			name2: STRING
			name: STRING
		do
				-- DOOM border patch.
			name1 := "FLOOR7_2"
				-- DOOM II border patch.
			name2 := "GRNROCK"
				-- If we are running full screen, there is no need to do any of this,
				-- and the background buffer can be freed if it was previously in use.
			if scaledviewwidth = SCREENWIDTH then
				if background_buffer /= Void then
					background_buffer := Void
				end
					-- return
			else
					-- Allocate the background buffer if necessary
				if background_buffer = Void then
					create background_buffer.make (SCREENWIDTH * (SCREENHEIGHT - SBARHEIGHT))
				end
				if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
					name := name2
				else
					name := name1
				end
				border_patch := i_main.w_wad.w_cachelumpname (name)
				create src.share_from_pointer (border_patch.item, border_patch.count)
				dest := background_buffer
				check attached dest then
					from
						y := 0
					until
						y >= SCREENHEIGHT - SBARHEIGHT
					loop
						from
							x := 0
						until
							x >= SCREENWIDTH // 64
						loop
							dest.copy_from_count (src + ((y & 63) |<< 6), 64)
							dest := dest + 64
							x := x + 1
						end
						if SCREENWIDTH & 63 /= 0 then
							dest.copy_from_count (src + ((y & 63) |<< 6), SCREENWIDTH & 63)
							dest := dest + (SCREENWIDTH & 63)
						end
						y := y + 1
					end
				end

					-- Draw screen and bezel; this is done to a separate screen buffer.

				check attached background_buffer as bb then
					i_main.v_video.V_UseBuffer (bb)
				end
				patch := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("brdr_t"))
				from
					x := 0
				until
					x >= scaledviewwidth
				loop
					i_main.v_video.V_DrawPatch (viewwindowx + x, viewwindowy - 8, patch)
					x := x + 8
				end
				patch := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("brdr_b"))
				from
					x := 0
				until
					x >= scaledviewwidth
				loop
					i_main.v_video.V_DrawPatch (viewwindowx + x, viewwindowy + viewheight, patch)
					x := x + 8
				end
				patch := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("brdr_l"))
				from
					y := 0
				until
					y >= viewheight
				loop
					i_main.v_video.V_DrawPatch (viewwindowx - 8, viewwindowy + y, patch)
					y := y + 8
				end
				patch := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("brdr_r"))
				from
					y := 0
				until
					y >= viewheight
				loop
					i_main.v_video.V_DrawPatch (viewwindowx + scaledviewwidth, viewwindowy + y, patch)
					y := y + 8
				end

					-- Draw beveled edge.
				i_main.v_video.V_DrawPatch (viewwindowx - 8, viewwindowy - 8, create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("brdr_tl")))
				i_main.v_video.V_DrawPatch (viewwindowx + scaledviewwidth, viewwindowy - 8, create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("brdr_tr")))
				i_main.v_video.V_DrawPatch (viewwindowx - 8, viewwindowy + viewheight, create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("brdr_bl")))
				i_main.v_video.V_DrawPatch (viewwindowx + scaledviewwidth, viewwindowy + viewheight, create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("brdr_br")))
				i_main.v_video.V_RestoreBuffer
			end
		end

	R_VideoErase (ofs: INTEGER; count: INTEGER)
			-- Copy a screen buffer
			--
			-- ofs was originally unsigned
		do
				-- LFB copy.
				-- This might not be a good idea if memcpy
				-- is not optiomal, e.g. byte by byte on
				-- a 32bit CPU, as GNU GCC/Linux libc did
				-- at one point.
			if attached background_buffer as bb then
				(i_main.i_video.I_VideoBuffer + ofs).copy_from_count (bb + ofs, count)
			end
		end

	R_DrawViewBorder
			-- Draws the border around the view
			--  for different size windows?
		local
			top: INTEGER
			side: INTEGER
			ofs: INTEGER
			i: INTEGER
		do
			if scaledviewwidth = SCREENWIDTH then
					-- return
			else
				top := ((SCREENHEIGHT - SBARHEIGHT) - viewheight) // 2
				side := (SCREENWIDTH - scaledviewwidth) // 2
					-- copy top and one line of left side
				R_VideoErase (0, top * SCREENWIDTH + side)
					-- copy one line of right side and bottom
				ofs := (viewheight + top) * SCREENWIDTH - side
				R_VideoErase (ofs, top * SCREENWIDTH + side)
					-- copy sides using wraparound
				ofs := top * SCREENWIDTH + SCREENWIDTH - side
				side := side |<< 1
				from
					i := 1
				until
					i >= viewheight
				loop
					R_VideoErase (ofs, side)
					ofs := ofs + SCREENWIDTH
					i := i + 1
				end

					-- ?
				i_main.v_video.V_MarkRect (0, 0, SCREENWIDTH, SCREENHEIGHT - SBARHEIGHT)
			end
		end

feature -- R_DrawTranslatedColumn

	dc_translation: detachable INDEX_IN_ARRAY [NATURAL_16] assign set_dc_translation

	set_dc_translation (a_dc_translation: like dc_translation)
		do
			dc_translation := a_dc_translation
		end

	translationtables: detachable ARRAY [NATURAL_16]

	R_DrawTranslatedColumn
			-- Used to draw player sprites
			-- with the green colorramp mapped to others.
			-- Could be used with different translation
			-- tables, e.g. the lighter colored version
			-- of the BaronOfHell, the HellKnight, uses
			-- identical sprites, kinda brightened up.
		require
			RANGECHECK: dc_x < SCREENWIDTH and dc_yl >= 0 and dc_yh < SCREENHEIGHT
		local
			count: INTEGER
			dest: PIXEL_T_BUFFER
			frac: FIXED_T
			fracstep: FIXED_T
		do
			count := dc_yh - dc_yl
			if count >= 0 then
				check
					RANGECHECK: dc_x < SCREENWIDTH and dc_yl >= 0 and dc_yh < SCREENHEIGHT
				end
				dest := ylookup [dc_yl] + columnofs [dc_x]

					-- Looks familiar.
				fracstep := dc_iscale
				frac := dc_texturemid + (dc_yl - i_main.r_main.centery) * fracstep

					-- Here we do an additional index re-mapping.
				from
					count := count + 1
				until
					count = 0
				loop
						-- Translation tables are used
						-- to map certain colorramps to other ones,
						-- used with PLAY sprites.
						-- Thus the "green" ramp of the player 0 sprite
						-- is mapped to gray, red, black/indigo.
					check attached dc_colormap as dcc and then attached dc_translation as dct and then attached dc_source as dcs then
						dest.put (dcc [dct [dcs [frac |>> {M_FIXED}.FRACBITS]]], 0)
					end
					dest := dest + SCREENWIDTH
					frac := frac + fracstep
					count := count - 1
				end
			end
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
					ds_source_val := src [spot]
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
			{NOT_IMPLEMENTED}.not_implemented ("R_DrawColumnLow", true)
		end

	R_DrawFuzzColumn
		require
			RANGECHECK: dc_x < SCREENWIDTH and dc_yl >= 0 and dc_yh < SCREENHEIGHT
		do
			{NOT_IMPLEMENTED}.not_implemented ("R_DrawFuzzColumn", true)
		end

	r_DrawSpanLow
		require
			RANGECHECK: ds_x2 >= ds_x1 and ds_x1 >= 0 and ds_x2 < SCREENWIDTH and ds_y <= SCREENHEIGHT
		do
			{NOT_IMPLEMENTED}.not_implemented ("R_DrawSpanLow", true)
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
