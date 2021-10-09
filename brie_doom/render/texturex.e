note
	description: "[
		Struct for TEXTURE1 and TEXTURE2 lumps.
		
		Definition: https://doomwiki.org/wiki/TEXTURE1_and_TEXTURE2
	]"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
		Copyright (C) 2021 Ilgiz Mustafin

		This program is free software; you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation; either version 2 of the License, or
		(at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along
		with this program; if not, write to the Free Software Foundation, Inc.,
		51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
				print("read_maptexture_t not implemented%N")
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
