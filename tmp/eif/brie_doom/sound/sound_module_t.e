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
	SOUND_MODULE_T

feature

	sound_devices: ARRAY [INTEGER]
			-- List of sound devices that this sound module is used for.
		deferred
		end

	init (use_sfx_prefix: BOOLEAN): BOOLEAN
			-- Initialise sound module
			-- Returns True if successfully initialised
		deferred
		end

	shutdown
			-- Shutdown sound module
		deferred
		end

	get_sfx_lump_num (sfxinfo: SFXINFO_T): INTEGER
			-- Returns the lump index of the given sound.
		deferred
		end

	update
			-- Called periodically to update the subsystem.
		deferred
		end

	update_sound_params (channel, vol, sep: INTEGER)
			-- Update the sound settings on the given channel.
		deferred
		end

	start_sound (sfxinfo: SFXINFO_T; channel, vol, sep, pitch: INTEGER): INTEGER
			-- Start a sound on a given channel. Returns the channel id
			-- or -1 on failure.
		deferred
		end

	stop_sound (channel: INTEGER)
			-- Stop the sound playing on the given channel
		deferred
		end

	cache_sounds (sounds: ARRAY [SFXINFO_T])
			-- Called on startup to precache sound effects (if necessary)
		deferred
		end

	sound_is_playing (channel: INTEGER): BOOLEAN
			-- Query if a sound is playing on the given channel
		deferred
		end

end
