note
	description: "result_e from p_spec.h"

expanded class
	RESULT_E

inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Creation

	default_create
		do
			make (0)
		end

feature {RESULT_E} -- Initialization

	make (a_value: like item)
		do
			item := a_value
		end

feature -- Enumeration

	ok: RESULT_E
		once
			Result.make (0)
		ensure
			instance_free: class
		end

	crushed: RESULT_E
		once
			Result.make (1)
		ensure
			instance_free: class
		end

	pastdest: RESULT_E
		once
			Result.make (2)
		ensure
			instance_free: class
		end

feature -- Access

	item: INTEGER

end
