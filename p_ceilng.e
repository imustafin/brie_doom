note
	description: "[
		p_ceilng.c
		
		Ceiling aninmation (lowering, crushing, raising)
	]"

class
	P_CEILNG

feature

	EV_DoCeiling (line: LINE_T; type: INTEGER): BOOLEAN
			-- Move a ceiling up/down and all around!
		do
			{I_MAIN}.i_error ("EV_DoCeiling not implemented")
		ensure
			instance_free: class
		end

end
