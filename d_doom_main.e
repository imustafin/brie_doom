note
	description: "[
		d_main.c
		DOOM main program (D_DoomMain) and game loop (D_DoomLoop),
		plus functions to determine game mode (shareware, registered),
		parse command line parameters, configure game parameters (turbo),
		and call the startup functions.
	]"

class
	D_DOOM_MAIN

create
	make

feature

	i_main: I_MAIN

	wadfiles: LIST [STRING]

	make (a_i_main: I_MAIN)
		do
			i_main := a_i_main
			create {LINKED_LIST [STRING]} wadfiles.make
			D_DoomMain
		end

	D_DoomMain
		do
			FindResponseFile
			IdentifyVersion
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.shareware then
				print ("            DOOM Shareware Startup%N")
				print ("V_Init: allocate screens.%N")
				i_main.v_video.v_init
				print ("M_LoadDefaults: Load system defauls.%N")
				i_main.m_misc.m_loaddefaults
				print ("Z_Init: Init zone memory allocation daemon.%N")
				i_main.z_zone.z_init
				print ("W_Init: Init WADfiles.%N")
				i_main.w_wad.W_InitMultipleFiles (wadfiles)
				print ("added%N")
				print ("==================%N")
				print ("   Shareware!%N")
				print ("==================%N")
				print ("M_Init: Init miscellaneous info.%N")
				i_main.m_menu.m_init
			end
		end

	FindResponseFile
		do
				-- Stub
		end

	IdentifyVersion
		do
				-- Stub
			i_main.doomstat_h.gamemode := {GAME_MODE_T}.shareware
			D_AddFile ("doom1.wad")
		end

	D_AddFile (a_wadfile: STRING)
		do
			wadfiles.extend (a_wadfile)
		end

end
