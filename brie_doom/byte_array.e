note
	description: "Reference for array of bytes (NATURAL_8)"
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
	BYTE_ARRAY

inherit

	BYTE_SEQUENCE

create
	with_array

feature

	with_array (ar: ARRAY [NATURAL_8])
		do
			item := ar
		end

	item: ARRAY [NATURAL_8]

feature

	get alias "[]" (index: INTEGER): NATURAL_8
		do
			Result := item [index]
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := item.valid_index (i)
		end

end
