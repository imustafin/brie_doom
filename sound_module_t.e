note
	description: "chocolate doom i_sound.h"

deferred class
	SOUND_MODULE_T

feature

	sound_devices: ARRAY [INTEGER]
		deferred
		end

	init (use_sfx_prefix: BOOLEAN): BOOLEAN
			-- Initialise sound module
			-- Returns True if successfully initialised
		deferred
		end

end
