note
	description: "[
		p_spec.c
		Implements special effects:
		Texture animation, height or lighting changes
		 according to adjacent sectors, respective
		 utility functions, etc.
		Line Tag handling. Line and Sector triggers.
	]"

class
	P_SPEC

create
	make

feature

	make
		do
		end

feature

	P_InitPicAnims
		do
				-- Stub
		end

	P_SpawnSpecials
		do
				-- Stub
		end

	P_UpdateSpecials
			-- Animate planes, scroll walls, etc.
		do
				-- Stub
		end

	P_PlayerInSpecialSector (player: PLAYER_T)
			-- Called every tic frame
			-- that the player origin is in a special sector
		do
			{I_MAIN}.i_error ("P_PlayerInSpecialSector is not implemented")
		end

end
