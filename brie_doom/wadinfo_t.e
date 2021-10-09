note
	description: "w_wad.h"
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
	WADINFO_T

create
	read_bytes

feature

	read_bytes (a_file: RAW_FILE)
		local
			i: INTEGER
			p: MANAGED_POINTER
			c: CHARACTER
		do
			create p.make (12)
			a_file.read_to_managed_pointer (p, 0, 12)
			identification := ""
			from
				i := 0
			until
				i > 3
			loop
				c := p.read_character (i)
				if c /~ '%U' then
					identification.extend (c)
					i := i + 1
				else
					i := 4 -- break
				end
			end
			numlumps := p.read_integer_32_le (4)
			infotableofs := p.read_integer_32_le (8)
		end

feature

	identification: STRING

	numlumps: INTEGER

	infotableofs: INTEGER

end
