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

	sound_initialized: BOOLEAN

	use_libsamplerate: INTEGER = 0

	use_sfx_prefix: BOOLEAN

	mixer_freq: INTEGER
	mixer_format: INTEGER_16
	mixer_channels: INTEGER

	NUM_CHANNELS: INTEGER = 16

	channels_playing: ARRAY [detachable ALLOCATED_SOUND_T]
		local
			i: INTEGER
		once
			create Result.make_filled (Void, 0, NUM_CHANNELS - 1)
			from
				i := Result.lower
			until
				i > Result.upper
			loop
				Result [i] := create {ALLOCATED_SOUND_T}.make
				i := i + 1
			end
		end

feature

	init (a_use_sfx_prefix: BOOLEAN): BOOLEAN
		local
			i: INTEGER
		do
			use_sfx_prefix := a_use_sfx_prefix
			from
				i := 0
			until
				i >= NUM_CHANNELS
			loop
				channels_playing [i] := Void
				i := i + 1
			end
			if {SDL_FUNCTIONS_API}.sdl_init ({SDL_CONSTANT_API}.sdl_init_audio.to_natural_32) < 0 then
				print ("Unable to set up sound" + {SDL_ERROR}.sdl_get_error)
				Result := False
			else
				if {SDL_MIXER_FUNCTIONS_API}.mix_open_audio_device ({I_SOUND}.snd_samplerate, {SDL_AUDIO}.AUDIO_S16SYS.to_natural_32, 2, get_slice_size, default_pointer, {SDL_CONSTANT_API}.SDL_AUDIO_ALLOW_FREQUENCY_CHANGE) < 0 then
					print ("Error initialising SDL_mixer: " + {MIX_ERROR}.get_error)
					Result := False
				else
					expand_sound_data_sdl_mode := True
					if {SDL_MIXER_FUNCTIONS_API}.mix_query_spec ($mixer_freq, $mixer_format, $mixer_channels) = 0 then
						{I_MAIN}.i_error("Error Mix_QuerySpec" + {MIX_ERROR}.get_error)
					end
						-- skip libsamplerate
					if use_libsamplerate /= 0 then
						print ("use_libsamplerate=" + use_libsamplerate.out + " but libsamplerate not supported")
					end
					if {SDL_MIXER_FUNCTIONS_API}.mix_allocate_channels (NUM_CHANNELS) /= NUM_CHANNELS then
						{I_MAIN}.i_error("Should not happen! Mix_AllocateChannels(" + NUM_CHANNELS.out + ") returned other value")
					end
					{SDl_AUDIO_FUNCTIONS_API}.sdl_pause_audio (0)
					sound_initialized := True
					Result := True
				end
			end
		end

	expand_sound_data_sdl_mode: BOOLEAN
			-- Use ExpandSoudData_SDL? If not, then ExpandSoundData_SRC

	expand_sound_data: BOOLEAN
		do
			check expand_sound_data_sdl_mode then
				Result := expand_sound_data_sdl
			end
		end

	expand_sound_data_sdl: BOOLEAN
		do
				-- Stub
		end

	get_slice_size: INTEGER
		do
				-- Stub
			Result := 1024
		end

	sound_devices: ARRAY [INTEGER]
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
