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

			create thinkercap.make
		end

feature

	thinkercap: THINKER_T
			-- Both the head and tail of the thinker list.

	leveltime: INTEGER assign set_leveltime

	set_leveltime (a_leveltime: like leveltime)
		do
			leveltime := a_leveltime
		end

feature

	P_InitThinkers
		do
			thinkercap.next := thinkercap
			thinkercap.prev := thinkercap
		end

	P_AddThinker (thinker: THINKER_T)
			-- Adds a new thinker at the end of the list
		do
			thinkercap.prev.next := thinker
			thinker.next := thinkercap
			thinker.prev := thinkercap.prev
			thinkercap.prev := thinker
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
				currentthinker := thinkercap.next
				from

				until
					currentthinker = thinkercap
				loop
					if attached currentthinker.function.acv as acv then
						-- time to remove it
						currentthinker.next.prev := currentthinker.prev
						currentthinker.prev.next := currentthinker.next
					else
						if attached currentthinker.function.acp1 as acp1 then
							acp1.call (currentthinker)
						end
					end

					currentthinker := currentthinker.next
				end
			end
end
