note
	description: "st_binicon_t with it's functions from st_lib.c"
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
	ST_BIN_ICON

create
	make

feature

	i_main: I_MAIN

	make (a_x, a_y: INTEGER; i: PATCH_T; a_val: like val; a_on: like on; a_i_main: I_MAIN)
		do
			i_main := a_i_main
			x := a_x
			y := a_y
			oldval := False
			val := a_val
			on := a_on
			p := i
		end

feature

	x, y: INTEGER
			-- center-justified location of icon

	oldval: BOOLEAN
			-- last icon value

	val: PREDICATE
			-- pointer to current icon status

	on: PREDICATE
			-- pointer to boolean
			-- stating whether to update icon

	p: PATCH_T
			-- icon

	data: INTEGER
			-- user data

feature

	update (refresh: BOOLEAN)
		local
			l_x, l_y, w, h: INTEGER
		do
			if on.item and (oldval /= val.item or refresh) then
				l_x := x - p.leftoffset
				l_y := y - p.topoffset
				w := p.width
				h := p.height
				check
					l_y - {ST_STUFF}.ST_Y >= 0
				end
				if val.item then
					i_main.v_video.v_drawpatch (x, y, p)
				else
					check attached i_main.st_stuff.st_backing_screen as sb then
						i_main.v_video.v_copyrect (l_x, l_y - {ST_STUFF}.ST_Y, sb, w, h, l_x, l_y)
					end
				end
				oldval := val.item
			end
		end

end
