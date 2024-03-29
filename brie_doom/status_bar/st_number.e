note
	description: "st_number_t with it's functions from st_lib.c"
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
	ST_NUMBER

create
	make

feature

	i_main: I_MAIN

	make (a_x: like x; a_y: like y; a_p: like p; a_num: like num; a_on: like on; a_width: like width; a_i_main: I_MAIN)
		do
			x := a_x
			y := a_y
			oldnum := 0
			width := a_width
			num := a_num
			on := a_on
			p := a_p
			i_main := a_i_main
		end

feature

	x, y: INTEGER
			-- upper right-hand corner
			-- of the number (right-justified)

	width: INTEGER
			-- max # of digits in number

	oldnum: INTEGER
			-- last number value

	num: FUNCTION [INTEGER] assign set_num
			-- pointer to current value

	set_num (a_num: like num)
		do
			num := a_num
		end

	on: PREDICATE
			-- pointer to boolean stating
			-- whether to update number

	p: ARRAY [detachable PATCH_T]
			-- list of patches for 0-9

	data: INTEGER assign set_data
			-- user data

	set_data (a_data: like data)
		do
			data := a_data
		end

feature

	update (refresh: BOOLEAN)
		do
			if on.item then
				draw (refresh)
			end
		end

	draw (refreh: BOOLEAN)
			-- A fairly efficient way to draw a number
			-- based on differences from the old number.
			-- Note: worth the trouble?
		local
			numdigits: INTEGER
			l_num: INTEGER
			w: INTEGER
			h: INTEGER
			l_x: INTEGER
			neg: BOOLEAN
		do
			numdigits := width
			l_num := num.item
			check attached p [0] as p0 then
				w := p0.width
				h := p0.height
			end
			l_x := x
			oldnum := num.item
			neg := l_num < 0
			if neg then
				if numdigits = 2 and l_num < -9 then
					l_num := -9
				elseif numdigits = 3 and l_num < -99 then
					l_num := -99
				end
			end

				-- clear the area
			l_x := x - numdigits * w
			check
				y - {ST_STUFF}.ST_Y >= 0
			end
			check attached i_main.st_stuff.st_backing_screen as sb then
				i_main.v_video.v_copyrect (l_x, y - {ST_STUFF}.ST_Y, sb, w * numdigits, h, l_x, y)
			end

				-- if non-number, do not draw it
			if l_num = 1994 then
					-- return
			else
				l_x := x.item
					-- in the special case of 0, you draw 0
				if l_num = 0 then
					check attached p [0] as p0 then
						i_main.v_video.v_drawpatch (l_x - w, y, p0)
					end
				end
					-- draw the new number
				from
				until
					l_num = 0 or numdigits = 0
				loop
					l_x := l_x - w
					check attached p [l_num \\ 10] as pnum then
						i_main.v_video.v_drawpatch (l_x, y, pnum)
					end
					l_num := l_num // 10
					numdigits := numdigits - 1
				end

					-- draw a minus sign if necessary
				if neg and attached i_main.st_lib.sttminus as sm then
					i_main.v_video.v_drawpatch (l_x - 8, y, sm)
				end
			end
		ensure
			x_not_changed: x = old x
			y_not_changed: y = old y
		end

end
