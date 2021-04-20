note
	description: "[
		p_map.c
		
		Movement, collision handling.
		Shooting and aiming
	]"

class
	P_MAP

feature

	P_UseLines (player: PLAYER_T)
			-- Looks for special lines in front of the player to activate
		do
			{I_MAIN}.i_error ("P_UseLines is not implemented")
		ensure
			instance_free: class
		end

end
