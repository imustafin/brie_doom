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
	from_pointer

feature

	pointer: MANAGED_POINTER

feature

	width: INTEGER_16

	height: INTEGER_16

	leftoffset: INTEGER_16

	topoffset: INTEGER_16

	columnofs: ARRAY [INTEGER]

feature

	columns: ARRAYED_LIST [COLUMN_T]
		local
			i: INTEGER
		do
			create Result.make (width)

			from
				i := 0
			until
				i >= width
			loop
				Result.extend(create {COLUMN_T}.from_pointer(pointer, columnofs[i]))

				i := i + 1
			end
		end

feature

	from_pointer (a_p: MANAGED_POINTER)
		require
			has_header: a_p.count >= 40
		local
			i: INTEGER
		do
			pointer := a_p
			width := pointer.read_integer_16_le (0)
			height := pointer.read_integer_16_le (2)
			leftoffset := pointer.read_integer_16_le (4)
			topoffset := pointer.read_integer_16_le (6)
			create columnofs.make_filled (0, 0, width - 1) -- originally was `int columnofs[8];`
			from
				i := 0
			until
				i > columnofs.upper
			loop
				columnofs [i] := pointer.read_integer_32_le (8 + i * 4)
				i := i + 1
			end
		end

end
