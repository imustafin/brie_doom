note
	description: "chocolate doom i_sound.h"
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

deferred class
	MUSIC_MODULE_T

feature

	sound_devices: ARRAY [INTEGER]
			-- List of sound devices that the music module is used for.
		deferred
		end

	init: BOOLEAN
			-- Initialise the music subsystem
		deferred
		end

	shutdown
			-- Shutdown the music subsystem
		deferred
		end

	set_music_volume (volume: INTEGER)
			-- Set music volume - range 0-127
		require
			volume >= 0
			volume <= 127
		deferred
		end

	pause_music
			-- Pause music
		deferred
		end

	resumeMusic
			-- Un-pause music
		deferred
		end

	registersong (handle: detachable ANY; len: INTEGER): detachable ANY
			-- Register a song handle from data
			-- Returns a handle that can be used to play the song
		deferred
		end

	unregistersong (handle: detachable ANY)
			-- Un-register (free) song data
		deferred
		end

	playsong (handle: detachable ANY; looping: BOOLEAN)
			-- Play the song
		deferred
		end

	stopSong
			-- Stop playing the current song.
		deferred
		end

	music_is_playing: BOOLEAN
			-- Query if music is playing.
		deferred
		end

	poll
			-- Invoked periodically to poll.
		deferred
		end

end
