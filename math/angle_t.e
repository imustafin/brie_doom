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

feature
	flip_sign alias "-": like Current
		do
			Result := {NATURAL} 0 - Current
		end

	abs: like Current
		local
			min_one: like Current
		do
			if bit_test(31) then
				Result := -Current
			else
				Result := Current
			end
		end
end
