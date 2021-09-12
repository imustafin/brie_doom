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

	numspechit: INTEGER assign set_numspechit

	set_numspechit (a_numspechit: like numspechit)
		do
			numspechit := a_numspechit
		end

	spechit: ARRAY [detachable LINE_T]

	MAXSPECIALCROSS: INTEGER = 8

feature

	usething: detachable MOBJ_T

	P_UseLines (player: PLAYER_T)
			-- Looks for special lines in front of the player to activate
		require
			player.mo /= Void
		local
			angle: INTEGER
			x1: FIXED_T
			y1: FIXED_T
			x2: FIXED_T
			y2: FIXED_T
		do
			check attached player.mo as mo then
				usething := mo
				angle := mo.angle |>> {TABLES}.ANGLETOFINESHIFT
				x1 := mo.x
				y1 := mo.y
				x2 := x1 + ({P_LOCAL}.USERANGE |>> {M_FIXED}.FRACBITS) * i_main.r_main.finecosine [angle]
				y2 := y1 + ({P_LOCAL}.USERANGE |>> {M_FIXED}.FRACBITS) * i_main.r_main.finesine [angle]
				if i_main.p_maputl.P_PathTraverse (x1, y1, x2, y2, {P_LOCAL}.PT_ADDLINES, agent PTR_UseTraverse) then
						-- do nothing
				end
			end
		end

	PTR_UseTraverse (in: INTERCEPT_T): BOOLEAN
		require
			usething /= Void
		local
			side: INTEGER
		do
			check attached in.line as line and then attached usething as ut then
				if line.special = 0 then
					i_main.p_maputl.P_LineOpening (line)
					if i_main.p_maputl.openrange <= 0 then
						i_main.s_sound.s_startsound (usething, {SFXENUM_T}.sfx_noway)

							-- can't use through a wall
						Result := False
					else
						Result := True
					end
				else
					side := 0
					if i_main.p_maputl.P_PointOnLineSide (ut.x, ut.y, line) = 1 then
						side := 1
					end
					if i_main.p_switch.P_UseSpecialLine (ut, line, side) then
							-- do nothing
					end

						-- can't use for than one special line in a row
					Result := False
				end
			end
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
							i_main.p_inter.P_DamageMobj (thing, tmthing, tmthing, damage)
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
								i_main.p_inter.P_DamageMobj (thing, tmthing, tmt.target, damage)
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
							i_main.p_inter.P_TouchSpecialThing (thing, tmt)
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

feature -- SECTOR HEIGHT CHANGING

		-- After modifying a sectors floor or ceiling height,
		-- call this routine to adjust the positions
		-- of all things that touch the sector.
		--
		-- If anything doesn't fit anymore, true will be returned.
		-- If crunch is true, they will take damage
		-- as they are being crushed.
		-- If Crunch is false, you should set the sector height back
		-- the way it was and call P_ChangeSector again to undo the changes.

	crushchange: BOOLEAN

	nofit: BOOLEAN

	P_ThingHeightClip (thing: MOBJ_T): BOOLEAN
		local
			onfloor: BOOLEAN
		do
			onfloor := (thing.z = thing.floorz)
			P_CheckPosition (thing, thing.x, thing.y).do_nothing
				-- what about stranding a monster partially off an edge?

			thing.floorz := tmfloorz
			thing.ceilingz := tmceilingz
			if onfloor then
					-- walking monsters rise and fall with the floor
				thing.z := thing.floorz
			else
					-- don't adjust a floating monster unless forced to
				if thing.z + thing.height > thing.ceilingz then
					thing.z := thing.ceilingz - thing.height
				end
			end
			if thing.ceilingz - thing.floorz < thing.height then
				Result := False
			else
				Result := True
			end
		end

	PIT_ChangeSector (thing: MOBJ_T): BOOLEAN
		local
			mo: MOBJ_T
		do
			if P_ThingHeightClip (thing) then
					-- keep checking
				Result := True
			else
					-- crunch bodies to giblets
				if thing.health <= 0 then
					i_main.p_mobj.P_SetMobjState (thing, {STATENUM_T}.S_GIBS).do_nothing
					thing.flags := thing.flags & MF_SOLID.bit_not
					thing.height := 0
					thing.radius := 0

						-- keep checking
					Result := True
				else
						-- crunch dropped items
					if thing.flags & MF_DROPPED /= 0 then
						i_main.p_mobj.P_RemoveMobj (thing)
							-- keep checking
						Result := True
					else
						if thing.flags & MF_SHOOTABLE = 0 then
								-- assume it is bloody gibs or something
							Result := True
						else
							nofit := True
							if crushchange and i_main.p_tick.leveltime & 3 = 0 then
								i_main.p_inter.P_DamageMobj (thing, Void, Void, 10)
									-- spray blood in a random direction
								mo := i_main.p_mobj.P_SpawnMobj (thing.x, thing.y, thing.z + thing.height // 2, MT_BLOOD)
								mo.momx := (i_main.m_random.P_Random - i_main.m_random.P_Random) |<< 12
								mo.momy := (i_main.m_random.P_Random - i_main.m_random.P_Random) |<< 12
							end
								-- keep checking (crush other things)
							Result := True
						end
					end
				end
			end
		end

	P_ChangeSector (sector: SECTOR_T; crunch: BOOLEAN): BOOLEAN
		local
			x: INTEGER
			y: INTEGER
		do
			nofit := False
			crushchange := crunch

				-- re-check heights for all things near the moving sector
			from
				x := sector.blockbox [{M_BBOX}.BOXLEFT]
			until
				x > sector.blockbox [{M_BBOX}.BOXRIGHT]
			loop
				from
					y := sector.blockbox [{M_BBOX}.BOXBOTTOM]
				until
					y > sector.blockbox [{M_BBOX}.BOXTOP]
				loop
					i_main.p_maputl.P_BlockThingsIterator (x, y, agent PIT_ChangeSector).do_nothing
					y := y + 1
				end
				x := x + 1
			end
			Result := nofit
		end

feature

	linetarget: detachable MOBJ_T
			-- who got hit (or NULL)

	shootthing: detachable MOBJ_T

	shootz: FIXED_T
			-- Height if not aiming up or down
			-- ???: use slope for monsters?

	la_damage: INTEGER

	attackrange: FIXED_T

	aimslope: FIXED_T

	P_AimLineAttack (t1: MOBJ_T; a_angle: ANGLE_T; distance: FIXED_T): FIXED_T
		local
			x2, y2: FIXED_T
			angle: ANGLE_T
		do
			angle := a_angle |>> {R_MAIN}.ANGLETOFINESHIFT
			shootthing := t1
			x2 := t1.x + (distance |>> {M_FIXED}.FRACBITS) * i_main.r_main.finecosine [angle]
			y2 := t1.y + (distance |>> {M_FIXED}.FRACBITS) * i_main.r_main.finesine [angle]
			shootz := t1.z + (t1.height |>> 1) + 8 * {M_FIXED}.fracunit

				-- can't shoot outside view angles
			i_main.p_sight.topslope := 100 * {M_FIXED}.FRACUNIT // 160
			i_main.p_sight.bottomslope := -100 * {M_FIXED}.FRACUNIT // 160
			attackrange := distance
			linetarget := Void
			i_main.p_maputl.P_PathTraverse (t1.x, t1.y, x2, y2, {P_LOCAL}.PT_ADDLINES | {P_LOCAL}.PT_ADDTHINGS, agent PTR_AimTraverse).do_nothing
			if linetarget /= Void then
				Result := aimslope
			else
				Result := 0
			end
		end

feature -- PTR_AimTraverse

	PTR_AimTraverse (in: INTERCEPT_T): BOOLEAN
			-- Sets linetarget and aimslope when a target is aimed at.
		local
			slope: FIXED_T
			dist: FIXED_T
			thingtopslope: FIXED_T
			thingbottomslope: FIXED_T
		do
			if in.isaline then
				check attached in.line as li then
					if li.flags & {DOOMDATA_H}.ML_TWOSIDED = 0 then
						Result := False -- stop
					else
							-- Crosses a two sided line.
							-- A two sided line will restrict
							-- the possible target ranges.
						i_main.p_maputl.P_LineOpening (li)
						if i_main.p_maputl.openbottom >= i_main.p_maputl.opentop then
							Result := False -- stop
						else
							dist := {M_FIXED}.fixedmul (attackrange, in.frac)
							check attached li.frontsector as front and then attached li.backsector as back then
								if front.floorheight /= back.floorheight then
									slope := {M_FIXED}.fixeddiv (i_main.p_maputl.openbottom - shootz, dist)
									if slope > i_main.p_sight.bottomslope then
										i_main.p_sight.bottomslope := slope
									end
								end
								if front.ceilingheight /= back.ceilingheight then
									slope := {M_FIXED}.fixeddiv (i_main.p_maputl.opentop - shootz, dist)
									if slope < i_main.p_sight.topslope then
										i_main.p_sight.topslope := slope
									end
								end
							end
							if i_main.p_sight.topslope <= i_main.p_sight.bottomslope then
								Result := False -- stop
							else
								Result := True -- shot continues
							end
						end
					end
				end
			else
				check attached in.thing as th then
					if th = shootthing then
						Result := True -- can't shoot self
					else
						if th.flags & MF_SHOOTABLE = 0 then
							Result := True -- corpse or something
						else
								-- check angles to see if the thing can be aimed at
							dist := {M_FIXED}.fixedmul (attackrange, in.frac)
							thingtopslope := {M_FIXED}.fixeddiv (th.z + th.height - shootz, dist)
							if thingtopslope < i_main.p_sight.bottomslope then
								Result := True -- shot over the thing
							else
								thingbottomslope := {M_FIXED}.fixeddiv (th.z - shootz, dist)
								if thingbottomslope > i_main.p_sight.topslope then
									Result := True -- shot under the thing
								else
										-- this thing can be hit!
									if thingtopslope > i_main.p_sight.topslope then
										thingtopslope := i_main.p_sight.topslope
									end
									if thingbottomslope < i_main.p_sight.bottomslope then
										thingbottomslope := i_main.p_sight.bottomslope
									end
									aimslope := (thingtopslope + thingbottomslope) // 2
									linetarget := th
									Result := False -- don't go any further
								end
							end
						end
					end
				end
			end
		end

	P_LineAttack (t1: MOBJ_T; a_angle: ANGLE_T; distance: FIXED_T; slope: FIXED_T; damage: INTEGER)
			-- If damage == 0, it is just a test trace
			-- that will leave linetarget set.
		local
			x2, y2: FIXED_T
			angle: ANGLE_T
		do
			angle := a_angle |>> {R_MAIN}.ANGLETOFINESHIFT
			shootthing := t1
			la_damage := damage
			x2 := t1.x + (distance |>> {M_FIXED}.FRACBITS) * i_main.r_main.finecosine [angle]
			y2 := t1.y + (distance |>> {M_FIXED}.FRACBITS) * i_main.r_main.finesine [angle]
			shootz := t1.z + (t1.height |>> 1) + 8 * {M_FIXED}.FRACUNIT
			attackrange := distance
			aimslope := slope
			i_main.p_maputl.P_PathTraverse (t1.x, t1.y, x2, y2, {P_LOCAL}.PT_ADDLINES | {P_LOCAL}.PT_ADDTHINGS, agent PTR_ShootTraverse).do_nothing
		end

feature -- PTR_ShootTraverse

	PTR_ShootTraverse_line_hitline (li: LINE_T; in: INTERCEPT_T): BOOLEAN
		local
			frac: FIXED_T
			x, y, z: FIXED_T
			hit_sky: BOOLEAN
		do
				-- hit line
				-- position a bit closer
			frac := in.frac - {M_FIXED}.fixeddiv (4 * {M_FIXED}.fracunit, attackrange)
			x := i_main.p_maputl.trace.x + {M_FIXED}.fixedmul (i_main.p_maputl.trace.dx, frac)
			y := i_main.p_maputl.trace.y + {M_FIXED}.fixedmul (i_main.p_maputl.trace.dy, frac)
			z := shootz + {M_FIXED}.fixedmul (aimslope, {M_FIXED}.fixedmul (frac, attackrange))
				-- Check if sky is hit
			check attached li.frontsector as front then
				if front.ceilingpic = i_main.r_sky.skyflatnum then
						-- don't shoot the sky!
					if z > front.ceilingheight then
						hit_sky := True
					end
						-- it's a sky hack wall
					if not hit_sky and then attached li.backsector as back and then back.ceilingpic = i_main.r_sky.skyflatnum then
						hit_sky := True
					end
				end
			end
			if not hit_sky then
					-- Spawn bullet puffs.
				i_main.p_mobj.P_SpawnPuff (x, y, z)
			end
			Result := False -- don't go any farther (in all cases so)
		end

	PTR_ShootTraverse (in: INTERCEPT_T): BOOLEAN
		local
			goto_hitline: BOOLEAN
			dist: FIXED_T
			slope: FIXED_T
			x, y, z, frac: FIXED_T
			thingtopslope, thingbottomslope: FIXED_T
		do
			if in.isaline then
				check attached in.line as li then
					if li.special /= 0 then
						check attached shootthing as st then
							i_main.p_spec.P_ShootSpecialLine (st, li)
						end
					end
					if li.flags & {DOOMDATA_H}.ML_TWOSIDED = 0 then
						goto_hitline := True
					else
							-- crosses a two sided line
						i_main.p_maputl.P_LineOpening (li)
						dist := {M_FIXED}.fixedmul (attackrange, in.frac)
						check attached li.frontsector as front and then attached li.backsector as back then
							if front.floorheight /= back.floorheight then
								slope := {M_FIXED}.fixeddiv (i_main.p_maputl.openbottom - shootz, dist)
								if slope > aimslope then
									goto_hitline := True
								end
							end
							if front.ceilingheight /= back.ceilingheight then
								slope := {M_FIXED}.fixeddiv (i_main.p_maputl.opentop - shootz, dist)
								if slope < aimslope then
									goto_hitline := True
								end
							end
						end
					end
					if goto_hitline then
						Result := PTR_ShootTraverse_line_hitline (li, in)
					else
						Result := True -- shot continue
					end
				end
			else
				check attached in.thing as th then
					if th = shootthing then
						Result := True -- can't shoot self
					else
						if th.flags & MF_SHOOTABLE = 0 then
							Result := True -- corpse or something
						else
								-- check angles to see if the thing can be aimed at
							dist := {M_FIXED}.fixedmul (attackrange, in.frac)
							thingtopslope := {M_FIXED}.fixeddiv (th.z + th.height - shootz, dist)
							if thingtopslope < aimslope then
								Result := True -- shot over the thing
							else
								thingbottomslope := {M_FIXED}.fixeddiv (th.z - shootz, dist)
								if thingbottomslope > aimslope then
									Result := True -- shot under the thing
								else
										-- hit thing
										-- position a bit closer
									frac := in.frac - {M_FIXED}.fixeddiv (10 * {M_FIXED}.FRACUNIT, attackrange)
									x := i_main.p_maputl.trace.x + {M_FIXED}.fixedmul (i_main.p_maputl.trace.dx, frac)
									y := i_main.p_maputl.trace.y + {M_FIXED}.fixedmul (i_main.p_maputl.trace.dy, frac)
									z := shootz + {M_FIXED}.fixedmul (aimslope, {M_FIXED}.fixedmul (frac, attackrange))

										-- Spawn bullet puffs or blod spots,
										-- depending on target type.
									if th.flags & MF_NOBLOOD /= 0 then
										i_main.p_mobj.P_SpawnPuff (x, y, z)
									else
										i_main.p_mobj.P_SpawnBlood (x, y, z, la_damage)
									end
									if la_damage /= 0 then
										i_main.p_inter.P_DamageMobj (th, shootthing, shootthing, la_damage)
									end
										-- don't go any farther
									Result := False
								end
							end
						end
					end
				end
			end
		end

invariant
	spechit.lower = 0 and spechit.count = MAXSPECIALCROSS
	tmbbox.lower = 0 and tmbbox.count = 4

end
