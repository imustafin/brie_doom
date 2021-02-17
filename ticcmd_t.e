note
	description: "[
		d_ticcmd.h
		System specific interface stuff.
		
		The data sampled per tick (single player)
		and transmitted to other players (multiplayer).
		Mainly movements/button commands per game tick,
		plus a checksum for internal state consistency.
	]"

class
	TICCMD_T

create
	make

feature

	make
		do
		end

feature

	forwardmove: CHARACTER -- *2048 for move

	sidemove: CHARACTER -- *2048 for move

	angleturn: INTEGER -- <<16 for angle data

	consistency: INTEGER -- checks for net game

	chatchar: INTEGER

	buttons: INTEGER

end
