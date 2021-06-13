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
			create flattranslation.make_empty
			create texturetranslation.make_empty
			create textureheight.make_empty
			create texturewidthmask.make_empty
		end

feature

	colormaps: ARRAY [LIGHTTABLE_T]

	numtextures: INTEGER

	textures: ARRAY [TEXTURE_T]

	firstflat: INTEGER

	lastflat: INTEGER

	numflats: INTEGER

	flattranslation: ARRAY [INTEGER]

	texturetranslation: ARRAY [INTEGER]

	textureheight: ARRAY [INTEGER]

	texturewidthmask: ARRAY [INTEGER]

	texturecolumnlump: detachable ARRAY [detachable ARRAY [INTEGER_16]]

	texturecolumnofs: detachable ARRAY [detachable ARRAY [NATURAL_16]]

	texturecomposite: detachable ARRAY [detachable MANAGED_POINTER]

	texturecompositesize: detachable ARRAY [INTEGER]

	firstspritelump: INTEGER

	lastspritelump: INTEGER

	numspritelumps: INTEGER

	spritewidth: detachable ARRAY [FIXED_T]

	spriteoffset: detachable ARRAY [FIXED_T]

	spritetopoffset: detachable ARRAY [FIXED_T]

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
				i > names.names.upper
			loop
				patchlookup [i] := i_main.w_wad.w_checknumforname (names.names [i])
				i := i + 1
			variant
				names.names.upper - i + 1
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
			create texturewidthmask.make_filled (0, 0, numtextures - 1)
			create textureheight.make_filled (0, 0, numtextures - 1)
			create texturecolumnlump.make_filled (Void, 0, numtextures - 1)
			create texturecomposite.make_filled (Void, 0, numtextures - 1)
			create texturecompositesize.make_filled (0, 0, numtextures - 1)
			create texturecolumnofs.make_filled (Void, 0, numtextures - 1)
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
			from
				i := textures.lower
			until
				i > textures.upper
			loop
				check attached texturecolumnlump as tcl then
					tcl [i] := create {ARRAY [INTEGER_16]}.make_filled (0, 0, textures [i].width - 1)
				end
				check attached texturecolumnofs as tco then
					tco [i] := create {ARRAY [NATURAL_16]}.make_filled (0, 0, textures [i].width - 1)
				end
				from
					j := 1
				until
					j * 2 > textures [i].width
				loop
					j := j |<< 1
				end
				texturewidthmask [i] := j - 1
				textureheight [i] := textures [i].height.to_integer_32 |<< {M_FIXED}.FRACBITS
				i := i + 1
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
			create texturetranslation.make_filled (0, 0, numtextures + 1)
			from
				i := 0
			until
				i >= numtextures
			loop
				texturetranslation [i] := i
				i := i + 1
			end
		ensure
			not texturetranslation.is_empty
			not texturewidthmask.is_empty
		end

	R_GenerateLookup (texnum: INTEGER)
		local
			texture: TEXTURE_T
			patchcount: ARRAY [INTEGER] -- patchcount[texture->width]
			patch: INTEGER -- index inside textures.patches
			realpatch: PATCH_T
			x: INTEGER
			x1: INTEGER
			x2: INTEGER
			i: INTEGER
			collump: ARRAY [INTEGER_16]
			colofs: ARRAY [NATURAL_16]
		do
			texture := textures [texnum]

				-- Composite texture not created yet
			check attached texturecomposite as tc then
				tc [texnum] := Void
			end
			check attached texturecompositesize as tcs then
				tcs [texnum] := 0
			end
			check attached texturecolumnlump as tcl then
				collump := tcl [texnum]
			end
			check attached texturecolumnofs as tcofs then
				check attached tcofs [texnum] as tcofs_texnum then
					colofs := tcofs [texnum]
				end
			end

				-- Now coun the number of columns
				-- that are covered by more than one patch.
				-- Fill in the lump / offset, so columns
				-- with only a single patch are all done.
			create patchcount.make_filled (0, 0, texture.width - 1)
			from
				i := 0
				patch := 0
			until
				i >= texture.patches.count
			loop
				realpatch := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpnum (texture.patches [patch].patch, {Z_ZONE}.pu_cache))
				x1 := texture.patches [patch].originx
				x2 := x1 + realpatch.width
				if x1 < 0 then
					x := 0
				else
					x := x1
				end
				if x2 > texture.width then
					x2 := texture.width
				end
				from
				until
					x >= x2
				loop
					patchcount [x] := patchcount [x] + 1
					check attached collump as cl then
						collump [x] := texture.patches [patch].patch.to_integer_16
					end
					check attached colofs then
						colofs [x] := (realpatch.columnofs [x - x1] + 3).to_natural_16
					end
					x := x + 1
				end
				i := i + 1
				patch := patch + 1
			end
			from
				x := 0
			until
				x >= texture.width
			loop
				if patchcount [x] = 0 then
					print ("R_GenerateLookup: column without a patch (" + texture.name + ")%N")
					x := texture.width -- return
				elseif patchcount [x] > 1 then
						-- Use the cached block
					check attached collump as cl then
						cl [x] := -1
					end
					check attached texturecompositesize as tcs then
						check attached colofs then
							colofs [x] := tcs [texnum].to_natural_16
						end
						if tcs [texnum] > 0x10000 - texture.height then
							{I_MAIN}.i_error ("R_GenerateLookup: texture " + texnum.out + " is > 64k")
						end
						tcs [texnum] := tcs [texnum] + texture.height
					end
				end
				x := x + 1
			end
		end

	R_InitFlats
		local
			i: INTEGER
		do
			firstflat := i_main.w_wad.w_getnumforname ("F_START") + 1
			lastflat := i_main.w_wad.w_getnumforname ("F_END") - 1
			numflats := lastflat - firstflat + 1
			create flattranslation.make_filled (0, 0, numflats + 1)
			from
				i := 0
			until
				i >= numflats
			loop
				flattranslation [i] := i
				i := i + 1
			end
		end

	R_InitSpriteLumps
			-- Finds the width and hoffset of all sprites in the wad,
			-- so the sprite does not need to be cached completely
			-- just for having the header info ready during rendering.
		local
			i: INTEGER
			patch: PATCH_T
		do
			firstspritelump := i_main.w_wad.w_getnumforname ("S_START") + 1
			lastspritelump := i_main.w_wad.w_getnumforname ("S_END") - 1
			numspritelumps := lastspritelump - firstspritelump + 1
			create spritewidth.make_filled (0, 0, numspritelumps - 1)
			create spriteoffset.make_filled (0, 0, numspritelumps - 1)
			create spritetopoffset.make_filled (0, 0, numspritelumps - 1)
			from
				i := 0
			until
				i >= numspritelumps
			loop
					-- skip debug print
				patch := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpnum (firstspritelump + i, {Z_ZONE}.pu_cache))
				check attached spritewidth as sw and then attached spriteoffset as so and then attached spritetopoffset as st then
					sw [i] := patch.width.to_integer_32 |<< {M_FIXED}.FRACBITS
					so [i] := patch.leftoffset.to_integer_32 |<< {M_FIXED}.FRACBITS
					st [i] := patch.topoffset.to_integer_32 |<< {M_FIXED}.FRACBITS
				end
				i := i + 1
			end
		end

	R_InitColormaps
		local
			i: INTEGER
			lump, length: INTEGER
			p: MANAGED_POINTER
		do
				-- No 256 byte align
			lump := i_main.w_wad.W_GetNumForName ("COLORMAP")
			length := i_main.w_wad.W_LumpLength (lump)
			create colormaps.make_filled ({NATURAL_8} 0, 0, length - 1)
			p := i_main.w_wad.W_ReadLump (lump)
			from
				i := 0
			until
				i > colormaps.upper
			loop
				colormaps [i] := p.read_natural_8_le (i)
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
					Result >= NUMTEXTURES or else textures [Result].name.as_upper ~ name.as_upper
				loop
					Result := Result + 1
				end
				if Result >= NUMTEXTURES then
					Result := -1
				end
			end
		end

	R_FlatNumForName (name: STRING): INTEGER
			-- Retrieval, get a flat number for a flat name.
		do
			Result := i_main.w_wad.W_CheckNumForName (name)
			if Result = -1 then
				{I_MAIN}.i_error ("R_FlatNumForName: " + name + " not found%N")
			end
			Result := Result - firstflat
		end

	R_PrecacheLevel
		do
				-- Stub
		end

	R_GetColumn (tex, a_col: INTEGER): MANAGED_POINTER_WITH_OFFSET
		local
			lump: INTEGER
			ofs: INTEGER
			col: INTEGER
		do
			col := a_col
			col := col & texturewidthmask [tex]
			check attached texturecolumnlump as tcl then
				check attached tcl [tex] as tcl_tex then
					check attached tcl_tex [col] as tcl_tex_col then
						lump := tcl_tex_col
					end
				end
			end
			check attached texturecolumnofs as tcofs then
				check attached tcofs [tex] as tcofs_tex then
					ofs := tcofs_tex [col]
				end
			end
			if lump > 0 then
				create Result.make (i_main.w_wad.w_cachelumpnum (lump, {Z_ZONE}.pu_cache), ofs)
			else
				check attached texturecomposite as tc_ar then
					if tc_ar [tex] = Void then
						R_GenerateComposite (tex)
					end
					check attached tc_ar [tex] as tc then
						create Result.make (tc, ofs)
					end
				end
			end
		end

	R_GenerateComposite (texnum: INTEGER)
			-- Using the texture definition,
			-- the composite texture is created from the patches,
			-- and each column is cached
		local
			block: MANAGED_POINTER
			texture: TEXTURE_T
			patch: INTEGER -- index inside texture.patches
			realpatch: PATCH_T
			x: INTEGER
			x1: INTEGER
			x2: INTEGER
			i: INTEGER
			collump: ARRAY [INTEGER_16]
			colofs: ARRAY [NATURAL_16]
		do
			texture := textures [texnum]
			check attached texturecompositesize as tcs then
				check attached texturecomposite as tc then
					block := create {MANAGED_POINTER}.make (tcs [texnum])
					tc [texnum] := block
				end
			end
			check attached texturecolumnlump as tcl then
				collump := tcl [texnum]
			end
			check attached texturecolumnofs as tcofs then
				check attached tcofs [texnum] as tcofs_texnum then
					colofs := tcofs_texnum
				end
			end

				-- Composite the columns together.
			from
				i := 0
				patch := 0
			until
				i >= texture.patches.count
			loop
				realpatch := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpnum (texture.patches [patch].patch, {Z_ZONE}.pu_cache))
				x1 := texture.patches [patch].originx
				x2 := x1 + realpatch.width
				if x1 < 0 then
					x := 0
				else
					x := x1
				end
				if x2 > texture.width then
					x2 := texture.width
				end
				from
				until
					x >= x2
				loop
						-- Column does not have multiple patches?
					check attached collump then
						if collump [x] >= 0 then
								-- continue
						else
							R_DrawColumnInCache (realpatch, x - x1, block, colofs [x], texture.patches [patch].originy, texture.height)
						end
					end
					x := x + 1
				end
				i := i + 1
				patch := patch + 1
			end
		end

	R_DrawColumnInCache (real_patch: PATCH_T; col_num: INTEGER; cache: MANAGED_POINTER; cache_ofs: INTEGER; originy: INTEGER; cacheheight: INTEGER)
		local
			count: INTEGER
			position: INTEGER
			source: ARRAY [NATURAL_8]
			column: COLUMN_T
			post_num: INTEGER
		do
			from
				column := real_patch.columns [col_num + 1]
				post_num := 1
			until
				post_num > column.posts.upper
			loop
				source := column.posts [post_num].body
				count := column.posts [post_num].length
				position := originy + column.posts [post_num].topdelta
				if position < 0 then
					count := count + position
					position := 0
				end
				if position + count > cacheheight then
					count := cacheheight - position
				end
				if count > 0 then
					cache.put_array (source.subarray (0, count - 1), cache_ofs + position)
				end
				post_num := post_num + 1
			end
		end

end
