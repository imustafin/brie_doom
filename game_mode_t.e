note
	description: "Enum from doomdef.h"

expanded class
	GAME_MODE_T

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

feature {GAME_MODE_T} -- Initialization

	make (a_value: like item)
		do
			item := a_value
		end

feature -- Enumeration

	shareware: GAME_MODE_T
		once
			Result.make (0)
		ensure
			instance_free: class
		end

	registered: GAME_MODE_T
		once
			Result.make (1)
		ensure
			instance_free: class
		end

	commerial: GAME_MODE_T
		once
			Result.make (2)
		ensure
			instance_free: class
		end

	retail: GAME_MODE_T
		once
			Result.make (3)
		ensure
			instance_free: class
		end

	indetermined: GAME_MODE_T
		once
			Result.make (4)
		ensure
			instance_free: class
		end

feature -- Access

	item: INTEGER

end
