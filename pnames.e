note
	description: "[
		Struct for PNAMES lump
		
		From https://zdoom.org/wiki/PNAMES
		Bytes 0-3 is uint32 (number of entries)
		x+0 - x+8 is char[8] (patch name)
	]"

class
	PNAMES

create
	from_pointer

feature

	from_pointer (m: MANAGED_POINTER)
		local
			len: NATURAL_32
			pos: INTEGER
			i: INTEGER
		do
			len := m.read_natural_32_le (0)
			pos := 4 -- after len
			create names.make_filled ("", 0, len.to_integer_32 - 1)
			from
				i := 0
			until
				i >= len.to_integer_32
			loop
				names [i] := create {STRING}.make_from_c (m.item + pos + i * 8)
				i := i + 1
			end
		end

feature

	names: ARRAY [STRING]

end
