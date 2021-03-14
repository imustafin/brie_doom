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

	inner_v_video: detachable V_VIDEO

	v_video: V_VIDEO
		do
			check attached inner_v_video as x then
				Result := x
			end
		end

	inner_m_misc: detachable M_MISC

	m_misc: M_MISC
		do
			check attached inner_m_misc as x then
				Result := x
			end
		end

	z_zone: Z_ZONE

	inner_w_wad: detachable W_WAD

	w_wad: W_WAD
		do
			check attached inner_w_wad as x then
				Result := x
			end
		end

	inner_m_menu: detachable M_MENU

	m_menu: M_MENU
		do
			check attached inner_m_menu as x then
				Result := x
			end
		end

	inner_r_main: detachable R_MAIN

	r_main: R_MAIN
		do
			check attached inner_r_main as x then
				Result := x
			end
		end

	inner_r_data: detachable R_DATA

	r_data: R_DATA
		do
			check attached inner_r_data as x then
				Result := x
			end
		end

	r_plane: R_PLANE

	r_sky: R_SKY

	r_draw: R_DRAW

	inner_p_setup: detachable P_SETUP

	p_setup: P_SETUP
		do
			check attached inner_p_setup as x then
				Result := x
			end
		end

	p_switch: P_SWITCH

	p_spec: P_SPEC

	r_things: R_THINGS

	info: INFO

	inner_i_system: detachable I_SYSTEM

	i_system: I_SYSTEM
		do
			check attached inner_i_system as x then
				Result := x
			end
		end

	inner_i_sound: detachable I_SOUND

	i_sound: I_SOUND
		do
			check attached inner_i_sound as x then
				Result := x
			end
		end

	inner_d_net: detachable D_NET

	d_net: D_NET
		do
			check attached inner_d_net as x then
				Result := x
			end
		end

	inner_s_sound: detachable S_SOUND

	s_sound: S_SOUND
		do
			check attached inner_s_sound as x then
				Result := x
			end
		end

	inner_hu_stuff: detachable HU_STUFF

	hu_stuff: HU_STUFF
		do
			check attached inner_hu_stuff as x then
				Result := x
			end
		end

	st_stuff: ST_STUFF

	inner_g_game: detachable G_GAME

	g_game: G_GAME
		do
			check attached inner_g_game as g then
				Result := g
			end
		end

	inner_i_video: detachable I_VIDEO

	i_video: I_VIDEO
		do
			check attached inner_i_video as x then
				Result := x
			end
		end

	i_net: detachable I_NET

	d_doom_main: detachable D_DOOM_MAIN

	f_finale: F_FINALE

	f_wipe: detachable F_WIPE

	hu_lib: HU_LIB

	am_map: AM_MAP

	wi_stuff: WI_STUFF

	m_random: M_RANDOM

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
			create m_random.make
			create inner_r_data.make (Current)
			create inner_i_sound.make (Current)
			create inner_s_sound.make (Current)
			create inner_hu_stuff.make (Current)
			create inner_g_game.make (Current)
			create inner_i_video.make (Current)
			create inner_m_menu.make (Current)
			create inner_w_wad.make (Current)
			create inner_p_setup.make (Current)
			create inner_i_system.make (Current)
			create inner_r_main.make (Current)
			create d_doom_main.make (Current)
			create f_wipe.make (Current)
			create inner_v_video.make (Current)
			create i_net.make (Current)
			create inner_d_net.make (Current)
			create inner_m_misc.make (Current)
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
