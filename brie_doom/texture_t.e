note
	description: "[
		texture_t from r_data.c
		
		A maptexturedef_t describes a rectangular texture,
		which is composed of one or more mappatch_t structures
		that arrange graphic patches.
	]"

class
	TEXTURE_T

create
	make, make_from_maptexture_t

feature

	make
		do
			name := ""
			create patches.make_empty
		end

	make_from_maptexture_t (m: MAPTEXTURE_T; patchlookup: ARRAY [INTEGER])
		local
			i: INTEGER
		do
			width := m.width
			height := m.height
			name := m.name
			create patches.make_filled (create {TEXPATCH_T}, 0, m.patches.count - 1)
			from
				i := 0
			until
				i >= patches.count
			loop
				patches [i] := create {TEXPATCH_T}
				patches [i].originx := m.patches [i].originx
				patches [i].originy := m.patches [i].originy
				patches [i].patch := patchlookup [m.patches [i].patch]
				i := i + 1
			end
		end

feature

	name: STRING assign set_name
			-- Keep name for switch changing, etc.

	set_name (a_name: like name)
		do
			name := a_name
		end

	width: INTEGER_16 assign set_width

	set_width (a_width: like width)
		do
			width := a_width
		end

	height: INTEGER_16 assign set_height

	set_height (a_height: like height)
		do
			height := a_height
		end

		-- All the patches[patchcount]
		-- are drawn back to front into the cached texture.

	patches: ARRAY [TEXPATCH_T]

invariant
	name.count <= 8

end
