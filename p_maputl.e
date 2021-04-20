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

end
