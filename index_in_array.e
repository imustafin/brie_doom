note
	description: "Utility class to represent pointers inside array"

class
	INDEX_IN_ARRAY [G]

create
	make

feature

	index: INTEGER

feature

	make (a_index: INTEGER; a_array: ARRAY [G])
		do
			index := a_index
			array := a_array
		end

feature {NONE}

	array: ARRAY [G]

feature

	plus alias "+" (num: INTEGER): like Current
		do
			create Result.make (index + num, array)
		end

	minus alias "-" (num: INTEGER): like Current
		do
			create Result.make (index - num, array)
		end

	item alias "[]" (num: INTEGER): G assign put
		require
			valid_index (num)
		do
			Result := array [num + index]
		end

	put (v: G; num: INTEGER)
		require
			valid_index (num)
		do
			array [num + index] := v
		end

	subcopy (other: ARRAY [G]; start_pos, end_pos, index_pos: INTEGER)
		require
			valid_index (index_pos)
			valid_index (index_pos + (end_pos - start_pos))
		do
			array.subcopy (other, start_pos, end_pos, index + index_pos)
		end

	valid_index (num: INTEGER): BOOLEAN
		do
			Result := array.valid_index (index + num)
		end

end
