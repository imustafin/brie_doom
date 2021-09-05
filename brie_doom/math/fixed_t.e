note
	description: "m_fixed.h"

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
