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

feature

	mp: MANAGED_POINTER

feature

	ofs: INTEGER

	count: INTEGER
		do
			Result := mp.count
		end

	get alias "[]" (pos: INTEGER): NATURAL_8
		do
			Result := mp.read_natural_8_le (ofs + pos)
		end


	valid_index (i: INTEGER): BOOLEAN
		local
			pos: INTEGER
		do
			pos := ofs + i
			Result := pos >= 0 and pos < mp.count
		end

	this: NATURAL_8
		-- Get the first item
		do
			Result := get (0)
		end

	set (val: NATURAL_8)
		do
			mp.put_natural_8 (val, ofs)
		ensure
			this = val
		end

	plus alias "+" (num: INTEGER): like Current
		do
			create Result.make (mp, num + ofs)
		end

end
