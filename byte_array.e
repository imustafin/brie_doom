note
	description: "Reference for array of bytes (NATURAL_8)"

class
	BYTE_ARRAY

inherit

	BYTE_SEQUENCE

create
	with_array

feature

	with_array (ar: ARRAY [NATURAL_8])
		do
			item := ar
		end

	item: ARRAY [NATURAL_8]

feature

	get alias "[]" (index: INTEGER): NATURAL_8
		do
			Result := item [index]
		end

end
