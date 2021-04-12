note
	description: "[
		d_englsh.h
		Printed strings for translation.
		English language support (default).
	]"

class
	D_ENGLSH

feature

	PRESSKEY: STRING = "press a key."

	PRESSYN: STRING = "press y or n."

	NEWGAME: STRING
		once
			Result := "you can't start a new game%Nwhile in a network game.%N%N" + PRESSKEY
		ensure
			instance_free: class
		end

	SWSTRING: STRING
		once
			Result := "this is the shareware version of doom.%N%Nyou need to order the entire trilogy.%N%N" + PRESSKEY
		ensure
			instance_free: class
		end

	NIGHTMARE: STRING
		once
			Result := "are you sure? this skill level%Nisn't even remotely fair.%N%N" + PRESSYN
		ensure
			instance_free: class
		end

end
