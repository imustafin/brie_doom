note
	description: "[
		r_segs.c
		All the clipping: columns, horizontal spans, sky columns.
	]"

class
	R_SEGS

inherit

	R_DEFS

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create maskedtexturecol.make (0, i_main.r_plane.openings)
		end

feature

	walllights: detachable ARRAY [detachable INDEX_IN_ARRAY [LIGHTTABLE_T]] assign set_walllights -- lighttable_t**

	set_walllights (a_walllights: like walllights)
		do
			walllights := a_walllights
		end

	rw_angle1: ANGLE_T assign set_rw_angle1

	set_rw_angle1 (a_rw_angle1: like rw_angle1)
		do
			rw_angle1 := a_rw_angle1
		end

	rw_centerangle: ANGLE_T

	rw_offset: FIXED_T

	rw_normalangle: ANGLE_T

	rw_distance: FIXED_T

	rw_x: INTEGER

	rw_stopx: INTEGER

	rw_scale: FIXED_T

	rw_scalestep: FIXED_T

	rw_midtexturemid: FIXED_T

	rw_toptexturemid: FIXED_T

	rw_bottomtexturemid: FIXED_T

	worldtop: INTEGER

	worldbottom: INTEGER

	worldhigh: INTEGER

	worldlow: INTEGER

	toptexture: INTEGER

	bottomtexture: INTEGER

	midtexture: INTEGER

	maskedtexture: BOOLEAN

	markfloor: BOOLEAN

	markceiling: BOOLEAN

	maskedtexturecol: INDEX_IN_ARRAY [INTEGER_16] -- index in {R_PLANE}.openings

	segtextured: BOOLEAN

	topstep: FIXED_T

	topfrac: FIXED_T

	bottomstep: FIXED_T

	bottomfrac: FIXED_T

	pixhigh: FIXED_T

	pixlow: FIXED_T

	pixhighstep: FIXED_T

	pixlowstep: FIXED_T

feature

	R_StoreWallRange (start, stop: INTEGER)
			-- A wall segment will be drawn
			-- between start and stop pixels (inclusive)
		require
			RANGECHECK: start < i_main.r_draw.viewwidth and start <= stop
		local
			hyp: FIXED_T
			sineval: FIXED_T
			distangle, offsetangle: ANGLE_T
			vtop: FIXED_T
			lightnum: INTEGER
		do
				-- don't overflow and crash
			if i_main.r_bsp.ds_p /= MAXDRAWSEGS then
				i_main.r_bsp.sidedef := i_main.r_bsp.curline.sidedef
				i_main.r_bsp.linedef := i_main.r_bsp.curline.linedef

					-- mark the segment as visible for auto map
				i_main.r_bsp.linedef.flags := i_main.r_bsp.linedef.flags | {DOOMDATA_H}.ML_MAPPED.as_integer_16

					-- calculate rw_distance for scale calculation
				rw_normalangle := i_main.r_bsp.curline.angle + {TABLES}.ANG90
				offsetangle := (rw_normalangle - rw_angle1).abs
				if offsetangle > {TABLES}.ANG90 then
					offsetangle := {TABLES}.ANG90
				end
				distangle := {TABLES}.ANG90 - offsetangle
				hyp := i_main.r_main.R_PointToDist (i_main.r_bsp.curline.v1.x, i_main.r_bsp.curline.v1.y)
				sineval := {TABLES}.finesine [distangle |>> {TABLES}.ANGLETOFINESHIFT]
				rw_distance := {M_FIXED}.FixedMul (hyp, sineval)

					--
				rw_x := start
				i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].x1 := start
				i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].x2 := stop
				i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].curline := i_main.r_bsp.curline
				rw_stopx := stop + 1

					-- calculate scale at both ends and step
				rw_scale := i_main.r_main.R_ScaleFromGlobalAngle (i_main.r_main.viewangle + i_main.r_main.xtoviewangle [start])
				i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].scale1 := rw_scale
				if stop > start then
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].scale2 := i_main.r_main.R_ScaleFromGlobalAngle (i_main.r_main.viewangle + i_main.r_main.xtoviewangle [stop])
					rw_scalestep := (i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].scale2 - rw_scale) // (stop - start)
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].scalestep := rw_scalestep
				else
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].scale2 := i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].scale1
				end

					-- calculate texture bundaries
					-- and decide if floor / ceiling marks are needed
				worldtop := (i_main.r_bsp.frontsector.ceilingheight - i_main.r_main.viewz).to_integer_32
				worldbottom := (i_main.r_bsp.frontsector.floorheight - i_main.r_main.viewz).to_integer_32
				midtexture := 0
				toptexture := 0
				bottomtexture := 0
				maskedtexture := False
				i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].maskedtexturecol := Void
				if i_main.r_bsp.backsector = Void then
						-- single sided line
					midtexture := i_main.r_data.texturetranslation [i_main.r_bsp.sidedef.midtexture]
						-- a single sided line is terminal, so it must mark ends
					markceiling := True
					markfloor := True
					if i_main.r_bsp.linedef.flags & {DOOMDATA_H}.ML_DONTPEGBOTTOM /= 0 then
						vtop := i_main.r_bsp.frontsector.floorheight + i_main.r_data.textureheight [i_main.r_bsp.sidedef.midtexture]
							-- bottom of texture at bottom
						rw_midtexturemid := vtop - i_main.r_main.viewz
					else
							-- top of texture at top
						rw_midtexturemid := worldtop
					end
					rw_midtexturemid := rw_midtexturemid + i_main.r_bsp.sidedef.rowoffset
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := SIL_BOTH
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprtopclip := create {INDEX_IN_ARRAY [INTEGER_16]}.make (0, i_main.r_things.screenheightarray)
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprbottomclip := create {INDEX_IN_ARRAY [INTEGER_16]}.make (0, i_main.r_things.negonearray)
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].bsilheight := {DOOMTYPE_H}.MAXINT
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].tsilheight := {DOOMTYPE_H}.MININT
				else
						-- two sided line
					check attached i_main.r_bsp.backsector as backsector then
						i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprbottomclip := Void
						i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprtopclip := Void
						i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := 0
						if i_main.r_bsp.frontsector.floorheight > backsector.floorheight then
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := SIL_BOTTOM
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].bsilheight := i_main.r_bsp.frontsector.floorheight
						elseif backsector.floorheight > i_main.r_main.viewz then
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := SIL_BOTTOM
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].bsilheight := {DOOMTYPE_H}.MAXINT
						end
						if i_main.r_bsp.frontsector.ceilingheight < backsector.ceilingheight then
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette | SIL_TOP
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].tsilheight := i_main.r_bsp.frontsector.ceilingheight
						elseif backsector.ceilingheight < i_main.r_main.viewz then
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette | SIL_TOP
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].tsilheight := {DOOMTYPE_H}.MININT
						end
						if backsector.ceilingheight <= i_main.r_bsp.frontsector.floorheight then
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprbottomclip := create {INDEX_IN_ARRAY [INTEGER_16]}.make (0, i_main.r_things.negonearray)
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].bsilheight := {DOOMTYPE_H}.MAXINT
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette | SIL_BOTTOM
						end
						if backsector.floorheight >= i_main.r_bsp.frontsector.ceilingheight then
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprtopclip := create {INDEX_IN_ARRAY [INTEGER_16]}.make (0, i_main.r_things.screenheightarray)
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].tsilheight := {DOOMTYPE_H}.MININT
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette | SIL_TOP
						end
						worldhigh := (backsector.ceilingheight - i_main.r_main.viewz).to_integer_32
						worldlow := (backsector.floorheight - i_main.r_main.viewz).to_integer_32

							-- hack to allow height changes in outdoor areas
						if i_main.r_bsp.frontsector.ceilingpic = i_main.r_sky.skyflatnum and backsector.ceilingpic = i_main.r_sky.skyflatnum then
							worldtop := worldhigh
						end
						if worldlow /= worldbottom or backsector.floorpic /= i_main.r_bsp.frontsector.floorpic or backsector.lightlevel /= i_main.r_bsp.frontsector.lightlevel then
							markfloor := True
						else
								-- same plane on both sides
							markfloor := False
						end
						if worldhigh /= worldtop or backsector.ceilingpic /= i_main.r_bsp.frontsector.ceilingpic or backsector.lightlevel /= i_main.r_bsp.frontsector.lightlevel then
							markceiling := True
						else
								-- same plane on both sides
							markceiling := False
						end
						if backsector.ceilingheight <= i_main.r_bsp.frontsector.floorheight or backsector.floorheight >= i_main.r_bsp.frontsector.ceilingheight then
								-- closed door
							markceiling := True
							markfloor := True
						end
						if worldhigh < worldtop then
								-- top texture
							toptexture := i_main.r_data.texturetranslation [i_main.r_bsp.sidedef.toptexture]
							if i_main.r_bsp.linedef.flags & {DOOMDATA_H}.ML_DONTPEGTOP /= 0 then
									-- top texture at top
								rw_toptexturemid := worldtop
							else
								vtop := backsector.ceilingheight + i_main.r_data.textureheight [i_main.r_bsp.sidedef.toptexture]

									-- bottom of texture
								rw_toptexturemid := vtop - i_main.r_main.viewz
							end
						end
						if worldlow > worldbottom then
								-- bottom texture
							bottomtexture := i_main.r_data.texturetranslation [i_main.r_bsp.sidedef.bottomtexture]
							if i_main.r_bsp.linedef.flags & {DOOMDATA_H}.ML_DONTPEGBOTTOM /= 0 then
									-- bottom texture at bottom
									-- top of texture at top
								rw_bottomtexturemid := worldtop
							else
									-- top of texture at top
								rw_bottomtexturemid := worldlow
							end
						end
						rw_toptexturemid := rw_toptexturemid + i_main.r_bsp.sidedef.rowoffset
						rw_bottomtexturemid := rw_bottomtexturemid + i_main.r_bsp.sidedef.rowoffset

							-- allocate space for masked texture tables
						if i_main.r_bsp.sidedef.midtexture /= 0 then
								-- masked midtexture
							maskedtexture := True
							maskedtexturecol := i_main.r_plane.lastopening - rw_x
							i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].maskedtexturecol := maskedtexturecol
							i_main.r_plane.lastopening := i_main.r_plane.lastopening + rw_stopx - rw_x
						end
					end
				end

					-- calculate rw_offset (only needed for textured lines)
				segtextured := (midtexture | toptexture | bottomtexture) /= 0 or maskedtexture
				if segtextured then
					offsetangle := rw_normalangle - rw_angle1
					if offsetangle > {TABLES}.ANG180 then
						offsetangle := - offsetangle
					end
					if offsetangle > {TABLES}.ANG90 then
						offsetangle := {TABLES}.ANG90
					end
					sineval := {TABLES}.finesine [offsetangle |>> {TABLES}.ANGLETOFINESHIFT]
					rw_offset := {M_FIXED}.FixedMul (hyp, sineval)
					if rw_normalangle - rw_angle1 < {TABLES}.ANG180 then
						rw_offset := - rw_offset
					end
					rw_offset := rw_offset + i_main.r_bsp.sidedef.textureoffset + i_main.r_bsp.curline.offset
					rw_centerangle := {TABLES}.ANG90 + i_main.r_main.viewangle - rw_normalangle

						-- calculate light table
						-- use different light tables
						-- for horizontal / vertical / diagonal
						-- OPTIMIZE: get rid of LIGHTSEGSHIFT globally
					if i_main.r_main.fixedcolormap = Void then
						lightnum := (i_main.r_bsp.frontsector.lightlevel |>> {R_MAIN}.LIGHTSEGSHIFT) + i_main.r_main.extralight
						if i_main.r_bsp.curline.v1.y = i_main.r_bsp.curline.v2.y then
							lightnum := lightnum - 1
						elseif i_main.r_bsp.curline.v1.x = i_main.r_bsp.curline.v2.x then
							lightnum := lightnum + 1
						end
						check attached i_main.r_main.scalelight as scalelight then
							if lightnum < 0 then
								walllights := scalelight [0]
							elseif lightnum >= {R_MAIN}.LIGHTLEVELS then
								walllights := scalelight [{R_MAIN}.LIGHTLEVELS - 1]
							else
								walllights := scalelight [lightnum]
							end
						end
					end
				end
					-- if a floor / ceiling plane is on the wrong side
					-- of the view plane, it is definitely invisible
					-- and doesn't need to be marked

				if i_main.r_bsp.frontsector.floorheight >= i_main.r_main.viewz then
						-- above view plane
					markfloor := False
				end
				if i_main.r_bsp.frontsector.ceilingheight <= i_main.r_main.viewz and i_main.r_bsp.frontsector.ceilingpic /= i_main.r_sky.skyflatnum then
						-- below view plane
					markceiling := False
				end

					-- calculate incremental stepping values for texture edges
				worldtop := worldtop |>> 4
				worldbottom := worldbottom |>> 4
				topstep := - {M_FIXED}.FixedMul (rw_scalestep, worldtop)
				topfrac := (i_main.r_main.centeryfrac |>> 4) - {M_FIXED}.FixedMul (worldtop, rw_scale)
				bottomstep := - {M_FIXED}.FixedMul (rw_scalestep, worldbottom)
				bottomfrac := (i_main.r_main.centeryfrac |>> 4) - {M_FIXED}.FixedMul (worldbottom, rw_scale)
				if attached i_main.r_bsp.backsector as backsector then
					worldhigh := worldhigh |>> 4
					worldlow := worldlow |>> 4
					if worldhigh < worldtop then
						pixhigh := (i_main.r_main.centeryfrac |>> 4) - {M_FIXED}.FixedMul (worldhigh, rw_scale)
						pixhighstep := - {M_FIXED}.FixedMul (rw_scalestep, worldhigh)
					end
					if worldlow > worldbottom then
						pixlow := (i_main.r_main.centeryfrac |>> 4) - {M_FIXED}.FixedMul (worldlow, rw_scale)
						pixlowstep := - {M_FIXED}.FixedMul (rw_scalestep, worldlow)
					end
				end

					-- render it
				if markceiling then
					check attached i_main.r_plane.ceilingplane as ceilingplane then
						i_main.r_plane.ceilingplane := i_main.r_plane.R_CheckPlane (ceilingplane, rw_x, rw_stopx - 1)
					end
				end
				if markfloor then
					check attached i_main.r_plane.floorplane as floorplane then
						i_main.r_plane.floorplane := i_main.r_plane.R_CheckPlane (floorplane, rw_x, rw_stopx - 1)
					end
				end
				R_RenderSegLoop

					-- save sprite clipping info
				if (i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette & SIL_TOP /= 0 or maskedtexture) and i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprtopclip = Void then

						-- memcpy (lastopening, ceilingclip + start, 2 * (rw_stopx - start))
					i_main.r_plane.lastopening.subcopy (i_main.r_plane.ceilingclip, start, rw_stopx, 0)
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprtopclip := i_main.r_plane.lastopening - start
					i_main.r_plane.lastopening := i_main.r_plane.lastopening + rw_stopx - start
				end
				if (i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette & SIL_BOTTOM /= 0 or maskedtexture) and i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprbottomclip = Void then
						-- memcpy (lastopening, floorclip + start, 2 * (rw_stopx - start))
					i_main.r_plane.lastopening.subcopy (i_main.r_plane.floorclip, start, rw_stopx, 0)
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].sprbottomclip := i_main.r_plane.lastopening - start
					i_main.r_plane.lastopening := i_main.r_plane.lastopening + rw_stopx - start
				end
				if maskedtexture and not (i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette & SIL_TOP /= 0) then
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette | SIL_TOP
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].tsilheight := {DOOMTYPE_H}.MININT
				end
				if maskedtexture and not (i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette & SIL_BOTTOM /= 0) then
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette := i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].silhouette | SIL_BOTTOM
					i_main.r_bsp.drawsegs [i_main.r_bsp.ds_p].bsilheight := {DOOMTYPE_H}.MAXINT
				end
				i_main.r_bsp.ds_p := i_main.r_bsp.ds_p + 1
			end
		end

feature -- R_RenderSegLoop

	HEIGHTBITS: INTEGER = 12

	HEIGHTUNIT: INTEGER
		once
			Result := 1 |<< HEIGHTBITS
		ensure
			instance_free: class
		end

	R_RenderSegLoop
			-- Draws zero, one, or two textures (and possibly a masked texture)
			-- for walls.
			-- Can draw or mark the starting pixel of floor and ceiling textures.
			-- CALLED: CORE LOOPING ROUTINE
		local
			angle: ANGLE_T
			index: NATURAL
			yl: INTEGER
			yh: INTEGER
			mid: INTEGER
			texturecolumn: FIXED_T
			top: INTEGER
			bottom: INTEGER
				-- globals
			ceilingclip: ARRAY [INTEGER_16]
			floorclip: ARRAY [INTEGER_16]
			xtoviewangle: ARRAY [ANGLE_T]
			angletofineshift: INTEGER
			finetangent: ARRAY [INTEGER]
			fracbits: INTEGER
			lightscaleshift: INTEGER
			maxlightscale: INTEGER
			colfunc: PROCEDURE
			viewheight: INTEGER
		do
			ceilingclip := i_main.r_plane.ceilingclip
			floorclip := i_main.r_plane.floorclip
			xtoviewangle := i_main.r_main.xtoviewangle
			angletofineshift := {TABLES}.angletofineshift
			finetangent := {TABLES}.finetangent
			fracbits := {M_FIXED}.fracbits
			lightscaleshift := {R_MAIN}.lightscaleshift
			maxlightscale := {R_MAIN}.maxlightscale
			check attached i_main.r_main.colfunc as cf then
				colfunc := cf
			end
			viewheight := i_main.r_draw.viewheight

				-- body

			from
			until
				rw_x >= rw_stopx
			loop
					-- mark floor / ceiling areas
				yl := ((topfrac + HEIGHTUNIT - 1) |>> HEIGHTBITS).to_integer_32

					-- no space above wall?
				if yl < ceilingclip [rw_x] + 1 then
					yl := ceilingclip [rw_x] + 1
				end
				if markceiling then
					top := ceilingclip [rw_x] + 1
					bottom := yl - 1
					if bottom >= floorclip [rw_x] then
						bottom := floorclip [rw_x] - 1
					end
					if top <= bottom then
						check attached i_main.r_plane.ceilingplane as ceilingplane then
							ceilingplane.top [rw_x] := top.to_natural_8
							ceilingplane.bottom [rw_x] := bottom.to_natural_8
						end
					end
				end
				yh := (bottomfrac |>> HEIGHTBITS).to_integer_32
				if yh >= floorclip [rw_x] then
					yh := floorclip [rw_x] - 1
				end
				if markfloor then
					top := yh + 1
					bottom := floorclip [rw_x] - 1
					if top <= ceilingclip [rw_x] then
						top := ceilingclip [rw_x] + 1
					end
					if top <= bottom then
						check attached i_main.r_plane.floorplane as floorplane then
							floorplane.top [rw_x] := top.to_natural_8
							floorplane.bottom [rw_x] := bottom.to_natural_8
						end
					end
				end

					-- texturecolumn and lighting are independent of wall tiers
				if segtextured then
						-- calculate texture offset
					angle := (rw_centerangle + xtoviewangle [rw_x]) |>> ANGLETOFINESHIFT
					texturecolumn := rw_offset - {M_FIXED}.fixedmul (finetangent [angle], rw_distance)
					texturecolumn := texturecolumn |>> FRACBITS
						-- calculate lighting
					index := rw_scale |>> LIGHTSCALESHIFT
					if index.to_integer_32 >= MAXLIGHTSCALE then
						index := (MAXLIGHTSCALE - 1).to_natural_32
					end
					check attached walllights as wls then
						i_main.r_draw.dc_colormap := wls [index.to_integer_32]
					end
					i_main.r_draw.dc_x := rw_x
					i_main.r_draw.dc_iscale := ((0xffffffff).to_natural_32 // rw_scale.to_natural_32).to_integer_32
				end

					-- draw the wall tiers
				if midtexture /= 0 then
						-- single sided line
					i_main.r_draw.dc_yl := yl
					i_main.r_draw.dc_yh := yh
					i_main.r_draw.dc_texturemid := rw_midtexturemid
					i_main.r_draw.dc_source := i_main.r_data.R_GetColumn (midtexture, texturecolumn.to_integer_32)
					colfunc.call
					ceilingclip [rw_x] := viewheight.to_integer_16
					floorclip [rw_x] := -1
				else
						-- two sided line
					if toptexture /= 0 then
						mid := (pixhigh |>> HEIGHTBITS).to_integer_32
						pixhigh := pixhigh + pixhighstep
						if mid >= floorclip [rw_x] then
							mid := floorclip [rw_x] - 1
						end
						if mid >= yl then
							i_main.r_draw.dc_yl := yl
							i_main.r_draw.dc_yh := mid
							i_main.r_draw.dc_texturemid := rw_toptexturemid
							i_main.r_draw.dc_source := i_main.r_data.R_GetColumn (toptexture, texturecolumn.to_integer_32)
							colfunc.call
							ceilingclip [rw_x] := mid.to_integer_16
						else
							ceilingclip [rw_x] := (yl - 1).to_integer_16
						end
					else
							-- no top wall
						if markceiling then
							ceilingclip [rw_x] := (yl - 1).to_integer_16
						end
					end
					if bottomtexture /= 0 then
							-- bottom wall
						mid := ((pixlow + HEIGHTUNIT - 1) |>> HEIGHTBITS).to_integer_32
						pixlow := pixlow + pixlowstep

							-- no space above wall?
						if mid <= ceilingclip [rw_x] then
							mid := ceilingclip [rw_x] + 1
						end
						if mid <= yh then
							i_main.r_draw.dc_yl := mid
							i_main.r_draw.dc_yh := yh
							i_main.r_draw.dc_texturemid := rw_bottomtexturemid
							i_main.r_draw.dc_source := i_main.r_data.R_GetColumn (bottomtexture, texturecolumn.to_integer_32)
							colfunc.call
							floorclip [rw_x] := mid.to_integer_16
						else
							floorclip [rw_x] := (yh + 1).to_integer_16
						end
					else
							-- no bottom wall
						if markfloor then
							floorclip [rw_x] := (yh + 1).to_integer_16
						end
					end
					if maskedtexture then
							-- save texturecol
							-- for backdrawing of masked mid texture
						maskedtexturecol [rw_x] := texturecolumn.to_integer_16
					end
				end
				rw_scale := rw_scale + rw_scalestep
				topfrac := topfrac + topstep
				bottomfrac := bottomfrac + bottomstep
				rw_x := rw_x + 1
			end
		end

feature -- R_RenderMaskedSegRange

	R_RenderMaskedSegRange (ds: DRAWSEG_T; x1, x2: INTEGER)
		local
			index: NATURAL
			col: MANAGED_POINTER_WITH_OFFSET
			lightnum: INTEGER
			texnum: INTEGER
		do
				-- Calculate light table.
				-- Use different light tables
				-- for horizontal / vertical / diagonal. Diagonal?
				-- OPTIMIZE: get rid of LIGHTSEGSHIFT globally
			check attached ds.curline as dsc then
				i_main.r_bsp.curline := dsc
			end
			check attached i_main.r_bsp.curline.frontsector as fs then
				i_main.r_bsp.frontsector := fs
			end
			i_main.r_bsp.backsector := i_main.r_bsp.curline.backsector
			texnum := i_main.r_data.texturetranslation [i_main.r_bsp.curline.sidedef.midtexture]
			lightnum := (i_main.r_bsp.frontsector.lightlevel |>> {R_MAIN}.LIGHTSEGSHIFT) + i_main.r_main.extralight
			if i_main.r_bsp.curline.v1.y = i_main.r_bsp.curline.v2.y then
				lightnum := lightnum - 1
			elseif i_main.r_bsp.curline.v1.x = i_main.r_bsp.curline.v2.x then
				lightnum := lightnum + 1
			end
			if lightnum < 0 then
				walllights := i_main.r_main.scalelight [0]
			elseif lightnum >= {R_MAIN}.LIGHTLEVELS then
				walllights := i_main.r_main.scalelight [{R_MAIN}.LIGHTLEVELS - 1]
			else
				walllights := i_main.r_main.scalelight [lightnum]
			end
			check attached ds.maskedtexturecol as mtc then
				maskedtexturecol := mtc
			end
			rw_scalestep := ds.scalestep
			i_main.r_things.spryscale := ds.scale1 + (x1 - ds.x1) * rw_scalestep
			i_main.r_things.mfloorclip := ds.sprbottomclip
			i_main.r_things.mceilingclip := ds.sprtopclip

				-- find positioning
			check attached i_main.r_bsp.backsector as bs then
				if i_main.r_bsp.curline.linedef.flags & {DOOMDATA_H}.ML_DONTPEGBOTTOM /= 0 then
					i_main.r_draw.dc_texturemid := i_main.r_bsp.frontsector.floorheight.max (bs.floorheight)
					i_main.r_draw.dc_texturemid := i_main.r_draw.dc_texturemid + i_main.r_data.textureheight [texnum] - i_main.r_main.viewz
				else
					i_main.r_draw.dc_texturemid := i_main.r_bsp.frontsector.ceilingheight.min (bs.ceilingheight)
					i_main.r_draw.dc_texturemid := i_main.r_draw.dc_texturemid - i_main.r_main.viewz
				end
			end
			i_main.r_draw.dc_texturemid := i_main.r_draw.dc_texturemid + i_main.r_bsp.curline.sidedef.rowoffset
			if i_main.r_main.fixedcolormap /= Void then
				i_main.r_draw.dc_colormap := i_main.r_main.fixedcolormap
			end

				-- draw the columns
			from
				i_main.r_draw.dc_x := x1
			until
				i_main.r_draw.dc_x > x2
			loop
					-- calculate lighting
				if maskedtexturecol [i_main.r_draw.dc_x] /= {DOOMTYPE_H}.MAXSHORT then
					if i_main.r_main.fixedcolormap = Void then
						index := i_main.r_things.spryscale |>> {R_MAIN}.LIGHTSCALESHIFT
						if index >= {R_MAIN}.MAXLIGHTSCALE.to_natural_32 then
							index := {R_MAIN}.MAXLIGHTSCALE.to_natural_32 - 1
						end
						check attached walllights as wl then
							i_main.r_draw.dc_colormap := wl [index.to_integer_32]
						end
					end
					i_main.r_things.sprtopscreen := i_main.r_main.centeryfrac - {M_FIXED}.fixedmul (i_main.r_draw.dc_texturemid, i_main.r_things.spryscale)
					i_main.r_draw.dc_iscale := ((0xffffffff).to_natural_32 // i_main.r_things.spryscale.to_natural_32).to_integer_32

						-- draw the texture
					col := i_main.r_data.R_GetColumn (texnum, maskedtexturecol [i_main.r_draw.dc_x])
					i_main.r_things.R_DrawMaskedColumn (create {COLUMN_T}.from_pointer(col.mp, col.ofs - 3))
					maskedtexturecol [i_main.r_draw.dc_x] := {DOOMTYPE_H}.MAXSHORT
				end
				i_main.r_things.spryscale := i_main.r_things.spryscale + rw_scalestep
				i_main.r_draw.dc_x := i_main.r_draw.dc_x + 1
			end
		end

end
