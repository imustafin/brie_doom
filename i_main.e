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

	m_menu: M_MENU

	r_main: R_MAIN

	r_data: R_DATA

	r_plane: R_PLANE

	m_fixed: M_FIXED

	r_sky: R_SKY

	r_draw: R_DRAW

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			d_doom_main: D_DOOM_MAIN
		do
				--| Add your code here
			myargv := argument_array
			myargc := argument_count + 1
			create m_fixed.make
			create doomstat_h.make
			create v_video.make
			create m_misc.make
			create z_zone.make
			create m_menu.make (Current)
			create w_wad.make (Current)
			create r_sky.make (Current)
			create r_draw.make
			create r_data.make
			create r_plane.make
			create r_main.make (Current)
			create d_doom_main.make (Current)
		end

feature -- i_system.c

	i_error (a_message: STRING)
		do
			print ("Error: " + a_message + "%N")
			(create {DEVELOPER_EXCEPTION}).raise
		end

end
