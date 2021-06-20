note
	description: "Summary description for {D_DISPLAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	D_DISPLAY

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			wipegamestate := {DOOMDEF_H}.GS_DEMOSCREEN
			oldgamestate := -1
		end

feature

	D_PageDrawer
		do
			check attached i_main.d_doom_main as d_doom_main then
				i_main.v_video.V_DrawPatch (0, 0, create {PATCH_T}.from_pointer (i_main.w_wad.W_CacheLumpName (d_doom_main.pagename, {Z_ZONE}.PU_CACHE)))
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
					i_main.f_wipe.wipe_StartScreen (0, 0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT)
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
				i_main.i_video.I_UpdateNoBlit

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
					i_main.i_video.I_FinishUpdate -- page flip or blit buffer
				else
						-- wipe update
					i_main.f_wipe.wipe_EndScreen (0, 0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT)
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
						done := i_main.f_wipe.wipe_ScreenWipe ({F_WIPE}.wipe_Melt, 0, 0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT, tics)
						i_main.i_video.I_UpdateNoBlit
						i_main.m_menu.M_Drawer -- menu is drawn even on top of wipes
						i_main.i_video.I_FinishUpdate -- page flip or blit buffer
					end
				end
			end
		end

end
