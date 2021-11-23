note
	description: "[
		p_sight.c
		
		LineOfSight/Visibility checks, uses REJECT Lookup Table.
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
	P_SIGHT

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: I_MAIN)
		do
			i_main := a_i_main
			create strace
		end

feature -- P_CheckSight

	topslope: FIXED_T assign set_topslope
			-- slope to the top of target

	set_topslope (a_topslope: like topslope)
		do
			topslope := a_topslope
		end

	bottomslope: FIXED_T assign set_bottomslope
			-- slope to the bottom of target

	set_bottomslope (a_bottomslope: like bottomslope)
		do
			bottomslope := a_bottomslope
		end

	sightzstart: FIXED_T
			-- eye z of looker

	strace: DIVLINE_T
			-- from t1 to t2

	t2x: FIXED_T

	t2y: FIXED_T

	P_CheckSight (t1, t2: MOBJ_T): BOOLEAN
			-- Returns true
			-- if a straight line between t1 and t2 is unobstructed.
			-- Uses REJECT.
		local
			s1, s2: INTEGER
			pnum: INTEGER
			bytenum: INTEGER
			bitnum: INTEGER
		do
				-- First check for trivial rejection.
				-- Determine subsector entries in REJECT table.
			check attached t1.subsector as sub and then attached sub.sector as sec then
				s1 := {UTILS [SECTOR_T]}.first_index (i_main.p_setup.sectors, sec)
			end
			check attached t2.subsector as sub and then attached sub.sector as sec then
				s2 := {UTILS [SECTOR_T]}.first_index (i_main.p_setup.sectors, sec)
			end
			pnum := s1 * i_main.p_setup.numsectors + s2
			bytenum := pnum |>> 3
			bitnum := 1 |<< (pnum & 7)
				-- Check in REJECT table.
			check attached i_main.p_setup.rejectmatrix as rm then
				if rm [bytenum] & bitnum /= 0 then
						-- can't possibly be connected
					Result := False
				else
						-- An obstructed LOS is possible.
						-- Now look from eyes of t1 to any part of t2.
					i_main.r_main.validcount := i_main.r_main.validcount + 1
					sightzstart := t1.z + t1.height - (t1.height |>> 2)
					topslope := (t2.z + t2.height) - sightzstart
					bottomslope := (t2.z) - sightzstart
					strace.x := t1.x
					strace.y := t1.y
					t2x := t2.x
					t2y := t2.y
					strace.dx := t2.x - t1.x
					strace.dy := t2.y - t1.y

						-- the head node is the last node output
					Result := P_CrossBSPNode (i_main.p_setup.numnodes - 1)
				end
			end
		end

feature

	P_CrossBSPNode (bspnum: INTEGER): BOOLEAN
			-- Returns true
			-- if strace crosses the given node successfully.
		local
			bsp: NODE_T
			side: INTEGER
		do
			if bspnum & {DOOMDATA_H}.NF_SUBSECTOR /= 0 then
				if bspnum = -1 then
					Result := P_CrossSubsector (0)
				else
					Result := P_CrossSubsector (bspnum & {DOOMDATA_H}.NF_SUBSECTOR.bit_not)
				end
			else
				bsp := i_main.p_setup.nodes [bspnum]
					-- decide which side the start point is on
				side := P_DivlineSide (strace.x, strace.y, bsp)
				if side = 2 then
					side := 0 -- an "on" should cross both sides
				end
					-- cross the starting side
				if not P_CrossBSPNode (bsp.children [side]) then
					Result := False
				else
						-- the partition plane is crossed here
					if side = P_DivlineSide (t2x, t2y, bsp) then
							-- the line doesn't touch the other side
						Result := True
					else
							-- cross the ending side
						Result := P_CrossBSPNode (bsp.children [side.bit_xor (1)])
					end
				end
			end
		end

	P_DivlineSide (x, y: FIXED_T; node: DIVLINE_T): INTEGER
			-- Returns side 0 (front), 1 (back), or 2 (on)
		local
			dx, dy: FIXED_T
			left, right: FIXED_T
		do
			if node.dx = 0 then
				if x = node.x then
					Result := 2
				elseif x <= node.x then
					Result := (node.dy > 0).to_integer
				else
					Result := (node.dy < 0).to_integer
				end
			elseif node.dy = 0 then
				if x = node.y then
					Result := 2
				elseif y <= node.y then
					Result := (node.dx < 0).to_integer
				else
					Result := (node.dx > 0).to_integer
				end
			else
				dx := (x - node.x)
				dy := (y - node.y)
				left := (node.dy |>> {M_FIXED}.FRACBITS) * (dx |>> {M_FIXED}.FRACBITS)
				right := (dy |>> {M_FIXED}.FRACBITS) * (node.dx |>> {M_FIXED}.FRACBITS)
				if right < left then
					Result := 0 -- front side
				else
					if left = right then
						Result := 2
					else
						Result := 1 -- back side
					end
				end
			end
		end

	P_CrossSubsector (num: INTEGER): BOOLEAN
			-- Returns true
			-- if strace crosses the given subsector successfully
		require
			RANGECHECK: num < i_main.p_setup.subsectors.count
		local
			seg: SEG_T
			seg_i: INTEGER
			line: LINE_T
			s1, s2: INTEGER
			count: INTEGER
			sub: SUBSECTOR_T
			front, back: SECTOR_T
			opentop, openbottom: FIXED_T
			divl: DIVLINE_T
			v1, v2: VERTEX_T
			frac: FIXED_T
			slope: FIXED_T
			returned: BOOLEAN
		do
			create divl
			sub := i_main.p_setup.subsectors [num]
				-- check lines
			count := sub.numlines
			seg_i := sub.firstline
			from
			until
				returned or count = 0
			loop
				seg := i_main.p_setup.segs [seg_i]
				line := seg.linedef

					-- allready checked other side?
				if line.validcount = i_main.r_main.validcount then
						-- continue
				else
					line.validcount := i_main.r_main.validcount
					v1 := line.v1
					v2 := line.v2
					s1 := P_DivlineSide (v1.x, v1.y, strace)
					s2 := P_DivlineSide (v2.x, v2.y, strace)

						-- line isn't crossed?
					if s1 = s2 then
							-- continue
					else
						divl.x := v1.x
						divl.y := v1.y
						divl.dx := v2.x - v1.x
						divl.dy := v2.y - v1.y
						s1 := P_DivlineSide (strace.x, strace.y, divl)
						s2 := P_DivlineSide (t2x, t2y, divl)

							-- line isn't crossed?
						if s1 = s2 then
								-- continue
						else
								-- stop because it is not two sided anyway
								-- might do this after updating validcount?
							if line.flags & {DOOMDATA_H}.ML_TWOSIDED = 0 then
								Result := False
								returned := True
							else
									-- crosses a two sided line
								front := seg.frontsector
								back := seg.backsector
								check attached front and then attached back then
										-- no wall to block sight with?
									if front.floorheight = back.floorheight and front.ceilingheight = back.ceilingheight then
											-- continue
									else
											-- possible occluder
											-- because of ceiling height differences
										if front.ceilingheight < back.ceilingheight then
											opentop := front.ceilingheight
										else
											opentop := back.ceilingheight
										end
											-- because of ceiling height differences
										if front.floorheight > back.floorheight then
											openbottom := front.floorheight
										else
											openbottom := back.floorheight
										end
											-- quick test for totally closed doors
										if openbottom >= opentop then
											Result := False -- stop
											returned := True
										else
											frac := P_InterceptVector2 (strace, divl)
											if front.floorheight /= back.floorheight then
												slope := {M_FIXED}.fixeddiv (openbottom - sightzstart, frac)
												if slope > bottomslope then
													bottomslope := slope
												end
											end
											if front.ceilingheight /= back.ceilingheight then
												slope := {M_FIXED}.fixeddiv (opentop - sightzstart, frac)
												if slope < topslope then
													topslope := slope
												end
											end
											if topslope <= bottomslope then
												Result := False -- stop
												returned := True
											end
										end
									end
								end
							end
						end
					end
				end
				seg_i := seg_i + 1
				count := count - 1
			end
			if not returned then
					-- passed the subsector ok
				Result := True
			end
		end

	P_InterceptVector2 (v2, v1: DIVLINE_T): FIXED_T
			-- Returns the fractional intercept point
			-- along the first divline.
			-- This is only called by the addthings and addlines traversers
		local
			frac, num, den: FIXED_T
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

end
