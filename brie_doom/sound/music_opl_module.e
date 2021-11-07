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
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL poll", True)
		end

	init: BOOLEAN
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL init", True)
		end

	playsong (handle: detachable ANY; looping: BOOLEAN)
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL playsong", True)
		end

	registersong (handle: detachable ANY; len: INTEGER): detachable ANY
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL registersong", True)
		end

	stopsong
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL stopsog", True)
		end

	resumemusic
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL resumemusic", True)
		end

	unregistersong (handle: detachable ANY)
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL unregistersong", True)
		end

	shutdown
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL shutdown", True)
		end

	set_music_volume (vol: INTEGER)
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL set_music_volume", True)
		end

	pause_music
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL pause_music", True)
		end

	music_is_playing: BOOLEAN
		do
			{NOT_IMPLEMENTED}.not_implemented ("MUSIC_OPL music_is_playing", True)
		end

end
