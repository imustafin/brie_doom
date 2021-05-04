note
	description: "[
		p_lights.c
		
		Handle Sector base lighting effects.
		Muzzle flash?
	]"

class
	P_LIGHTS

feature

	EV_LightTurnOn (line: LINE_T; bright: INTEGER)
		do
			{I_MAIN}.i_error ("EV_LightTurnOn not implemented")
		ensure
			instance_free: class
		end

end
