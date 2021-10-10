note
	description: "[
		i_net.c
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
	I_NET

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	I_InitNetwork
		do
			{NOT_IMPLEMENTED}.not_implemented("I_InitNetwork", false)
			i_main.d_net.doomcom := (create {DOOMCOM_T}.make)
				-- Skip -dup param
			i_main.d_net.doomcom.ticdup := 1
				-- Skip -extratic param
			i_main.d_net.doomcom.extratics := 0

				-- Skip -port param
				-- Skip -net param

				-- single player game
			i_main.g_game.netgame := False
			i_main.d_net.doomcom.id := {D_NET}.doomcom_id
			i_main.d_net.doomcom.numplayers := 1
			i_main.d_net.doomcom.numnodes := 1
			i_main.d_net.doomcom.deathmatch := 0 -- was assigning false originally
			i_main.d_net.doomcom.consoleplayer := 0

				-- Continue skipping -net param
		end

end
