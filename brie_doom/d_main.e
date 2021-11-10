note
	description: "[
		d_main.c
		DOOM main program (D_DoomMain) and game loop (D_DoomLoop),
		plus functions to determine game mode (shareware, registered),
		parse command line parameters, configure game parameters (turbo),
		and call the startup functions.
	]"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
		Copyright (C) 2005-2014 Simon Howard
		Copyright (C) 2021 Ilgiz Mustafin
		
		This program is free software; you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation; either version 2 of the License, or
		(at your option) any later version.
		
		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		
		You should have received a copy of the GNU General Public License along
		with this program; if not, write to the Free Software Foundation, Inc.,
		51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
	]"

class
	D_MAIN

create
	make

feature

	i_main: I_MAIN

	wadfiles: LIST [STRING]

	make (a_i_main: I_MAIN)
		do
			i_main := a_i_main
			create {LINKED_LIST [STRING]} wadfiles.make
			pagename := ""
			singletics := True
		end

feature

	startskill: INTEGER

	startepisode: INTEGER

	startmap: INTEGER

	autostart: BOOLEAN

	singletics: BOOLEAN assign set_singletics -- debug flag to cancel adaptiveness

	set_singletics (a_singletics: like singletics)
		do
			singletics := a_singletics
		end

	debugfile: detachable FILE

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
		local
			p: INTEGER
			file: STRING
		do
			{NOT_IMPLEMENTED}.not_implemented ("D_DoomMain", false)
			FindResponseFile
			IdentifyVersion
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.shareware then
				print ("            DOOM Shareware Startup%N")
			end
				-- skip -cdrom
				-- skip -turbo
				-- skip -wart
				-- skip -file
				-- start the appropriate game based on params

			p := i_main.m_argv.M_CheckParm ("-playdemo")
			if not p.to_boolean then
				p := i_main.m_argv.m_checkparm ("-timedemo")
			end
			if p.to_boolean and p <= i_main.m_argv.myargv.upper then
				file := i_main.m_argv.myargv [p + 1].to_string_32 + ".lmp"
				D_AddFile (file)
				print ("Playing demo " + i_main.m_argv.myargv [p + 1] + ".lmp.%N")
			end
			startskill := {DOOMDEF_H}.sk_medium
			startepisode := 1
			startmap := 1
			autostart := False

				-- skip -statcopy
				-- skip -record

			print ("V_Init: allocate screens.%N")
			i_main.v_video.v_init
			print ("M_LoadDefaults: Load system defauls.%N")
			i_main.m_misc.m_loaddefaults
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
			i_main.s_sound.S_Init (i_main.s_sound.snd_SfxVolume * 8, i_main.s_sound.snd_MusicVolume * 8)
			print ("HU_Init: Setting up heads up display.%N")
			i_main.hu_stuff.HU_Init
			print ("ST_Init: Init status bar.%N")
			i_main.st_stuff.ST_Init
			p := i_main.m_argv.m_checkparm ("-record")
			if p.to_boolean and p < i_main.m_argv.myargv.count - 1 then
				i_main.g_game.G_RecordDemo (i_main.m_argv.myargv [p + 1].to_string_32)
				autostart := True
			end
			p := i_main.m_argv.M_CheckParm ("-timedemo")
			if p /= 0 and p <= i_main.m_argv.myargv.upper then
				i_main.g_game.G_TimeDemo (i_main.m_argv.myargv [p + 1].to_string_32)
				D_DoomLoop -- never returns
			end
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

	D_StartTitle
		do
			i_main.g_game.gameaction := {G_GAME}.ga_nothing
			demosequence := -1
			D_AdvanceDemo
		end

	advancedemo: BOOLEAN

	D_AdvanceDemo
			-- Called after each demo or intro demosequence finishes
		do
			advancedemo := True
		end

	FindResponseFile
		do
			{NOT_IMPLEMENTED}.not_implemented ("FindResponseFile", False)
		end

	IdentifyVersion
		do
			{NOT_IMPLEMENTED}.not_implemented ("IdentifyVersion", false)
			i_main.doomstat_h.gamemode := {GAME_MODE_T}.shareware
			D_AddFile ("doom1.wad")
		end

	D_AddFile (a_wadfile: STRING)
		do
			wadfiles.extend (a_wadfile)
		end

feature -- D_DoomLoop

	drone: BOOLEAN

	D_GrabMouseCallback: BOOLEAN
			-- Called to determine whether to grab the mouse pointer
		note
			source: "chocolate doom d_main.c"
		do
			if drone then
					-- Drone players don't need mouse focus
				Result := False
			elseif i_main.m_menu.menuactive or i_main.g_game.paused then
					-- when menu is active or game is paused, release the mouse
				Result := False
			else
					-- only grab mouse when playing levels (but not demos)
				Result := (i_main.g_game.gamestate = {DOOMDEF_H}.GS_LEVEL) and not i_main.g_game.demoplayback and not advancedemo
			end
		end

	D_DoomLoop
		do
			{NOT_IMPLEMENTED}.not_implemented ("D_DoomLoop", false)
			if i_main.g_game.demorecording then
				i_main.g_game.G_BeginRecording
			end
				-- skip -debugfile
			i_main.i_video.grabmouse_callback := agent D_GrabMouseCallback
			check attached i_main.i_video as iv then
				iv.I_InitGraphics
			end
			from
			until
				False
			loop
				D_RunFrame
			end
		end

	wipestart: INTEGER

	wipe: BOOLEAN

	D_RunFrame
		local
			nowtime: INTEGER
			tics: INTEGER
			perf_start, perf_end, perf_total: NATURAL_64
		do
			if wipe then
				from
					tics := 0 -- set zero to run loop at least once (do {} while(tics <= 0) from chocolate doom D_RunFrame
				until
					tics > 0
				loop
					nowtime := i_main.i_system.I_GetTime
					tics := nowtime - wipestart
					i_main.i_system.i_sleep (1)
				end
				perf_start := i_main.i_timer.i_get_time_us
				wipestart := nowtime
				wipe := not i_main.f_wipe.wipe_ScreenWipe ({F_WIPE}.wipe_Melt, 0, 0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT, tics)
				i_main.i_video.I_UpdateNoBlit
				i_main.m_menu.M_Drawer -- menu is drawn even on top of wipes
				i_main.i_video.I_FinishUpdate -- page flip or blit buffer
				perf_end := i_main.i_timer.i_get_time_us
				perf_total := perf_end - perf_start
				i_main.i_timer.i_log_perf_frame (perf_total, "wipe")
			else
				if not i_main.g_game.timingdemo then
					print ("DOOM LOOP GAMETIC: " + i_main.g_game.gametic.out + ", state " + i_main.g_game.gamestate.out + "%N")
				else
					perf_start := i_main.i_timer.i_get_time_us
				end
				i_main.i_video.I_StartFrame
				if singletics then
					i_main.i_video.i_starttic
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
				i_main.s_sound.S_UpdateSounds (i_main.g_game.players [i_main.g_game.consoleplayer].mo) -- move positional sounds
				if i_main.i_video.screenvisible and not i_main.g_game.nodrawers then
					wipe := i_main.d_display.D_Display
					if wipe then
							-- start wipe on this frame
						i_main.f_wipe.wipe_EndScreen (0, 0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT)
						wipestart := i_main.i_system.I_GetTime - 1
					else
						i_main.i_video.I_FinishUpdate -- page flip or blit buffer
						perf_end := i_main.i_timer.i_get_time_us
						perf_total := perf_end - perf_start
						i_main.i_timer.i_log_perf_frame (perf_total, "gamestate " + i_main.g_game.gamestate.out)
					end
				end
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

	D_PageTicker
			-- Handles timing for warped projection
		do
			pagetic := pagetic - 1
			if pagetic < 0 then
				D_AdvanceDemo
			end
		end

end
