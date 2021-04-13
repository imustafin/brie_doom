note
	description: "d_player.h"

class
	PLAYER_T

create
	make

feature

	make
		do
			create mo.make
		end

feature -- playerstate_t

	PST_LIVE: INTEGER = 0 -- Playing or camping.

	PST_DEAD: INTEGER = 1 -- Dead on the ground, view follows killer.

	PST_REBORN: INTEGER = 2 -- Ready to restart/respawn???

feature

	mo: MOBJ_T

	playerstate: INTEGER assign set_playerstate

	set_playerstate (a_playerstate: like playerstate)
		do
			playerstate := a_playerstate
		end

	extralight: INTEGER assign set_extralight -- So gun flashes light up areas

	set_extralight (a_extralight: like extralight)
		do
			extralight := a_extralight
		end

end
