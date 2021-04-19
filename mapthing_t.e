note
	description: "[
		mapthing_t from doomdata.h
		
		Thing definition, position, orientation and type,
		plus skill/visibility flags and attributes.
	]"

class
	MAPTHING_T

create
	from_pointer

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
