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

	g_game: G_GAME

	i_video: I_VIDEO

	i_net: detachable I_NET

	d_doom_main: detachable D_DOOM_MAIN

	f_finale: F_FINALE

	f_wipe: detachable F_WIPE

	hu_lib: HU_LIB

	am_map: AM_MAP

	wi_stuff: WI_STUFF

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			myargv := argument_array
			myargc := argument_count + 1
			create doomstat_h.make
			create hu_lib.make
			create am_map.make
			create wi_stuff.make
			create r_plane.make
			create p_switch.make
			create p_spec.make
			create r_things.make
			create info.make
			create z_zone.make
			create r_draw.make
			create st_stuff.make
			create r_sky.make
			create f_finale.make
			create i_net.make (Current)
			create d_net.make (Current)
			create m_misc.make (Current)
			create r_data.make (Current)
			create i_sound.make (Current)
			create s_sound.make (Current)
			create hu_stuff.make (Current)
			create g_game.make (Current)
			create i_video.make (Current)
			create m_menu.make (Current)
			create w_wad.make (Current)
			create p_setup.make (Current)
			create i_system.make (Current)
			create r_main.make (Current)
			create d_doom_main.make (Current)
			create f_wipe.make (Current)
			create v_video.make (Current)
			check attached d_doom_main as d then
				d.D_DoomMain
			end
		end

feature -- i_system.c

	i_error (a_message: STRING)
		do
			print ("Error: " + a_message + "%N")
			(create {DEVELOPER_EXCEPTION}).raise
		ensure
			instance_free: class
		end

end
