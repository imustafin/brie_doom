note
	description: "r_defs.h"

class
	POST_T

create
	from_pointer

feature

	topdelta: NATURAL_8

	length: NATURAL_8

	body: ARRAY [NATURAL_8]

feature

	from_pointer (p: MANAGED_POINTER; offset: INTEGER)
		require
			offset >= 0
		do
			topdelta := p.read_natural_8_le (offset)
			if not is_after then
				length := p.read_natural_8_le (offset + 1)
				body := p.read_array (offset + 2, length)
			else
				length := 0
				create body.make_empty
			end
		end

feature

	is_after: BOOLEAN
		do
			Result := topdelta = 0xff
		end

end
