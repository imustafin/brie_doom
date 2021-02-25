note
	description: "[
		m_menu.c
		DOOM selection menu, options, episodes etc.
		Sliders and icons. Kinda widget stuff.
	]"

class
	M_MENU

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			messagestring := ""
		end

feature -- defaulted values

	mouseSensitivity: INTEGER assign set_mouseSensitivity -- has default

	set_mouseSensitivity (a_mouseSensitivity: like mouseSensitivity)
		do
			mouseSensitivity := a_mouseSensitivity
		end

	showMessages: INTEGER assign set_showMessages -- Show messages has default, 0 = off, 1 = on

	set_showMessages (a_showMessages: like showMessages)
		do
			showMessages := a_showMessages
		end

	detailLevel: INTEGER assign set_screenblocks -- Blocky mode, has default, 0 = high, 1 = normal

	set_detaillevel (a_detaillevel: like detaillevel)
		do
			detaillevel := a_detaillevel
		end

	screenblocks: INTEGER assign set_screenblocks

	set_screenblocks (a_screenblocks: like screenblocks)
		do
			screenblocks := a_screenblocks
		end

feature

	LINEHEIGHT: INTEGER = 16

	SKULLXOFF: INTEGER = -32

	skullName: ARRAY [STRING]
		once
			Result := <<"M_SKULL1", "M_SKULL2">>
		end

feature -- main_e

	newgame: INTEGER = 0

	options: INTEGER = 1

	loadgame: INTEGER = 2

	savegame: INTEGER = 3

	readthis: INTEGER = 4

	quitdoom: INTEGER = 5

	main_end: INTEGER = 6

feature -- newgame_e

	killthings: INTEGER = 0

	toorough: INTEGER = 1

	hurtme: INTEGER = 2

	violence: INTEGER = 3

	nightmare: INTEGER = 4

	newg_end: INTEGER = 5

feature

	currentMenu: detachable MENU_T

	MainDef: MENU_T
		once
			create Result.make (main_end, Void, MainMenu, agent M_DrawMainMenu, 97, 64, 0)
		end

	NewGameMenu: ARRAY [MENUITEM_T]
		once
			Result := <<create {MENUITEM_T}.make (1, "M_JKILL", agent M_ChooseSkill, 'i'), create {MENUITEM_T}.make (1, "M_ROUGH", agent M_ChooseSkill, 'h'), create {MENUITEM_T}.make (1, "M_HURT", agent M_ChooseSkill, 'h'), create {MENUITEM_T}.make (1, "M_ULTRA", agent M_ChooseSkill, 'u'), create {MENUITEM_T}.make (1, "M_NMARE", agent M_ChooseSkill, 'n')>>
		end

	NewDef: MENU_T
		once
			create Result.make (newg_end, EpiDef, NewGameMenu, agent M_DrawNewGame, 48, 63, hurtme)
		end

	MainMenu: ARRAY [MENUITEM_T]
		once
			Result := <<create {MENUITEM_T}.make (1, "M_NGAME", agent M_NewGame, 'n'), create {MENUITEM_T}.make (1, "M_OPTION", agent M_Options, 'o'), create {MENUITEM_T}.make (1, "M_LOADG", agent M_LoadGame, 'l'), create {MENUITEM_T}.make (1, "M_SAVEG", agent M_SaveGame, 's'), create {MENUITEM_T}.make (1, "M_RDTHIS", agent M_ReadThis, 'r'), create {MENUITEM_T}.make (1, "M_QUITG", agent M_QuitDOOM, 'q')>>
		end

	inhelpscreens: BOOLEAN

	menuactive: BOOLEAN

	itemOn: INTEGER -- menu item skull is on

	whichskull: INTEGER -- which skull to draw

	skullanimcounter: INTEGER -- skull animation counter

	screensize: INTEGER -- temp for screenblocks (0-9)

	messagetoprint: BOOLEAN -- (was int) 1 = message to be printed

	messagestring: STRING -- ...and here is the message string!

	messageLastMenuActive: BOOLEAN -- (was int)

	quickSaveSlot: INTEGER -- -1 = no quicksave slot picked!

feature -- Read This! MENU 1 & 2

	rdthssempty1: INTEGER = 0

	read1_end: INTEGER = 1

	ReadMenu1: ARRAY [MENUITEM_T]
		once
			Result := <<create {MENUITEM_T}.make (1, "", agent M_ReadThis2, '0')>>
		end

	ReadDef1: MENU_T
		once
			create Result.make (read1_end, MainDef, ReadMenu1, agent M_DrawReadThis1, 280, 185, 0)
		end

	rdthsempty2: INTEGER = 0

	read2_end: INTEGER = 1

	ReadMenu2: ARRAY [MENUITEM_T]
		once
			Result := <<create {MENUITEM_T}.make (1, "", agent M_FinishReadThis, '0')>>
		end

	ReadDef2: MENU_T
		once
			create Result.make (read2_end, ReadDef1, ReadMenu2, agent M_DrawReadThis2, 330, 175, 0)
		end

feature

	M_DrawReadThis1
		do
				-- Stub
		end

	M_FinishReadThis (choice: INTEGER)
		do
				-- Stub
		end

	M_DrawEpisode
		do
				-- Stub
		end

	M_DrawReadThis2
		do
				-- Stub
		end

	M_ReadThis2 (choice: INTEGER)
		do
				-- Stub
		end

	M_NewGame (choice: INTEGER)
		do
				-- Stub
		end

	M_Options (choice: INTEGER)
		do
				-- Stub
		end

	M_LoadGame (choice: INTEGER)
		do
				-- Stub
		end

	M_SaveGame (choice: INTEGER)
		do
				-- Stub
		end

	M_ReadThis (choice: INTEGER)
		do
				-- Stub
		end

	M_QuitDOOM (choice: INTEGER)
		do
				-- Stub
		end

	M_DrawNewGame
		do
				-- Stub
		end

	M_ChooseSkill (choice: INTEGER)
		do
				-- Stub
		end

	M_DrawMainMenu
		do
				-- Stub
		end

feature -- EPISODE SELECT

	ep1: INTEGER = 0

	ep2: INTEGER = 1

	ep3: INTEGER = 2

	ep4: INTEGER = 3

	ep_end: INTEGER = 4

	EpisodeMenu: ARRAY [MENUITEM_T]
		once
			Result := <<create {MENUITEM_T}.make (1, "M_EPI1", agent M_Episode, 'k'), create {MENUITEM_T}.make (1, "M_EPI2", agent M_Episode, 't'), create {MENUITEM_T}.make (1, "M_EPI3", agent M_Episode, 'i'), create {MENUITEM_T}.make (1, "M_EPI4", agent M_Episode, 't')>>
		end

	EpiDef: MENU_T
		once
			create Result.make (ep_end, MainDef, EpisodeMenu, agent M_DrawEpisode, 48, 63, ep1)
		end

feature -- M_Episode

	M_Episode (choice: INTEGER)
		do
				-- Stub
		end

feature

	saveStringEnter: BOOLEAN -- we are going to be entering a savegame string

feature -- CONTROL PANEL

	M_Responder (ev: EVENT_T): BOOLEAN
		local
			ch: INTEGER
		do
			ch := -1
				-- skip ev_joystick
				-- skip ev_mouse
			if ev.type = ev.ev_keydown then
				ch := ev.data1
			end
			if ch /= -1 then
				if saveStringEnter then
						-- skip
				elseif messageToPrint then
						-- skip
				elseif False then -- devparm && h == KEY_F1
						-- skip
				elseif not menuactive then -- F-Keys
						-- skip

				elseif not menuactive then -- Pop-up menu?
						-- skip
				else -- Keys usable within menu
					if attached currentMenu as currentMenuAttached then
						if ch = {DOOMDEF_H}.KEY_DOWNARROW then
							from
								if itemOn + 1 > currentMenuAttached.numitems - 1 then
									itemOn := 0
								else
									itemOn := itemOn + 1
								end
								i_main.s_sound.S_StartSound (Void, {SOUNDS_H}.sfx_pstop)
							until
								currentMenuAttached.menuitems [itemOn].status /= -1
							loop
								if itemOn + 1 > currentMenuAttached.numitems - 1 then
									itemOn := 0
								else
									itemOn := itemOn + 1
								end
								i_main.s_sound.S_StartSound (Void, {SOUNDS_H}.sfx_pstop)
							end
							Result := True
						elseif ch = {DOOMDEF_H}.key_uparrow then
							from
								if itemOn = 0 then
									itemOn := currentMenuAttached.numitems - 1
								else
									itemOn := itemOn - 1
								end
								i_main.s_sound.S_StartSound (Void, {SOUNDS_H}.sfx_pstop)
							until
								currentMenuAttached.menuitems [itemOn].status /= -1
							loop
								if itemOn = 0 then
									itemOn := currentMenuAttached.numitems - 1
								else
									itemOn := itemOn - 1
								end
								i_main.s_sound.S_StartSound (Void, {SOUNDS_H}.sfx_pstop)
							end
							Result := True
						end
					end
				end
			end
		end

feature

	M_Init
		do
			currentMenu := MainDef
			menuactive := False
			if attached currentMenu as c then
				itemOn := c.lastOn
			end
			whichSkull := 0
			skullAnimCounter := 10
			screenSize := screenblocks - 3
			messageToPrint := False
				--			messageString := ""
			messageLastMenuActive := menuactive
			quickSaveSlot := -1
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
				MainMenu [readthis] := MainMenu [quitdoom]
				MainDef.numitems := MainDef.numitems - 1
				MainDef.y := MainDef.y + 8
				NewDef.prevMenu := MainDef
				ReadDef1.routine := agent M_DrawReadThis1
				ReadDef1.x := 330
				ReadDef1.y := 165
				ReadMenu1 [0].routine := agent M_FinishReadThis
			elseif i_main.doomstat_h.gamemode = {GAME_MODE_T}.registered then
				EpiDef.numitems := EpiDef.numitems - 1
			end
		end

feature

	M_Ticker
		do
			skullAnimCounter := skullAnimCounter - 1
			if skullAnimCounter <= 0 then
				whichSkull := whichSkull.bit_xor (1)
				skullAnimCounter := 8
			end
		end

feature -- M_Drawer

	x: INTEGER

	y: INTEGER

	M_Drawer
			-- Called after the view has been rendered,
			-- but before it has been blitted.
		local
			i: INTEGER
			max: INTEGER
		do
			inhelpscreens := False
			if messagetoprint then
					-- skip
			elseif not menuactive then
					-- nothing
			else
				if attached currentmenu as cm then
					if attached cm.routine as r then
						r.call
					end

						-- DRAW MENU
					x := cm.x
					y := cm.y
					max := cm.numitems
					from
						i := 0
					until
						i >= max
					loop
						if not cm.menuitems [i].name.is_empty then
							i_main.v_video.V_DrawPatchDirect (x, y, 0, create {PATCH_T}.from_pointer (i_main.w_wad.W_CacheLumpName (cm.menuitems [i].name, {Z_ZONE}.pu_cache)))
						end
						y := y + LINEHEIGHT
						i := i + 1
					end

						-- DRAW SKULL
					i_main.v_video.V_DrawPatchDirect (x + SKULLXOFF, cm.y - 5 + itemOn * LINEHEIGHT, 0, create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname (skullName [whichSkull], {Z_ZONE}.pu_cache)))
				end
			end
		end

end
