note
	description: "[
		p_map.c
		
		Movement, collision handling.
		Shooting and aiming
	]"

class
	P_MAP

inherit

	MOBJFLAG_T

	MOBJTYPE_T

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create spechit.make_filled (Void, 0, MAXSPECIALCROSS - 1)
			create tmbbox.make_filled (0, 0, 3)
		end

feature

	ceilingline: detachable LINE_T
			-- keep track of the line that lowers the ceiling,
			-- so missiles don't explode against sky hack walls

	floatok: BOOLEAN
			-- If true, move would be ok
			-- if within `tmfloorz - tmceilingz`

	tmbbox: ARRAY [INTEGER]

	tmthing: detachable MOBJ_T

	tmflags: INTEGER

	tmx: INTEGER

	tmy: INTEGER

	tmfloorz: FIXED_T

	tmceilingz: FIXED_T

	tmdropoffz: FIXED_T

	numspechit: INTEGER

	spechit: ARRAY [detachable LINE_T]

	MAXSPECIALCROSS: INTEGER = 8

feature

	P_UseLines (player: PLAYER_T)
			-- Looks for special lines in front of the player to activate
		do
			{I_MAIN}.i_error ("P_UseLines is not implemented")
		ensure
			instance_free: class
		end

	P_TryMove (thing: MOBJ_T; x, y: FIXED_T): BOOLEAN
			-- Attempt to move to a new position,
			-- crossing special lines unless MF_TELEPORT is set
		local
			oldx: FIXED_T
			oldy: FIXED_T
			side: INTEGER
			oldside: INTEGER
			ld: LINE_T
			returned: BOOLEAN
		do
			floatok := False
			if not P_CheckPosition (thing, x, y) then
				returned := True
				Result := False -- solid wall or thing
			end
			if not returned then
				if thing.flags & {MOBJFLAG_T}.MF_NOCLIP = 0 then
					if tmceilingz - tmfloorz < thing.height then
						returned := True
						Result := False -- doesn't fit
					end
					if not returned then
						floatok := True
						if thing.flags & {MOBJFLAG_T}.MF_TELEPORT = 0 and tmceilingz - thing.z < thing.height then
							returned := True
							Result := False -- mobj must lower itself to fit
						end
					end
					if not returned then
						if thing.flags & {MOBJFLAG_T}.MF_TELEPORT = 0 and tmfloorz - thing.z > 24 * {M_FIXED}.FRACUNIT then
							returned := True
							Result := False -- too big a step up
						end
					end
					if not returned then
						if thing.flags & ({MOBJFLAG_T}.MF_DROPOFF | {MOBJFLAG_T}.MF_FLOAT) = 0 and tmfloorz - tmdropoffz > 24 * {M_FIXED}.FRACUNIT then
							returned := True
							Result := False -- don't stand over a dropoff
						end
					end
				end
			end
			if not returned then
					-- the move is ok,
					-- so link the thing into its new position
				i_main.p_maputl.P_UnsetThingPosition (thing)
				oldx := thing.x
				oldy := thing.y
				thing.floorz := tmfloorz
				thing.ceilingz := tmceilingz
				thing.x := x
				thing.y := y
				i_main.p_maputl.P_SetThingPosition (thing)

					-- if any special lines were hit, do the effect
				if thing.flags & ({MOBJFLAG_T}.MF_TELEPORT | {MOBJFLAG_T}.MF_NOCLIP) = 0 then
					from
					until
						numspechit <= 0
					loop
						numspechit := numspechit - 1
							-- see if the line was crossed
						ld := spechit [numspechit]
						check attached ld then
							side := i_main.p_maputl.P_PointOnLineSide (thing.x, thing.y, ld)
							oldside := i_main.p_maputl.P_PointOnLineSide (oldx, oldy, ld)
							if side /= oldside then
								if ld.special /= 0 then
									i_main.p_spec.P_CrossSpecialLine ({UTILS [LINE_T]}.first_index (i_main.p_setup.lines, ld), oldside, thing)
								end
							end
						end
					end
				end
				Result := True
			end
		ensure
			(not Result) implies thing ~ old thing
		end

	P_CheckPosition (thing: MOBJ_T; x, y: FIXED_T): BOOLEAN
		local
			xl: INTEGER
			xh: INTEGER
			yl: INTEGER
			yh: INTEGER
			bx: INTEGER
			by: INTEGER
			newsubsec: SUBSECTOR_T
			returned: BOOLEAN
		do
			tmthing := thing
			tmflags := thing.flags
			tmx := x.to_integer_32
			tmy := y.to_integer_32
			tmbbox [{M_BBOX}.BOXTOP] := (y + thing.radius).to_integer_32
			tmbbox [{M_BBOX}.BOXBOTTOM] := (y - thing.radius).to_integer_32
			tmbbox [{M_BBOX}.BOXRIGHT] := (x + thing.radius).to_integer_32
			tmbbox [{M_BBOX}.BOXLEFT] := (x - thing.radius).to_integer_32
			ceilingline := Void
			newsubsec := i_main.r_main.R_PointInSubsector (x, y)
				-- The base floor / ceiling is from the subsector
				-- that contains the point.
				-- Any contacted lines the step closer together
				-- will adjust them.
			check attached newsubsec.sector as sector then
				tmfloorz := sector.floorheight
				tmdropoffz := tmfloorz
				tmceilingz := sector.ceilingheight
			end
			i_main.r_main.validcount := i_main.r_main.validcount + 1
			numspechit := 0
			if tmflags & {MOBJFLAG_T}.MF_NOCLIP /= 0 then
				Result := True
				returned := True
			end
			if not returned then
					-- Check thing first, possibly picking things up.
					-- The bounding box is extended by MAXRADIUS
					-- because mobj_ts are grouped into mapblocks
					-- based on their origin point, and can overlap
					-- into adjacent blocks by up to MAXRADIUS units.
				xl := (tmbbox [{M_BBOX}.BOXLEFT] - i_main.p_setup.bmaporgx - {P_LOCAL}.MAXRADIUS) |>> {P_LOCAL}.MAPBLOCKSHIFT
				xh := (tmbbox [{M_BBOX}.BOXRIGHT] - i_main.p_setup.bmaporgx + {P_LOCAL}.MAXRADIUS) |>> {P_LOCAL}.MAPBLOCKSHIFT
				yl := (tmbbox [{M_BBOX}.BOXBOTTOM] - i_main.p_setup.bmaporgy - {P_LOCAL}.MAXRADIUS) |>> {P_LOCAL}.MAPBLOCKSHIFT
				yh := (tmbbox [{M_BBOX}.BOXTOP] - i_main.p_setup.bmaporgy + {P_LOCAL}.MAXRADIUS) |>> {P_LOCAL}.MAPBLOCKSHIFT
				from
					bx := xl
				until
					returned or bx > xh
				loop
					from
						by := yl
					until
						returned or by > yh
					loop
						if not i_main.p_maputl.P_BlockThingsIterator (bx, by, agent PIT_CheckThing) then
							Result := False
							returned := True
						end
						by := by + 1
					end
					bx := bx + 1
				end
			end
			if not returned then
					-- check lines
				xl := (tmbbox [{M_BBOX}.BOXLEFT] - i_main.p_setup.bmaporgx) |>> {P_LOCAL}.MAPBLOCKSHIFT
				xh := (tmbbox [{M_BBOX}.BOXRIGHT] - i_main.p_setup.bmaporgx) |>> {P_LOCAL}.MAPBLOCKSHIFT
				yl := (tmbbox [{M_BBOX}.BOXBOTTOM] - i_main.p_setup.bmaporgy) |>> {P_LOCAL}.MAPBLOCKSHIFT
				yh := (tmbbox [{M_BBOX}.BOXTOP] - i_main.p_setup.bmaporgy) |>> {P_LOCAL}.MAPBLOCKSHIFT
				from
					bx := xl
				until
					returned or bx > xh
				loop
					from
						by := yl
					until
						returned or by > yh
					loop
						if not i_main.p_maputl.P_BlockLinesIterator (bx, by, agent PIT_CheckLine) then
							Result := False
							returned := True
						end
						by := by + 1
					end
					bx := bx + 1
				end
			end
			if not returned then
				Result := True
			end
		end

	PIT_CheckThing (thing: MOBJ_T): BOOLEAN
		local
			blockdist: FIXED_T
			solid: BOOLEAN
			damage: INTEGER
			returned: BOOLEAN
		do
			if thing.flags & (MF_SOLID | MF_SPECIAL | MF_SHOOTABLE) = 0 then
				Result := True
				returned := True
			end
			if not returned then
				check attached tmthing as tmt then
					blockdist := thing.radius + tmt.radius
				end
				if (thing.x - tmx).abs >= blockdist or (thing.y - tmy).abs >= blockdist then
						-- didn't hit it
					Result := True
					returned := True
				end
			end
			if not returned then
					-- don't clip against self
				if thing = tmthing then
					Result := True
					returned := True
				end
			end
			if not returned then
					-- check for skulls slamming into things
				check attached tmthing as tmt then
					if tmt.flags & MF_SKULLFLY /= 0 then
						check attached tmt.info as info then
							damage := ((i_main.m_random.p_random \\ 8) + 1) * info.damage
							{P_INTER}.P_DamageMobj (thing, tmthing, tmthing, damage)
							tmt.flags := tmt.flags & MF_SKULLFLY.bit_not
							tmt.momx := 0
							tmt.momy := 0
							tmt.momz := 0
							if i_main.p_mobj.P_SetMobjState (tmt, info.spawnstate) then
									-- do nothing
							end
							Result := False
							returned := True
						end
					end
				end
			end
			if not returned then
					-- missiles can hit other things
				check attached tmthing as tmt then
					if tmt.flags & MF_MISSILE /= 0 then
							-- see if it went over / under
						if tmt.z > thing.z + thing.height then
							Result := True -- overhead
							returned := True
						elseif tmt.z + tmt.height < thing.z then
							Result := True -- underneath
							returned := True
						end
						if not returned then
							if attached tmt.target as target and then (target.type = thing.type or (target.type = MT_KNIGHT and thing.type = MT_BRUISER) or (target.type = MT_BRUISER and thing.type = MT_KNIGHT)) then
									-- Don't hit same species as originator
								if thing = tmt.target then
									Result := True
									returned := True
								elseif thing.type /= MT_PLAYER then
										-- Explode, but do no damage.
										-- Let players missile other payers.
									Result := False
									returned := True
								end
							end
						end
						if not returned then
							if thing.flags & MF_SHOOTABLE = 0 then
									-- didn't do any damage
								Result := thing.flags & MF_SOLID = 0
								returned := True
							end
						end
						if not returned then
								-- damage / explode
							check attached tmt.info as info then
								damage := ((i_main.m_random.p_random \\ 8) + 1) * info.damage
								{P_INTER}.P_DamageMobj (thing, tmthing, tmt.target, damage)
							end
								-- don't traverse any more
							Result := False
							returned := True
						end
					end
				end
			end
			if not returned then
					-- check for special pickup
				if thing.flags & MF_SPECIAL /= 0 then
					solid := thing.flags & MF_SOLID /= 0
					if tmflags & MF_PICKUP /= 0 then
							-- can remove thing
						check attached tmthing as tmt then
							{P_INTER}.P_TouchSpecialThing (thing, tmt)
						end
					end
					Result := not solid
					returned := True
				end
			end
			if not returned then
				Result := thing.flags & MF_SOLID = 0
			end
		end

	PIT_CheckLine (ld: LINE_T): BOOLEAN
			-- Adjusts tmfloorz and tmceilingz as lines are contacted
		local
			returned: BOOLEAN
		do
			if tmbbox [{M_BBOX}.BOXRIGHT] <= ld.bbox [{M_BBOX}.BOXLEFT] or tmbbox [{M_BBOX}.BOXLEFT] >= ld.bbox [{M_BBOX}.BOXRIGHT] or tmbbox [{M_BBOX}.BOXTOP] <= ld.bbox [{M_BBOX}.BOXBOTTOM] or tmbbox [{M_BBOX}.BOXBOTTOM] >= ld.bbox [{M_BBOX}.BOXTOP] then
				Result := True
				returned := True
			end
			if not returned then
				if i_main.p_maputl.P_BoxOnLineSide (tmbbox, ld) /= -1 then
					Result := True
					returned := True
				end
			end
			if not returned then
					-- A line has been hit

					-- The moving thing's destination position will cross
					-- the given line.
					-- If this should not be allowed, return false.
					-- If the line is special, keep track of it
					-- to process later if the move is proven ok.
					-- NOTE: specials are NOT sorted by order,
					-- so two special lines that are only 8 pixels apart
					-- could be crossed in either order.

				if ld.backsector = Void then
					Result := False
					returned := True
				end
			end
			if not returned then
				check attached tmthing as tmt then
					if tmt.flags & MF_MISSILE = 0 then
						if ld.flags & {DOOMDATA_H}.ML_BLOCKING /= 0 then
							Result := False -- explicitly blocking everything
							returned := True
						elseif tmt.player = Void and ld.flags & {DOOMDATA_H}.ML_BLOCKMONSTERS /= 0 then
							Result := False -- block monsters only
							returned := True
						end
					end
				end
			end
			if not returned then
					-- set openrange, opentop, openbottom
				i_main.p_maputl.P_LineOpening (ld)

					-- adjust floor / ceiling heights
				if i_main.p_maputl.opentop < tmceilingz then
					tmceilingz := i_main.p_maputl.opentop
					ceilingline := ld
				end
				if i_main.p_maputl.openbottom > tmfloorz then
					tmfloorz := i_main.p_maputl.openbottom
				end
				if i_main.p_maputl.lowfloor < tmdropoffz then
					tmdropoffz := i_main.p_maputl.lowfloor
				end
				if ld.special /= 0 then
					spechit [numspechit] := ld
					numspechit := numspechit + 1
				end
				Result := True
			end
		end

	P_SlideMove (mo: MOBJ_T)
			-- The momx/momy move is bad, so try to slide
			-- along a wall.
			-- Find the first line hit, move flush to it,
			-- and slide along it
			--
			-- This is a kludgy mess.
		do
				-- Stub
		end

invariant
	spechit.lower = 0 and spechit.count = MAXSPECIALCROSS
	tmbbox.lower = 0 and tmbbox.count = 4

end
