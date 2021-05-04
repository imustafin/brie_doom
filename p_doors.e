note
	description: "[
		p_doors.c
		
		Door animation code (opening/closing)
	]"

class
	P_DOORS

feature

	EV_VerticalDoor (line: LINE_T; thing: MOBJ_T)
			-- open a door manually, no tag value
		do
			{I_MAIN}.i_error ("EV_VerticalDoor not implemented")
		ensure
			instance_free: class
		end

	EV_DoDoor (line: LINE_T; type: INTEGER): BOOLEAN
		do
			{I_MAIN}.i_error ("EV_DoDoor not implemented")
		ensure
			instance_free: class
		end

	EV_DoLockedDoor (line: LINE_T; type: INTEGER; thing: MOBJ_T): BOOLEAN
			-- Move a locked door up/down
		do
			{I_MAIN}.i_error ("EV_DoLockedDoor not implemented")
		ensure
			instance_free: class
		end

end
