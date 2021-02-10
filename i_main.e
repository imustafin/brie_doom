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

	m_misc: M_MISC

	z_zone: Z_ZONE

	w_wad: W_WAD

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			d_doom_main: D_DOOM_MAIN
		do
				--| Add your code here
			myargv := argument_array
			myargc := argument_count + 1
			create doomstat_h.make
			create v_video.make
			create m_misc.make
			create z_zone.make
			create w_wad.make (Current)
			create d_doom_main.make (Current)
		end

feature -- i_system.c

	i_error (a_message: STRING)
		do
			print ("Error: " + a_message + "%N")
			(create {DEVELOPER_EXCEPTION}).raise
		end

end
