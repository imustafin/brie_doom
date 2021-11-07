note
	description: "chocolate doom i_musicpack.c"
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
	I_MUSICPACK

inherit

	MUSIC_MODULE_T

create
	make

feature

	make
		do
		end

feature

	sound_devices: ARRAY [INTEGER]
		once
			create Result.make_empty
		end

	poll
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK poll", True)
		end

	init: BOOLEAN
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK init", True)
		end

	playsong (handle: detachable ANY; looping: BOOLEAN)
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK playsong", True)
		end

	registersong (handle: detachable ANY; len: INTEGER): detachable ANY
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK registersong", True)
		end

	stopsong
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK stopsong", True)
		end

	resumemusic
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK resumemusic", True)
		end

	unregistersong (handle: detachable ANY)
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK unregistersong", True)
		end

	shutdown
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK shutdown", True)
		end

	set_music_volume (vol: INTEGER)
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK set_music_volume", True)
		end

	pause_music
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK pause_music", True)
		end

	music_is_playing: BOOLEAN
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSICPACK music_is_playing", True)
		end

end
