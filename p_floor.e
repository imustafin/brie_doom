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

end
