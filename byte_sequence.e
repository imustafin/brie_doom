note
	description: "General interface for a bound byte sequence"

deferred class
	BYTE_SEQUENCE

feature

	get alias "[]" (index: INTEGER): NATURAL_8
		require
			valid_index (index)
		deferred
		end

	valid_index (i: INTEGER): BOOLEAN
		deferred
		end

end
