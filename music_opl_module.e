note
	description: "chocolate doom i_oplmusic.c"

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

end
