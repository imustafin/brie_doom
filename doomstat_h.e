note
	description: "[
		doomstat.h
		All the global variables that store the internal state.
		 Theoretically speaking, the internal state of the engie
		 should be found by looking at the variables collected
		 here, and every relevant module will have to include
		 this header file.
		In practice, things are a bit messy.
	]"

class
	DOOMSTAT_H

create
	make

feature

	gamemode: GAME_MODE_T assign set_gamemode

	precache: BOOLEAN

feature

	make
		do
			gamemode := {GAME_MODE_T}.shareware
		end

feature -- Setters

	set_gamemode (a_new: like gamemode)
		do
			gamemode := a_new
		end

end
