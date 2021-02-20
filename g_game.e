note
	description: "[
		g_game.c
		none
	]"

class
	G_GAME

create
	make

feature

	make
		do
		end

feature -- gameaction_t

	ga_nothing: INTEGER = 0

	ga_loadlevel: INTEGER = 1

	ga_newgame: INTEGER = 2

	ga_loadgame: INTEGER = 3

	ga_savegame: INTEGER = 4

	ga_playdemo: INTEGER = 5

	ga_completed: INTEGER = 6

	ga_victory: INTEGER = 7

	ga_worlddone: INTEGER = 8

	ga_screenshot: INTEGER = 9

feature

	gameaction: INTEGER assign set_gameaction

	demorecording: BOOLEAN

feature

	set_gameaction (a_gameaction: like gameaction)
		do
			gameaction := a_gameaction
		end

	netgame: BOOLEAN assign set_netgame

	set_netgame (a_netgame: like netgame)
		do
			netgame := a_netgame
		end

	deathmatch: BOOLEAN -- only if started as net death

feature -- G_InitNew

	G_InitNew (skill: INTEGER; episode: INTEGER; map: INTEGER)
		do
				-- Stub
		end

feature

	consoleplayer: INTEGER assign set_consoleplayer -- player taking events and displaying

	displayplayer: INTEGER assign set_displayplayer -- view being displayed

	gametic: INTEGER assign set_gametic

feature

	set_gametic (a_gametic: like gametic)
		do
			gametic := a_gametic
		end

	set_consoleplayer (a_consoleplayer: like consoleplayer)
		do
			consoleplayer := a_consoleplayer
		end

	set_displayplayer (a_displayplayer: like displayplayer)
		do
			displayplayer := a_displayplayer
		end

feature

	G_BeginRecording
		do
				-- Stub
		end

	G_BuildTiccmd (cmd: TICCMD_T)
		do
				-- Stub
		end

	G_Ticker
		do
				-- Stub
		end

feature

	players: ARRAYED_LIST [PLAYER_T]
		once
			create Result.make ({DOOMDEF_H}.MAXPLAYERS)
		end

	playeringame: ARRAY [BOOLEAN]
		once
			create Result.make_filled (False, 0, {DOOMDEF_H}.maxplayers - 1)
		end

feature

	G_Responder (event: EVENT_T): BOOLEAN
		do
				-- Stub
		end

end
