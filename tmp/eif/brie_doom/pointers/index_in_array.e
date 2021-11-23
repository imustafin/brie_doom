note
	description: "Utility class to represent pointers inside array"
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
	INDEX_IN_ARRAY [G]

create
	make

feature

	index: INTEGER

feature

	make (a_index: INTEGER; a_array: ARRAY [G])
		do
			index := a_index
			array := a_array
		end

feature {NONE}

	array: ARRAY [G]

feature

	plus alias "+" (num: INTEGER): like Current
		do
			create Result.make (index + num, array)
		end

	minus alias "-" (num: INTEGER): like Current
		do
			create Result.make (index - num, array)
		end

	item alias "[]" (num: INTEGER): G assign put
		require
			valid_index (num)
		do
			Result := array [num + index]
		end

	this: G
		do
			Result := array [index]
		end

	put (v: G; num: INTEGER)
		require
			valid_index (num)
		do
			array [num + index] := v
		end

	subcopy (other: ARRAY [G]; start_pos, end_pos, index_pos: INTEGER)
		require
			valid_index (index_pos)
			valid_index (index_pos + (end_pos - start_pos))
		do
			array.subcopy (other, start_pos, end_pos, index + index_pos)
		end

	valid_index (num: INTEGER): BOOLEAN
		do
			Result := array.valid_index (index + num)
		end

end
