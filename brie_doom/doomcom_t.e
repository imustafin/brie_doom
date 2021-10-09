note
	description: "d_net.h"
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
	DOOMCOM_T

create
	make

feature

	make
		do
			create data.make
		end

feature

	id: INTEGER assign set_id -- supposed to be DOOMCOM_ID?

	set_id (a_id: like id)
		do
			id := a_id
		end

feature -- Info common to all nodes.

	numnodes: INTEGER assign set_numnodes -- Console is allways node 0.

	ticdup: INTEGER assign set_ticdup -- Flag: 1 = no duplication, 2-5 = dup for slow nets.

	extratics: INTEGER assign set_extratics -- Flag: 1 = send backup tic in every packet.

	deathmatch: INTEGER assign set_deathmatch -- Flag: 1 = deathmatch

	set_deathmatch (a_deathmatch: like deathmatch)
		do
			deathmatch := a_deathmatch
		end

	set_numnodes (a_numnodes: like numnodes)
		do
			numnodes := a_numnodes
		end

	set_ticdup (a_ticdup: like ticdup)
		do
			ticdup := a_ticdup
		end

	set_extratics (a_extratics: like extratics)
		do
			extratics := a_extratics
		end

feature -- Info specific to this node.

	numplayers: INTEGER assign set_numplayers

	set_numplayers (a_numplayers: like numplayers)
		do
			numplayers := a_numplayers
		end

	consoleplayer: INTEGER assign set_consoleplayer

	set_consoleplayer (a_consoleplayer: like consoleplayer)
		do
			consoleplayer := a_consoleplayer
		end

	data: DOOMDATA_T

end
