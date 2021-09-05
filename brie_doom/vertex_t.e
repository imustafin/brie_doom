note
	description: "[
		vertex_t from r_defs.h
		
		Your plain vanilla vertex.
		Note: transformed values not buffered locally,
		like some DOOM-alikes ("wt", "WebView") did.
	]"

class
	VERTEX_T

create
	default_create, from_pointer

feature

	x: FIXED_T

	y: FIXED_T

feature

	from_pointer (m: MANAGED_POINTER; offset: INTEGER)
		do
			x := m.read_integer_16_le (0 + offset).to_integer_32 |<< {M_FIXED}.FRACBITS
			y := m.read_integer_16_le (2 + offset).to_integer_32 |<< {M_FIXED}.FRACBITS
		end

	structure_size: INTEGER = 4
			-- sizeof(mapvertex_t)

end
