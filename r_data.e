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

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create colormaps.make_empty
			create textures.make_empty
		end

feature

	colormaps: ARRAY [LIGHTTABLE_T]

	numtextures: INTEGER

	textures: ARRAY[TEXTURE_T]

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
		local
			i: INTEGER
			lump, length: INTEGER
			p: MANAGED_POINTER
		do
			lump := i_main.w_wad.W_GetNumForName ("COLORMAP")
			length := i_main.w_wad.W_LumpLength (lump)
			create colormaps.make_filled (0, 0, length - 1)
			p := i_main.w_wad.W_ReadLump (lump)
			from
				i := 0
			until
				i > colormaps.upper
			loop
				colormaps [i] := p.read_integer_8_le (i).as_integer_32
				i := i + 1
			end
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

	R_TextureNumForName (name: STRING): INTEGER
			-- Calls R_CheckTextureForName,
			-- aborts with error message
		do
			Result := R_CheckTextureNumForName (name)
			if Result = -1 then
				{I_MAIN}.i_error ("R_TextureNumForName: " + name + " not found%N")
			end
		end

	R_CheckTextureNumForName (name: STRING): INTEGER
			-- Check whether texture is available.
			-- Filter out NoTexture indicator.
		do
			if name.starts_with ("-") then
				Result := 0
			else
				from
					Result := 0
				until
					Result >= NUMTEXTURES or else textures [Result].name ~ name
				loop
					Result := Result + 1
				end
				if Result >= NUMTEXTURES then
					Result := -1
				end
			end
		end

end
