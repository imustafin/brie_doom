note
	description: "[
		doomdata_t from d_net.h
		
		Network packet data.
	]"

class
	DOOMDATA_T

create
	make

feature

	make
		do
		end

feature

	player: NATURAL_8 assign set_player

	set_player (a_player: like player)
		do
			player := a_player
		end

end
