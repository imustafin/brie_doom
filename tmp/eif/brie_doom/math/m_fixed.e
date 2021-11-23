note
	description: "[
		m_fixed.c
		Fixed point arithmetics, implementation
	]"
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
	M_FIXED

inherit

	DOOMTYPE_H

feature -- m_fixed.h

	FRACBITS: INTEGER = 16

	FRACUNIT: INTEGER
		once
			Result := 1 |<< FRACBITS
		ensure
			instance_free: class
		end

feature

	FixedMul (a, b: FIXED_T): FIXED_T
		do
			Result := ((a.as_integer_64 * b.as_integer_64) |>> FRACBITS).as_integer_32
		ensure
			instance_free: class
		end

	FixedDiv (a, b: FIXED_T): FIXED_T
		do
			if (a.abs |>> 14) >= b.abs then
				if a.bit_xor (b) < 0 then
					Result := MININT
				else
					Result := MAXINT
				end
			else
				Result := FixedDiv2 (a, b)
			end
		ensure
			instance_free: class
		end

	FixedDiv2 (a, b: FIXED_T): FIXED_T
		local
			c: REAL_64
		do
			c := (a.to_double / b.to_double) * FRACUNIT
			if c >= 2147483648.0 or c < -2147483648.0 then
				{I_MAIN}.i_error ("FixedDiv: divide by zero")
			end
			Result := c.floor
		ensure
			instance_free: class
		end

end
