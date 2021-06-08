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
			create vsprsortedhead
			vissprites := {REF_ARRAY_CREATOR [VISSPRITE_T]}.make_ref_array (MAXVISSPRITES)
		end

feature

	MAXVISSPRITES: INTEGER = 128

	vissprites: ARRAY [VISSPRITE_T]

	vissprite_p: INTEGER -- originally pointer inside vissprites

	spritelights: detachable ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]] -- lighttable_t**

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

feature -- R_SortVisSprites

	vsprsortedhead: VISSPRITE_T

	R_SortVisSprites
		local
			i: INTEGER
			count: INTEGER
			ds: INDEX_IN_ARRAY [VISSPRITE_T]
			dss: VISSPRITE_T
			best: VISSPRITE_T
			unsorted: VISSPRITE_T
			bestscale: FIXED_T
		do
			count := vissprite_p - vissprites.lower
			create unsorted
			unsorted.next := unsorted
			unsorted.prev := unsorted
			if count = 0 then
					-- return
			else
				from
					create ds.make (vissprites.lower, vissprites)
				until
					ds.index >= vissprite_p
				loop
					ds.this.next := (ds + 1).this
					ds.this.prev := (ds - 1).this
					ds := ds + 1
				end
				vissprites [0].prev := unsorted
				unsorted.next := vissprites [0]
				vissprites [vissprite_p - 1].next := unsorted
				unsorted.prev := vissprites [vissprite_p - 1]

					-- pull the vissprites out by scale
				vsprsortedhead.next := vsprsortedhead
				vsprsortedhead.prev := vsprsortedhead
				from
					i := 0
				until
					i >= count
				loop
					bestscale := {DOOMTYPE_H}.maxint
					from
						dss := unsorted.next
					until
						dss = unsorted
					loop
						check attached dss then
							if dss.scale < bestscale then
								bestscale := dss.scale
								best := dss
							end
							dss := dss.next
						end
					end
					check attached best then
						check attached best.next as bnext then
							bnext.prev := best.prev
						end
						check attached best.prev as bprev then
							bprev.next := best.next
						end
						best.next := vsprsortedhead
						best.prev := vsprsortedhead.prev
						check attached vsprsortedhead.prev as vprev then
							vprev.next := best
						end
						vsprsortedhead.prev := best
					end
					i := i + 1
				end
			end
		end

feature

	R_DrawSprite (spr: VISSPRITE_T)
		do
				-- Stub
		end

	R_DrawPlayerSprites
		do
				-- Stub
		end

	R_DrawMasked
		local
			spr: VISSPRITE_T
			ds: INTEGER
		do
			R_SortVisSprites
			if vissprite_p > vissprites.lower then
					-- draw all vissprites back to front
				from
					spr := vsprsortedhead.next
				until
					spr = vsprsortedhead
				loop
					check attached spr then
						R_DrawSprite (spr)
						spr := spr.next
					end
				end
			end

				-- render any remaining masked mid textures
			from
				ds := i_main.r_bsp.ds_p - 1
			until
				ds < i_main.r_bsp.drawsegs.lower
			loop
				if i_main.r_bsp.drawsegs [ds].maskedtexturecol /= Void then
					i_main.r_segs.R_RenderMaskedSegRange (i_main.r_bsp.drawsegs [ds], i_main.r_bsp.drawsegs [ds].x1, i_main.r_bsp.drawsegs [ds].x2)
				end
				ds := ds - 1
			end

				-- draw the psprites on top of everything
				-- but does not draw on side views
			if i_main.r_main.viewangleoffset /= 0 then
				R_DrawPlayerSprites
			end
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
				check attached i_main.r_main.scalelight as scalelight then
					if lightnum < 0 then
						spritelights := scalelight [0]
					elseif lightnum >= {R_MAIN}.LIGHTLEVELS then
						spritelights := scalelight [{R_MAIN}.LIGHTLEVELS - 1]
					else
						spritelights := scalelight [lightnum]
					end
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
	{UTILS [VISSPRITE_T]}.invariant_ref_array (vissprites, MAXVISSPRITES)

end
