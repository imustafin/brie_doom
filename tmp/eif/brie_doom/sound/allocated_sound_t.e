note
	description: "chocolate doom i_sdlsound.c"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
				Copyright (C) 2005-2014 Simon Howard
				Copyright (C) 2008 David Flater
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
	ALLOCATED_SOUND_T

create
	make

feature

	make
		do
			create chunk.make
		end

feature

	sfxinfo: detachable SFXINFO_T assign set_sfxinfo

	set_sfxinfo (a_sfxinfo: like sfxinfo)
		do
			sfxinfo := a_sfxinfo
		end

	chunk: MIX_CHUNK

	use_count: INTEGER assign set_use_count

	set_use_count (a_use_count: like use_count)
		do
			use_count := a_use_count
		end

	pitch: INTEGER assign set_pitch

	set_pitch (a_pitch: like pitch)
		do
			pitch := a_pitch
		end

	prev: detachable ALLOCATED_SOUND_T assign set_prev

	set_prev (a_prev: like prev)
		do
			prev := a_prev
		end

	next: detachable ALLOCATED_SOUND_T assign set_next

	set_next (a_next: like next)
		do
			next := a_next
		end

end
