note
	description: "tables.h"
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
	ANGLE_T

inherit

	NATURAL_32_REF

create
	default_create, from_natural

convert
	from_natural ({NATURAL}),
	as_integer_32: {INTEGER_32}

feature

	from_natural (a_natural: NATURAL)
		do
			set_item (a_natural)
		end

feature

	flip_sign alias "-": like Current
		do
			Result := {NATURAL} 0 - Current
		end

	abs: like Current
		local
			min_one: like Current
		do
			if bit_test (31) then
				Result := - Current
			else
				Result := Current
			end
		end

end
