note
	description: "chocolate doom i_sound.h"

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
