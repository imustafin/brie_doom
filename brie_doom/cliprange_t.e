note
	description: "[
		cliprange_t from r_bsp.c
		
		ClipWallSegment
		Clips the given range of columns
		and includes it in the new clip list.
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
	CLIPRANGE_T

inherit

	ANY
		redefine
			out
		end

feature

	first: INTEGER assign set_first

	set_first (a_first: like first)
		do
			first := a_first
		end

	last: INTEGER assign set_last

	set_last (a_last: INTEGER)
		do
			last := a_last
		end

feature

	out: STRING
		do
			Result := "(" + first.out + ", " + last.out + ")"
		end

end
