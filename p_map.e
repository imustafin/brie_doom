note
	description: "[
		p_map.c
		
		Movement, collision handling.
		Shooting and aiming
	]"

class
	P_MAP

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create spechit.make_filled (Void, 0, MAXSPECIALCROSS - 1)
		end

feature

	ceilingline: detachable LINE_T
			-- keep track of the line that lowers the ceiling,
			-- so missiles don't explode against sky hack walls

	floatok: BOOLEAN
			-- If true, move would be ok
			-- if within `tmfloorz - tmceilingz`

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
				print ("MOVE IS OK!!!%N")
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
			newsubsec: SUBSECTOR_T
		do
				-- Stub
			print ("P_CheckPosition not fully implemented%N")
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
			Result := True
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

end
