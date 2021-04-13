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

	textures: ARRAY [TEXTURE_T]

feature

	R_InitTextures
			-- Initializes the texture list
			-- with the textures from the world map.
		local
			i: INTEGER
			j: INTEGER
			maptex1: TEXTUREX
			maptex2: TEXTUREX
			names: PNAMES
			patchlookup: ARRAY [INTEGER] -- lumpnum of i-th patch
		do
				-- Load the patch names from pnames.lmp.
			create names.from_pointer (i_main.w_wad.W_CacheLumpName ("PNAMES", {Z_ZONE}.pu_static))
			create patchlookup.make_filled (0, 0, names.names.count - 1)
			from
				i := 0
			until
				i >= names.names.count - 1
			loop
				patchlookup [i] := i_main.w_wad.w_checknumforname (names.names [i])
				i := i + 1
			end

				-- Load the map texture definitions from textures.lmp.
				-- The data is contained in one or two lumps,
				-- TEXTURE1 for shareware, plus TEXTURE2 for commercial.
			create maptex1.from_pointer (i_main.w_wad.W_CacheLumpName ("TEXTURE1", {Z_ZONE}.pu_static))
			numtextures := maptex1.textures.count
			if i_main.w_wad.W_CheckNumForName ("TEXTURE2") /= -1 then
				create maptex2.from_pointer (i_main.w_wad.W_CacheLumpName ("TEXTURE2", {Z_ZONE}.pu_static))
				numtextures := numtextures + maptex2.textures.count
			end

				-- Make textures
			create textures.make_filled (create {TEXTURE_T}.make, 0, numtextures - 1)
			from
				i := 0
			until
				i >= maptex1.textures.count
			loop
				textures [i] := create {TEXTURE_T}.make_from_maptexture_t (maptex1.textures [i], patchlookup)
				i := i + 1
			end
			if attached maptex2 as m2 then
				from
					j := 0
				until
					j >= m2.textures.count
				loop
					textures [i] := create {TEXTURE_T}.make_from_maptexture_t (m2.textures [j], patchlookup)
					i := i + 1
					j := j + 1
				end
			end

				-- Precalculate whatever possible
			from
				i := 0
			until
				i >= numtextures
			loop
				R_GenerateLookup (i)
				i := i + 1
			end

				-- Create translation table for global animation.
				-- Skip
		end

	R_GenerateLookup (texnum: INTEGER)
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
