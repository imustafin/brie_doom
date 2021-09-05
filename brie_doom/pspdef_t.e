note
	description: "pspdef_t from p_spr.h"

class
	PSPDEF_T

feature

	state: detachable STATE_T assign set_state

	set_state (a_state: like state)
		do
			state := a_state
		end

	tics: INTEGER assign set_tics

	set_tics (a_tics: like tics)
		do
			tics := a_tics
		end

	sx: FIXED_T assign set_sx

	set_sx (a_sx: like sx)
		do
			sx := a_sx
		end

	sy: FIXED_T assign set_sy

	set_sy (a_sy: like sy)
		do
			sy := a_sy
		end

end
