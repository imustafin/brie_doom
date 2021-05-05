note
	description: "[
		p_floor.c
		
		Floor animation: raising stairs.
	]"

class
	P_FLOOR

feature

	EV_BuildStairs (line: LINE_T; type: INTEGER): BOOLEAN
			-- BUILD A STAIRCASE!
		do
			{I_MAIN}.i_error ("EV_BuildStairs not implemented")
		ensure
			instance_free: class
		end

	EV_DoFloor (line: LINE_T; type: INTEGER): BOOLEAN
			-- HANDLE FLOOR TYPES
		do
			{I_MAIN}.i_error ("EV_DoFloor not implemented")
		ensure
			instance_free: class
		end

	T_MovePlane(sector: SECTOR_T; speed, dest: FIXED_T; crush: BOOLEAN; floorOrCeiling, direction: INTEGER): RESULT_E
		do
			{I_MAIN}.i_error ("T_MovePlane is not implemented")
		ensure
			instance_free: class
		end

end
