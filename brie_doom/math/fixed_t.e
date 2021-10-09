note
	description: "m_fixed.h"
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

expanded class
	FIXED_T

inherit

	INTEGER_32_REF

create
	default_create, from_integer

convert
	from_integer ({INTEGER}),
	as_natural_32: {NATURAL_32},
	as_integer_32: {INTEGER_32}

feature

	from_integer (a_integer: INTEGER)
		do
			set_item (a_integer)
		end

end
