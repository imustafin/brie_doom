note
	description: "intercept_t from p_local.h"

class
	INTERCEPT_T

feature

	frac: FIXED_T assign set_frac
			-- along trace line

	set_frac (a_frac: like frac)
		do
			frac := a_frac
		end

	isaline: BOOLEAN assign set_isaline

	set_isaline (a_isaline: like isaline)
		do
			isaline := a_isaline
		end

feature -- union d

	thing: detachable MOBJ_T assign set_thing

	set_thing (a_thing: like thing)
		do
			thing := a_thing
		end

	line: detachable LINE_T assign set_line

	set_line (a_line: like line)
		do
			line := a_line
		end

end
