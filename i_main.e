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

	r_main: R_MAIN
		once
			create Result.make (Current)
		end

	inner_r_data: detachable R_DATA

	r_data: R_DATA
		do
			check attached inner_r_data as x then
				Result := x
			end
		end

	inner_r_plane: detachable R_PLANE

	r_plane: R_PLANE
		do
			check attached inner_r_plane as x then
				Result := x
			end
		end

	r_sky: R_SKY

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

	r_things: R_THINGS
		once
			create Result.make (Current)
		end

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

	d_doom_main: D_DOOM_MAIN
		once
			create Result.make (Current)
		end

	f_finale: F_FINALE

	f_wipe: detachable F_WIPE

	hu_lib: HU_LIB

	am_map: AM_MAP

	wi_stuff: WI_STUFF
		once
			create Result.make (Current)
		end

	m_random: M_RANDOM

	i_midipipe: I_MIDIPIPE

	p_tick: P_TICK
		once
			create Result.make (Current)
		end

	p_mobj: P_MOBJ

	inner_r_segs: detachable R_SEGS

	r_segs: R_SEGS
		do
			check attached inner_r_segs as x then
				Result := x
			end
		end

	inner_r_bsp: detachable R_BSP

	r_bsp: R_BSP
		do
			check attached inner_r_bsp as x then
				Result := x
			end
		end

	p_pspr: P_PSPR

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
			create Result
		end

	p_floor: P_FLOOR
		once
			create Result.make (Current)
		end

	m_argv: M_ARGV

	p_spr: P_SPR
		once
			create Result
		end

	p_enemy: P_ENEMY
		once
			create Result
		end

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			create m_argv.make (argument_array)
			create doomstat_h.make
			create hu_lib.make
			create am_map.make
			create p_spec.make
			create info.make
			create z_zone.make
			create st_stuff.make
			create r_sky.make
			create f_finale.make
			create m_random.make
			create i_midipipe
			create p_mobj.make (Current)
			create p_pspr.make (Current)
			create inner_r_plane.make (Current)
			create inner_r_segs.make (Current)
			create inner_r_bsp.make (Current)
			create inner_r_data.make (Current)
			create inner_i_sound.make (Current)
			create inner_s_sound.make (Current)
			create inner_hu_stuff.make (Current)
			create inner_g_game.make (Current)
			create inner_i_video.make (Current)
			create inner_m_menu.make (Current)
			create inner_w_wad.make (Current)
			create inner_i_system.make (Current)
			create f_wipe.make (Current)
			create inner_v_video.make (Current)
			create i_net.make (Current)
			create inner_d_net.make (Current)
			create inner_m_misc.make (Current)
			d_doom_main.D_DoomMain
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
