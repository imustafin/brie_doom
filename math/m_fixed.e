note
	description: "[
		m_fixed.c
		Fixed point arithmetics, implementation
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
			c: REAL
		do
			c := (a.to_real / b.to_real) * FRACUNIT
			if c >= 2147483648.0 or c < -2147483648.0 then
				{I_MAIN}.i_error ("FixedDiv: divide by zero")
			end
			Result := c.floor
		ensure
			instance_free: class
		end

end
