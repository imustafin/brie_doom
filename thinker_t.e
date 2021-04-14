note
	description: "thinker_t from d_think.h"

class
	THINKER_T

create
	make

feature

	make
		do
			prev := Current
			next := Current
			create function.make_one (Void)
		end

feature

	prev: THINKER_T assign set_prev

	set_prev (a_prev: like prev)
		do
			prev := a_prev
		end

	next: THINKER_T assign set_next

	set_next (a_next: like next)
		do
			next := a_next
		end

	function: ACTIONF_T

end
