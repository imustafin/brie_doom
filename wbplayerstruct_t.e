note
	description: "wbplayerstruct_t from d_player.h"

class
	WBPLAYERSTRUCT_T

feature

	in: BOOLEAN -- whether the player is in game

	skills: INTEGER

	sitems: INTEGER

	ssecret: INTEGER

	stime: INTEGER

	frags: ARRAY [INTEGER]
		once
			create Result.make_filled (0, 0, 3)
		ensure
			Result.lower = 0
			Result.count = 4
		end

	score: INTEGER

end
