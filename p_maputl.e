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

feature

	P_SetThingPosition(thing: MOBJ_T)
		-- Links a thing into both a block and a subsector
		-- based on it's x y.
		-- Sets thing->subsector properly
		do
			{I_MAIN}.i_error("P_SetThingPosition is not implemented")
		ensure
			instance_free: class
		end

end
