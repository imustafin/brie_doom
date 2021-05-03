note
	description: "[
		p_switch.c
		Switches, buttons. Two-state animation. Exits.
	]"

class
	P_SWITCH

create
	make

feature

	make
		do
		end

feature

	P_InitSwitchList
		do
				-- Stub
		end

	P_UseSpecialLine (thing: MOBJ_T; line: LINE_T; side: INTEGER): BOOLEAN
			-- Called when a thing uses a special line.
			-- Only the front sides of lines are usable.
		do
				-- Stub
		end

end
