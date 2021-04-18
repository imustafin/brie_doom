note
	description: "Utility class to represent pointers inside array"

class
	INDEX_IN_ARRAY [G]

create
	make

feature

	index: INTEGER

	array: ARRAY [G]

feature

	make (a_index: INTEGER; a_array: ARRAY [G])
		do
			index := a_index
			array := a_array
		end

feature

	plus alias "+" (num: INTEGER): like Current
		do
			create Result.make (index + num, array)
		end

	minus alias "-" (num: INTEGER): like Current
		do
			create Result.make (index - num, array)
		end

end
