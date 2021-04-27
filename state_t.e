note
	description: "state_t from info.h"

class
	STATE_T

create
	make

feature

	make (a_sprite: like sprite; a_frame: like frame; a_tics: like tics; a_action: like action; a_nextstate: like nextstate; a_misc1: like misc1; a_misc2: like misc2)
		do
			sprite := a_sprite
			frame := a_frame
			tics := a_tics
			action := a_action
			nextstate := a_nextstate
			misc1 := a_misc1
			misc2 := a_misc2
		end

feature

	sprite: INTEGER -- statenum_t

	frame: INTEGER_64

	tics: INTEGER_64 assign set_tics

	set_tics (a_tics: like tics)
		do
			tics := a_tics
		end

	action: ACTIONF_T

	nextstate: INTEGER -- statenum_t

	misc1: INTEGER_64

	misc2: INTEGER_64

feature

	is_player_run: BOOLEAN
		local
			indices: ARRAY [INTEGER]
		do
			indices := <<{STATENUM_T}.s_play_run1, {STATENUM_T}.s_play_run2, {STATENUM_T}.s_play_run3, {STATENUM_T}.s_play_run4>>
			Result := across indices as i some Current = {INFO}.states [i.item] end
		end

end
