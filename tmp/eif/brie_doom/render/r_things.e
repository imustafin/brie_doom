note
	description: "[
		r_things.c
		Refresh of things, i.e. objects represented by sprites.
	]"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
				Copyright (C) 2005-2014 Simon Howard
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
			spritename := ""
			make_sprtemp
			create overflowsprite
		end

feature

	BASEYCENTER: INTEGER = 100

	MINZ: INTEGER
		once
			Result := {M_FIXED}.fracunit * 4
		end

	MAXVISSPRITES: INTEGER = 128

	vissprites: ARRAY [VISSPRITE_T]

	vissprite_p: INTEGER -- originally pointer inside vissprites

	spritelights: detachable ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]] -- lighttable_t**

feature
	-- constant arrays
	-- used for psprite clipping and initializing clipping

	negonearray: ARRAY [INTEGER_16]

	screenheightarray: ARRAY [INTEGER_16]

feature -- R_InitSprites

	sprites: detachable ARRAY [SPRITEDEF_T]

	numsprites: INTEGER

	sprtemp: ARRAY [SPRITEFRAME_T]

	make_sprtemp
		do
			sprtemp := {REF_ARRAY_CREATOR [SPRITEFRAME_T]}.make_ref_array (29)
		end

	maxframe: INTEGER

	spritename: STRING

	R_InitSprites (namelist: ARRAY [STRING])
			-- Called at program start.
		do
				-- negonearray created in make
			R_InitSpriteDefs (namelist)
		end

	make_sprites (num: INTEGER)
		do
			sprites := {REF_ARRAY_CREATOR [SPRITEDEF_T]}.make_ref_array (num)
		end

	compute_intname (str: STRING): INTEGER
			-- take first 4 chars and construct an int from them
		do
			Result := (str [1].code) | (str [2].code |<< 8) | (str [3].code |<< 16) | (str [4].code |<< 24)
		end

	R_InitSpriteDefs (namelist: ARRAY [STRING])
			-- Pass a null terminated list of sprite names
			-- (4 chars exactly) to be used.
			-- Builds the sprite rotation matrixes to account
			-- for horizontally flipped sprites.
			-- Will report an error if the lumps are inconsistant.
			-- Only called at startup.
			--
			-- Sprite lump names are 4 characters for the actor,
			-- a letter for the frame, and a number for the rotation.
			-- A sprite that is flippable will have an additional
			-- letter/number appended.
			-- The rotation can be 0 to signify no rotations.
		require
			all_4_long: across namelist as name all name.item.count = 4 end
		local
			i: INTEGER
			l: INTEGER
			intname: INTEGER
			frame: INTEGER
			rotation: INTEGER
			s: INTEGER
			e: INTEGER
			patched: INTEGER
		do
			numsprites := namelist.count
			numsprites := numsprites - 1 -- ??? // -1 added by georg
			make_sprites (namelist.count)
			s := i_main.r_data.firstspritelump - 1
			e := i_main.r_data.lastspritelump + 1

				-- scan all the lump names for each of the names,
				-- noting the highest frame letter.
				-- Just compare 4 characters as ints
			from
				i := 0
			until
				i >= numsprites
			loop
				spritename := namelist [i]
				make_sprtemp
				maxframe := -1
				intname := compute_intname (spritename)

					-- scan the lumps,
					-- filling in the frames for whatever is found
				from
					l := s + 1
				until
					l >= e
				loop
					check attached i_main.w_wad.lumpinfo as li then
						if compute_intname (li [l].name) = intname then
							frame := li [l].name [5].code - ('A').code
							rotation := li [l].name [6].code - ('0').code
							if i_main.doomstat_h.modifiedgame then
								patched := i_main.w_wad.W_GetNumForName (li [l].name)
							else
								patched := l
							end
							R_InstallSpriteLump (patched, frame.to_natural_32, rotation.to_natural_32, False)
							if li [l].name.count >= 7 then
								frame := li [l].name [7].code - ('A').code
								rotation := li [l].name [8].code - ('0').code
								R_InstallSpriteLump (l, frame.to_natural_32, rotation.to_natural_32, True)
							end
						end
					end
					l := l + 1
				end

					-- check the frames that were found for completeness
				if maxframe = -1 then
					check attached sprites as ss then
						ss [i].numframes := 0
					end
				else
					maxframe := maxframe + 1
					from
						frame := 0
					until
						frame >= maxframe
					loop
						if not sprtemp [frame].initialized then
								-- no rotations were found for that frame at all
							{I_MAIN}.i_error ("R_InitSprites: No patches found for " + namelist [i] + " frame " + ((frame + ('A').code).to_character_8.out))
						elseif not sprtemp [frame].rotate then
								-- only the first rotation is needed
						elseif sprtemp [frame].rotate then
								-- must have all 8 frames
							from
								rotation := 0
							until
								rotation >= 8
							loop
								if sprtemp [frame].lump [rotation] = -1 then
									{I_MAIN}.i_error ("R_InitSprites: Sprite " + namelist [l] + " frame " + (frame + ('A').code).to_character_8.out + " is missing rotations")
								end
								rotation := rotation + 1
							end
						end
						frame := frame + 1
					end

						-- allocate space for the frames present and copy sprtemp to it
					check attached sprites as ss then
						ss [i].numframes := maxframe
						ss [i].spriteframes := sprtemp -- assign because we create new sprtemps each iteration
					end
				end
				i := i + 1
			end
		end

	R_InstallSpriteLump (lump: INTEGER; frame, a_rotation: NATURAL; flipped: BOOLEAN)
		local
			r: INTEGER
			rotation: NATURAL
		do
			rotation := a_rotation
			if frame >= 29 or rotation > 8 then
				{I_MAIN}.i_error ("R_InstallSpriteLump: Bad frame characters in lump " + lump.out)
			end
			if frame.to_integer_32 > maxframe then
				maxframe := frame.to_integer_32
			end
			if rotation = 0 then
					-- the lump should be used for all rotations
				if sprtemp [frame.to_integer_32].initialized and sprtemp [frame.to_integer_32].rotate = False then
					{I_MAIN}.i_error ("R_InitSprites: Sprite " + spritename + " frame " + (frame.to_integer_32 + ('A').code).to_character_8.out + " has multip rot=0 lump")
				end
				if sprtemp [frame.to_integer_32].initialized and sprtemp [frame.to_integer_32].rotate = True then
					{I_MAIN}.i_error ("R_InitSprites: Sprite " + spritename + " frame " + (frame.to_integer_32 + ('A').code).to_character_8.out + " has rotations and a rot=0 lump")
				end
				sprtemp [frame.to_integer_32].rotate := False
				sprtemp [frame.to_integer_32].initialized := True
				from
					r := 0
				until
					r >= 8
				loop
					sprtemp [frame.to_integer_32].lump [r] := (lump.to_integer_32 - i_main.r_data.firstspritelump).to_integer_16
					sprtemp [frame.to_integer_32].flip [r] := flipped
					r := r + 1
				end
			else
					-- the lump is only used for one rotation
				if sprtemp [frame.to_integer_32].initialized and sprtemp [frame.to_integer_32].rotate = False then
					{I_MAIN}.i_error ("R_InitSprites: Sprite " + spritename + " frame " + (frame.to_integer_32 + ('A').code).to_character_8.out + " has rotations and a rot=0 lump")
				end
				sprtemp [frame.to_integer_32].rotate := True
				sprtemp [frame.to_integer_32].initialized := True

					-- make 0 based
				rotation := rotation - 1
				if sprtemp [frame.to_integer_32].lump [rotation.to_integer_32] /= -1 then
					{I_MAIN}.i_error ("R_InitSprites: Sprite " + spritename + " : " + (frame.to_integer_32 + ('A').code).to_character_8.out + " : " + (rotation.to_integer_32 + ('1').code).to_character_8.out + "has two lumps mapped to it")
				end
				sprtemp [frame.to_integer_32].lump [rotation.to_integer_32] := (lump - i_main.r_data.firstspritelump).to_integer_16
				sprtemp [frame.to_integer_32].flip [rotation.to_integer_32] := flipped
			end
		ensure
			sprtemp [frame.to_integer_32].initialized
		end

feature

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
					if ds.index /= 0 then
						ds.this.prev := (ds - 1).this
					end
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

feature -- R_DrawMaskedColumn

	mfloorclip: detachable INDEX_IN_ARRAY [INTEGER_16] assign set_mfloorclip

	set_mfloorclip (a_mfloorclip: like mfloorclip)
		do
			mfloorclip := a_mfloorclip
		end

	mceilingclip: detachable INDEX_IN_ARRAY [INTEGER_16] assign set_mceilingclip

	set_mceilingclip (a_mceilingclip: like mceilingclip)
		do
			mceilingclip := a_mceilingclip
		end

	spryscale: FIXED_T assign set_spryscale

	set_spryscale (a_spryscale: like spryscale)
		do
			spryscale := a_spryscale
		end

	sprtopscreen: FIXED_T assign set_sprtopscreen

	set_sprtopscreen (a_sprtopscreen: like sprtopscreen)
		do
			sprtopscreen := a_sprtopscreen
		end

	R_DrawMaskedColumn (column: COLUMN_T)
			-- Used for sprites and masked mid textures.
			-- Masked means: partly transparent, i.e. stored
			-- in posts/runs of opaque pixels.
		local
			topscreen: INTEGER
			bottomscreen: INTEGER
			basetexturemid: FIXED_T
			i: INTEGER
			post: POST_T
		do
			basetexturemid := i_main.r_draw.dc_texturemid
			from
				i := column.posts.lower
			until
				i > column.posts.upper
			loop
					-- calculate unclipped screen coordinates
					-- for post
				post := column.posts [i]
				topscreen := sprtopscreen + spryscale * post.topdelta.to_integer_32
				bottomscreen := topscreen + spryscale * post.length.to_integer_32
				i_main.r_draw.dc_yl := (topscreen + {M_FIXED}.FRACUNIT - 1) |>> {M_FIXED}.FRACBITS
				i_main.r_draw.dc_yh := (bottomscreen - 1) |>> {M_FIXED}.FRACBITS
				check attached mfloorclip as mfc then
					if i_main.r_draw.dc_yh >= mfc [i_main.r_draw.dc_x] then
						i_main.r_draw.dc_yh := mfc [i_main.r_draw.dc_x] - 1
					end
				end
				check attached mceilingclip as mcc then
					if i_main.r_draw.dc_yl <= mcc [i_main.r_draw.dc_x] then
						i_main.r_draw.dc_yl := mcc [i_main.r_draw.dc_x] + 1
					end
				end
				if i_main.r_draw.dc_yl <= i_main.r_draw.dc_yh then
					i_main.r_draw.dc_source := create {BYTE_ARRAY}.with_array (post.body)
					i_main.r_draw.dc_texturemid := basetexturemid - (post.topdelta.to_integer_32 |<< {M_FIXED}.FRACBITS)

						-- Drawn by either R_DrawColumn
						-- or (SHADOW) R_DrawFuzzColumn
					check attached i_main.r_main.colfunc as colfunc then
						colfunc.call
					end
				end
				i := i + 1
			end
			i_main.r_draw.dc_texturemid := basetexturemid
		end

feature -- R_DrawVisSprite

	R_DrawVisSprite (vis: VISSPRITE_T; x1, x2: INTEGER)
			-- mfloorclip and mceiling should also be set
		require
			mfloorclip /= Void
			mceilingclip /= Void
		local
			texturecolumn: INTEGER
			frac: FIXED_T
			patch: PATCH_T
		do
			patch := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpnum (vis.patch + i_main.r_data.firstspritelump))
			i_main.r_draw.dc_colormap := vis.colormap
			if i_main.r_draw.dc_colormap = Void then
					-- NULL colormap = shadow draw
				i_main.r_main.colfunc := i_main.r_main.fuzzcolfunc
			elseif vis.mobjflags & {P_MOBJ}.MF_TRANSLATION /= 0 then
				i_main.r_main.colfunc := agent (i_main.r_draw).R_DrawTranslatedColumn
				check attached i_main.r_draw.translationtables as ttables then
					i_main.r_draw.dc_translation := create {INDEX_IN_ARRAY [NATURAL_16]}.make (-256 + ((vis.mobjflags & {P_MOBJ}.MF_TRANSLATION) |>> ({P_MOBJ}.MF_TRANSSHIFT - 8)), ttables)
				end
			end
			i_main.r_draw.dc_iscale := (vis.xiscale).abs |>> i_main.r_main.detailshift
			i_main.r_draw.dc_texturemid := vis.texturemid
			frac := vis.startfrac
			spryscale := vis.scale
			sprtopscreen := i_main.r_main.centeryfrac - {M_FIXED}.fixedmul (i_main.r_draw.dc_texturemid, spryscale)
			from
				i_main.r_draw.dc_x := vis.x1
			until
				i_main.r_draw.dc_x > vis.x2
			loop
				texturecolumn := frac |>> {M_FIXED}.fracbits
				check
					RANGECHECK: texturecolumn >= 0 and texturecolumn < patch.width
				end
				R_DrawMaskedColumn (patch.column_by_offset (patch.columnofs [texturecolumn]))
				i_main.r_draw.dc_x := i_main.r_draw.dc_x + 1
				frac := frac + vis.xiscale
			end
			i_main.r_main.colfunc := i_main.r_main.basecolfunc
		end

feature

	R_DrawSprite (spr: VISSPRITE_T)
		local
			ds: INDEX_IN_ARRAY [DRAWSEG_T]
			clipbot: ARRAY [INTEGER_16]
			cliptop: ARRAY [INTEGER_16]
			x: INTEGER
			r1: INTEGER
			r2: INTEGER
			scale: FIXED_T
			lowscale: FIXED_T
			silhouette: INTEGER
		do
			create clipbot.make_filled (0, 0, {DOOMDEF_H}.screenwidth - 1)
			create cliptop.make_filled (0, 0, {DOOMDEF_H}.screenwidth - 1)
			from
				x := spr.x1
			until
				x > spr.x2
			loop
				clipbot [x] := -2
				cliptop [x] := -2
				x := x + 1
			end

				-- Scan drawsegs from end to start for obscuring segs.
				-- The first drawseg that has a greater scale
				-- is the clip seg.
			from
				create ds.make (i_main.r_bsp.ds_p - 1, i_main.r_bsp.drawsegs)
			until
				ds.index < i_main.r_bsp.drawsegs.lower
			loop
					-- determine if the drawseg obscures the sprite
				if ds.this.x1 > spr.x2 or ds.this.x2 < spr.x1 or (ds.this.silhouette = 0 and ds.this.maskedtexturecol = Void) then
						-- does not cover sprite
						-- continue
				else
					r1 := if ds.this.x1 < spr.x1 then spr.x1 else ds.this.x1 end
					r2 := if ds.this.x2 > spr.x2 then spr.x2 else ds.this.x2 end
					if ds.this.scale1 > ds.this.scale2 then
						lowscale := ds.this.scale2
						scale := ds.this.scale1
					else
						lowscale := ds.this.scale1
						scale := ds.this.scale2
					end
					check attached ds.this.curline as ds_curline then
						if scale < spr.scale or (lowscale < spr.scale and (i_main.r_main.R_PointOnSegSide (spr.gx, spr.gy, ds_curline) = 0)) then
								-- masked mid texture?
							if ds.this.maskedtexturecol /= Void then
								i_main.r_segs.R_RenderMaskedSegRange (ds.this, r1, r2)
							end
								-- seg is behind sprite
								-- continue
						else
								-- clip this piece of the sprite
							silhouette := ds.this.silhouette
							if spr.gz >= ds.this.bsilheight then
								silhouette := silhouette & {R_DEFS}.SIL_BOTTOM.bit_not
							end
							if spr.gzt <= ds.this.tsilheight then
								silhouette := silhouette & {R_DEFS}.SIL_TOP.bit_not
							end
							if silhouette = 1 then
									-- bottom sil
								from
									x := r1
								until
									x > r2
								loop
									if clipbot [x] = -2 then
										check attached ds.this.sprbottomclip as botclip then
											clipbot [x] := botclip [x]
										end
									end
									x := x + 1
								end
							elseif silhouette = 2 then
									-- top sil
								from
									x := r1
								until
									x > r2
								loop
									if cliptop [x] = -2 then
										check attached ds.this.sprtopclip as topclip then
											cliptop [x] := topclip [x]
										end
									end
									x := x + 1
								end
							elseif silhouette = 3 then
									-- both
								from
									x := r1
								until
									x > r2
								loop
									if clipbot [x] = -2 then
										check attached ds.this.sprbottomclip as botclip then
											clipbot [x] := botclip [x]
										end
									end
									if cliptop [x] = -2 then
										check attached ds.this.sprtopclip as topclip then
											cliptop [x] := topclip [x]
										end
									end
									x := x + 1
								end
							end
						end
					end
				end
				ds := ds - 1
			end

				-- all clipping has been performed, so draw the sprite

				-- check for unclipped columns
			from
				x := spr.x1
			until
				x > spr.x2
			loop
				if clipbot [x] = -2 then
					clipbot [x] := i_main.r_draw.viewheight.to_integer_16
				end
				if cliptop [x] = -2 then
					cliptop [x] := -1
				end
				x := x + 1
			end
			create mfloorclip.make (0, clipbot)
			create mceilingclip.make (0, cliptop)
			R_DrawVisSprite (spr, spr.x1, spr.x2)
		end

feature -- Player Sprites

	R_DrawPlayerSprites
		local
			i: INTEGER
			lightnum: INTEGER
			psp: PSPDEF_T
		do
				-- get light level
			check attached i_main.r_main.viewplayer.mo as mo and then attached mo.subsector as ss and then attached ss.sector as s then
				lightnum := (s.lightlevel |>> {R_MAIN}.LIGHTSEGSHIFT) + i_main.r_main.extralight
			end
			if lightnum < 0 then
				spritelights := i_main.r_main.scalelight [0]
			elseif lightnum >= {R_MAIN}.LIGHTLEVELS then
				spritelights := i_main.r_main.scalelight [{R_MAIN}.LIGHTLEVELS - 1]
			else
				spritelights := i_main.r_main.scalelight [lightnum]
			end

				-- clip to screen bounds
			create mfloorclip.make (0, screenheightarray)
			create mceilingclip.make (0, negonearray)

				-- add all active psprites
			from
				i := 0
			until
				i >= {P_PSPR}.NUMPSPRITES
			loop
				psp := i_main.r_main.viewplayer.psprites [i]
				if psp.state /= Void then
					R_DrawPSprite (psp)
				end
				i := i + 1
			end
		end

	R_DrawPSprite (psp: PSPDEF_T)
		require
			RANGECHECK: attached psp.state as s1 and then s1.sprite < numsprites
			RANGECHECK: attached psp.state as s2 and then attached sprites as sprs and then (s2.frame & {P_PSPR}.FF_FRAMEMASK) < sprs [s2.sprite].numframes
		local
			tx: FIXED_T
			x1, x2: INTEGER
			sprdef: SPRITEDEF_T
			sprframe: SPRITEFRAME_T
			lump: INTEGER
			flip: BOOLEAN
			vis: VISSPRITE_T
			avis: VISSPRITE_T
		do
			create avis
				-- decide which patch to use
			check attached psp.state as s then
				check attached sprites as sprs then
					sprdef := sprs [s.sprite]
				end
				check attached sprdef.spriteframes as sfrms then
					sprframe := sfrms [(s.frame & {P_PSPR}.ff_framemask).to_integer_32]
				end
			end
			lump := sprframe.lump [0]
			flip := sprframe.flip [0]

				-- calculate edges of the shape
			tx := psp.sx - 160 * {M_FIXED}.FRACUNIT
			check attached i_main.r_data.spriteoffset as sof then
				tx := tx - sof [lump]
			end
			x1 := (i_main.r_main.centerxfrac + {M_FIXED}.fixedmul (tx, pspritescale)) |>> {M_FIXED}.FRACBITS
				-- off the right side
			if x1 > i_main.r_draw.viewwidth then
					-- return
			else
				check attached i_main.r_data.spritewidth as sw then
					tx := tx + sw [lump]
				end
				x2 := ((i_main.r_main.centerxfrac + {M_FIXED}.fixedmul (tx, pspritescale)) |>> {M_FIXED}.FRACBITS) - 1

					-- off the left side
				if x2 < 0 then
						-- return
				else
						-- store information in a vissprite
					vis := avis
					vis.mobjflags := 0
					check attached i_main.r_data.spritetopoffset as stopof then
						vis.texturemid := (BASEYCENTER |<< {M_FIXED}.FRACBITS) + {M_FIXED}.FRACUNIT // 2 - (psp.sy - stopof [lump])
					end
					vis.x1 := x1.max (0)
					vis.x2 := x2.min (i_main.r_draw.viewwidth - 1)
					vis.scale := pspritescale |<< i_main.r_main.detailshift
					if flip then
						vis.xiscale := - pspriteiscale
						check attached i_main.r_data.spritewidth as sw then
							vis.startfrac := sw [lump] - 1
						end
					else
						vis.xiscale := pspriteiscale
						vis.startfrac := 0
					end
					if vis.x1 > x1 then
						vis.startfrac := vis.startfrac + vis.xiscale * (vis.x1 - x1)
					end
					vis.patch := lump
					check attached psp.state as s then
						if i_main.r_main.viewplayer.powers [{POWERTYPE_T}.pw_invisibility] > 4 * 32 or i_main.r_main.viewplayer.powers [{POWERTYPE_T}.pw_invisibility] & 8 /= 0 then
								-- shadow draw
							vis.colormap := Void
						elseif i_main.r_main.fixedcolormap /= Void then
								-- fixed color
							vis.colormap := i_main.r_main.fixedcolormap
						elseif s.frame & {P_PSPR}.FF_FULLBRIGHT /= 0 then
								-- full bright
							vis.colormap := create {INDEX_IN_ARRAY [LIGHTTABLE_T]}.make (0, i_main.r_data.colormaps)
						else
								-- local light
							check attached spritelights as sl then
								vis.colormap := sl [{R_MAIN}.MAXLIGHTSCALE - 1]
							end
						end
					end
					R_DrawVisSprite (vis, vis.x1, vis.x2)
				end
			end
		end

feature

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
			if i_main.r_main.viewangleoffset = 0 then
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
		local
			tr_x, tr_y: FIXED_T
			gxt, gyt: FIXED_T
			tx, tz: FIXED_T
			xscale: FIXED_T
			x1, x2: INTEGER
			sprdef: SPRITEDEF_T
			sprframe: SPRITEFRAME_T
			lump: INTEGER
			rot: INTEGER -- originally unsigned
			flip: BOOLEAN
			index: INTEGER
			vis: VISSPRITE_T
			ang: ANGLE_T
			iscale: FIXED_T
		do
				-- transform the origin point
			tr_x := thing.x - i_main.r_main.viewx
			tr_y := thing.y - i_main.r_main.viewy
			gxt := {M_FIXED}.fixedmul (tr_x, i_main.r_main.viewcos)
			gyt := - {M_FIXED}.fixedmul (tr_y, i_main.r_main.viewsin)
			tz := gxt - gyt

				-- thing is behind view plane?
			if tz < MINZ then
					-- return
			else
				xscale := {M_FIXED}.fixeddiv (i_main.r_main.projection, tz)
				gxt := - {M_FIXED}.fixedmul (tr_x, i_main.r_main.viewsin)
				gyt := {M_FIXED}.fixedmul (tr_y, i_main.r_main.viewcos)
				tx := - (gyt + gxt)

					-- too far off the side?
				if tx.abs > (tz |<< 2) then
						-- return
				else
						-- decide which patch to use for sprite relative to player
					check
						RANGECHECK: thing.sprite.to_natural_32 < numsprites.to_natural_32
					end
					check attached sprites as ss then
						sprdef := ss [thing.sprite]
					end
					check
						RANGECHECK: thing.frame.bit_and (i_main.p_pspr.FF_FRAMEMASK) < sprdef.numframes
					end
					check attached sprdef.spriteframes as sf then
						sprframe := sf [thing.frame.bit_and (i_main.p_pspr.FF_FRAMEMASK)]
					end
					if sprframe.rotate then
							-- choose a different rotation based on player view
						ang := i_main.r_main.R_PointToAngle (thing.x, thing.y)
						rot := (ang - thing.angle + (i_main.r_main.ANG45 // 2).to_natural_32 * 9) |>> 29
						lump := sprframe.lump [rot]
						flip := sprframe.flip [rot]
					else
							-- use single rotation for all views
						lump := sprframe.lump [0]
						flip := sprframe.flip [0]
					end

						-- calculate edges of the shape
					check attached i_main.r_data.spriteoffset as so then
						tx := tx - so [lump]
					end
					x1 := (i_main.r_main.centerxfrac + {M_FIXED}.fixedmul (tx, xscale)) |>> {M_FIXED}.fracbits

						-- off the right side?
					if x1 > i_main.r_draw.viewwidth then
							-- return
					else
						check attached i_main.r_data.spritewidth as sw then
							tx := tx + sw [lump]
						end
						x2 := ((i_main.r_main.centerxfrac + {M_FIXED}.fixedmul (tx, xscale)) |>> {M_FIXED}.fracbits) - 1

							-- off the left side
						if x2 < 0 then
								-- return
						else
								-- store information in a vissprite
							vis := R_NewVisSprite
							vis.mobjflags := thing.flags
							vis.scale := xscale |<< i_main.r_main.detailshift
							vis.gx := thing.x
							vis.gy := thing.y
							vis.gz := thing.z
							check attached i_main.r_data.spritetopoffset as st then
								vis.gzt := thing.z + st [lump]
							end
							vis.texturemid := vis.gzt - i_main.r_main.viewz
							vis.x1 := x1.max (0)
							vis.x2 := x2.min (i_main.r_draw.viewwidth - 1)
							iscale := {M_FIXED}.fixeddiv ({M_FIXED}.fracunit, xscale)
							if flip then
								check attached i_main.r_data.spritewidth as sw then
									vis.startfrac := sw [lump] - 1
								end
								vis.xiscale := - iscale
							else
								vis.startfrac := 0
								vis.xiscale := iscale
							end
							if vis.x1 > x1 then
								vis.startfrac := vis.startfrac + vis.xiscale * (vis.x1 - x1)
							end
							vis.patch := lump

								-- get light level
							if thing.flags & {P_MOBJ}.MF_SHADOW /= 0 then
									-- shadow draw
								vis.colormap := Void
							elseif i_main.r_main.fixedcolormap /= Void then
									-- fixed map
								vis.colormap := i_main.r_main.fixedcolormap
							elseif thing.frame & {P_PSPR}.FF_FULLBRIGHT /= 0 then
									-- full bright
								vis.colormap := create {INDEX_IN_ARRAY [LIGHTTABLE_T]}.make (0, i_main.r_data.colormaps)
							else
									-- diminished light
								index := xscale |>> ({R_MAIN}.LIGHTSCALESHIFT - i_main.r_main.detailshift)
								if index >= {R_MAIN}.MAXLIGHTSCALE then
									index := {R_MAIN}.MAXLIGHTSCALE - 1
								end
								check attached spritelights as sl then
									vis.colormap := sl [index]
								end
							end
						end
					end
				end
			end
		end

feature -- R_NewVisSprite

	overflowsprite: VISSPRITE_T

	R_NewVisSprite: VISSPRITE_T
		do
			if vissprite_p = MAXVISSPRITES then
				Result := overflowsprite
			else
				vissprite_p := vissprite_p + 1
				Result := vissprites [vissprite_p - 1]
			end
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

feature -- Contracts

	spriteframes_different: BOOLEAN
		local
			i, j: INTEGER
		do
			Result := True
			if attached sprites as ss then
				from
					i := ss.lower
				until
					not Result or i > ss.upper
				loop
					from
						j := i + 1
					until
						not Result or j > ss.upper
					loop
						Result := ss [i].spriteframes /= Void and ss [j].spriteframes /= Void implies ss [i].spriteframes /= ss [j].spriteframes
						j := j + 1
					end
					i := i + 1
				end
			end
		end

invariant
	screenheightarray.lower = 0
	screenheightarray.count = {DOOMDEF_H}.SCREENWIDTH
	negonearray.lower = 0
	negonearray.count = {DOOMDEF_H}.SCREENWIDTH
	across negonearray as i_neg all i_neg.item = -1 end
	{UTILS [VISSPRITE_T]}.invariant_ref_array (vissprites, MAXVISSPRITES)
	{UTILS [SPRITEFRAME_T]}.invariant_ref_array (sprtemp, 29)
	spriteframes_different

end
