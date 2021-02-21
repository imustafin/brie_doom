note
	description: "tables.h"

expanded class
	ANGLE_T

inherit

	NATURAL_32_REF

create
	default_create, from_natural

convert
	from_natural ({NATURAL}),
	to_integer_32: {INTEGER_32}

feature

	from_natural (a_natural: NATURAL)
		do
			set_item (a_natural)
		end

end
