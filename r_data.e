note
	description: "[
		r_data.c
		Preparation for data rendering,
		generation of lookups, caching, retrieval by name.
	]"

class
	R_DATA

create
	make

feature

	make
		do
			create colormaps.make_empty
		end

feature

	colormaps: ARRAY [LIGHTTABLE_T]

feature

	R_InitTextures
		do
				-- Stub
		end

	R_InitFlats
		do
				-- Stub
		end

	R_InitSpriteLumps
		do
				-- Stub
		end

	R_InitColormaps
		do
				-- Stub
		end

	R_InitData
		do
			R_InitTextures
			print ("%NInitTextures")
			R_InitFlats
			print ("%NInitFlats")
			R_InitSpriteLumps
			print ("%NInitSprites")
			R_InitColormaps
			print ("%NInitColormaps")
		end

end
