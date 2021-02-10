note
	description: "w_wad.c"

class
	FILELUMP_T

create
	make, read_bytes

feature

	filepos: INTEGER

	size: INTEGER

	name: STRING

feature

	make (a_filepos: like filepos; a_size: like size; a_name: like name)
		do
			filepos := a_filepos
			size := a_size
			name := a_name
		end

	read_bytes (a_file: RAW_FILE)
		local
			i: INTEGER
			p: MANAGED_POINTER
		do
			create p.make (16)
			a_file.read_to_managed_pointer (p, 0, 16)
			filepos := p.read_integer_32_le (0)
			size := p.read_integer_32_le (4)
			from
				name := ""
				i := 8
			until
				i >= 16
			loop
				name.extend (p.read_character (i))
				i := i + 1
			end
		end

end
