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

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	music_initialized: BOOLEAN

	sdl_was_initialized: BOOLEAN

feature

	music_sdl_module(a_i_main: like i_main): MUSIC_SDL_MODULE
		once
			create Result.make(a_i_main)
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

	sdl_is_initialized: BOOLEAN
		local
			freq, channels: INTEGER
			format: NATURAL_16
		do
			Result := {SDL_MIXER_FUNCTIONS_API}.mix_query_spec ($freq, $format, $channels) /= 0
		end

	remove_timidity_config
		do
				-- Stub
		end

	init: BOOLEAN
			-- Initialize music subsystem
		local
			i: INTEGER
		do
				-- If SDL_mixer is not initialized, we have to initialize it
				-- and have the responsibility to shut it down later on.

			if sdl_is_initialized then
				music_initialized := True
			else
				if {SDL_FUNCTIONS_API}.sdl_init ({SDL_CONSTANT_API}.SDL_INIT_AUDIO.to_natural_32) < 0 then
					print ("Unable to set up sound.%N")
				elseif {SDL_MIXER_FUNCTIONS_API}.mix_open_audio_device ({I_SOUND}.snd_samplerate, {SDL_AUDIO}.AUDIO_S16SYS.to_natural_32, 2, 1024, default_pointer, {SDL_CONSTANT_API}.SDL_AUDIO_ALLOW_FREQUENCY_CHANGE) < 0 then
					print ("Error initializing SDL_mixer: " + {MIX_ERROR}.get_error)
					{SDL_FUNCTIONS_API}.sdl_quit_sub_system ({SDL_CONSTANT_API}.SDL_INIT_AUDIO.to_natural_32)
				else
					{SDL_AUDIO_FUNCTIONS_API}.sdl_pause_audio (0)
					sdl_was_initialized := True
					music_initialized := True
				end

					-- Initialize SDL_Mixer for MIDI music playback
					-- do nothing with i
				i := {SDL_MIXER_FUNCTIONS_API}.Mix_Init ({MIX_INIT_FLAGS_ENUM_API}.MIX_INIT_MID)

					-- Once initialization is complete, the temporary Timidity config
					-- file can be removed.

				remove_timidity_config

					-- If snd_musiccmd is set, we need to call Mix_SetMusicCMD to
					-- configure an external music playback program.

				if not i_main.i_sound.snd_musiccmd.is_empty then
					if {SDL_MIXER_FUNCTIONS_API}.mix_set_music_cmd ((create {C_STRING}.make (i_main.i_sound.snd_musiccmd)).item) < 0 then
						{I_MAIN}.i_error("Could not Mix_SetMusicCMD " + {MIX_ERROR}.get_error)
					end
				end

					-- skip WIN32 I_MidiPipInitServer
					-- [AM] Start up midiproc to handle playing MIDI music.
					-- Don't enable it for GUS, since it handles its own volume just fine.

				Result := music_initialized
			end
		end

end
