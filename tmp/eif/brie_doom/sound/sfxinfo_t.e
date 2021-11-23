note
	description: "sounds.h"
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
	SFXINFO_T

create
	make

feature

	make (a_name: like name; a_singularity: like singularity; a_priority: like priority; a_link: like link; a_pitch: like pitch)
		do
			name := a_name
			singularity := a_singularity
			priority := a_priority
			link := a_link
			pitch := a_pitch
		end

feature

	name: detachable STRING -- up to 6-character name

	singularity: BOOLEAN -- Sfx singularity (one at a time) (originally int)

	priority: INTEGER -- Sfx priority

	link: detachable SFXINFO_T -- referenced sound if a link

	pitch: INTEGER -- pitch if a link

	volume: INTEGER -- volume if a link

	data: detachable ANY -- sound data (orignally void*)

	usefulness: INTEGER assign set_usefulness
			-- this is checked every second to see if sound can be thrown out
			-- (if 0, then decrement,
			--  if -1, then throw out,
			--  if > 0, then it is in use)

	set_usefulness (a_usefulness: like usefulness)
		do
			usefulness := a_usefulness
		end

	lumpnum: INTEGER assign set_lumpnum -- lump number of sfx

	set_lumpnum (a_lumpnum: like lumpnum)
		do
			lumpnum := a_lumpnum
		end

end
