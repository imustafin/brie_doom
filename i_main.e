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

	p_setup: P_SETUP

	p_switch: P_SWITCH

	p_spec: P_SPEC

	r_things: R_THINGS

	info: INFO

	i_system: I_SYSTEM

	i_sound: I_SOUND

	d_net: D_NET

	s_sound: S_SOUND

	hu_stuff: HU_STUFF

	st_stuff: ST_STUFF

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
			create p_setup.make (Current)
			create p_switch.make
			create p_spec.make
			create r_things.make
			create info.make
			create i_system.make (Current)
			create i_sound.make
			create d_net.make
			create s_sound.make
			create hu_stuff.make
			create st_stuff.make
			create d_doom_main.make (Current)
		end

feature -- i_system.c

	i_error (a_message: STRING)
		do
			print ("Error: " + a_message + "%N")
			(create {DEVELOPER_EXCEPTION}).raise
		end

end
