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
	main

feature -- Globals

	doomstat_h: DOOMSTAT_H
		once
			create Result.make
		end

	v_video: V_VIDEO
		once
			create Result.make (Current)
		end

	m_misc: M_MISC
		once
			create Result.make (Current)
		end

	z_zone: Z_ZONE
		once
			create Result.make
		end

	w_wad: W_WAD
		once
			create Result.make (Current)
		end

	m_menu: M_MENU
		once
			create Result.make (Current)
		end

	r_main: R_MAIN
		once
			create Result.make (Current)
		end

	r_data: R_DATA
		once
			create Result.make (Current)
		end

	r_plane: R_PLANE
		once
			create Result.make (Current)
		end

	r_sky: R_SKY
		once
			create Result.make
		end

	r_draw: R_DRAW
		once
			create Result.make (Current)
		end

	p_setup: P_SETUP
		once
			create Result.make (Current)
		end

	p_switch: P_SWITCH
		once
			create Result.make (Current)
		end

	p_spec: P_SPEC
		once
			create Result.make
		end

	r_things: R_THINGS
		once
			create Result.make (Current)
		end

	info: INFO
		once
			create Result.make
		end

	i_system: I_SYSTEM
		once
			create Result.make (Current)
		end

	i_sound: I_SOUND
		once
			create Result.make (Current)
		end

	d_net: D_NET
		once
			create Result.make (Current)
		end

	s_sound: S_SOUND
		once
			create Result.make (Current)
		end

	hu_stuff: HU_STUFF
		once
			create Result.make (Current)
		end

	st_stuff: ST_STUFF
		once
			create Result.make (Current)
		end

	g_game: G_GAME
		once
			create Result.make (Current)
		end

	i_video: I_VIDEO
		once
			create Result.make (Current)
		end

	i_net: I_NET
		once
			create Result.make (Current)
		end

	d_main: D_MAIN
		once
			create Result.make (Current)
		end

	f_finale: F_FINALE
		once
			create Result.make
		end

	f_wipe: F_WIPE
		once
			create Result.make (Current)
		end

	hu_lib: HU_LIB
		once
			create Result.make
		end

	am_map: AM_MAP
		once
			create Result.make
		end

	wi_stuff: WI_STUFF
		once
			create Result.make (Current)
		end

	m_random: M_RANDOM
		once
			create Result.make
		end

	i_midipipe: I_MIDIPIPE
		once
			create Result
		end

	p_tick: P_TICK
		once
			create Result.make (Current)
		end

	p_mobj: P_MOBJ
		once
			create Result.make (Current)
		end

	r_segs: R_SEGS
		once
			create Result.make (Current)
		end

	r_bsp: R_BSP
		once
			create Result.make (Current)
		end

	p_pspr: P_PSPR
		once
			create Result.make (Current)
		end

	p_maputl: P_MAPUTL
		once
			create Result.make (Current)
		end

	p_user: P_USER
		once
			create Result.make (Current)
		end

	d_display: D_DISPLAY
		once
			create Result.make (Current)
		end

	p_map: P_MAP
		once
			create Result.make (Current)
		end

	p_doors: P_DOORS
		once
			create Result.make (Current)
		end

	p_inter: P_INTER
		once
			create Result.make (Current)
		end

	p_floor: P_FLOOR
		once
			create Result.make (Current)
		end

	m_argv: M_ARGV

	p_enemy: P_ENEMY
		once
			create Result.make (Current)
		end

	st_lib: ST_LIB
		once
			create Result.make (Current)
		end

	p_sight: P_SIGHT
		once
			create Result.make (Current)
		end

feature {NONE} -- Initialization

	main
			-- Run application.
		do
			create m_argv.make (argument_array)
			d_main.D_DoomMain
		end

feature -- i_system.c

	i_error (a_message: STRING)
		do
			print("I_Error not implemented%N")
			print ("Error: " + a_message + "%N")
			(create {DEVELOPER_EXCEPTION}).raise
		ensure
			instance_free: class
			is_error: False
		end

end
