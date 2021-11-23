note
	description: "[
		Struct for PNAMES lump
		
		From https://zdoom.org/wiki/PNAMES
		Bytes 0-3 is uint32 (number of entries)
		x+0 - x+8 is char[8] (patch name)
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
	PNAMES

create
	from_pointer

feature

	from_pointer (m: MANAGED_POINTER)
		local
			len: NATURAL_32
			pos: INTEGER
			i: INTEGER
			cstr: C_STRING
		do
			len := m.read_natural_32_le (0)
			pos := 4 -- after len
			create names.make_filled ("", 0, len.to_integer_32 - 1)
			from
				i := 0
			until
				i >= len.to_integer_32
			loop
				cstr := create {C_STRING}.make_by_pointer_and_count (m.item + pos + i * 8, 8)
				names [i] := cstr.string
				i := i + 1
			end
		end

feature

	names: ARRAY [STRING]

end
