note
	description: "chocolate doom i_sdlsound.c"

class
	SOUND_SDL_MODULE

inherit

	SOUND_MODULE_T

create
	make

feature {NONE}

	make
		do
		end

feature

	init (use_sfx_prefix: BOOLEAN): BOOLEAN
		do
		end

	sound_devices: ARRAY[INTEGER]
	once
		Result := <<{I_SOUND}.snddevice_sb, {I_SOUND}.snddevice_pas, {I_SOUND}.snddevice_gus, {I_SOUND}.snddevice_waveblaster, {I_SOUND}.snddevice_soundcanvas, {I_SOUND}.snddevice_awe32>>
	end

feature

	sound_sdl_module: SOUND_SDL_MODULE
		once
			create Result.make
		ensure
			instance_free: class
		end

end
