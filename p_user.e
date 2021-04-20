note
	description: "[
		p_user.c
		
		Player related stuff.
		Bobbing POV/weapon, movement.
		Pending weapon.
	]"

class
	P_USER

feature

	P_PlayerThink (player: PLAYER_T)
		do
			{I_MAIN}.i_error ("P_PlayerThink not implemented")
		ensure
			instance_free: class
		end

end
