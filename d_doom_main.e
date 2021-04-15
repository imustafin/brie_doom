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
			wipegamestate := {DOOMDEF_H}.GS_DEMOSCREEN
			oldgamestate := -1
			pagename := ""
		end

feature

	startskill: INTEGER

	startepisode: INTEGER

	startmap: INTEGER

	autostart: BOOLEAN

	singletics: BOOLEAN = True -- debug flag to cancel adaptiveness

feature -- DEMO LOOP

	demosequence: INTEGER

	pagetic: INTEGER

	pagename: STRING

feature

	devparm: BOOLEAN assign set_devparm -- started game with -devparm

	set_devparm (a_devparm: like devparm)
		do
			devparm := a_devparm
		end

	nomonsters: BOOLEAN assign set_nomonsters -- checkparm of -nomonsters

	set_nomonsters (a_nomonsters: like nomonsters)
		do
			nomonsters := a_nomonsters
		end

	respawnparm: BOOLEAN assign set_respawnparm -- checkparm of -respawn

	set_respawnparm (a_respawnparm: like respawnparm)
		do
			respawnparm := a_respawnparm
		end

	fastparm: BOOLEAN assign set_fastparm -- checkparm of -fast

	set_fastparm (a_fastparm: like fastparm)
		do
			fastparm := a_fastparm
		end

feature

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
				print ("R_Init: Init DOOM refresh daemon - ")
				i_main.r_main.R_Init
				print ("%NP_Init: Init Playloop state.%N")
				i_main.p_setup.P_Init
				print ("I_Init: Setting up machine state.%N")
				i_main.i_system.I_Init
				print ("D_CheckNetGame: Checking network game status.%N")
				i_main.d_net.D_CheckNetGame
				print ("S_Init: Setting up sound.%N")
				i_main.s_sound.S_Init (i_main.s_sound.snd_SfxVolume, i_main.s_sound.snd_MusicVolume)
				print ("HU_Init: Setting up heads up display.%N")
				i_main.hu_stuff.HU_Init
				print ("ST_Init: Init status bar.%N")
				i_main.st_stuff.ST_Init
					-- skip -statcopy
					-- skip -record
					-- skip -playdemo
					-- skip -timedemo
				startskill := {DOOMDEF_H}.sk_medium
				startepisode := 1
				startmap := 1
				autostart := False
					-- skip -loadgame
				if i_main.g_game.gameaction /= i_main.g_game.ga_loadgame then
					if autostart or i_main.g_game.netgame then
						i_main.g_game.G_InitNew (startskill, startepisode, startmap)
					else
						D_StartTitle
					end
				end
				D_DoomLoop
			end
		end

	D_StartTitle
		do
			i_main.g_game.gameaction := {G_GAME}.ga_nothing
			demosequence := -1
			D_AdvanceDemo
		end

	D_PageDrawer
		do
			i_main.v_video.V_DrawPatch (0, 0, create {PATCH_T}.from_pointer (i_main.w_wad.W_CacheLumpName (pagename, {Z_ZONE}.PU_CACHE)))
		end

	advancedemo: BOOLEAN

	D_AdvanceDemo
			-- Called after each demo or intro demosequence finishes
		do
			advancedemo := True
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

feature -- D_DoomLoop

	D_DoomLoop
		do
			if i_main.g_game.demorecording then
				i_main.g_game.G_BeginRecording
			end
				-- skip -debugfile
			check attached i_main.i_video as iv then
				iv.I_InitGraphics
			end
			from
			until
				False
			loop
				print ("DOOM LOOP GAMETIC: " + i_main.g_game.gametic.out + ", state " + i_main.g_game.gamestate.out + "%N")
				check attached i_main.i_video as iv then
					iv.I_StartFrame
				end
				if singletics then
					check attached i_main.i_video as iv then
						iv.I_StartTic
					end
					D_ProcessEvents
					i_main.g_game.G_BuildTiccmd (i_main.d_net.netcmds [i_main.g_game.consoleplayer] [i_main.d_net.maketic \\ {D_NET}.BACKUPTICS])
					if advancedemo then
						D_DoAdvanceDemo
					end
					i_main.m_menu.M_Ticker
					i_main.g_game.G_Ticker
					i_main.g_game.gametic := i_main.g_game.gametic + 1
					i_main.d_net.maketic := i_main.d_net.maketic + 1
				else
					i_main.d_net.TryRunTics
				end
				check attached i_main.g_game.players [i_main.g_game.consoleplayer].mo as cpmo then
					i_main.s_sound.S_UpdateSounds (cpmo) -- move positional sounds
				end
				D_Display
			end
		end

	D_ProcessEvents
			-- Send all the events of the given timestamp down the responder chain
		local
			event: EVENT_T
			res: BOOLEAN
		do
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial and i_main.w_wad.W_CheckNumForName ("map01") < 0 then
					-- STORE DEMO, DO NOT ACCEPT INPUT
			else
				from
				until
					eventtail = eventhead
				loop
					event := events [eventtail]
					if not i_main.m_menu.m_responder (event) then
						res := i_main.g_game.G_Responder (event)
					end
					eventtail := (eventtail + 1).bit_and ({D_EVENT}.maxevents - 1)
				end
			end
		end

	D_DoAdvanceDemo
			-- This cycles through the demo sequences.
			-- FIXME - version dependend demo numbers?
		do
			i_main.g_game.players [i_main.g_game.consoleplayer].playerstate := {PLAYER_T}.PST_LIVE -- not reborn
			advancedemo := False
			i_main.g_game.usergame := False -- no save / end game here
			i_main.g_game.paused := False
			i_main.g_game.gameaction := {G_GAME}.ga_nothing
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.retail then
				demosequence := (demosequence + 1) \\ 7
			else
				demosequence := (demosequence + 1) \\ 6
			end
			inspect demosequence
			when 0 then
				if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
					pagetic := 35 * 11
				else
					pagetic := 170
				end
				i_main.g_game.gamestate := {DOOMDEF_H}.GS_DEMOSCREEN
				pagename := "TITLEPIC"
				if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
					i_main.s_sound.S_StartMusic ({SOUNDS_H}.mus_dm2ttl)
				else
					i_main.s_sound.S_StartMusic ({SOUNDS_H}.mus_intro)
				end
			when 1 then
				i_main.g_game.G_DeferedPlayDemo ("demo1")
			when 2 then
				pagetic := 200
				i_main.g_game.gamestate := {DOOMDEF_H}.GS_DEMOSCREEN
				pagename := "CREDIT"
			when 3 then
				i_main.g_game.G_DeferedPlayDemo ("demo2")
			when 4 then
				i_main.g_game.gamestate := {DOOMDEF_H}.GS_DEMOSCREEN
				if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
					pagetic := 35 * 11
					pagename := "TITLEPIC"
					i_main.s_sound.S_StartMusic ({SOUNDS_H}.mus_dm2ttl)
				else
					pagetic := 200
					if i_main.doomstat_h.gamemode = {GAME_MODE_T}.retail then
						pagename := "CREDIT"
					else
						pagename := "HELP2"
					end
				end
			when 5 then
				i_main.g_game.G_DeferedPlayDemo ("demo3")
			when 6 then
				i_main.g_game.G_DeferedPlayDemo ("demo4")
			else
					-- Should not reach here
			end
		end

feature -- D_Display

	wipegamestate: INTEGER -- wipegamestate can be set to -1 to force a wipe on the next draw

	viewactivestate: BOOLEAN

	menuactivestate: BOOLEAN

	inhelpscreensstate: BOOLEAN

	fullscreen: BOOLEAN

	oldgamestate: INTEGER

	borderdrawcount: INTEGER

	D_Display
			-- draw current display, possibly wiping it from the previous
		local
			nowtime: INTEGER
			tics: INTEGER
			wipestart: INTEGER
			y: INTEGER
			done: BOOLEAN
			wipe: BOOLEAN
			redrawsbar: BOOLEAN
		do
			if i_main.g_game.nodrawers then
					-- for comparative timing / profiling
			else
				redrawsbar := False
				if i_main.r_main.setsizeneeded then
					i_main.r_main.R_ExecuteSetViewSize
					oldgamestate := -1 -- force background redraw
					borderdrawcount := 3
				end

					-- save the current screen if about to wipe
				if i_main.g_game.gamestate /= wipegamestate then
					wipe := True
					check attached i_main.f_wipe as w then
						w.wipe_StartScreen (0, 0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT)
					end
				else
					wipe := False
				end
				if i_main.g_game.gamestate = {DOOMDEF_H}.GS_LEVEL and i_main.g_game.gametic /= 0 then
					i_main.hu_stuff.HU_Erase
				end

					-- do buffered drawing
				if i_main.g_game.gamestate = {DOOMDEF_H}.GS_LEVEL then
					if i_main.g_game.gametic /= 0 then
						if i_main.am_map.automapactive then
							i_main.am_map.AM_Drawer
						end
						if wipe or (i_main.r_draw.viewheight /= 200 and fullscreen) then
							redrawsbar := True
						end
						if inhelpscreensstate and not i_main.m_menu.inhelpscreens then
							redrawsbar := True -- just put away the help screen
						end
						i_main.st_stuff.ST_Drawer (i_main.r_draw.viewheight = 200, redrawsbar)
						fullscreen := i_main.r_draw.viewheight = 200
					end
				elseif i_main.g_game.gamestate = {DOOMDEF_H}.GS_INTERMISSION then
					i_main.wi_stuff.WI_Drawer
				elseif i_main.g_game.gamestate = {DOOMDEF_H}.GS_FINALE then
					i_main.f_finale.F_Drawer
				elseif i_main.g_game.gamestate = {DOOMDEF_H}.GS_DEMOSCREEN then
					D_PageDrawer
				end

					-- draw buffered stuff to screen
				check attached i_main.i_video as iv then
					iv.I_UpdateNoBlit
				end

					-- draw the view directly
				if i_main.g_game.gamestate = {DOOMDEF_H}.GS_LEVEL and not i_main.am_map.automapactive and i_main.g_game.gametic /= 0 then
					i_main.r_main.R_RenderPlayerView (i_main.g_game.players [i_main.g_game.displayplayer])
				end
				if i_main.g_game.gamestate = {DOOMDEF_H}.GS_LEVEL and i_main.g_game.gametic /= 0 then
					i_main.hu_stuff.HU_Drawer
				end

					-- clean up border stuff
				if i_main.g_game.gamestate /= oldgamestate and i_main.g_game.gamestate /= {DOOMDEF_H}.GS_LEVEL then
					check attached i_main.i_video as iv then
						iv.I_SetPalette (i_main.w_wad.W_CacheLumpName ("PLAYPAL", {Z_ZONE}.PU_CACHE))
					end
				end

					-- see if the border needs to be initially drawn
				if i_main.g_game.gamestate = {DOOMDEF_H}.GS_LEVEL and oldgamestate /= {DOOMDEF_H}.GS_LEVEL then
					viewactivestate := False -- view was not active
					i_main.r_draw.R_FillBackScreen -- draw the pattern into the black screen
				end

					-- see if the border needs to be updated to the screen
				if i_main.g_game.gamestate = {DOOMDEF_H}.GS_LEVEL and not i_main.am_map.automapactive and i_main.r_draw.scaledviewwidth /= 320 then
					if i_main.m_menu.menuactive or menuactivestate or not viewactivestate then
						borderdrawcount := 3
					end
					if borderdrawcount /= 0 then
						i_main.r_draw.R_DrawViewBorder -- erase old menu stuff
						borderdrawcount := borderdrawcount - 1
					end
				end
				menuactivestate := i_main.m_menu.menuactive
				viewactivestate := i_main.g_game.viewactive
				inhelpscreensstate := i_main.m_menu.inhelpscreens
				oldgamestate := i_main.g_game.gamestate
				wipegamestate := i_main.g_game.gamestate

					-- draw pause pic
				if i_main.g_game.paused then
					if i_main.am_map.automapactive then
						y := 4
					else
						y := i_main.r_draw.viewwindowy + 4
					end
					i_main.v_video.V_DrawPatchDirect (i_main.r_draw.viewwindowx + (i_main.r_draw.scaledviewwidth - 68) // 2, y, create {PATCH_T}.from_pointer (i_main.w_wad.W_CacheLumpName ("M_PAUSE", {Z_ZONE}.PU_CACHE)))
				end

					-- menus go directly to the screen
				i_main.m_menu.M_Drawer -- menu is drawn even on top of everything
				i_main.d_net.NetUpdate -- send out any new accumulation

					-- normal update
				if not wipe then
					check attached i_main.i_video as iv then
						iv.I_FinishUpdate -- page flip or blit buffer
					end
				else
						-- wipe update
					check attached i_main.f_wipe as w then
						w.wipe_EndScreen (0, 0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT)
					end
					wipestart := i_main.i_system.I_GetTime - 1
					from
						done := False
					until
						done
					loop
						from
							tics := 0 -- set zero to run loop at least once (do {} while(tics <= 0) from chocolate doom D_RunFrame
						until
							tics > 0
						loop
							nowtime := i_main.i_system.I_GetTime
							tics := nowtime - wipestart
							i_main.i_system.i_sleep (1)
						end
						wipestart := nowtime
						check attached i_main.f_wipe as w then
							done := w.wipe_ScreenWipe ({F_WIPE}.wipe_Melt, 0, 0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT, tics)
						end
						check attached i_main.i_video as iv then
							iv.I_UpdateNoBlit
							i_main.m_menu.M_Drawer -- menu is drawn even on top of wipes
							iv.I_FinishUpdate -- page flip or blit buffer
						end
					end
				end
			end
		end

feature -- EVENT HANDLING

		-- Events are asynchronous inputs generally generated by the game user.
		-- Events can be discarded if no responder claims them

	events: ARRAY [EVENT_T]
		once
			create Result.make_filled (create {EVENT_T}.make, 0, {D_EVENT}.MAXEVENTS)
		end

	eventhead: INTEGER

	eventtail: INTEGER

	D_PostEvent (event: EVENT_T)
		do
			events [eventhead] := event
			eventhead := (eventhead + 1).bit_and ({D_EVENT}.MAXEVENTS - 1)
		ensure
			advanced_if_there_was_space: old eventhead < {D_EVENT}.maxevents - 1 implies eventhead = old eventhead + 1
			wrapped_if_there_was_no_space: old eventhead = {D_EVENT}.maxevents - 1 implies eventhead = 0
		end

end
