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

feature

	sound_pcsound_module: SOUND_PCSOUND_MODULE
		once
			create Result.make
		ensure
			instance_free: class
		end

end
