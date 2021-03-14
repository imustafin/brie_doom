note
	description: "[
		chocolate doom i_sdlmusic.c
		System interface for music.
	]"

class
	MUSIC_SDL_MODULE

inherit

	MUSIC_MODULE_T

create
	make

feature {NONE}

	make
		do
		end

feature

	music_sdl_module: MUSIC_SDL_MODULE
		once
			create Result.make
		ensure
			instance_free: class
		end

	sound_devices: ARRAY [INTEGER]
		once
			Result := <<{I_SOUND}.snddevice_pas, {I_SOUND}.snddevice_gus, {I_SOUND}.snddevice_waveblaster, {I_SOUND}.snddevice_soundcanvas, {I_SOUND}.snddevice_genmidi, {I_SOUND}.snddevice_awe32>>
		end

	poll
		do
				-- Stub
		end

end
