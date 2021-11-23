note
	description: "Summary description for {D_DISPLAY}."
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
			check attached i_main.d_main as d_doom_main then
				i_main.v_video.V_DrawPatch (0, 0, create {PATCH_T}.from_pointer (i_main.w_wad.W_CacheLumpName (d_doom_main.pagename)))
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

	D_Display: BOOLEAN
			-- draw current display, possibly wiping it from the previous
		local
			y: INTEGER
			redrawsbar: BOOLEAN
		do
			redrawsbar := False
			if i_main.r_main.setsizeneeded then
				i_main.r_main.R_ExecuteSetViewSize
				oldgamestate := -1 -- force background redraw
				borderdrawcount := 3
			end

				-- save the current screen if about to wipe
			if i_main.g_game.gamestate /= wipegamestate then
				Result := True
				i_main.f_wipe.wipe_StartScreen (0, 0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT)
			else
				Result := False
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
					if Result or (i_main.r_draw.viewheight /= {DOOMDEF_H}.screenheight and fullscreen) then
						redrawsbar := True
					end
					if inhelpscreensstate and not i_main.m_menu.inhelpscreens then
						redrawsbar := True -- just put away the help screen
					end
					i_main.st_stuff.ST_Drawer (i_main.r_draw.viewheight = {DOOMDEF_H}.screenheight, redrawsbar)
					fullscreen := i_main.r_draw.viewheight = {DOOMDEF_H}.screenheight
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
					iv.I_SetPalette (i_main.w_wad.W_CacheLumpName ("PLAYPAL"))
				end
			end

				-- see if the border needs to be initially drawn
			if i_main.g_game.gamestate = {DOOMDEF_H}.GS_LEVEL and oldgamestate /= {DOOMDEF_H}.GS_LEVEL then
				viewactivestate := False -- view was not active
				i_main.r_draw.R_FillBackScreen -- draw the pattern into the black screen
			end

				-- see if the border needs to be updated to the screen
			if i_main.g_game.gamestate = {DOOMDEF_H}.GS_LEVEL and not i_main.am_map.automapactive and i_main.r_draw.scaledviewwidth /= {DOOMDEF_H}.screenwidth then
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
				i_main.v_video.V_DrawPatchDirect (i_main.r_draw.viewwindowx + (i_main.r_draw.scaledviewwidth - 68) // 2, y, create {PATCH_T}.from_pointer (i_main.w_wad.W_CacheLumpName ("M_PAUSE")))
			end

				-- menus go directly to the screen
			i_main.m_menu.M_Drawer -- menu is drawn even on top of everything
			i_main.d_net.NetUpdate -- send out any new accumulation
		end

end
