note
	description: "[
		p_plats.c
		
		Plats (i.e. elevator platforms) code, raising/lowering
	]"

class
	P_PLATS

feature

	EV_DoPlat (line: LINE_T; type: INTEGER; amount: INTEGER): BOOLEAN
			-- Do Platforms
			-- `amount` is only used for SOME platforms.
		do
			{I_MAIN}.i_error ("EV_DoPlat not implemented")
		ensure
			instance_free: class
		end

end
