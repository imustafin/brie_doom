note
	description: "[
		r_defs.h
		Patches.
		A patch holds one or more columns.
		Patches are used for sprites and all masked pictures,
		and we compose textures from the TEXTURE1/2 lists
		of patches
	]"

class
	PATCH_T

create
	make_read_bytes

feature

	width: INTEGER_16

	height: INTEGER_16

	leftoffset: INTEGER_16

	topoffset: INTEGER_16

	columnofs: ARRAY [INTEGER]

feature

	make_read_bytes (a_file: RAW_FILE)
	local
		i: INTEGER
		p: MANAGED_POINTER
		do
			create columnofs.make_filled (0, 0, 7)

			create p.make (40)

			a_file.read_to_managed_pointer (p, 0, 40)

			width := p.read_integer_16_le (0)
			height := p.read_integer_16_le (2)
			leftoffset := p.read_integer_16_le (4)
			topoffset := p.read_integer_16_le (6)

			from
				i := 0
			until
				i >= 8
			loop
				columnofs[i] := p.read_integer_16_le (8 + i * 4)

				i := i + 1
			end
		end
end
