note
	description: "chocolate doom i_oplmusic.c"
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
	MUSIC_OPL_MODULE

inherit

	MUSIC_MODULE_T

create
	make

feature {NONE}

	make
		do
		end

feature

	sound_devices: ARRAY [INTEGER]
		once
			Result := <<{I_SOUND}.snddevice_adlib, {I_SOUND}.snddevice_sb>>
		end

	music_opl_module: MUSIC_OPL_MODULE
		once
			create Result.make
		ensure
			instance_free: class
		end

	poll
		do
				-- Stub
		end

	init: BOOLEAN
		do
				-- Stub
		end

	playsong (handle: detachable ANY; looping: BOOLEAN)
		do
				-- Stub
		end

	registersong (handle: detachable ANY; len: INTEGER): detachable ANY
		do
				-- Stub
		end

	stopsong
		do
				-- Stub
		end

	resumemusic
		do
				-- Stub
		end

	unregistersong (handle: detachable ANY)
		do
				-- Stub
		end

	shutdown
		do
				-- Stub
		end

	set_music_volume (vol: INTEGER)
		do
				-- Stub
		end

	pause_music
		do
				-- Stub
		end

	music_is_playing: BOOLEAN
		do
				-- Stub
		end

end
