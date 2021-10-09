note
	description: "[
		p_maputl.c
		
		Movement/collision utility functions,
		as used by function in p_map.c.
		BLOCKMAP Iterator functions,
		and some PIT_* functions to use for iteration
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
	P_MAPUTL

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		local
			i: INTEGER
		do
			i_main := a_i_main
			create trace
			create intercepts.make_filled (create {INTERCEPT_T}, 0, {P_LOCAL}.MAXINTERCEPTS - 1)
			from
				i := 0
			until
				i > intercepts.upper
			loop
				intercepts [i] := create {INTERCEPT_T}
				i := i + 1
			end
		end

feature

	P_UnsetThingPosition (thing: MOBJ_T)
			-- Unlinks a thing from block map and sectors.
			-- On each position change, BLOCKMAP and other
			-- lookups maintaining lists of things inside
			-- these structures need to be updated.
		local
			blockx: INTEGER
			blocky: INTEGER
		do
			if thing.flags & {MOBJFLAG_T}.MF_NOSECTOR = 0 then
					-- inert things don't need to be in blockmap?
					-- unlink from subsector
				if attached thing.snext as snext then
					snext.sprev := thing.sprev
				end
				if attached thing.sprev as sprev then
					sprev.snext := thing.snext
				else
					check attached thing.subsector as sub and then attached sub.sector as sec then
						sec.thinglist := thing.snext
					end
				end
			end
			if thing.flags & {MOBJFLAG_T}.MF_NOBLOCKMAP = 0 then
					-- inert things don't need to be in blockmap
					-- unlink from black map
				if attached thing.bnext as bnext then
					bnext.bprev := thing.bprev
				end
				if attached thing.bprev as bprev then
					bprev.bnext := thing.bnext
				else
					blockx := ((thing.x - i_main.p_setup.bmaporgx) |>> {P_LOCAL}.MAPBLOCKSHIFT).to_integer_32
					blocky := ((thing.y - i_main.p_setup.bmaporgy) |>> {P_LOCAL}.MAPBLOCKSHIFT).to_integer_32
					if blockx >= 0 and blockx < i_main.p_setup.bmapwidth and blocky >= 0 and blocky < i_main.p_setup.bmapheight then
						i_main.p_setup.blocklinks [blocky * i_main.p_setup.bmapwidth + blockx] := thing.bnext
					end
				end
			end
		end

	P_SetThingPosition (thing: MOBJ_T)
			-- Links a thing into both a block and a subsector
			-- based on it's x y.
			-- Sets thing->subsector properly
		local
			ss: SUBSECTOR_T
			sec: SECTOR_T
			blockx, blocky: INTEGER
			link: MOBJ_T
		do
				-- link into subsector
			ss := i_main.r_main.R_PointInSubsector (thing.x, thing.y)
			thing.subsector := ss
			if thing.flags & {MOBJFLAG_T}.MF_NOSECTOR = 0 then
					-- invisible things don't go into the sector links
				sec := ss.sector
				check attached sec then
					thing.sprev := Void
					thing.snext := sec.thinglist
					if attached sec.thinglist as thinglist then
						thinglist.sprev := thing
					end
					sec.thinglist := thing
				end
			end

				-- link into blockmap
			if thing.flags & {MOBJFLAG_T}.MF_NOBLOCKMAP = 0 then
					-- inert things don't need to be in blockmap
				blockx := ((thing.x - i_main.p_setup.bmaporgx) |>> {P_LOCAL}.MAPBLOCKSHIFT).to_integer_32
				blocky := ((thing.y - i_main.p_setup.bmaporgy) |>> {P_LOCAL}.MAPBLOCKSHIFT).to_integer_32
				if blockx >= 0 and blockx < i_main.p_setup.bmapwidth and blocky >= 0 and blocky < i_main.p_setup.bmapheight then
					link := i_main.p_setup.blocklinks [blocky * i_main.p_setup.bmapwidth + blockx]
					thing.bprev := Void
					thing.bnext := link
					if attached link then
						link.bprev := thing
					end
					i_main.p_setup.blocklinks [blocky * i_main.p_setup.bmapwidth + blockx] := thing
				else
						-- thing is off the map
					thing.bnext := Void
					thing.bprev := Void
				end
			end
		end

	P_PointOnLineSide (x, y: FIXED_T; line: LINE_T): INTEGER
			-- Returns 0 or 1
		local
			dx: FIXED_T
			dy: FIXED_T
			left: FIXED_T
			right: FIXED_T
		do
			if line.dx = 0 then
				if x <= line.v1.x then
					Result := (line.dy > 0).to_integer
				else
					Result := (line.dy < 0).to_integer
				end
			elseif line.dy = 0 then
				if y <= line.v1.y then
					Result := (line.dx < 0).to_integer
				else
					Result := (line.dx > 0).to_integer
				end
			else
				dx := x - line.v1.x
				dy := y - line.v1.y
				left := {M_FIXED}.fixedmul (line.dy |>> {M_FIXED}.FRACBITS, dx)
				right := {M_FIXED}.fixedmul (dy, line.dx |>> {M_FIXED}.FRACBITS)
				if right < left then
					Result := 0
				else
					Result := 1
				end
			end
		ensure
			Result = 0 or Result = 1
		end

	P_AproxDistance (a_dx, a_dy: FIXED_T): FIXED_T
		local
			dx, dy: FIXED_T
		do
			dx := a_dx.abs
			dy := a_dy.abs
			if dx < dy then
				Result := dx + dy - (dx |>> 1)
			else
				Result := dx + dy - (dy |>> 1)
			end
		end

	P_BlockThingsIterator (x, y: INTEGER; func: FUNCTION [MOBJ_T, BOOLEAN]): BOOLEAN
		local
			mobj: MOBJ_T
		do
			if x < 0 or y < 0 or x >= i_main.p_setup.bmapwidth or y >= i_main.p_setup.bmapheight then
				Result := True
			else
				from
					Result := True
					mobj := i_main.p_setup.blocklinks [y * i_main.p_setup.bmapwidth + x]
				until
					not Result or mobj = Void
				loop
					Result := func.item (mobj)
					mobj := mobj.bnext
				end
			end
		end

	P_BlockLinesIterator (x, y: INTEGER; func: PREDICATE [LINE_T]): BOOLEAN
			-- The validcount flags are used to avoid checking lines
			-- that are marked in multiple mapblocks,
			-- so increment validcount before the first call
			-- to P_BlocLinesIterator, then make one or more calls to it.
		local
			offset: INTEGER
			list: INTEGER -- index in blockmaplump
			ld: LINE_T
			returned: BOOLEAN
		do
			if x < 0 or y < 0 or x >= i_main.p_setup.bmapwidth or y >= i_main.p_setup.bmapheight then
				Result := True
				returned := True
			end
			if not returned then
				offset := y * i_main.p_setup.bmapwidth + x
				check attached i_main.p_setup.blockmap as bm then
					offset := bm [offset]
				end

				from
					Result := True
					list := offset
				until
					not Result or i_main.p_setup.blockmaplump [list] = -1
				loop
					ld := i_main.p_setup.lines [i_main.p_setup.blockmaplump [list]]
					if ld.validcount = i_main.r_main.validcount then
							-- continue -- line has already been checked
					else
						if not func.item (ld) then
							Result := False
						end
					end
					list := list + 1
				end
			end
		end

	P_BoxOnLineSide (tmbox: ARRAY [INTEGER]; ld: LINE_T): INTEGER
			-- Considers the line to be infinite
			-- Returns side 0 or 1, -1 if box crosses the line
		local
			p1: INTEGER
			p2: INTEGER
		do
			if ld.slopetype = {R_DEFS}.ST_HORIZONTAL then
				p1 := (tmbox [{M_BBOX}.BOXTOP] > ld.v1.y).to_integer
				p2 := (tmbox [{M_BBOX}.BOXBOTTOM] > ld.v1.y).to_integer
				if ld.dx < 0 then
					p1 := p1.bit_xor (1)
					p2 := p2.bit_xor (1)
				end
			elseif ld.slopetype = {R_DEFS}.ST_VERTICAL then
				p1 := (tmbox [{M_BBOX}.BOXRIGHT] < ld.v1.x).to_integer
				p2 := (tmbox [{M_BBOX}.BOXLEFT] < ld.v1.x).to_integer
				if ld.dy < 0 then
					p1 := p1.bit_xor (1)
					p2 := p2.bit_xor (1)
				end
			elseif ld.slopetype = {R_DEFS}.ST_POSITIVE then
				p1 := P_PointOnLineSide (tmbox [{M_BBOX}.BOXLEFT], tmbox [{M_BBOX}.BOXTOP], ld)
				p2 := P_PointOnLineSide (tmbox [{M_BBOX}.BOXRIGHT], tmbox [{M_BBOX}.BOXBOTTOM], ld)
			elseif ld.slopetype = {R_DEFS}.ST_NEGATIVE then
				p1 := P_PointOnLineSide (tmbox [{M_BBOX}.BOXRIGHT], tmbox [{M_BBOX}.BOXTOP], ld)
				p2 := P_PointOnLineSide (tmbox [{M_BBOX}.BOXLEFT], tmbox [{M_BBOX}.BOXBOTTOM], ld)
			end
			if p1 = p2 then
				Result := p1
			else
				Result := -1
			end
		end

feature -- P_LineOpening

	opentop: FIXED_T

	openbottom: FIXED_T

	openrange: FIXED_T

	lowfloor: FIXED_T

	P_LineOpening (linedef: LINE_T)
			-- Sets opentop and openbottom to the window
			-- through a two sided line.
			-- OPTIMIZE: keep this precalculated
		do
			if linedef.sidenum [1] = -1 then
					-- single sided line
				openrange := 0
			else
				check attached linedef.frontsector as front and then attached linedef.backsector as back then
					if front.ceilingheight < back.ceilingheight then
						opentop := front.ceilingheight
					else
						opentop := back.ceilingheight
					end
					if front.floorheight > back.floorheight then
						openbottom := front.floorheight
						lowfloor := back.floorheight
					else
						openbottom := front.floorheight
						lowfloor := front.floorheight
					end
					openrange := opentop - openbottom
				end
			end
		end

feature

	earlyout: BOOLEAN

	intercepts: ARRAY [INTERCEPT_T]

	intercept_p: detachable INDEX_IN_ARRAY [INTERCEPT_T]

	trace: DIVLINE_T

	P_PathTraverse (a_x1, a_y1, a_x2, a_y2: FIXED_T; flags: INTEGER; trav: PREDICATE [INTERCEPT_T]): BOOLEAN
		local
			xt1, yt1, xt2, yt2: FIXED_T
			xstep, ystep: FIXED_T
			partial: FIXED_T
			xintercept, yintercept: FIXED_T
			mapx: INTEGER
			mapy: INTEGER
			mapxstep: INTEGER
			mapystep: INTEGER
			count: INTEGER
			returned: BOOLEAN
			break: BOOLEAN
			x1, y1, x2, y2: FIXED_T
		do
			x1 := a_x1
			y1 := a_y1
			x2 := a_x2
			y2 := a_y2
			earlyout := flags & {P_LOCAL}.PT_EARLYOUT /= 0
			i_main.r_main.validcount := i_main.r_main.validcount + 1
			create intercept_p.make (0, intercepts)
			if ((x1 - i_main.p_setup.bmaporgx) & ({P_LOCAL}.MAPBLOCKSIZE - 1)) = 0 then
				x1 := x1 + {M_FIXED}.FRACUNIT -- don't side exactly on a line
			end
			if ((y1 - i_main.p_setup.bmaporgy) & ({P_LOCAL}.MAPBLOCKSIZE - 1)) = 0 then
				y1 := y1 + {M_FIXED}.FRACUNIT -- don't side exactly on a line
			end
			trace.x := x1
			trace.y := y1
			trace.dx := x2 - x1
			trace.dy := y2 - y1
			x1 := x1 - i_main.p_setup.bmaporgx
			y1 := y1 - i_main.p_setup.bmaporgy
			xt1 := x1 |>> {P_LOCAL}.MAPBLOCKSHIFT
			yt1 := y1 |>> {P_LOCAL}.MAPBLOCKSHIFT
			x2 := x2 - i_main.p_setup.bmaporgx
			y2 := y2 - i_main.p_setup.bmaporgy
			xt2 := x2 |>> {P_LOCAL}.MAPBLOCKSHIFT
			yt2 := y2 |>> {P_LOCAL}.MAPBLOCKSHIFT
			if xt2 > xt1 then
				mapxstep := 1
				partial := {M_FIXED}.fracunit - ((x1 |>> {P_LOCAL}.MAPBTOFRAC) & ({M_FIXED}.FRACUNIT - 1))
				ystep := {M_FIXED}.fixeddiv (y2 - y1, (x2 - x1).abs)
			elseif xt2 < xt1 then
				mapxstep := -1
				partial := (x1 |>> {P_LOCAL}.MAPBTOFRAC) & ({M_FIXED}.FRACUNIT - 1)
				ystep := {M_FIXED}.fixeddiv (y2 - y1, (x2 - x1).abs)
			else
				mapxstep := 0
				partial := {M_FIXED}.FRACUNIT
				ystep := 256 * {M_FIXED}.FRACUNIT
			end
			yintercept := (y1 |>> {P_LOCAL}.MAPBTOFRAC) + {M_FIXED}.fixedmul (partial, ystep)
			if yt2 > yt1 then
				mapystep := 1
				partial := {M_FIXED}.FRACUNIT - ((y1 |>> {P_LOCAL}.MAPBTOFRAC) & ({M_FIXED}.FRACUNIT - 1))
				xstep := {M_FIXED}.fixeddiv (x2 - x1, (y2 - y1).abs)
			elseif yt2 < yt1 then
				mapystep := -1
				partial := (y1 |>> {P_LOCAL}.MAPBTOFRAC) & ({M_FIXED}.FRACUNIT - 1)
				xstep := {M_FIXED}.fixeddiv (x2 - x1, (y2 - y1).abs)
			else
				mapystep := 0
				partial := {M_FIXED}.FRACUNIT
				xstep := 256 * {M_FIXED}.FRACUNIT
			end
			xintercept := (x1 |>> {P_LOCAL}.MAPBTOFRAC) + {M_FIXED}.fixedmul (partial, xstep)

				-- Step through map blocks.
				-- Count is present to prevent a round off error
				-- from skipping the break
			mapx := xt1
			mapy := yt1
			from
				count := 0
				returned := False
				break := False
			until
				returned or break or count >= 64
			loop
				if flags & {P_LOCAL}.PT_ADDLINES /= 0 then
					if not P_BlockLinesIterator (mapx, mapy, agent PIT_AddLineIntercepts) then
						Result := False
						returned := True -- early out
					end
				end
				if not returned then
					if flags & {P_LOCAL}.PT_ADDTHINGS /= 0 then
						if not P_BlockThingsIterator (mapx, mapy, agent PIT_AddThingIntercepts) then
							Result := False
							returned := True -- early out
						end
					end
				end
				if not returned then
					if mapx = xt2 and mapy = yt2 then
						break := True
					end
				end
				if not returned and not break then
					if (yintercept |>> {M_FIXED}.FRACBITS) = mapy then
						yintercept := yintercept + ystep
						mapx := mapx + mapxstep
					elseif (xintercept |>> {M_FIXED}.FRACBITS) = mapx then
						xintercept := xintercept + xstep
						mapy := mapy + mapystep
					end
				end
				count := count + 1
			end
			if not returned then
				Result := P_TraverseIntercepts (trav, {M_FIXED}.FRACUNIT)
			end
		end

	PIT_AddThingIntercepts (thing: MOBJ_T): BOOLEAN
		local
			x1: FIXED_T
			y1: FIXED_T
			x2: FIXED_T
			y2: FIXED_T
			s1: INTEGER
			s2: INTEGER
			tracepositive: BOOLEAN
			dl: DIVLINE_T
			frac: FIXED_T
		do
			tracepositive := (trace.dx.bit_xor (trace.dy)) > 0
				-- check a corner to corner crossection for hit
			if tracepositive then
				x1 := thing.x - thing.radius
				y1 := thing.y + thing.radius
				x2 := thing.x + thing.radius
				y2 := thing.y - thing.radius
			else
				x1 := thing.x - thing.radius
				y1 := thing.y - thing.radius
				x2 := thing.x + thing.radius
				y2 := thing.y + thing.radius
			end
			s1 := P_PointOnDivlineSide (x1, y1, trace).to_integer
			s2 := P_PointOnDivlineSide (x2, y2, trace).to_integer
			if s1 = s2 then
				Result := True -- line isn't crossed
			else
				create dl
				dl.x := x1
				dl.y := y1
				dl.dx := x2 - x1
				dl.dy := y2 - y1
				frac := P_InterceptVector (trace, dl)
				if frac < 0 then
					Result := True -- behind source
				else
					check attached intercept_p as ip then
						ip.this.frac := frac
						ip.this.isaline := False
						ip.this.thing := thing
						intercept_p := ip + 1
					end
					Result := True
				end
			end
		end

	PIT_AddLineIntercepts (ld: LINE_T): BOOLEAN
			-- Looks for lines in the given block
			-- that intercept the given trace
			-- to add to the intercepts list.
			--
			-- A line is crossed if its endpoints
			-- are on opposite sides of the trace.
			-- Returns true if earlyout and a solid line hit.
		local
			s1: INTEGER
			s2: INTEGER
			frac: FIXED_T
			dl: DIVLINE_T
		do
				-- avoid precision problems with two routines
			if trace.dx > {M_FIXED}.fracunit * 16 or trace.dy > {M_FIXED}.fracunit * 16 or trace.dx < - {M_FIXED}.fracunit * 16 or trace.dy < - {M_FIXED}.fracunit then
				s1 := P_PointOnDivlineSide (ld.v1.x, ld.v1.y, trace).to_integer
				s2 := P_PointOnDivlineSide (ld.v2.x, ld.v2.y, trace).to_integer
			else
				s1 := P_PointOnLineSide (trace.x, trace.y, ld)
				s2 := P_PointOnLineSide (trace.x + trace.dx, trace.y + trace.dy, ld)
			end
			if s1 = s2 then
				Result := True -- line isn't crossed
			else
					-- hit the line
				create dl.make_from_line (ld)
				frac := P_InterceptVector (trace, dl)
				if frac < 0 then
					Result := True -- behind source
				else
						-- try to early out the check
					if earlyout and frac < {M_FIXED}.fracunit and ld.backsector = Void then
						Result := False -- stop checking
					else
						check attached intercept_p as ip then
							ip.this.frac := frac
							ip.this.isaline := True
							ip.this.line := ld
							intercept_p := ip + 1
							Result := True -- continue
						end
					end
				end
			end
		end

	P_InterceptVector (v2, v1: DIVLINE_T): FIXED_T
			-- Returns the fractional intercept point
			-- along the first divline.
			-- This is only called by the addthings
			-- and addlines traversers.
		local
			frac: FIXED_T
			num: FIXED_T
			den: FIXED_T
		do
			den := {M_FIXED}.fixedmul (v1.dy |>> 8, v2.dx) - {M_FIXED}.fixedmul (v1.dx |>> 8, v2.dy)
			if den = 0 then
				Result := 0
			else
				num := {M_FIXED}.fixedmul ((v1.x - v2.x) |>> 8, v1.dy) + {M_FIXED}.fixedmul ((v2.y - v1.y) |>> 8, v1.dx)
				frac := {M_FIXED}.fixeddiv (num, den)
				Result := frac
			end
		end

	P_PointOnDivlineSide (x, y: FIXED_T; line: DIVLINE_T): BOOLEAN
			-- Returns True for 1, False for 0
		local
			dx: FIXED_T
			dy: FIXED_T
			left: FIXED_T
			right: FIXED_T
		do
			if line.dx = 0 then
				if x <= line.x then
					Result := line.dy > 0
				else
					Result := line.dy < 0
				end
			elseif line.dy = 0 then
				if y <= line.y then
					Result := line.dx < 0
				else
					Result := line.dx > 0
				end
			else
				dx := (x - line.x)
				dy := (y - line.y)

					-- try to quickly decide by looking at sign bits
				if line.dy.bit_xor (line.dx).bit_xor (dx).bit_xor (dy) & (0x80000000).to_integer_32 /= 0 then
					if line.dy.bit_xor (dx) & (0x80000000).to_integer_32 /= 0 then
						Result := True
					else
						Result := False
					end
				else
					left := {M_FIXED}.fixedmul (line.dy |>> 8, dx |>> 8)
					right := {M_FIXED}.fixedmul (dy |>> 8, line.dx |>> 8)
					if right < left then
						Result := False -- front side
					else
						Result := True -- back side

					end
				end
			end
		end

	P_TraverseIntercepts (func: PREDICATE [INTERCEPT_T]; maxfrac: FIXED_T): BOOLEAN
			-- Returns true if the traverser function returns true
			-- for all lines.
		require
			intercept_p /= Void
		local
			count: INTEGER
			dist: FIXED_T
			scan: INDEX_IN_ARRAY [INTERCEPT_T]
			in: INTERCEPT_T
			returned: BOOLEAN
		do
			from
				check attached intercept_p as ip then
					count := ip.index
				end
			until
				returned or count = 0
			loop
				count := count - 1
				dist := {DOOMTYPE_H}.MAXINT
				from
					create scan.make (0, intercepts)
				until
					returned or (intercept_p = Void or else (attached intercept_p as ip and then scan.index >= ip.index))
				loop
					if scan.this.frac < dist then
						dist := scan.this.frac
						in := scan.this
					end
					create scan.make (scan.index + 1, intercepts)
				end
				if dist > maxfrac then
					Result := True -- checked everything in range
					returned := True
				else
					check attached in as attached_in then
						if not func.item (attached_in) then
							Result := False -- don't bother going farther
							returned := True
						else
							attached_in.frac := {DOOMTYPE_H}.MAXINT
						end
					end
				end
			end
			if not returned then
				Result := True
			end
		end

invariant
	{UTILS [INTERCEPT_T]}.invariant_ref_array (intercepts, {P_LOCAL}.MAXINTERCEPTS)

end
