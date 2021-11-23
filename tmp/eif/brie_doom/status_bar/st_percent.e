note
	description: "st_percent_t with it's functions from st_lib.c"
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
	ST_PERCENT

create
	make

feature

	i_main: I_MAIN

	make (x, y: INTEGER; pl: ARRAY [detachable PATCH_T]; num: FUNCTION [INTEGER]; on: PREDICATE; a_p: like p; a_i_main: I_MAIN)
		do
			i_main := a_i_main
			create n.make (x, y, pl, num, on, 3, a_i_main)
			p := a_p
		end

feature

	n: ST_NUMBER
			-- number information

	p: PATCH_T
			-- percent sign graphic

feature

	update (refresh: BOOLEAN)
		do
			if refresh and n.on.item then
				i_main.v_video.v_drawpatch (n.x, n.y, p)
			end
			n.update (refresh)
		end

end
