note
	description: "[
		r_bsp.c
		BSP traversal, handling of LineSegs for rendering
	]"

class
	R_BSP

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: I_MAIN)
		do
			i_main := a_i_main
			create solidsegs.make_filled (create {CLIPRANGE_T}, 0, MAXSEGS - 1)
			create drawsegs.make_empty
			create frontsector.make
			create curline.make
		end

feature

	MAXSEGS: INTEGER = 32

	newend: INTEGER -- one past the last valid seg

	solidsegs: ARRAY [CLIPRANGE_T]

	drawsegs: ARRAY [DRAWSEG_T]

	ds_p: INTEGER -- pointer inside drawsegs

	frontsector: SECTOR_T

	backsector: detachable SECTOR_T

	curline: SEG_T

feature

	R_ClearClipSegs
		do
			solidsegs [0].first := -0x7fffffff
			solidsegs [0].last := -1
			solidsegs [1].first := i_main.r_draw.viewwidth
			solidsegs [1].last := 0x7fffffff
			newend := 2
		end

	R_ClearDrawSegs
		do
			ds_p := 0
		end

	R_RenderBSPNode (bspnum: INTEGER)
			-- Renders all subsectors below a given node,
			-- traversing subtree recursively.
			-- Just call with BSP root
		local
			bsp: NODE_T
			side: INTEGER
			side_bool: BOOLEAN
		do
				-- Found a subsector?
			if bspnum & {DOOMDATA_H}.NF_SUBSECTOR /= 0 then
				if bspnum = -1 then
					R_Subsector (0)
				else
					R_Subsector (bspnum & ({DOOMDATA_H}.NF_SUBSECTOR.bit_not))
				end
			else
				bsp := i_main.p_setup.nodes [bspnum]

					-- Decide which side the view point is on.
				side_bool := i_main.r_main.R_PointOnSide (i_main.r_main.viewx, i_main.r_main.viewy, bsp)
				if side_bool then
					side := 1
				else
					side := 0
				end

					-- Recursively divide front space.
				R_RenderBSPNode (bsp.children [side])

					-- Possibly divide back space.
				if R_CheckBBox (bsp.bbox [side.bit_xor (1)]) then
					R_RenderBSPNode (bsp.children [side.bit_xor (1)])
				end
			end
		end

	R_Subsector (num: INTEGER)
			-- Determine floor/ceiling planes.
			-- Add sprites of things in sector.
			-- Draw one or more line segments.
		local
			count: INTEGER
			line: INTEGER -- index in i_main.p_setup.segs
			sub: SUBSECTOR_T
		do
			i_main.r_main.sscount := i_main.r_main.sscount + 1
			sub := i_main.p_setup.subsectors [num]
			check attached sub.sector as ss then
				frontsector := ss
			end
			count := sub.numlines
			line := sub.firstline
			if frontsector.floorheight < i_main.r_main.viewz then
				i_main.r_plane.floorplane := i_main.r_plane.R_FindPlane (frontsector.floorheight, frontsector.floorpic, frontsector.lightlevel)
			else
				i_main.r_plane.floorplane := Void
			end
			if frontsector.ceilingheight > i_main.r_main.viewz or frontsector.ceilingpic = i_main.r_sky.skyflatnum then
				i_main.r_plane.ceilingplane := i_main.r_plane.R_FindPlane (frontsector.ceilingheight, frontsector.ceilingpic, frontsector.lightlevel)
			else
				i_main.r_plane.ceilingplane := Void
			end
			i_main.r_things.R_AddSprites (frontsector)
			from
			until
				count = 0
			loop
				count := count - 1
				R_AddLine (i_main.p_setup.segs [line])
				line := line + 1
			end
		end

	R_AddLine (line: SEG_T)
			-- Clips the given segment
			-- and adds any visible pieces to the line list.
		local
			x1: INTEGER
			x2: INTEGER
			angle1: ANGLE_T
			angle2: ANGLE_T
			span: ANGLE_T
			tspan: ANGLE_T
			returned: BOOLEAN
			goto_clipsolid: BOOLEAN
			goto_clippass: BOOLEAN
			bs: detachable SECTOR_T
		do
			curline := line

				-- OPTIMIZE: quickly reject orthogonal back sides.
			angle1 := i_main.r_main.R_PointToAngle (line.v1.x, line.v1.y)
			angle2 := i_main.r_main.R_PointToAngle (line.v2.x, line.v2.y)

				-- Clip to view edges.
				-- Optimize: make constant out of 2*clipangle (FIELDOFVIEW).
			span := angle1 - angle2

				-- Back side? I.e. backface culling?
			if span >= {R_MAIN}.ANG180 then
					-- return
			else
					-- Global angle needed by segcalc.
				i_main.r_segs.rw_angle1 := angle1
				angle1 := angle1 - i_main.r_main.viewangle
				angle2 := angle2 - i_main.r_main.viewangle
				tspan := angle1 + i_main.r_main.clipangle
				if tspan > 2 * i_main.r_main.clipangle then
					tspan := (tspan - 2 * i_main.r_main.clipangle).to_natural_32

						-- Totally off the left edge?
					if tspan >= span then
						returned := True
					else
						angle1 := i_main.r_main.clipangle
					end
				end
				if not returned then
					tspan := i_main.r_main.clipangle - angle2
					if tspan > 2 * i_main.r_main.clipangle then
						tspan := (tspan - 2 * i_main.r_main.clipangle).to_natural_32

							-- Totally off the left edge?
						if tspan >= span then
							returned := True
						else
							angle2 := (- i_main.r_main.clipangle.to_integer_32).to_natural_32
						end
					end
				end
				if not returned then
						-- The seg is in the view range,
						-- but not neccessarily visible.
					angle1 := (angle1 + {R_MAIN}.ANG90) |>> {R_MAIN}.ANGLETOFINESHIFT
					angle2 := (angle2 + {R_MAIN}.ANG90) |>> {R_MAIN}.ANGLETOFINESHIFT
					x1 := i_main.r_main.viewangletox [angle1]
					x2 := i_main.r_main.viewangletox [angle2]

						-- Does not cross a pixel?
					if x1 = x2 then
						returned := True
					end
				end
				if not returned then
					backsector := line.backsector
					bs := backsector

						-- Single sided line?
					if bs = Void then
						goto_clipsolid := True
					elseif bs.ceilingheight <= frontsector.floorheight or bs.floorheight >= frontsector.ceilingheight then
							-- Closed door.
						goto_clipsolid := True
					elseif bs.ceilingheight /= frontsector.ceilingheight or bs.floorheight /= frontsector.floorheight then
							-- Window.
						goto_clippass := True
					elseif bs.ceilingpic = frontsector.ceilingpic and bs.floorpic = frontsector.floorpic and bs.lightlevel = frontsector.lightlevel and curline.sidedef.midtexture = 0 then
						returned := True
					end
				end
				if not returned then
					if not goto_clipsolid then
						R_ClipPassWallSegment (x1, x2 - 1)
					else
						R_ClipSolidWallSegment (x1, x2 - 1)
					end
				end
			end
		end

	R_ClipPassWallSegment (first, last: INTEGER)
			-- Clips the given range of columns,
			-- but does not includes it in the clip list.
			-- Does handle windows,
			-- e.g. LineDefs with upper and lower texture.
		do
				-- Stub
		end

	R_ClipSolidWallSegment (first, last: INTEGER)
			-- Does handle solid walls ,
			-- e.g. single sided LineDefs (middle texture)
			-- that entirely block the view.
		do
				-- Stub
		end

feature -- R_CheckBBox

	checkcoord: ARRAY [ARRAY [INTEGER]]
		once
			create Result.make_filled (create {ARRAY [INTEGER]}.make_empty, 0, 11)
			Result [0] := <<3, 0, 2, 1>>
			Result [1] := <<3, 0, 2, 0>>
			Result [3] := <<3, 1, 2, 0>>
			Result [4] := <<0, 0, 0, 0>> -- just {0} originally
			Result [5] := <<2, 0, 2, 1>>
			Result [6] := <<0, 0, 0, 0>>
			Result [7] := <<3, 1, 3, 0>>
			Result [8] := <<0, 0, 0, 0>> -- just {0} originally
			Result [9] := <<2, 0, 3, 1>>
			Result [10] := <<2, 1, 3, 1>>
			Result [11] := <<2, 1, 3, 0>>
		ensure
			Result.lower = 0
			Result.count = 12
			across Result as r all r.item.lower = 1 and r.item.count = 4 end
		end

	R_CheckBBox (bspcoord: ARRAY [FIXED_T]): BOOLEAN
		require
			bspcoord.valid_index ({M_BBOX}.BOXLEFT)
			bspcoord.valid_index ({M_BBOX}.BOXRIGHT)
			bspcoord.valid_index ({M_BBOX}.BOXTOP)
			bspcoord.valid_index ({M_BBOX}.BOXBOTTOM)
		local
			boxx: INTEGER
			boxy: INTEGER
			boxpos: INTEGER
			x1, y1: FIXED_T
			x2, y2: FIXED_T
			angle1, angle2: ANGLE_T
			span, tspan: ANGLE_T
			start: INTEGER -- index in solidsegs

			sx1, sx2: INTEGER
			returned: BOOLEAN
		do
				-- Find the corners of the box
				-- that define the edges from current viewpoint.
			if i_main.r_main.viewx <= bspcoord [{M_BBOX}.BOXLEFT] then
				boxx := 0
			elseif i_main.r_main.viewx < bspcoord [{M_BBOX}.BOXRIGHT] then
				boxx := 1
			else
				boxx := 2
			end
			if i_main.r_main.viewy >= bspcoord [{M_BBOX}.BOXTOP] then
				boxy := 0
			elseif i_main.r_main.viewy > bspcoord [{M_BBOX}.BOXBOTTOM] then
				boxy := 1
			else
				boxy := 2
			end
			boxpos := (boxx |<< 2) + boxx
			if boxpos = 5 then
				Result := True
			else
				x1 := bspcoord [checkcoord [boxpos] [1]]
				y1 := bspcoord [checkcoord [boxpos] [2]]
				x2 := bspcoord [checkcoord [boxpos] [3]]
				y2 := bspcoord [checkcoord [boxpos] [4]]

					-- check clip list for an open space
				angle1 := i_main.r_main.R_PointToAngle (x1, y1) - i_main.r_main.viewangle
				angle2 := i_main.r_main.R_PointToAngle (x2, y2) - i_main.r_main.viewangle
				span := angle1 - angle2

					-- Sitting on a line?
				if span >= {R_MAIN}.ANG180 then
					Result := True
				else
					tspan := angle1 + i_main.r_main.clipangle
					if tspan > 2 * i_main.r_main.clipangle then
						tspan := tspan - (2 * i_main.r_main.clipangle).to_natural_32

							-- Totally off the left edge?
						if tspan >= span then
							Result := False
							returned := True
						else
							angle1 := i_main.r_main.clipangle
						end
						if not returned then
							tspan := i_main.r_main.clipangle - angle2
							if tspan > 2 * i_main.r_main.clipangle then
								tspan := tspan - (2 * i_main.r_main.clipangle).to_natural_32

									-- Totally off the left edge?
								if tspan >= span then
									Result := False
									returned := True
								else
									angle2 := (-1 * i_main.r_main.clipangle).to_natural_32
								end
							end
						end
						if not returned then
								-- Find the first clippost
								-- that touches the source post
								-- (adjacent pixels are touching).
							angle1 := (angle1 + {R_MAIN}.ANG90) |>> {R_MAIN}.ANGLETOFINESHIFT
							angle2 := (angle2 + {R_MAIN}.ANG90) |>> {R_MAIN}.ANGLETOFINESHIFT
							sx1 := i_main.r_main.viewangletox [angle1]
							sx2 := i_main.r_main.viewangletox [angle2]

								-- Does not cross a pixel
							if sx1 = sx2 then
								Result := False
								returned := True
							end
							if not returned then
								sx2 := sx2 - 1
								start := 0
								from
								until
									solidsegs [start].last < sx2
								loop
									start := start + 1
								end
								if sx1 >= solidsegs [start].first and sx2 <= solidsegs [start].last then
										-- The clippost contains the new span.
									Result := False
								else
									Result := True
								end
							end
						end
					end
				end
			end
		end

invariant
	solidsegs.count = MAXSEGS

end
