note
	description: "w_wad.c"
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
	FILELUMP_T

create
	make, read_bytes

feature

	filepos: INTEGER

	size: INTEGER

	name: STRING

feature

	make (a_filepos: like filepos; a_size: like size; a_name: like name)
		do
			filepos := a_filepos
			size := a_size
			name := a_name
		end

	read_bytes (a_file: RAW_FILE)
		local
			i: INTEGER
			p: MANAGED_POINTER
			c: CHARACTER
		do
			create p.make (16)
			a_file.read_to_managed_pointer (p, 0, 16)
			filepos := p.read_integer_32_le (0)
			size := p.read_integer_32_le (4)
			from
				name := ""
				i := 8
			until
				i >= 16
			loop
				c := p.read_character (i)
				if c /~ '%U' then
					name.extend (p.read_character (i))
					i := i + 1
				else
					i := 17 -- break
				end
			end
		end

end
