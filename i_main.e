note
	description: "[
		i_main.c
		Main program, simply calls D_DoomMain high level loop
	]"

class
	I_MAIN

inherit

	ARGUMENTS_32

create
	make

feature -- Globals

	myargc: INTEGER

	myargv: ARRAY [IMMUTABLE_STRING_32]

	doomstat_h: DOOMSTAT_H

	v_video: V_VIDEO

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			d_doom_main: D_DOOM_MAIN
		do
				--| Add your code here
			print ("Hello Eiffel World!%N")
			myargv := argument_array
			myargc := argument_count + 1
			create doomstat_h.make
			create v_video.make
			create d_doom_main.make (Current)
		end

end
