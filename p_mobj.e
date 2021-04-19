note
	description: "[
		p_mobj.c
		Moving object handling. Spawn functions.
	]"

class
	P_MOBJ

feature -- P_RemoveMobj

	iquehead: INTEGER assign set_iquehead

	set_iquehead (a_iquehead: like iquehead)
		do
			iquehead := a_iquehead
		end

	iquetail: INTEGER assign set_iquetail

	set_iquetail (a_iquetail: like iquetail)
		do
			iquetail := a_iquetail
		end

	P_SpawnPlayer (mthing: MAPTHING_T)
			-- Called when a player is spawned on the level.
			-- Most of the player structure stays unchanged
			-- between levels.
		do
			{I_MAIN}.i_error ("P_SpawnPlayer not implemented")
		end

	P_SpawnMapThing (mthing: MAPTHING_T)
		do
			{I_MAIN}.i_error ("P_SpawnMapThing not implemented")
		end

end
