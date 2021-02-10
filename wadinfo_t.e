note
	description: "w_wad.h"

class
	WADINFO_T

create
	read_bytes

feature

	read_bytes (a_file: RAW_FILE)
		local
			i: INTEGER
			p: MANAGED_POINTER
		do
			create p.make (12)
			a_file.read_to_managed_pointer (p, 0, 12)
			identification := ""
			from
				i := 0
			until
				i > 3
			loop
				identification.extend (p.read_character (i))
				i := i + 1
			end
			numlumps := p.read_integer_32_le (4)
			infotableofs := p.read_integer_32_le (8)
		end

feature

	identification: STRING

	numlumps: INTEGER

	infotableofs: INTEGER

end
