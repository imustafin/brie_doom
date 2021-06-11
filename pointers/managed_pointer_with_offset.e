note
	description: "Utility class to bundle a managed pointer with an offset"

class
	MANAGED_POINTER_WITH_OFFSET

inherit

	BYTE_SEQUENCE

create
	make

feature

	make (a_mp: like mp; a_ofs: like ofs)
		do
			mp := a_mp
			ofs := a_ofs
		end

feature {NONE}

	mp: MANAGED_POINTER

feature

	ofs: INTEGER

	count: INTEGER
		do
			Result := mp.count
		end

	get alias "[]" (pos: INTEGER): NATURAL_8
		require else
			ofs + pos >= 0
			ofs + pos + {MANAGED_POINTER}.natural_8_bytes <= count
		do
			Result := mp.read_natural_8_le (ofs + pos)
		end

end
