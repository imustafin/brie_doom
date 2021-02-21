note
	description: "m_fixed.h"

expanded class
	FIXED_T

inherit

	INTEGER_32_REF

create
	default_create,
	from_integer

convert
	from_integer ({INTEGER}),
	to_natural_32: {NATURAL_32}

feature

	from_integer (a_integer: INTEGER)
		do
			set_item (a_integer)
		end

feature

	abs_ref2: like Current
		do
			Result := item.abs
		ensure
			same_if_non_negative: item >= 0 implies Result = Current
			other_if_negative: item < 0 implies Result /= Current
		end

end
