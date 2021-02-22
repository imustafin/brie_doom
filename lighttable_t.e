note
	description: "[
		r_defs.h
		This could be wider for >8 bit display.
		Indeed, true color support is possible
		 precalculating 24bpp lightmap/colormap LUT.
		 from darkening PLAYPAL to all black.
		Could even us emore than 32 levels.
	]"

class
	LIGHTTABLE_T

inherit

	INTEGER_8_REF

create
	default_create, from_integer

convert
	from_integer ({INTEGER})

feature

	from_integer (a_integer: INTEGER)
		do
			set_item (a_integer.as_integer_8)
		end

end
