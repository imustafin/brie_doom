note
	description: "[
		Struct for TEXTURE1 and TEXTURE2 lumps.
		
		Definition: https://doomwiki.org/wiki/TEXTURE1_and_TEXTURE2
	]"

class
	TEXTUREX

create
	from_pointer

feature

	from_pointer(m: MANAGED_POINTER)
		local
			numtextures: INTEGER
			offsets: ARRAY[INTEGER]
			i: INTEGER
		do
			-- Read numtextures
			numtextures := m.read_integer_32_le (0)

			-- Read offset[]
			create offsets.make_filled (0, 0, numtextures - 1)
			from
				i := 0
			until
				i >= numtextures
			loop
				offsets[i] := m.read_integer_32_le (4 + i * 4)

				i := i + 1
			end

			-- Read mtexture[]
			create textures.make_filled(create {MAPTEXTURE_T}.make, 0, numtextures - 1)
			from
				i := 0
			until
				i >= numtextures
			loop
				textures[i] := read_maptexture_t(m, offsets[i])

				i := i + 1
			end
		end

		read_maptexture_t(m: MANAGED_POINTER; offset: INTEGER): MAPTEXTURE_T
			local
				patchcount: INTEGER_16
				patches: ARRAY [MAPPATCH_T]
				i: INTEGER
			do
				create Result.make
				Result.name := create {STRING}.make_from_c (m.item + offset)
				Result.masked := m.read_integer_32_le (offset + 0x08) /= 0
				Result.width := m.read_integer_16_le (offset + 0x0C)
				Result.height := m.read_integer_16_le (offset + 0x0E)
				-- skip columndirectory
				patchcount := m.read_integer_16_le (offset + 0x14)
				create patches.make_filled (create {MAPPATCH_T}, 0, patchcount - 1)
				from
					i := 0
				until
					i >= patchcount
				loop
					patches[i] := read_mappatch_t(m, offset + 0x16 + i * 10)
					i := i + 1
				end
				Result.patches := patches
			end

		read_mappatch_t(m: MANAGED_POINTER; offset: INTEGER): MAPPATCH_T
			do
				create Result
				Result.originx := m.read_integer_16_le (offset)
				Result.originy := m.read_integer_16_le (offset + 0x02)
				Result.patch := m.read_integer_16_le (offset + 0x04)
				Result.stepdir := m.read_integer_16_le (offset + 0x06)
				Result.colormap := m.read_integer_16_le (offset + 0x08)
			end

feature

	textures: ARRAY[MAPTEXTURE_T]


end
