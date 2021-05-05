note
	description: "[
		p_tick.c
		Archiving: SaveGame I/O.
		Thinker, Ticker.
	]"

class
	P_TICK

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create thinkers.make
		end

feature

	thinkers: LINKED_LIST [WITH_THINKER]

	leveltime: INTEGER assign set_leveltime

	set_leveltime (a_leveltime: like leveltime)
		do
			leveltime := a_leveltime
		end

feature

	P_InitThinkers
		do
			thinkers.wipe_out
		end

	P_AddThinker (thinker: WITH_THINKER)
			-- Adds a new thinker at the end of the list
		do
			thinkers.force (thinker)
		end

	P_RemoveThinker (thinker: THINKER_T)
		do
			{I_MAIN}.i_error ("P_RemoveThinker not implemented")
		end

	P_Ticker
		local
			i: INTEGER
		do
				-- run the tic
			if i_main.g_game.paused then
					-- return
			else
					-- pause if in menu and at least one tic has been run
				if not i_main.g_game.netgame and i_main.m_menu.menuactive and not i_main.g_game.demoplayback and i_main.g_game.players [i_main.g_game.consoleplayer].viewz /= 1 then
						-- return
				else
					from
						i := 0
					until
						i >= {DOOMDEF_H}.MAXPLAYERS
					loop
						if i_main.g_game.playeringame [i] then
							i_main.p_user.P_PlayerThink (i_main.g_game.players [i])
						end
						i := i + 1
					end
					P_RunThinkers
					i_main.p_spec.P_UpdateSpecials
					i_main.p_mobj.P_RespawnSpecials

						-- for par times
					leveltime := leveltime + 1
				end
			end
		end

	P_RunThinkers
		local
			currentthinker: THINKER_T
		do
			from
				thinkers.start
			until
				thinkers.exhausted
			loop
				if attached thinkers.item.thinker.function as function then
					function.call
					thinkers.forth
				else
					thinkers.remove
				end
			end
		end

end
