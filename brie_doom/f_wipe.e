note
	description: "[
		f_wipe.c
		Mission begin melt/wipe screen special effect.
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
	F_WIPE

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create melt_y.make_empty
			create wipe_scr.make (0)
			create wipe_scr_end.make (0)
			create wipe_scr_start.make (0)
		end

feature

	wipe_scr_start: PIXEL_T_BUFFER

	wipe_scr_end: PIXEL_T_BUFFER

	wipe_scr: PIXEL_T_BUFFER

	SIZEOF_WIPE_SCR: INTEGER = 1 -- sizeof(*wipe_scr)

	go: BOOLEAN

feature

	wipe_StartScreen (x, y, width, height: INTEGER)
		do
			create wipe_scr_start.make ({DOOMDEF_H}.screenwidth * {DOOMDEF_H}.screenheight)
			i_main.i_video.I_ReadScreen (wipe_scr_start)
		end

	wipe_EndScreen (x, y, width, height: INTEGER)
		do
			create wipe_scr_end.make ({DOOMDEF_H}.screenwidth * {DOOMDEF_H}.screenheight)
			i_main.i_video.i_readscreen (wipe_scr_end)
			i_main.v_video.V_DrawBlock (x, y, width, height, wipe_scr_start) -- restore start scr.
		end

	wipe_ScreenWipe (wipeno: INTEGER; x, y: INTEGER; width, height: INTEGER; ticks: INTEGER): BOOLEAN
		local
			rc: BOOLEAN
			wipes: ARRAY [PREDICATE [TUPLE [INTEGER, INTEGER, INTEGER]]]
		do
				-- Mainly from Chocolate Doom

				-- Initial stuff
			wipes := {ARRAY [PREDICATE [TUPLE [INTEGER, INTEGER, INTEGER]]]} <<agent wipe_initColorXForm, agent wipe_doColorXForm, agent wipe_exitColorXForm, agent wipe_initMelt, agent wipe_doMelt, agent wipe_exitMelt>>
			wipes.rebase (0)
			if not go then
				go := True
				wipe_scr := i_main.i_video.I_VideoBuffer
				wipes [wipeno * 3].call (width, height, ticks)
			end

				-- do a piece of wipe-in
			i_main.v_video.V_MarkRect (0, 0, width, height)
			rc := wipes [wipeno * 3 + 1].item (width, height, ticks)

				-- final stuff
			if rc then
				go := False
				wipes [wipeno * 3 + 2].call (width, height, ticks)
			end
			Result := not go
		end

feature -- wipe ColorXForm

	wipe_initColorXForm (width, height, ticks: INTEGER): BOOLEAN
		do
			wipe_scr_start.copy_from (wipe_scr_end)
		end

	wipe_doColorXForm (width, height, ticks: INTEGER): BOOLEAN
		local
			changed: BOOLEAN
			w: INTEGER
			e: INTEGER
			newval: NATURAL_8
		do
			changed := False
			from
				w := 0
				e := 0
			invariant
				w >= 0 and w < wipe_scr.p.count
				e >= 0 and e < wipe_scr_end.p.count
			until
				w = wipe_scr.p.count - 1
			loop
				if wipe_scr.item (w) /= wipe_scr_end.item (e) then
					if wipe_scr.item (w) > wipe_scr_end.item (e) then
						newval := (wipe_scr.item (w) - ticks).to_natural_8
						if newval < wipe_scr_end.item (e) then
							wipe_scr.put (wipe_scr_end.item (e), w)
						else
							wipe_scr.put (newval, w)
						end
						changed := True
					elseif wipe_scr.item (w) < wipe_scr_end.item (e) then
						newval := (wipe_scr.item (w) + ticks).to_natural_8
						if newval > wipe_scr_end.item (e) then
							wipe_scr.put (wipe_scr_end.item (e), w)
						else
							wipe_scr.put (newval, w)
						end
						changed := True
					end
				end
				w := w + 1
				e := e + 1
			variant
				wipe_scr.p.count - w
			end
			Result := not changed
		end

	wipe_exitColorXForm (width, height, ticks: INTEGER): BOOLEAN
		do
			Result := False
		end

feature -- wipe Melt

	melt_y: ARRAY [INTEGER]

	wipe_shittyColMajorXForm (array: PIXEL_T_BUFFER; width, height: INTEGER)
		local
			x: INTEGER
			y: INTEGER
			dest: PIXEL_T_BUFFER
		do
			create dest.make (width * height * 2) -- x2 to make dpixels
			from
				y := 0
			until
				y >= height
			loop
				from
					x := 0
				until
					x >= width
				loop
					dest.put_dpixel (array.item_dpixel (y * width + x), x * height + y)
					x := x + 1
				end
				y := y + 1
			end
			array.copy_from (dest)
		end

	wipe_initMelt (width, height, ticks: INTEGER): BOOLEAN
		local
			r: INTEGER
			i: INTEGER
		do
				-- copy start screen to main screen
			wipe_scr.copy_from (wipe_scr_start)

				-- makes this wipe faster (in theory)
				-- to have stuff in column-major format
			wipe_shittyColMajorXForm (wipe_scr_start, width // 2, height)
			wipe_shittyColMajorXForm (wipe_scr_end, width // 2, height)

				-- setup initial column positions
				-- (y < 0 => not ready to scroll yet)
			create melt_y.make_filled (0, 0, width - 1)
			melt_y [0] := - (i_main.m_random.m_random \\ 16)
			from
				i := 1
			until
				i >= width
			loop
				r := (i_main.m_random.m_random \\ 3) - 1
				melt_y [i] := melt_y [i - 1] + r
				if melt_y [i] > 0 then
					melt_y [i] := 0
				elseif melt_y [i] = -16 then
					melt_y [i] := -15
				end
				i := i + 1
			end
		end

	wipe_doMelt (a_width, height, a_ticks: INTEGER): BOOLEAN
		local
			i: INTEGER
			j: INTEGER
			dy: INTEGER
			idx: INTEGER
			width: INTEGER
			ticks: INTEGER
			s: INTEGER -- dpixel index in wipe_scr_end
			d: INTEGER -- dpixel index in wipe_scr
		do
			Result := True
			width := a_width // 2
			ticks := a_ticks
			from
			until
				ticks = 0
			loop
				from
					i := 0
				until
					i >= width
				loop
					if melt_y [i] < 0 then
						melt_y [i] := melt_y [i] + 1
						Result := False
					elseif melt_y [i] < height then
						if melt_y [i] < 16 then
							dy := melt_y [i] + 1
						else
							dy := 8
						end
						if melt_y [i] + dy >= height then
							dy := height - melt_y [i]
						end
							-- Draw some wipe_scr_end
						from
							s := i * height + melt_y [i]
							d := melt_y [i] * width + i
							idx := 0
							j := dy
						until
							j = 0
						loop
							wipe_scr.put_dpixel (wipe_scr_end.item_dpixel (s), d + idx)
							s := s + 1
							idx := idx + width
							j := j - 1
						end
						melt_y [i] := melt_y [i] + dy
							-- Draw some wipe_scr_start
						from
							s := i * height
							d := melt_y [i] * width + i
							idx := 0
							j := height - melt_y [i]
						until
							j = 0
						loop
							wipe_scr.put_dpixel (wipe_scr_start.item_dpixel (s), d + idx)
							s := s + 1
							idx := idx + width
							j := j - 1
						end
						Result := False
					end
					i := i + 1
				end
				ticks := ticks - 1
			end
		end

	wipe_exitMelt (width, height, ticks: INTEGER): BOOLEAN
		do
				-- Stub, free melt_y, wipe_scr_start, wipe_scr_end
			{NOT_IMPLEMENTED}.not_implemented ("wipe_exitMelt", False)
		end

feature -- wipenos

	wipe_ColorXForm: INTEGER = 0

	wipe_Melt: INTEGER = 1

	wipe_NUMWIPES: INTEGER = 2

end
