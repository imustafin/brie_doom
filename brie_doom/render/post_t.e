note
	description: "r_defs.h"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
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
	POST_T

create
	from_pointer

feature

	topdelta: NATURAL_8

	length: NATURAL_8

	body: ARRAY [NATURAL_8]

feature

	from_pointer (p: MANAGED_POINTER; offset: INTEGER)
		require
			offset >= 0
		do
			topdelta := p.read_natural_8_le (offset)
			if not is_after then
				length := p.read_natural_8_le (offset + 1)
				body := p.read_array (offset + 3, length)
			else
				length := 0
				create body.make_empty
			end
			body.rebase (0)
		ensure
			body.lower = 0
		end

feature

	is_after: BOOLEAN
		do
			Result := topdelta = 0xff
		end

end
