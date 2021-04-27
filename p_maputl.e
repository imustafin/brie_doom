note
	description: "[
		p_maputl.c
		
		Movement/collision utility functions,
		as used by function in p_map.c.
		BLOCKMAP Iterator functions,
		and some PIT_* functions to use for iteration
	]"

class
	P_MAPUTL

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
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
			if thing.flags & {MOBJFLAG_T}.MF_NOSECTOR /= 0 then
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
			if thing.flags & {MOBJFLAG_T}.MF_NOBLOCKMAP /= 0 then
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
					i_main.p_setup.blocklinks [blocky * i_main.p_setup.bmapwidth + blockx] := link
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

	P_BlockLinesIterator (x, y: INTEGER; func: FUNCTION [LINE_T, BOOLEAN]): BOOLEAN
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
				offset := i_main.p_setup.blockmap [offset]
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
				p1 := (tmbox [{M_BBOX}.BOXTOP] < ld.v1.x).to_integer
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

end
