note
	description: "[
		r_things.c
		Refresh of things, i.e. objects represented by sprites.
	]"

class
	R_THINGS

create
	make

feature

	make
		do
			create vissprites.make_empty
		end

feature

	vissprites: ARRAY [VISSPRITE_T]

	vissprite_p: INTEGER -- originally pointer inside vissprites

feature

	R_InitSprites (namelist: ARRAY [STRING])
		do
				-- Stub
		end

	R_ClearSprites
			-- Called at frame start.
		do
			vissprite_p := 0
		end

	R_DrawMasked
		do
				-- Stub
		end

feature -- Sprite rotation

		-- Sprite rotation 0 is facing the viewer,
		--  rotation 1 is one angle turn CLOCKWISE around the axis.
		-- This is not the same as the angle,
		--  which increases counter clockwise (protractor).
		-- There was a lot of stuff grabbed wrong, so I changed it...

	pspritescale: FIXED_T assign set_pspritescale

	set_pspritescale (a_pspritescale: like pspritescale)
		do
			pspritescale := a_pspritescale
		end

	pspriteiscale: FIXED_T assign set_pspriteiscale

	set_pspriteiscale (a_pspriteiscale: like pspriteiscale)
		do
			pspriteiscale := a_pspriteiscale
		end

		-- constant arrays
		--  used for psprite clipping and initializing clipping

	negonearray: ARRAY [INTEGER_16]
		once
			create Result.make_filled (0, 0, {DOOMDEF_H}.SCREENWIDTH - 1)
		end

	screenheightarray: ARRAY [INTEGER_16]
		once
			create Result.make_filled (0, 0, {DOOMDEF_H}.SCREENWIDTH - 1)
		end

end
