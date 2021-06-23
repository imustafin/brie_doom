note
	description: "[
		p_sight.c
		
		LineOfSight/Visibility checks, uses REJECT Lookup Table.
	]"

class
	P_SIGHT

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

end
