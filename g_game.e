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

feature

	set_gameaction (a_gameaction: like gameaction)
		do
			gameaction := a_gameaction
		end

	netgame: BOOLEAN

feature -- G_InitNew

	G_InitNew (skill: INTEGER; episode: INTEGER; map: INTEGER)
		do
				-- Stub
		end

end
