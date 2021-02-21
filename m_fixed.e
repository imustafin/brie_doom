note
	description: "[
		m_fixed.c
		Fixed point arithmetics, implementation
	]"

class
	M_FIXED

create
	make

feature

	make
		do
		end

feature -- m_fixed.h

	FRACBITS: INTEGER = 16

	FRACUNIT: INTEGER
		once
			Result := 1 |<< FRACBITS
		ensure
			instance_free: class
		end

feature
	FixedMul(a, b: FIXED_T): FIXED_T
	do
		Result := ((a.as_integer_64 * b.as_integer_64) |>> FRACBITS).as_integer_32
	ensure
		instance_free: class
	end

end
