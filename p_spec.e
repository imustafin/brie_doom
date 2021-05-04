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

	P_CrossSpecialLine (linenum, side: INTEGER; thing: MOBJ_T)
			-- Called every time a thing origin is about
			-- to cross a line with a non 0 special
		do
				-- Stub
		end

feature -- Special Stuff that can not be categorized

	EV_DoDonut (line: LINE_T): BOOLEAN
		do
			{I_MAIN}.i_error ("EV_DoDonut not implemented")
		ensure
			instance_free: class
		end

end
