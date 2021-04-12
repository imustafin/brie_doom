note
	description: "chocolate doom i_sound.h"

deferred class
	MUSIC_MODULE_T

feature

	sound_devices: ARRAY [INTEGER]
		deferred
		end

	init: BOOLEAN
		deferred
		end

	resumeMusic
		do
				--  Stub
		end

	stopSong
		deferred
		end

	unregistersong (handle: detachable ANY)
		do
				-- Stub
		end

	registersong (handle: detachable ANY; len: INTEGER): detachable ANY
		deferred
		end

	playsong (handle: detachable ANY; looping: BOOLEAN)
		deferred
		end

	poll
		deferred
		end

end
