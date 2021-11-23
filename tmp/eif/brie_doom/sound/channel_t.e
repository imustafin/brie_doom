note
	description: "s_sound.c"
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
	CHANNEL_T

create
	make

feature

	make
		do
		end

feature

	sfxinfo: detachable SFXINFO_T assign set_sfxinfo -- sound information (if null, channel avail.)

	set_sfxinfo (a_sfxinfo: like sfxinfo)
		do
			sfxinfo := a_sfxinfo
		end

	origin: detachable MOBJ_T assign set_origin -- origin of sound (orginally void*)

	set_origin (a_origin: like origin)
		do
			origin := a_origin
		end

	handle: INTEGER assign set_handle -- handle of the sound being played

	set_handle (a_handle: like handle)
		do
			handle := a_handle
		end

	pitch: INTEGER assign set_pitch

	set_pitch (a_pitch: like pitch)
		do
			pitch := a_pitch
		end

end
