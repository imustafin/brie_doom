note
	description: "Utility class to bundle a managed pointer with an offset"
	license: "[
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
	MANAGED_POINTER_WITH_OFFSET

inherit

	BYTE_SEQUENCE

create
	make

feature

	make (a_mp: like mp; a_ofs: like ofs)
		do
			mp := a_mp
			ofs := a_ofs
		end

feature

	mp: MANAGED_POINTER

feature

	ofs: INTEGER

	count: INTEGER
		do
			Result := mp.count
		end

	get alias "[]" (pos: INTEGER): NATURAL_8
		do
			Result := mp.read_natural_8_le (ofs + pos)
		end

	valid_index (i: INTEGER): BOOLEAN
		local
			pos: INTEGER
		do
			pos := ofs + i
			Result := pos >= 0 and pos < mp.count
		end

	this: NATURAL_8
			-- Get the first item
		do
			Result := get (0)
		end

	set (val: NATURAL_8)
		do
			mp.put_natural_8 (val, ofs)
		ensure
			this = val
		end

	plus alias "+" (num: INTEGER): like Current
		do
			create Result.make (mp, num + ofs)
		end

end
