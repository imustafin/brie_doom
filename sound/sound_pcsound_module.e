note
	description: "[
		chocolate doom i_pcsound.c
		System interface for PC speaker sound.
	]"

class
	SOUND_PCSOUND_MODULE

inherit

	SOUND_MODULE_T

create
	make

feature {NONE}

	make
		do
		end

feature

	sound_devices: ARRAY [INTEGER]
		once
			Result := <<{I_SOUND}.snddevice_pcspeaker>>
		end

	init (use_sfx_prefix: BOOLEAN): BOOLEAN
		do
				-- Stub
		end

	shutdown
		do
				-- Stub
		end

	get_sfx_lump_num (sfxinfo: SFXINFO_T): INTEGER
		do
				-- Stub
		end

	update
		do
				-- Stub
		end

update_sound_params (channel, vol, sep: INTEGER)
		do
			-- Stub
		end

	start_sound (sfxinfo: SFXINFO_T; channel, vol, sep, pitch: INTEGER): INTEGER
		do
			-- Stub
		end

	stop_sound (channel: INTEGER)
		do
			-- Stub
		end

	cache_sounds (sounds: ARRAY [SFXINFO_T])
		do
			-- Stub
		end

feature

	sound_pcsound_module: SOUND_PCSOUND_MODULE
		once
			create Result.make
		ensure
			instance_free: class
		end

end
