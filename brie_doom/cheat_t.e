note
	description: "[
		cheat_t from d_player.h
		
		Player internal flags, for cheats and debug
	]"

class
	CHEAT_T

feature

	CF_NOCLIP: INTEGER = 1
			-- No clipping, walk through barriers.

	CF_GODMODE: INTEGER = 2
			-- No damage, no health loss

	CF_NOMOMENTUM: INTEGER = 4
			-- Not really a cheat, just a debug aid

end
