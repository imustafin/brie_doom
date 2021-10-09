note
	description: "[
		mapthing_t from doomdata.h
		
		Thing definition, position, orientation and type,
		plus skill/visibility flags and attributes.
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
	MAPTHING_T

create
	default_create, from_pointer

feature

	x: INTEGER_16

	y: INTEGER_16

	angle: INTEGER_16

	type: INTEGER_16

	options: INTEGER_16

feature

	from_pointer (m: MANAGED_POINTER; offset: INTEGER)
		do
			x := m.read_integer_16_le (offset)
			y := m.read_integer_16_le (offset + 2)
			angle := m.read_integer_16_le (offset + 4)
			type := m.read_integer_16_le (offset + 6)
			options := m.read_integer_16_le (offset + 8)
		end

	structure_size: INTEGER = 10

end
