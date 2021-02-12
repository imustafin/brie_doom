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
		end

end
