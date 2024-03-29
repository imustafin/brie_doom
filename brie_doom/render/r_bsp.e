note
	description: "[
		r_bsp.c
		BSP traversal, handling of LineSegs for rendering
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
	R_BSP

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: I_MAIN)
		local
			i: INTEGER
		do
			i_main := a_i_main
			create solidsegs.make_filled (create {CLIPRANGE_T}, 0, MAXSEGS - 1)
			from
				i := 0
			until
				i > solidsegs.upper
			loop
				solidsegs [i] := create {CLIPRANGE_T}
				i := i + 1
			end
			drawsegs := {REF_ARRAY_CREATOR [DRAWSEG_T]}.make_ref_array ({R_DEFS}.maxdrawsegs)
			create frontsector.make
			create curline.make
			create linedef.make
			create sidedef
		ensure
			{UTILS [DRAWSEG_T]}.invariant_ref_array (drawsegs, {R_DEFS}.maxdrawsegs)
		end

feature

	MAXSEGS: INTEGER = 32

	newend: INTEGER -- one past the last valid seg

	solidsegs: ARRAY [CLIPRANGE_T]

	drawsegs: ARRAY [DRAWSEG_T]

	ds_p: INTEGER assign set_ds_p -- pointer inside drawsegs

	set_ds_p (a_ds_p: like ds_p)
		do
			ds_p := a_ds_p
		end

	frontsector: SECTOR_T assign set_frontsector

	set_frontsector (a_frontsector: like frontsector)
		do
			frontsector := a_frontsector
		end

	backsector: detachable SECTOR_T assign set_backsector

	set_backsector (a_backsector: like backsector)
		do
			backsector := a_backsector
		end

feature

	curline: SEG_T assign set_curline

	set_curline (a_curline: like curline)
		do
			curline := a_curline
		end

	sidedef: SIDE_T assign set_sidedef

	set_sidedef (a_sidedef: like sidedef)
		do
			sidedef := a_sidedef
		end

	linedef: LINE_T assign set_linedef

	set_linedef (a_linedef: like linedef)
		do
			linedef := a_linedef
		end

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
		require
				-- RANGECHECK
			i_main.p_setup.subsectors.valid_index (num)
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
				if tspan > (2).as_natural_32 * i_main.r_main.clipangle then
					tspan := tspan - (2).as_natural_32 * i_main.r_main.clipangle

						-- Totally off the left edge?
					if tspan >= span then
						returned := True
					else
						angle1 := i_main.r_main.clipangle
					end
				end
				if not returned then
					tspan := i_main.r_main.clipangle - angle2
					if tspan > (2).as_natural_32 * i_main.r_main.clipangle then
						tspan := tspan - (2).as_natural_32 * i_main.r_main.clipangle

							-- Totally off the left edge?
						if tspan >= span then
							returned := True
						else
							angle2 := - i_main.r_main.clipangle
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
		local
			start: INTEGER -- index in solidsegs
			returned: BOOLEAN
		do
				-- Find the first range that touches the range
				-- (adjacent pixels are touching).
			start := solidsegs.lower
			from
			until
				solidsegs [start].last >= first - 1
			loop
				start := start + 1
			end
			if first < solidsegs [start].first then
				if last < solidsegs [start].first - 1 then
						-- Post is entirely visible (above start)
					i_main.r_segs.R_StoreWallRange (first, last)
					returned := True
				else
						-- There is a wall segment above *start
					i_main.r_segs.R_StoreWallRange (first, solidsegs [start].first - 1)
				end
			end
			if not returned then
					-- Bottom contained in start?
				if last <= solidsegs [start].last then
					returned := True
				end
			end
			if not returned then
				from
				until
					returned or last < solidsegs [start + 1].first - 1
				loop
						-- There is a fragment between two posts.
					i_main.r_segs.R_StoreWallRange (solidsegs [start].last + 1, solidsegs [start + 1].first - 1)
					start := start + 1
					if last <= solidsegs [start].last then
						returned := True
					end
				end
			end
			if not returned then
				i_main.r_segs.R_StoreWallRange (solidsegs [start].last + 1, last)
			end
		end

	R_ClipSolidWallSegment (first, last: INTEGER)
			-- Does handle solid walls ,
			-- e.g. single sided LineDefs (middle texture)
			-- that entirely block the view.
		local
			next: INTEGER
			start: INTEGER -- index in solidsegs
			done: BOOLEAN -- returned?
			goto_crunch: BOOLEAN -- goto crunch?
		do
				-- Find the first range that touches the range
				-- (ajacent pixels are touching)
			from
				start := solidsegs.lower
			until
				solidsegs [start].last >= first - 1
			loop
				start := start + 1
			end
			if first < solidsegs [start].first then
				if last < solidsegs [start].first - 1 then
						-- Post is entirely visible (above start),
						-- so insert a new clippost
					i_main.r_segs.R_StoreWallRange (first, last)
					next := newend
					newend := newend + 1
					from
					until
						next = start
					loop
						solidsegs [next] := solidsegs [next - 1].twin
						next := next - 1
					end
					solidsegs [next].first := first
					solidsegs [next].last := last
					done := True
				else
						-- There is a fragment above *start
					i_main.r_segs.R_StoreWallRange (first, solidsegs [start].first - 1)
						-- Now adjust the clip size.
					solidsegs [start].first := first
				end
			end
			if not done then
					-- Bottom contained in start?
				if last <= solidsegs [start].last then
					done := True
				end
			end
			if not done then
				next := start
				from
				until
					goto_crunch or last < solidsegs [next + 1].first - 1
				loop
						-- There is a fragment between two posts.
					i_main.r_segs.R_StoreWallRange (solidsegs [next].last + 1, solidsegs [next + 1].first - 1)
					next := next + 1
					if last <= solidsegs [next].last then
							-- Bottom is contained in next.
							-- Adjust the clip size.
						solidsegs [start].last := solidsegs [next].last
						goto_crunch := True
					end
				end
			end
			if not done and not goto_crunch then
					-- There is a fragment after *next
				i_main.r_segs.R_StoreWallRange (solidsegs [next].last + 1, last)
					-- Adjust the clip size.
				solidsegs [start].last := last
			end
				-- crunch:
			if not done then
					-- Remove start + 1 to next from the clip list,
					-- because start now covers their area
				if next = start then
						-- Post just extended past the bottom of one post.
					done := True
				end
			end
			if not done then
				from
				until
					next = newend
				loop
					next := next + 1
						-- Remove a post
					start := start + 1
					solidsegs [start] := solidsegs [next].twin
				end
				newend := start + 1
			end
		end

feature -- R_CheckBBox

	checkcoord: ARRAY [ARRAY [INTEGER]]
		once
			create Result.make_filled (create {ARRAY [INTEGER]}.make_empty, 0, 11)
			Result [0] := <<3, 0, 2, 1>>
			Result [1] := <<3, 0, 2, 0>>
			Result [2] := <<3, 1, 2, 0>>
			Result [3] := <<0, 0, 0, 0>> -- just {0} originally
			Result [4] := <<2, 0, 2, 1>>
			Result [5] := <<0, 0, 0, 0>>
			Result [6] := <<3, 1, 3, 0>>
			Result [7] := <<0, 0, 0, 0>> -- just {0} originally
			Result [8] := <<2, 0, 3, 1>>
			Result [9] := <<2, 1, 3, 1>>
			Result [10] := <<2, 1, 3, 0>>
			Result [11] := <<0, 0, 0, 0>> -- omitted originally
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
			boxpos := (boxy |<< 2) + boxx
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
					if tspan > (2).as_natural_32 * i_main.r_main.clipangle then
						tspan := tspan - (2).as_natural_32 * i_main.r_main.clipangle

							-- Totally off the left edge?
						if tspan >= span then
							Result := False
							returned := True
						else
							angle1 := i_main.r_main.clipangle
						end
					end
					if not returned then
						tspan := i_main.r_main.clipangle - angle2
						if tspan > (2).as_natural_32 * i_main.r_main.clipangle then
							tspan := tspan - (2).as_natural_32 * i_main.r_main.clipangle

								-- Totally off the left edge?
							if tspan >= span then
								Result := False
								returned := True
							else
								angle2 := - i_main.r_main.clipangle
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
								solidsegs [start].last >= sx2
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

invariant
	solidsegs.count = MAXSEGS

end
