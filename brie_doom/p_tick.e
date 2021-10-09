note
	description: "[
		p_tick.c
		Archiving: SaveGame I/O.
		Thinker, Ticker.
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

	P_RemoveThinker (thinker: WITH_THINKER)
		do
			thinkers.start
			thinkers.prune (thinker)
		ensure
			across old thinkers as ots some ots.item = thinker end implies old thinkers.count = thinkers.count + 1
			across old thinkers as ots all ots.item /= thinker end implies old thinkers ~ thinkers
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
					if not thinkers.after then
						thinkers.forth
					end
				else
					thinkers.remove
				end
			end
		end

end
