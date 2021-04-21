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

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create vissprites.make_empty
			create spritelights.make_empty
			create screenheightarray.make_filled (0, 0, {DOOMDEF_H}.SCREENWIDTH - 1)
			create negonearray.make_filled (-1, 0, {DOOMDEF_H}.SCREENWIDTH - 1)
		end

feature

	vissprites: ARRAY [VISSPRITE_T]

	vissprite_p: INTEGER -- originally pointer inside vissprites

	spritelights: ARRAY [LIGHTTABLE_T] -- lighttable_t**

feature
	-- constant arrays
	-- used for psprite clipping and initializing clipping

	negonearray: ARRAY [INTEGER_16]

	screenheightarray: ARRAY [INTEGER_16]

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

	R_AddSprites (sec: SECTOR_T)
			-- During BSP traversal, this adds sprites by sector.
		local
			thing: detachable MOBJ_T
			lightnum: INTEGER
		do
				-- BSP is traversed by subsector.
				-- A sector might have beend split into several
				-- subsectors during BSP building.
				-- Thus we check whether its already added.
			if sec.validcount /= i_main.r_main.validcount then
					-- Well, now it will be done
				sec.validcount := i_main.r_main.validcount
				lightnum := (sec.lightlevel |>> {R_MAIN}.LIGHTSEGSHIFT) + i_main.r_main.extralight
				if lightnum < 0 then
					spritelights := i_main.r_main.scalelight [0]
				elseif lightnum >= {R_MAIN}.LIGHTLEVELS then
					spritelights := i_main.r_main.scalelight [{R_MAIN}.LIGHTLEVELS - 1]
				else
					spritelights := i_main.r_main.scalelight [lightnum]
				end

					-- Handle all things in sector.
				from
					thing := sec.thinglist
				until
					thing = Void
				loop
					R_ProjectSprite (thing)
					thing := thing.snext
				end
			end
		end

	R_ProjectSprite (thing: MOBJ_T)
			-- Generates a vissprite for a thing
			-- if it might be visible.
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

invariant
	screenheightarray.lower = 0
	screenheightarray.count = {DOOMDEF_H}.SCREENWIDTH
	negonearray.lower = 0
	negonearray.count = {DOOMDEF_H}.SCREENWIDTH
	across negonearray as i_neg all i_neg.item = -1 end

end
