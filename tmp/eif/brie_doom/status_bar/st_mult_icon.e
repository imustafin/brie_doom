note
	description: "st_multicon_t with it's functions from st_lib.c"
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
	ST_MULT_ICON

create
	make

feature

	i_main: I_MAIN

	make (a_x, a_y: INTEGER; il: ARRAY [detachable PATCH_T]; a_inum: like inum; a_on: like on; a_i_main: I_MAIN)
		do
			i_main := a_i_main
			x := a_x
			y := a_y
			oldinum := -1
			inum := a_inum
			on := a_on
			p := il
		end

feature

	x, y: INTEGER
			-- center-justified location of icons

	oldinum: INTEGER
			-- last icon number

	inum: FUNCTION [INTEGER]
			-- pointer to current icon

	on: PREDICATE
			-- pointer to boolean stating
			-- whether to update icon

	p: ARRAY [detachable PATCH_T]
			-- list of icons

	data: INTEGER
			-- user data

feature

	update (refresh: BOOLEAN)
		local
			l_x, l_y, w, h: INTEGER
		do
			if on.item and (oldinum /= inum.item or refresh) and (inum.item /= -1) then
				if oldinum /= -1 then
					check attached p [oldinum] as oldp then
						l_x := x - oldp.leftoffset
						l_y := y - oldp.topoffset
						w := oldp.width
						h := oldp.height
					end
					check
						l_y - {ST_STUFF}.st_y >= 0
					end
					check attached i_main.st_stuff.st_backing_screen as sb then
						i_main.v_video.v_copyrect (l_x, l_y - {ST_STUFF}.st_y, sb, w, h, l_x, l_y)
					end
				end
				check attached p [inum.item] as newp then
					i_main.v_video.v_drawpatch (x, y, newp)
				end
				oldinum := inum.item
			end
		end

end
